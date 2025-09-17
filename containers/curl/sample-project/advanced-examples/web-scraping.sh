#!/bin/bash

echo "🕷️ Web Scraping Examples"
echo "========================"

# Create output directory
mkdir -p /workspace/data/scraped

echo -e "\n1. Basic Web Scraping:"
# Scrape a simple webpage
curl -s https://httpbin.org/html > /workspace/data/scraped/sample.html
echo "Scraped HTML content saved to sample.html"

echo -e "\n2. Extracting JSON Data:"
# Extract JSON data
curl -s https://httpbin.org/json > /workspace/data/scraped/data.json
echo "JSON data extracted and saved"

echo -e "\n3. Scraping with Custom Headers:"
# Scrape with custom user agent
curl -s -H "User-Agent: Mozilla/5.0 (compatible; MyBot/1.0)" \
  https://httpbin.org/user-agent > /workspace/data/scraped/user-agent.json
echo "Scraped with custom user agent"

echo -e "\n4. Batch URL Scraping:"
# Scrape multiple URLs
urls=(
    "https://httpbin.org/json"
    "https://httpbin.org/xml"
    "https://httpbin.org/robots.txt"
)

for i in "${!urls[@]}"; do
    echo "Scraping URL $((i+1)): ${urls[$i]}"
    curl -s "${urls[$i]}" > "/workspace/data/scraped/url_$((i+1)).txt"
done

echo -e "\n5. Data Extraction and Processing:"
# Extract specific data using jq
curl -s https://httpbin.org/json | jq -r '.slideshow.slides[0].title' > /workspace/data/scraped/title.txt
echo "Extracted title: $(cat /workspace/data/scraped/title.txt)"

# Extract all slide titles
curl -s https://httpbin.org/json | jq -r '.slideshow.slides[].title' > /workspace/data/scraped/titles.txt
echo "All titles extracted to titles.txt"

echo -e "\n6. Scraped Files Summary:"
ls -la /workspace/data/scraped/

echo -e "\n✅ Web scraping completed!"
