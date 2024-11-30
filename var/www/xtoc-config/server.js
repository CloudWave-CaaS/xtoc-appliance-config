const express = require('express');
const auth = require('basic-auth-connect');
const os = require('os');
const crypto = require('crypto');
const path = require('path');

const app = express();
const port = 8080;

// Function to retrieve the MAC address of the first active network interface
function getMacAddress() {
    const networkInterfaces = os.networkInterfaces();
    for (const interfaceName in networkInterfaces) {
        const interfaces = networkInterfaces[interfaceName];
        for (const iface of interfaces) {
            if (!iface.internal && iface.mac) { // Skip internal interfaces (e.g., loopback)
                return iface.mac;
            }
        }
    }
    throw new Error('No active network interface found with a MAC address.');
}

// Function to generate a SHA-256 checksum of the MAC address
function generatePasswordFromMac() {
    const mac = getMacAddress();
    console.log(`MAC: ${mac}`);
    return crypto.createHash('sha256').update(mac).digest('hex');
}

// Generate the password
const username = 'admin';
const password = generatePasswordFromMac();

console.log(`Generated Password (SHA-256 of MAC Address): ${password}`);

// Add Basic Authentication Middleware
app.use(auth(username, password));

// Serve static files (CSS, images, etc.)
app.use(express.static(path.join(__dirname, 'public')));

// Serve the styled index page
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// API route to fetch system information
app.get('/api/system-info', (req, res) => {
    const networkInterfaces = os.networkInterfaces();
    const ipAddresses = Object.values(networkInterfaces)
        .flat()
        .filter((iface) => !iface.internal && iface.family === 'IPv4')
        .map((iface) => iface.address);

    const systemInfo = {
        hostname: os.hostname(),
        ipAddresses,
        osType: os.type(),
        osRelease: os.release(),
        platform: os.platform(),
        uptime: os.uptime(),
    };

    res.json(systemInfo);
});

app.use('/node_modules', express.static(path.join(__dirname, 'node_modules')));


// Start the server
app.listen(port, () => {
    console.log(`Web service running at http://localhost:${port}`);
    console.log(`Use username: admin and password: ${password}`);
});
