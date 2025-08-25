#!/usr/bin/env python3
"""
Bulk Container Documentation Generator
Generates documentation for 100+ popular container images across different categories.
Includes comprehensive image lists and batch processing capabilities.
"""

import os
import sys
import json
import time
import argparse
from pathlib import Path
from typing import List, Dict, Set
from datetime import datetime
import concurrent.futures
from threading import Lock
import requests

script_dir = os.path.dirname(os.path.abspath(__file__))
if script_dir not in sys.path:
    sys.path.insert(0, script_dir)

try:
    from generate import ContainerDocsGenerator
except ImportError as e:
    print("❌ Error: could not import ContainerDocsGenerator from generate.py")
    print(e)
    sys.exit(1)

class BulkContainerDocsGenerator:
    """Enhanced generator for processing multiple container images in batches."""
    
    def __init__(self, default_registry="{{registry.example.com}}", site_name="Container Registry"):
        self.generator = ContainerDocsGenerator(default_registry, site_name)
        self.lock = Lock()
        self.processed_count = 0
        self.failed_count = 0
        self.results = []
        self.failed_images = []
    

    
    def load_images_from_file(self, filepath: str) -> List[str]:
        """Load image list from a text file (one image per line)."""
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                images = [line.strip() for line in f if line.strip() and not line.startswith('#')]
            return images
        except FileNotFoundError:
            print(f"❌ File not found: {filepath}")
            return []
        except Exception as e:
            print(f"❌ Error reading file {filepath}: {e}")
            return []
    
    def save_images_to_file(self, images: List[str], filepath: str):
        """Save image list to a text file."""
        try:
            # Check if file already exists and handle conflicts
            if Path(filepath).exists():
                print(f"⚠️  File {filepath} already exists. Overwriting...")
            
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write("# Container Images List\n")
                f.write(f"# Generated on {datetime.now().isoformat()}\n")
                f.write("# One image per line, lines starting with # are comments\n\n")
                for img in images:
                    f.write(f"{img}\n")
            print(f"✅ Image list saved to: {filepath}")
        except Exception as e:
            print(f"❌ Error saving to file {filepath}: {e}")
    
    def process_single_image(self, image: str, delay_between_requests: float = 1.0) -> tuple:
        """Process a single image with error handling and rate limiting."""
        import traceback
        from pathlib import Path

        try:
            # Rate limiting
            if delay_between_requests > 0:
                time.sleep(delay_between_requests)
            
            json_file, md_file = self.generator.generate_docs(image)
            
            with self.lock:
                self.processed_count += 1
                result = (image, json_file, md_file, "SUCCESS")
                self.results.append(result)
                print(f"✅ [{self.processed_count}] {image} -> {json_file}")
            
            return result
            
        except Exception as e:
            with self.lock:
                self.failed_count += 1
                tb = traceback.format_exc()
                result = (image, None, None, f"FAILED: {str(e)}")
                self.failed_images.append(image)
                self.results.append(result)

                # Print failure info
                print(f"❌ [{self.failed_count}] {image} -> {str(e)}")
                print("🔎 Traceback:\n", tb)

                # If it's a requests exception, try to log response details
                if hasattr(e, "response") and e.response is not None:
                    print(f"📡 API Response Code: {e.response.status_code}")
                    print(f"📡 API Response Body: {e.response.text[:500]}")

                # Write failures to a log file
                fail_log = Path(self.generator.output_dir) / "failures.log"
                with open(fail_log, "a", encoding="utf-8") as f:
                    f.write(f"\n[{datetime.now()}] Image: {image}\n")
                    f.write(f"Error: {str(e)}\n")
                    f.write(f"Traceback:\n{tb}\n")
                    if hasattr(e, "response") and e.response is not None:
                        f.write(f"API Response Code: {e.response.status_code}\n")
                        f.write(f"API Response Body:\n{e.response.text[:1000]}\n")

            return result

    
    def process_images_sequential(self, images: List[str], delay_between_requests: float = 1.0) -> List[tuple]:
        """Process images sequentially with rate limiting."""
        print(f"🔄 Processing {len(images)} images sequentially...")
        
        results = []
        for i, image in enumerate(images, 1):
            print(f"\n[{i}/{len(images)}] Processing: {image}")
            result = self.process_single_image(image, delay_between_requests)
            results.append(result)
            
            # Progress update every 10 images
            if i % 10 == 0:
                print(f"\n📊 Progress: {i}/{len(images)} ({i/len(images)*100:.1f}%)")
                print(f"✅ Success: {self.processed_count}, ❌ Failed: {self.failed_count}")
        
        return results
    
    def process_images_parallel(self, images: List[str], max_workers: int = 5, delay_between_requests: float = 2.0) -> List[tuple]:
        """Process images in parallel with controlled concurrency."""
        print(f"🔄 Processing {len(images)} images with {max_workers} parallel workers...")
        
        results = []
        with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
            # Submit all tasks
            future_to_image = {
                executor.submit(self.process_single_image, image, delay_between_requests): image 
                for image in images
            }
            
            # Process completed tasks
            for future in concurrent.futures.as_completed(future_to_image):
                image = future_to_image[future]
                try:
                    result = future.result()
                    results.append(result)
                    
                    # Progress update
                    completed = len(results)
                    if completed % 10 == 0:
                        print(f"\n📊 Progress: {completed}/{len(images)} ({completed/len(images)*100:.1f}%)")
                        print(f"✅ Success: {self.processed_count}, ❌ Failed: {self.failed_count}")
                        
                except Exception as e:
                    print(f"❌ Unexpected error processing {image}: {e}")
        
        return results
    
    def generate_summary_report(self, results: List[tuple], output_dir: Path) -> str:
        """Generate a comprehensive summary report."""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        report_file = output_dir / f"bulk_generation_report_{timestamp}.json"
        
        # Categorize results
        successful = [r for r in results if r[3] == "SUCCESS"]
        failed = [r for r in results if r[3].startswith("FAILED")]
        
        # Generate summary
        summary = {
            "generation_timestamp": datetime.now().isoformat(),
            "total_images": len(results),
            "successful_count": len(successful),
            "failed_count": len(failed),
            "success_rate": f"{len(successful)/len(results)*100:.1f}%" if results else "0%",
            "successful_images": [
                {
                    "image": r[0],
                    "json_file": r[1],
                    "md_file": r[2]
                } for r in successful
            ],
            "failed_images": [
                {
                    "image": r[0],
                    "error": r[3]
                } for r in failed
            ],
            "processing_statistics": {
                "images_by_type": self._analyze_images_by_type([r[0] for r in successful]),
                "registries_processed": self._analyze_registries([r[0] for r in successful])
            }
        }
        
        # Save report
        with open(report_file, 'w', encoding='utf-8') as f:
            json.dump(summary, f, indent=2, ensure_ascii=False)
        
        return str(report_file)
    
    def _analyze_images_by_type(self, images: List[str]) -> Dict[str, int]:
        """Analyze image types based on common patterns."""
        type_counts = {}
        
        for img in images:
            img_name = img.split('/')[-1].split(':')[0].lower()  # Extract base image name
            
            # Categorize by common image patterns
            if any(db in img_name for db in ['postgres', 'mysql', 'redis', 'mongo', 'elastic']):
                type_counts['databases'] = type_counts.get('databases', 0) + 1
            elif any(web in img_name for web in ['nginx', 'apache', 'httpd']):
                type_counts['web_servers'] = type_counts.get('web_servers', 0) + 1
            elif any(lang in img_name for lang in ['node', 'python', 'java', 'golang', 'php']):
                type_counts['runtimes'] = type_counts.get('runtimes', 0) + 1
            elif any(os in img_name for os in ['ubuntu', 'alpine', 'centos', 'debian']):
                type_counts['base_os'] = type_counts.get('base_os', 0) + 1
            else:
                type_counts['other'] = type_counts.get('other', 0) + 1
        
        return type_counts
    
    def _analyze_registries(self, images: List[str]) -> Dict[str, int]:
        """Analyze which registries were processed."""
        registry_counts = {}
        
        for img in images:
            if '/' in img:
                registry = img.split('/')[0]
                if '.' in registry:  # Likely a registry domain
                    registry_counts[registry] = registry_counts.get(registry, 0) + 1
            else:
                registry_counts['default'] = registry_counts.get('default', 0) + 1
        
        return registry_counts


