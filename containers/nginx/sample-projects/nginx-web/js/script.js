// JavaScript for Nginx Static Site Example

// Global variables
let serverInfoLoaded = false;

// DOM Content Loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('Nginx Static Site loaded successfully!');
    
    // Initialize the application
    initializeApp();
    
    // Add smooth scrolling for navigation links
    addSmoothScrolling();
    
    // Add scroll animations
    addScrollAnimations();
    
    // Load server information
    loadServerInfo();
});

// Initialize the application
function initializeApp() {
    console.log('Initializing Nginx Static Site...');
    
    // Add loading animation to buttons
    const buttons = document.querySelectorAll('.btn');
    buttons.forEach(button => {
        button.addEventListener('click', function() {
            if (!this.classList.contains('btn-outline-primary')) {
                this.innerHTML = '<span class="loading"></span> Loading...';
                setTimeout(() => {
                    this.innerHTML = this.getAttribute('data-original-text') || this.innerHTML;
                }, 2000);
            }
        });
    });
    
    // Store original button text
    buttons.forEach(button => {
        button.setAttribute('data-original-text', button.innerHTML);
    });
}

// Add smooth scrolling for navigation links
function addSmoothScrolling() {
    const navLinks = document.querySelectorAll('a[href^="#"]');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            
            if (targetSection) {
                targetSection.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
                
                // Update active navigation link
                updateActiveNavLink(this);
            }
        });
    });
}

// Update active navigation link
function updateActiveNavLink(activeLink) {
    const navLinks = document.querySelectorAll('.nav-link');
    navLinks.forEach(link => link.classList.remove('active'));
    activeLink.classList.add('active');
}

// Add scroll animations
function addScrollAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);
    
    // Observe elements for animation
    const animateElements = document.querySelectorAll('.card, .feature-icon, .hero-image');
    animateElements.forEach(el => observer.observe(el));
}

// Load server information
function loadServerInfo() {
    const serverInfoDiv = document.getElementById('server-info');
    
    if (!serverInfoDiv) return;
    
    // Simulate loading server information
    setTimeout(() => {
        const serverInfo = {
            'Server': 'Nginx/1.24.0',
            'Platform': navigator.platform,
            'User Agent': navigator.userAgent.split(' ')[0],
            'Language': navigator.language,
            'Online': navigator.onLine ? 'Yes' : 'No',
            'Load Time': new Date().toLocaleTimeString()
        };
        
        displayServerInfo(serverInfo);
        serverInfoLoaded = true;
    }, 1000);
}

// Display server information
function displayServerInfo(info) {
    const serverInfoDiv = document.getElementById('server-info');
    
    if (!serverInfoDiv) return;
    
    let html = '';
    
    for (const [key, value] of Object.entries(info)) {
        html += `
            <div class="server-info-item">
                <span class="server-info-label">${key}:</span>
                <span class="server-info-value">${value}</span>
            </div>
        `;
    }
    
    serverInfoDiv.innerHTML = html;
    serverInfoDiv.classList.add('fade-in');
}

// Show alert function (called by button)
function showAlert() {
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-success alert-dismissible fade show position-fixed';
    alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
    alertDiv.innerHTML = `
        <i class="fas fa-check-circle me-2"></i>
        <strong>Success!</strong> Nginx is serving this static content efficiently!
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(alertDiv);
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 5000);
}

// Load dynamic content function (called by button)
function loadDynamicContent() {
    const contentDiv = document.createElement('div');
    contentDiv.className = 'alert alert-info fade-in';
    contentDiv.style.cssText = 'margin: 20px 0;';
    contentDiv.innerHTML = `
        <h5><i class="fas fa-info-circle me-2"></i>Dynamic Content Loaded</h5>
        <p>This content was loaded dynamically via JavaScript, demonstrating that Nginx can serve static files while JavaScript handles interactivity.</p>
        <div class="row mt-3">
            <div class="col-md-6">
                <strong>Current Time:</strong> ${new Date().toLocaleString()}
            </div>
            <div class="col-md-6">
                <strong>Page Loaded:</strong> ${new Date().toLocaleString()}
            </div>
        </div>
        <button class="btn btn-sm btn-outline-primary mt-2" onclick="this.parentElement.remove()">
            <i class="fas fa-times me-1"></i>Close
        </button>
    `;
    
    // Insert after the hero section
    const heroSection = document.querySelector('.hero-section');
    if (heroSection) {
        heroSection.parentNode.insertBefore(contentDiv, heroSection.nextSibling);
    }
}

// Add performance monitoring
function monitorPerformance() {
    if ('performance' in window) {
        window.addEventListener('load', function() {
            const loadTime = performance.timing.loadEventEnd - performance.timing.navigationStart;
            console.log(`Page load time: ${loadTime}ms`);
            
            // Display load time in server info if available
            if (serverInfoLoaded) {
                const serverInfoDiv = document.getElementById('server-info');
                if (serverInfoDiv) {
                    const loadTimeElement = serverInfoDiv.querySelector('.server-info-item:last-child .server-info-value');
                    if (loadTimeElement) {
                        loadTimeElement.textContent = `${loadTime}ms`;
                    }
                }
            }
        });
    }
}

// Add keyboard shortcuts
function addKeyboardShortcuts() {
    document.addEventListener('keydown', function(e) {
        // Ctrl/Cmd + K to show alert
        if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
            e.preventDefault();
            showAlert();
        }
        
        // Ctrl/Cmd + L to load dynamic content
        if ((e.ctrlKey || e.metaKey) && e.key === 'l') {
            e.preventDefault();
            loadDynamicContent();
        }
        
        // Escape to close alerts
        if (e.key === 'Escape') {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                if (alert.classList.contains('show')) {
                    const closeBtn = alert.querySelector('.btn-close');
                    if (closeBtn) {
                        closeBtn.click();
                    }
                }
            });
        }
    });
}

// Add service worker support (if available)
function addServiceWorkerSupport() {
    if ('serviceWorker' in navigator) {
        navigator.serviceWorker.register('/sw.js')
            .then(registration => {
                console.log('Service Worker registered successfully:', registration);
            })
            .catch(error => {
                console.log('Service Worker registration failed:', error);
            });
    }
}

// Add offline detection
function addOfflineDetection() {
    window.addEventListener('online', function() {
        showAlert();
    });
    
    window.addEventListener('offline', function() {
        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-warning alert-dismissible fade show position-fixed';
        alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
        alertDiv.innerHTML = `
            <i class="fas fa-wifi-slash me-2"></i>
            <strong>Offline!</strong> You are currently offline.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        
        document.body.appendChild(alertDiv);
    });
}

// Initialize additional features
document.addEventListener('DOMContentLoaded', function() {
    monitorPerformance();
    addKeyboardShortcuts();
    addServiceWorkerSupport();
    addOfflineDetection();
});

// Export functions for global access
window.showAlert = showAlert;
window.loadDynamicContent = loadDynamicContent;
