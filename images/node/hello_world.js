#!/usr/bin/env node
/**
 * Simple Hello World program in Node.js
 */

const readline = require('readline');

function main() {
    console.log("Hello, World!");
    console.log("Welcome to Node.js!");

    // Create readline interface
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    // Get user input
    rl.question("What's your name? ", (name) => {
        console.log(`Nice to meet you, ${name}!`);
        rl.close();
    });
}

main();
