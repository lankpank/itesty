const fetch = (...args) => import('node-fetch').then(({default: fetch}) => fetch(...args));
const fs = require('fs');
const { Octokit } = require("@octokit/rest");

// ============ CONFIGURATION ============
// These are read from GitHub Secrets for security
const PLACE_ID = 85896571713843; // Your game ID
const MAX_PLAYERS = 10;
const ROBLOX_COOKIE = process.env.ROBLOX_COOKIE || "";
const GITHUB_TOKEN = process.env.GITHUB_TOKEN || "";
const REPO_OWNER = "lankpank";
const REPO_NAME = "itesty";
const GITHUB_PATH = "hopper.lua";

// Discord webhook (optional)
const DISCORD_WEBHOOK_URL = "";

// ============ CODE ============
const octokit = new Octokit({ auth: GITHUB_TOKEN });
const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

async function sendDiscordNotification(message) {
    if (!DISCORD_WEBHOOK_URL) return;
    try {
        await fetch(DISCORD_WEBHOOK_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ content: message }),
        });
    } catch (error) {
        console.error("Couldn't send Discord notif:", error.message);
    }
}

async function apiFetch(url) {
    const options = {
        method: 'GET',
        headers: { 
            'Accept': 'application/json',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        }
    };
    
    if (ROBLOX_COOKIE && ROBLOX_COOKIE !== "") {
        options.headers['Cookie'] = ROBLOX_COOKIE;
        console.log("✅ Using Roblox cookie for authentication");
    } else {
        console.warn("⚠️ No Roblox cookie provided!");
    }
    
    return fetch(url, options);
}

async function fetchAllServers() {
    let allServers = [];
    let cursor = "";
    const urlTemplate = `https://games.roblox.com/v1/games/${PLACE_ID}/servers/Public?limit=100&cursor=`;
    let totalScanned = 0;
    let retryCount = 0;
    const MAX_RETRIES = 10;
    
    console.log(`\n🔍 Scanning for servers with < ${MAX_PLAYERS} players`);
    console.log(`📁 Place ID: ${PLACE_ID}`);
    console.log(`🍪 Cookie: ${ROBLOX_COOKIE ? '✅ Set' : '❌ Not set'}`);
    
    while (true) {
        if (retryCount >= MAX_RETRIES) {
            console.error(`\n❌ Max retries reached`);
            break;
        }
        
        try {
            const response = await apiFetch(urlTemplate + cursor);
            
            if (response.status === 429) {
                retryCount++;
                const waitTime = 5000 * Math.pow(2, retryCount - 1) + (Math.random() * 1000);
                console.warn(`\n⏳ Rate limited (attempt ${retryCount}/${MAX_RETRIES}). Waiting ${(waitTime / 1000).toFixed(1)}s...`);
                await sleep(waitTime);
                continue;
            }
            
            if (!response.ok) {
                throw new Error(`API returned status ${response.status}`);
            }
            
            retryCount = 0;
            const pageData = await response.json();
            const serversOnPage = pageData.data || [];
            
            if (serversOnPage.length === 0) break;
            
            totalScanned += serversOnPage.length;
            
            const suitableServers = serversOnPage.filter(server => server.playing < MAX_PLAYERS);
            
            if (suitableServers.length > 0) {
                allServers.push(...suitableServers.map(server => server.id));
            }
            
            cursor = pageData.nextPageCursor;
            process.stdout.write(`\r📊 Scanned ${totalScanned} | Found ${suitableServers.length} | Total: ${allServers.length}`);
            
            if (!cursor) break;
            await sleep(500);
            
        } catch (error) {
            console.error("\n❌ Error during server fetch:", error.message);
            retryCount++;
            await sleep(5000);
        }
    }
    
    console.log(`\n✅ Done! ${allServers.length} suitable servers found\n`);
    return allServers;
}

function generateLuaScript(serverList) {
    // Create the server list as a Lua table
    const serverIds = serverList.map(id => `        "${id}"`);
    const luaTable = `{\n${serverIds.join(',\n')}\n    }`;
    
    // Read the template
    let luaTemplate = fs.readFileSync('hopper_template.lua', 'utf8');
    
    // Replace placeholder
    const finalLua = luaTemplate.replace('SERVER_LIST_PLACEHOLDER', luaTable);
    
    return finalLua;
}

async function uploadToGitHub(content) {
    try {
        console.log("📤 Uploading to GitHub...");
        
        // Check if file exists
        let existingSha;
        try {
            const { data: fileData } = await octokit.rest.repos.getContent({
                owner: REPO_OWNER,
                repo: REPO_NAME,
                path: GITHUB_PATH,
            });
            existingSha = fileData.sha;
            console.log("📝 File exists, updating...");
        } catch (error) {
            if (error.status !== 404) throw error;
            console.log("📝 File doesn't exist, creating new...");
        }
        
        // Upload/Update file
        await octokit.rest.repos.createOrUpdateFileContents({
            owner: REPO_OWNER,
            repo: REPO_NAME,
            path: GITHUB_PATH,
            message: `[Auto] Updated server list - ${new Date().toISOString()}`,
            content: Buffer.from(content).toString('base64'),
            sha: existingSha,
        });
        
        console.log(`✅ Uploaded to GitHub!`);
        console.log(`🔗 https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main/${GITHUB_PATH}`);
        return true;
    } catch (error) {
        console.error("❌ GitHub upload failed:", error.message);
        return false;
    }
}

async function main() {
    console.log(`\n${'='.repeat(50)}`);
    console.log(`🔄 Scan at ${new Date().toLocaleString()}`);
    console.log(`${'='.repeat(50)}`);
    
    // Check for required secrets
    if (!ROBLOX_COOKIE || ROBLOX_COOKIE === "") {
        console.error("❌ ROBLOX_COOKIE is not set!");
        await sendDiscordNotification("❌ ROBLOX_COOKIE is not set in GitHub Secrets!");
        return;
    }
    
    if (!GITHUB_TOKEN || GITHUB_TOKEN === "") {
        console.error("❌ GITHUB_TOKEN is not set!");
        return;
    }
    
    await sendDiscordNotification(`🔄 Starting scan for ${REPO_OWNER}/${REPO_NAME}`);
    
    const serverList = await fetchAllServers();
    
    if (serverList.length === 0) {
        console.log("❌ No servers found");
        await sendDiscordNotification(`⚠️ No servers found with ${MAX_PLAYERS} or fewer players`);
        return;
    }
    
    // Generate Lua script with server list
    const luaContent = generateLuaScript(serverList);
    
    // Save locally for backup
    fs.writeFileSync('hopper.lua', luaContent);
    fs.writeFileSync('servers.txt', serverList.join('\n'));
    console.log(`✅ Saved locally`);
    
    // Upload to GitHub
    const uploaded = await uploadToGitHub(luaContent);
    
    if (uploaded) {
        console.log(`\n📋 Sample servers (first 3):`);
        for (let i = 0; i < Math.min(3, serverList.length); i++) {
            console.log(`   ${i+1}. ${serverList[i]}`);
        }
        await sendDiscordNotification(`✅ Updated with **${serverList.length}** servers on GitHub`);
    }
}

// ============ RUN ============
console.log(`\n🚀 GitHub Auto-Hopper Scanner`);
console.log(`📁 Place: ${PLACE_ID}`);
console.log(`👥 Max Players: ${MAX_PLAYERS}`);
console.log(`📤 GitHub: ${REPO_OWNER}/${REPO_NAME}/${GITHUB_PATH}`);
console.log(`🔒 Secrets: ${ROBLOX_COOKIE ? '✅ Set' : '❌ Missing'}`);

// Run once
main();
