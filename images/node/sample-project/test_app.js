#!/usr/bin/env node

const http = require('http');

// Test configuration
const BASE_URL = 'http://localhost:3000';

function makeRequest(options, data = null) {
    return new Promise((resolve, reject) => {
        const req = http.request(options, (res) => {
            let body = '';
            res.on('data', (chunk) => {
                body += chunk;
            });
            res.on('end', () => {
                try {
                    const parsedBody = JSON.parse(body);
                    resolve({ statusCode: res.statusCode, body: parsedBody });
                } catch (e) {
                    resolve({ statusCode: res.statusCode, body: body });
                }
            });
        });

        req.on('error', (err) => {
            reject(err);
        });

        if (data) {
            req.write(JSON.stringify(data));
        }
        req.end();
    });
}

async function testHealthCheck() {
    console.log('Testing health check...');
    try {
        const response = await makeRequest({
            hostname: 'localhost',
            port: 3000,
            path: '/health',
            method: 'GET'
        });

        if (response.statusCode === 200) {
            console.log(`✓ Health check passed: ${response.body.status}`);
            return true;
        } else {
            console.log(`✗ Health check failed: ${response.statusCode}`);
            return false;
        }
    } catch (error) {
        console.log(`✗ Health check error: ${error.message}`);
        return false;
    }
}

async function testApiEndpoints() {
    console.log('\nTesting API endpoints...');
    
    try {
        // Test creating a user
        console.log('Creating test user...');
        const createResponse = await makeRequest({
            hostname: 'localhost',
            port: 3000,
            path: '/api/users',
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        }, {
            name: 'Test User',
            email: 'test@example.com'
        });

        if (createResponse.statusCode === 201) {
            const user = createResponse.body;
            console.log(`✓ User created with ID: ${user.id}`);
            
            // Test getting all users
            console.log('Getting all users...');
            const getAllResponse = await makeRequest({
                hostname: 'localhost',
                port: 3000,
                path: '/api/users',
                method: 'GET'
            });

            if (getAllResponse.statusCode === 200) {
                console.log(`✓ Retrieved ${getAllResponse.body.length} users`);
            } else {
                console.log(`✗ Failed to get users: ${getAllResponse.statusCode}`);
            }

            // Test getting specific user
            console.log(`Getting user ${user.id}...`);
            const getOneResponse = await makeRequest({
                hostname: 'localhost',
                port: 3000,
                path: `/api/users/${user.id}`,
                method: 'GET'
            });

            if (getOneResponse.statusCode === 200) {
                const retrievedUser = getOneResponse.body;
                console.log(`✓ Retrieved user: ${retrievedUser.name} (${retrievedUser.email})`);
            } else {
                console.log(`✗ Failed to get user: ${getOneResponse.statusCode}`);
            }

            // Test deleting user
            console.log(`Deleting user ${user.id}...`);
            const deleteResponse = await makeRequest({
                hostname: 'localhost',
                port: 3000,
                path: `/api/users/${user.id}`,
                method: 'DELETE'
            });

            if (deleteResponse.statusCode === 200) {
                console.log('✓ User deleted successfully');
            } else {
                console.log(`✗ Failed to delete user: ${deleteResponse.statusCode}`);
            }

        } else {
            console.log(`✗ Failed to create user: ${createResponse.statusCode}`);
        }
    } catch (error) {
        console.log(`✗ API test error: ${error.message}`);
    }
}

async function main() {
    console.log('Node.js Express Application Test');
    console.log('=' * 30);
    
    // Test if server is running
    const healthCheck = await testHealthCheck();
    if (!healthCheck) {
        console.log('\nMake sure the application is running with: npm start');
        process.exit(1);
    }
    
    // Test API endpoints
    await testApiEndpoints();
    
    console.log('\n✓ All tests completed!');
}

if (require.main === module) {
    main().catch(console.error);
}
