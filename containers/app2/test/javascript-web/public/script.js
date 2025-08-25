// Global variables
let addUserModal;

// Initialize the application
document.addEventListener('DOMContentLoaded', function() {
    // Initialize Bootstrap modal
    addUserModal = new bootstrap.Modal(document.getElementById('addUserModal'));
    
    // Load users on page load
    loadUsers();
    
    // Check server status
    checkServerStatus();
    
    // Set up periodic status check
    setInterval(checkServerStatus, 30000); // Check every 30 seconds
});

// Load all users from the database
async function loadUsers() {
    try {
        showLoading(true);
        const response = await fetch('/api/users');
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const users = await response.json();
        displayUsers(users);
        updateStats(users.length);
        
    } catch (error) {
        console.error('Error loading users:', error);
        showError('Failed to load users: ' + error.message);
    } finally {
        showLoading(false);
    }
}

// Display users in the table
function displayUsers(users) {
    const tbody = document.getElementById('usersTableBody');
    const noUsersMessage = document.getElementById('noUsersMessage');
    
    if (users.length === 0) {
        tbody.innerHTML = '';
        noUsersMessage.style.display = 'block';
        return;
    }
    
    noUsersMessage.style.display = 'none';
    
    tbody.innerHTML = users.map(user => `
        <tr>
            <td><span class="badge bg-secondary">${user.id}</span></td>
            <td><strong>${escapeHtml(user.name)}</strong></td>
            <td><code>${escapeHtml(user.email)}</code></td>
            <td><small class="text-muted">${formatDate(user.created_at)}</small></td>
            <td>
                <button class="btn btn-danger btn-sm btn-action" onclick="deleteUser(${user.id})" title="Delete User">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

// Show/hide loading message
function showLoading(show) {
    const loadingMessage = document.getElementById('loadingMessage');
    const table = document.getElementById('usersTable');
    
    if (show) {
        loadingMessage.style.display = 'block';
        table.style.display = 'none';
    } else {
        loadingMessage.style.display = 'none';
        table.style.display = 'table';
    }
}

// Show error message
function showError(message) {
    // Create a temporary alert
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-danger alert-dismissible fade show position-fixed';
    alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
    alertDiv.innerHTML = `
        <i class="fas fa-exclamation-triangle me-2"></i>
        ${escapeHtml(message)}
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

// Show success message
function showSuccess(message) {
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-success alert-dismissible fade show position-fixed';
    alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
    alertDiv.innerHTML = `
        <i class="fas fa-check-circle me-2"></i>
        ${escapeHtml(message)}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(alertDiv);
    
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 3000);
}

// Show add user modal
function showAddUserModal() {
    // Clear form
    document.getElementById('userName').value = '';
    document.getElementById('userEmail').value = '';
    
    // Show modal
    addUserModal.show();
}

// Add a new user
async function addUser() {
    const name = document.getElementById('userName').value.trim();
    const email = document.getElementById('userEmail').value.trim();
    
    if (!name || !email) {
        showError('Please fill in both name and email fields');
        return;
    }
    
    if (!isValidEmail(email)) {
        showError('Please enter a valid email address');
        return;
    }
    
    try {
        const response = await fetch('/api/users', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ name, email })
        });
        
        const result = await response.json();
        
        if (!response.ok) {
            throw new Error(result.error || 'Failed to add user');
        }
        
        showSuccess('User added successfully!');
        addUserModal.hide();
        loadUsers(); // Refresh the table
        
    } catch (error) {
        console.error('Error adding user:', error);
        showError('Failed to add user: ' + error.message);
    }
}

// Delete a user
async function deleteUser(id) {
    if (!confirm('Are you sure you want to delete this user?')) {
        return;
    }
    
    try {
        const response = await fetch(`/api/users/${id}`, {
            method: 'DELETE'
        });
        
        const result = await response.json();
        
        if (!response.ok) {
            throw new Error(result.error || 'Failed to delete user');
        }
        
        showSuccess('User deleted successfully!');
        loadUsers(); // Refresh the table
        
    } catch (error) {
        console.error('Error deleting user:', error);
        showError('Failed to delete user: ' + error.message);
    }
}

// Reset database
async function resetDatabase() {
    if (!confirm('Are you sure you want to reset the database? This will delete all users and reload sample data.')) {
        return;
    }
    
    try {
        const response = await fetch('/api/reset', {
            method: 'POST'
        });
        
        const result = await response.json();
        
        if (!response.ok) {
            throw new Error(result.error || 'Failed to reset database');
        }
        
        showSuccess('Database reset successfully!');
        loadUsers(); // Refresh the table
        
    } catch (error) {
        console.error('Error resetting database:', error);
        showError('Failed to reset database: ' + error.message);
    }
}

// Refresh users table
function refreshUsers() {
    loadUsers();
}

// Check server status
async function checkServerStatus() {
    try {
        const response = await fetch('/api/users');
        const statusIndicator = document.getElementById('statusIndicator');
        const statusText = document.getElementById('statusText');
        const dbStatus = document.getElementById('dbStatus');
        
        if (response.ok) {
            statusIndicator.className = 'status-indicator status-online';
            statusText.textContent = 'Server Online';
            dbStatus.textContent = 'Online';
            dbStatus.className = 'text-success';
        } else {
            throw new Error('Server not responding');
        }
    } catch (error) {
        const statusIndicator = document.getElementById('statusIndicator');
        const statusText = document.getElementById('statusText');
        const dbStatus = document.getElementById('dbStatus');
        
        statusIndicator.className = 'status-indicator status-offline';
        statusText.textContent = 'Server Offline';
        dbStatus.textContent = 'Offline';
        dbStatus.className = 'text-danger';
    }
}

// Update statistics
function updateStats(userCount) {
    document.getElementById('totalUsers').textContent = userCount;
}

// API Testing Functions
async function testGetUsers() {
    try {
        const response = await fetch('/api/users');
        const data = await response.json();
        displayApiResponse('GET /api/users', response.status, data);
    } catch (error) {
        displayApiResponse('GET /api/users', 'ERROR', { error: error.message });
    }
}

async function testAddUser() {
    try {
        const testUser = {
            name: 'Test User ' + Date.now(),
            email: 'test' + Date.now() + '@example.com'
        };
        
        const response = await fetch('/api/users', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(testUser)
        });
        
        const data = await response.json();
        displayApiResponse('POST /api/users', response.status, data);
        
        // Refresh users table
        loadUsers();
    } catch (error) {
        displayApiResponse('POST /api/users', 'ERROR', { error: error.message });
    }
}

async function testDeleteUser() {
    try {
        const response = await fetch('/api/users/1', {
            method: 'DELETE'
        });
        
        const data = await response.json();
        displayApiResponse('DELETE /api/users/1', response.status, data);
        
        // Refresh users table
        loadUsers();
    } catch (error) {
        displayApiResponse('DELETE /api/users/1', 'ERROR', { error: error.message });
    }
}

async function testResetDatabase() {
    try {
        const response = await fetch('/api/reset', {
            method: 'POST'
        });
        
        const data = await response.json();
        displayApiResponse('POST /api/reset', response.status, data);
        
        // Refresh users table
        loadUsers();
    } catch (error) {
        displayApiResponse('POST /api/reset', 'ERROR', { error: error.message });
    }
}

// Display API response
function displayApiResponse(endpoint, status, data) {
    const apiResponse = document.getElementById('apiResponse');
    const timestamp = new Date().toLocaleTimeString();
    
    apiResponse.innerHTML = `
<span class="text-muted">// ${timestamp}</span>
<span class="text-primary">${endpoint}</span>
<span class="text-secondary">Status: ${status}</span>

${JSON.stringify(data, null, 2)}
    `;
}

// Utility functions
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

function formatDate(dateString) {
    if (!dateString) return 'N/A';
    
    const date = new Date(dateString);
    return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
}

// Keyboard shortcuts
document.addEventListener('keydown', function(event) {
    // Ctrl/Cmd + R to refresh
    if ((event.ctrlKey || event.metaKey) && event.key === 'r') {
        event.preventDefault();
        refreshUsers();
    }
    
    // Ctrl/Cmd + N to add new user
    if ((event.ctrlKey || event.metaKey) && event.key === 'n') {
        event.preventDefault();
        showAddUserModal();
    }
});