def main():
    """Main function for bulk container documentation generation."""
    parser = argparse.ArgumentParser(
        description="Generate documentation for 100+ container images in bulk",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Generate docs from your images.txt file
  python3 bulk_container_docs.py --from-file images.txt
  
  # Generate docs with parallel processing
  python3 bulk_container_docs.py --from-file images.txt --parallel --workers 3 --delay 2.0
  
  # Preview what images would be processed
  python3 bulk_container_docs.py --from-file images.txt --dry-run
  
  # Save processed images list for review
  python3 bulk_container_docs.py --from-file images.txt --save-list processed_images.txt --dry-run
  
  # Custom output directory
  python3 bulk_container_docs.py --from-file images.txt --output-dir ./my_docs
        """
    )
    
    # Image source options
    parser.add_argument('--from-file', default='images.txt',
                       help='Load image list from file (default: images.txt, one image per line)')
    
    # Processing options
    parser.add_argument('--parallel', action='store_true', 
                       help='Use parallel processing (faster but more API calls)')
    parser.add_argument('--workers', type=int, default=3, 
                       help='Number of parallel workers (default: 3)')
    parser.add_argument('--delay', type=float, default=2.0, 
                       help='Delay between API requests in seconds (default: 2.0)')
    
    # Output options
    parser.add_argument('--output-dir', default='bulk_responses', 
                       help='Output directory for generated files')
    parser.add_argument('--save-list', help='Save image list to file and exit')
    parser.add_argument('--dry-run', action='store_true', 
                       help='Show what images would be processed without generating docs')
    
    # Container options (from original script)
    parser.add_argument('--registry', default='{registry.example.com}',
                       help='Default container registry URL')
    parser.add_argument('--site-name', 
                       help='Default site name for documentation')
    
    args = parser.parse_args()
    
    try:
        # Initialize generator
        site_name = args.site_name or f"{args.registry.split('.')[0].title()} Registry"
        bulk_generator = BulkContainerDocsGenerator(args.registry, site_name)
        
        # Determine images to process
        images = []
        
        if args.from_file:
            print(f"📂 Loading images from file: {args.from_file}")
            images = bulk_generator.load_images_from_file(args.from_file)
        else:
            print("❌ No image source specified. Use --from-file to specify your images.txt file.")
            print("Example: python3 bulk_container_docs.py --from-file images.txt")
            return
        
        if not images:
            print("❌ No images to process. Check your filters or input file.")
            return
        
        # Remove duplicates while preserving order
        seen = set()
        unique_images = []
        for img in images:
            if img not in seen:
                seen.add(img)
                unique_images.append(img)
        images = unique_images
        
        print(f"📊 Total unique images to process: {len(images)}")
        
        # Save list if requested
        if args.save_list:
            bulk_generator.save_images_to_file(images, args.save_list)
            if not args.dry_run:
                return
        
        # Dry run - show what would be processed
        if args.dry_run:
            print("\n🔍 DRY RUN - Images that would be processed:")
            print("=" * 80)
            for i, img in enumerate(images, 1):
                registry_path, image_name, site_name = bulk_generator.generator.parse_image_path(img)
                full_path = f"{registry_path}/{image_name}"
                print(f"{i:3d}. {img:40s} → {full_path} from {site_name}")
            print("=" * 80)
            print(f"Total: {len(images)} images")
            return
        
        # Setup output directory
        output_dir = Path(args.output_dir)
        bulk_generator.generator.output_dir = output_dir
        bulk_generator.generator.json_dir = output_dir / 'json'
        bulk_generator.generator.md_dir = output_dir / 'markdown'
        
        output_dir.mkdir(exist_ok=True)
        bulk_generator.generator.json_dir.mkdir(exist_ok=True)
        bulk_generator.generator.md_dir.mkdir(exist_ok=True)
        
        print(f"\n🚀 Starting bulk documentation generation...")
        print(f"📁 Output directory: {output_dir}")
        print(f"⚙️  Processing mode: {'Parallel' if args.parallel else 'Sequential'}")
        print(f"⏱️  Delay between requests: {args.delay}s")
        if args.parallel:
            print(f"👥 Parallel workers: {args.workers}")
        print("=" * 80)
        
        start_time = time.time()
        
        # Process images
        if args.parallel:
            results = bulk_generator.process_images_parallel(images, args.workers, args.delay)
        else:
            results = bulk_generator.process_images_sequential(images, args.delay)
        
        end_time = time.time()
        processing_time = end_time - start_time
        
        # Generate summary report
        report_file = bulk_generator.generate_summary_report(results, output_dir)
        
        # Print final summary
        print("\n" + "=" * 80)
        print("🎉 BULK GENERATION COMPLETE!")
        print("=" * 80)
        print(f"📊 Total images processed: {len(results)}")
        print(f"✅ Successful: {bulk_generator.processed_count}")
        print(f"❌ Failed: {bulk_generator.failed_count}")
        print(f"📈 Success rate: {bulk_generator.processed_count/len(results)*100:.1f}%")
        print(f"⏱️  Total processing time: {processing_time:.1f}s")
        print(f"⚡ Average time per image: {processing_time/len(results):.1f}s")
        print(f"📄 Summary report: {report_file}")
        print(f"📁 JSON files: {bulk_generator.generator.json_dir}")
        print(f"📁 Markdown files: {bulk_generator.generator.md_dir}")
        
        if bulk_generator.failed_images:
            print(f"\n❌ Failed images ({len(bulk_generator.failed_images)}):")
            for img in bulk_generator.failed_images[:10]:  # Show first 10
                print(f"  • {img}")
            if len(bulk_generator.failed_images) > 10:
                print(f"  • ... and {len(bulk_generator.failed_images) - 10} more")
        
        print("=" * 80)
        
    except KeyboardInterrupt:
        print("\n⚠️  Operation cancelled by user")
        if hasattr(bulk_generator, 'processed_count'):
            print(f"📊 Processed {bulk_generator.processed_count} images before cancellation")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Critical error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()