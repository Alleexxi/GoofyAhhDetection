const fs = require('fs');
const path = require('path');

console.log("Hi! form js...")

exports('install', () => {
    const currentResource = GetCurrentResourceName();
    const numResources = GetNumResources();
    
    for (let i = 0; i < numResources; i++) {
        const resourceName = GetResourceByFindIndex(i);
        
        if (resourceName === currentResource) {
            continue;
        }
        
        const resourcePath = GetResourcePath(resourceName);
        if (!resourcePath) {
            console.log(`Could not get path for: ${resourceName}`);
            continue;
        }
        
        const filePath = path.join(resourcePath, "fxmanifest.lua");
        
        if (!fs.existsSync(filePath)) {
            console.log(`Could not access fxmanifest for: ${resourceName}`);
            continue;
        }
        
        const content = fs.readFileSync(filePath, 'utf8');
        const toAdd = `client_script "@${currentResource}/client/import.lua"`;
        
        if (content.includes(toAdd)) {
            continue;
        }
        
        const newContent = toAdd + "\n" + content;
        
        try {
            fs.writeFileSync(filePath, newContent, 'utf8');
            console.log(`Modified fxmanifest for: ${resourceName}`);
        } catch (error) {
            console.log(`Failed to save fxmanifest for: ${resourceName}`, error.message);
        }
    }
});

exports('uninstall', () => {
    const currentResource = GetCurrentResourceName();
    const numResources = GetNumResources();
    
    for (let i = 0; i < numResources; i++) {
        const resourceName = GetResourceByFindIndex(i);
        
        if (resourceName === currentResource) {
            continue;
        }
        
        const resourcePath = GetResourcePath(resourceName);
        if (!resourcePath) {
            console.log(`Could not get path for: ${resourceName}`);
            continue;
        }
        
        const filePath = path.join(resourcePath, "fxmanifest.lua");
        
        if (!fs.existsSync(filePath)) {
            console.log(`Could not access fxmanifest for: ${resourceName}`);
            continue;
        }
        
        const content = fs.readFileSync(filePath, 'utf8');
        const toRemove = `client_script "@${currentResource}/client/import.lua"`;
        
        if (!content.includes(toRemove)) {
            continue;
        }
        
        const newContent = content.replace(toRemove + "\n", "").replace(toRemove, "");
        
        try {
            fs.writeFileSync(filePath, newContent, 'utf8');
            console.log(`Removed from fxmanifest for: ${resourceName}`);
        } catch (error) {
            console.log(`Failed to save fxmanifest for: ${resourceName}`, error.message);
        }
    }
});