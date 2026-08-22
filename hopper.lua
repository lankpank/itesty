task.wait(45)  -- Wait for game to fully load

-- Loaded from GitHub: lankpank/itesty
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local localUsername = player.Name

-- ============ CONFIGURATION ============
local ACCOUNT_LABEL = "HopperBot"
local MAX_PLAYER_COUNT = 10
local RIFT_NAME = "overlord-rift"
local RIFT_PATH = workspace.Rendered.Rifts
local RIFT_CHECK_DELAY = 1
local HOP_COOLDOWN = 10
local MAX_RETRY_ATTEMPTS = 10  -- How many servers to try before giving up
local AUTO_TELEPORT_TO_RIFT = true  -- Set to true to auto-teleport to rift when found
local TELEPORT_DELAY = 1  -- Seconds to wait before teleporting to rift

-- ============ PING CONFIGURATION ============
local PING_EVERYONE = true  -- Set to true to ping @everyone when rift is found

-- Webhooks
local w_main = "https://discord.com/api/webhooks/1443518513934237706/SYlpNc5bZqXECZAYf98HD5yjrIZqmsKhSyzTArormuUv_V5HAZWB7nv2yQxufw0ix4v7"
local w_notify = "https://discord.com/api/webhooks/1497653143981396051/y64QfolU0nyeIMaQfGhLOrOFRenDfrBSI15SGMYMy1iUNCQSubtpNf_QO-kL-5ThBiJg"

-- ============ SERVER LIST (Auto-updated) ============
local SERVER_LIST = {
        "55286f17-0303-4bec-85e8-cc8b6fd69eaf",
        "f363d2d7-b860-47b3-8b01-dfae5791f206",
        "75b14f1a-842a-4f41-8b31-fe0a53c380c9",
        "38a46986-e036-473e-8e5e-2aa934ad11b5",
        "b44f95b3-9041-4c2a-a137-de8422319f4e",
        "8d55c360-3006-4f3b-b021-d96426cf48fc",
        "ede4fe20-0141-48b4-a229-8dc0ea84a014",
        "f88c4aaa-2cf5-4562-83f5-9daa14eccec3",
        "d3a11208-4e0d-4e15-8ac0-04864ed4c76c",
        "9f230d47-cbeb-45e6-8b2b-d5bdc5914797",
        "e7eb114f-6b6b-493e-8200-34dd43e926de",
        "bd5fe28e-7f9b-4c0b-aba7-d851029930a7",
        "6ae6e6e3-29c0-4f79-97e6-b160c9549126",
        "1aba5a25-8e51-4537-9807-2023e862e33b",
        "11493991-a10a-4674-b088-42de9a876cee",
        "f5704b76-f81b-40bb-9ca8-50b099a0a43a",
        "f7840e5b-0b4c-4994-a4f7-5e92032a1368",
        "b03ba380-bb2f-4959-a0d9-c0bd59d4f2d2",
        "1c931f81-24ba-4d7f-b42d-266aab497033",
        "6c248f5b-7fc3-43a2-9c0d-9e67ba0e98e7",
        "13d0a107-d92b-4b4b-89cc-65a439d83109",
        "eff355e5-caa1-42b4-83ca-06d3f2dd3603",
        "f77e8ff5-257e-4308-9e48-06adf43ad088",
        "3263da9d-0baf-4e75-9834-b3fe5b9493b7",
        "0f858f72-9a97-4e4c-a762-7c795d4825b2",
        "90408f07-aa64-42dd-9098-b025795c6b07",
        "584c0a0c-1e28-4835-8ef1-4190eeb4788e",
        "3740dc76-12f4-4d52-81f6-906137d7f729",
        "61ae9643-d9f8-49ab-81a2-8752f09da756",
        "4f97e826-423c-4d33-8864-dbaef050c0a3",
        "ce5c9b9e-f667-4345-aea8-63bd45a37832",
        "d2f5dfa0-f397-4098-9a22-845f052f27bf",
        "1fdd4010-5703-42fc-bb35-fdc56e6175f4",
        "7f55034b-dbe3-442d-8571-179624acc6ff",
        "7b4f5292-dfcb-49da-991d-d2c89bd50b05",
        "041133d4-e50e-4f02-9761-dcec4fd53d34",
        "a0491ac6-48aa-4f13-939a-e21093c19a69",
        "108f66a8-2211-45c8-9e1f-2a639e1c6e4c",
        "df8a3322-d411-41d7-9621-ebea2ca5a58a",
        "521588a6-9ce4-4eda-ab9d-270994839d30",
        "c103a8bb-81a6-44fe-8a68-e2e2aaa4796f",
        "705beab1-5e40-43ce-8315-5eccf039b988",
        "c99e5357-9909-4dbb-b78b-ffa465d84eb8",
        "ceba35aa-7e85-4e1d-96c8-9362318ae06b",
        "69ebc3ae-8e60-48b6-956d-54a41cd4ce85",
        "95ce5447-9d19-4986-903f-c1c406d725d5",
        "a47e1b11-af08-4350-a2d8-cdcd73e2548d",
        "792e99fd-8712-4ffe-b267-cdd3f042401b",
        "9699bbb9-461e-488a-b376-ec5801f7393e",
        "e9728f3a-30cf-4fe6-bd77-0fa0c6bc20af",
        "c77b9fa2-93d1-488b-9d96-947b7a18c0fd",
        "d3fb4788-50ad-4d51-be05-aebe23c54aad",
        "9f0ed94c-9515-4f75-96aa-42f56a9c6e89",
        "b0e3dd75-8f2d-42b3-b687-7433843d53f8",
        "6921f3ef-729c-4e81-8305-bb1db8c97fa8",
        "2e4e1f19-deb7-41c6-ba9d-857fb7ed36f4",
        "2de779d0-ca30-46b3-9a8c-13d60e3c52b7",
        "9573cfe4-1bf6-4feb-bd17-5ee56e83177a",
        "5b104000-60e1-4146-b841-33cbac6f9396",
        "782434cd-7a2d-4776-b957-06929d652833",
        "69e3a22b-6146-4652-a76e-e5833d001966",
        "f4332eea-fb4b-4dce-a82f-9862ab2956ef",
        "8a8ed303-c8dd-486c-8d2c-d2c755aeaccd",
        "b691191e-883a-46ef-85ac-c0c5466839a1",
        "7282136a-cdcd-4590-a035-35910d98058c",
        "02d1010e-50d5-4d11-bb1f-984f8434d078",
        "3a58b735-7387-4006-9b0c-e1eea68883b1",
        "654dc562-f5e2-4d57-92a2-28ebbd8638c1",
        "93d81cf3-da94-4510-961d-82327dd969c7",
        "e0064d6d-b6b9-4ebc-9a49-db01a4c1a995",
        "79858c93-a171-4b4d-b6e0-8e60c2fa0080",
        "8957c5c9-8fe1-4e13-b5df-bb92021500c8",
        "850cb166-038a-4f13-92d6-a011e3efc0a9",
        "f08375f9-85dd-46de-a60c-660908fdee20",
        "e71dbcd0-aa86-490b-8b23-742943ad33c5",
        "126defb4-14eb-4a7e-8e73-bc0bbf2be628",
        "0238e3a1-5c5b-4f6e-9886-16a57c9929b2",
        "f0996e25-d4da-459d-a88b-90fdb8f92eb9",
        "5c759a37-442e-4593-bab9-e291ee1e972e",
        "042d327e-3030-4dca-abac-1b161d11227b",
        "56f3e323-a034-406b-b94c-efdeb403fb00",
        "af83a909-1ae4-4713-be14-246fb8d5cee2",
        "c699f455-669a-4718-96d1-2a05ccea8d39",
        "b291fdce-b964-46a2-a599-79e5dc717b26",
        "74e69530-7f39-4d0e-a129-766ebab31f2f",
        "faa433cf-3a0c-4736-9123-e5c0932b76aa",
        "324d0e12-045a-42f5-befe-55ad9c4e543d",
        "b291fdce-b964-46a2-a599-79e5dc717b26",
        "74e69530-7f39-4d0e-a129-766ebab31f2f",
        "faa433cf-3a0c-4736-9123-e5c0932b76aa",
        "324d0e12-045a-42f5-befe-55ad9c4e543d",
        "1d9c9fdc-1758-4539-8123-28e5dc554d84",
        "d0876ff9-a167-4984-98fa-b0eb15bf715f",
        "81caaeaf-24ec-4d30-bebd-202bda6c0654",
        "69fef36e-a3cd-4d2f-a19f-986df8d158ae",
        "b9419302-33e5-4c2b-8838-b4513289321b",
        "a5a04caa-f75b-446b-ad5e-f3e417b0d4a2",
        "cb0b1b4f-d6fa-4383-89fc-2614db9020b6",
        "fd60f008-bfad-4c35-a30e-5b05d23694ca",
        "2d8df2c9-c04e-43eb-b0dd-a5f7d5ed1f4d",
        "11590b6b-3b65-4b72-8dad-11bfad1c9753",
        "95a4ce3b-e232-45dc-963c-c24c42a0e1f5",
        "0173ee59-f260-4a3f-b91c-8bc4b1e673eb",
        "4d41c8e7-c6ce-403c-ab31-d9c767dfed41",
        "4c95baf4-87f0-4736-b97d-7c0d5aa40af4",
        "47be5bdb-6035-4c82-b0f7-707466712b72",
        "8a342cb4-2913-491c-88a4-29af6747f3d0",
        "4c6228c8-e341-428c-9800-59f393770214",
        "d89dcd96-d6a1-4f28-88a5-954bcf847187",
        "24817b1a-0fbc-42ec-9ab5-8f29fa0b5066",
        "fea8188a-c50e-43f3-8433-00974c0890e7",
        "aab529c4-fd49-47ea-8e61-976db8ed5778",
        "6eede3b0-9846-4ed2-8812-bf024430a03a",
        "14cf083d-0ef1-4069-aeb6-9e8de85838ff",
        "ebe524c2-bfb5-4afe-9de3-6818b28c82df",
        "90fdbee6-6a55-4540-a593-ded58b6c46d7",
        "ccda4eb8-72f6-48c2-96c0-1b9b56c3853e",
        "83dd5659-433d-4f40-b754-16a38907f3a8",
        "09aff9ff-649d-46ae-8e9f-fb8461301f4e",
        "9b7969ba-5027-434d-9d84-c7867ebc91e5",
        "ef08da69-172e-48ae-b156-f725c0b3e442",
        "31d0414f-cd6c-410f-94e5-7e88ae2e575d",
        "34cc6e79-c69d-40a8-834f-ec1b3752e4aa",
        "28489db1-627d-4745-b45e-6b02f4c58b1b",
        "bd387430-a24c-42dc-a546-05f7993fc8be",
        "d547231b-2808-4c3e-972c-1d9438e17427",
        "b2a1652c-79d6-4df4-bd43-d9772211df5b",
        "755464f0-e90e-432b-b0aa-5d96c22552c1",
        "5856d84e-a60f-4e24-8f68-7a62946dd3bf",
        "e34d87ce-7a94-4b2c-b445-f7dea74b4fb5",
        "befabdbe-8f42-4229-9630-5f6aa78c5084",
        "dcd14dc7-7eea-464f-a00d-b8ffc5c1c63a",
        "49ab9eab-3b01-4ece-9070-371e91b21467",
        "c0ae6f0a-5957-4c1d-925b-eca63cc1b1d6",
        "4bc6dd8e-3df0-47ed-a210-c76a760aa12d",
        "b6a0d48b-64a3-4ae7-8dc5-730d5638c7fd",
        "4221f8ce-2e65-4359-9e57-c7e0bc892084",
        "4a8b9e16-515e-4586-b615-cfe7c99cb391",
        "390cf100-f6a1-4600-81da-963495fca64c",
        "a1ebf777-affe-4bb1-b588-2e2909936d56",
        "18747ea2-33fa-488a-9a3e-a5e331fa7cc0",
        "478cd5ac-343d-4451-8c7b-0c449f47ecfd",
        "d39d4382-8c1d-4895-bb47-da73546d5138",
        "15561c58-33ce-4918-8865-2909aaac9122",
        "03b48d3f-103e-4656-9587-f1e13be2e0d4",
        "77ec9976-caee-49f8-825b-d5fa95bfed1f",
        "ee769c0d-0963-4720-98bf-268808a8b73b",
        "a8a65703-f85e-4874-89aa-daef1eb7bc94",
        "9b23baf4-c924-46c9-83ca-8a946b9a85a8",
        "cf9ce47c-5aea-446f-9b01-c98eb205c7fe",
        "8bd62bbb-7355-4257-b1ae-16ce6c8be8a5",
        "15ea386a-bdf8-4e20-883b-82ab98b8a270",
        "b5cc09b1-d069-476e-8d53-d08ac6620a93",
        "b1ee0589-7720-4ca4-bffe-8a9af7ec5313",
        "cd2312d3-c8c6-47f5-8888-e564534c83c7"
    }

-- ============ STATE ============
local isHopping = false
local riftActive = false
local hasTeleportedToRift = false

-- ============ WEBHOOK ============
local function sendWebhook(targetUrl, payload)
    if targetUrl == "" then return end
    local requestBody = HttpService:JSONEncode(payload)
    pcall(function()
        if syn and syn.request then
            return syn.request({Url=targetUrl,Method="POST",Headers={["Content-Type"]="application/json"},Body=requestBody})
        elseif request then
            return request({Url=targetUrl,Method="POST",Headers={["Content-Type"]="application/json"},Body=requestBody})
        elseif http and http.request then
            return http.request({Url=targetUrl,Method="POST",Headers={["Content-Type"]="application/json"},Body=requestBody})
        end
    end)
end

-- ============ RIFT ============
local function isRiftValid()
    local rift = RIFT_PATH:FindFirstChild(RIFT_NAME)
    return rift and rift:FindFirstChild("Display") and rift.Display:IsA("BasePart") and rift or nil
end

-- ============ AUTO TELEPORT TO RIFT ============
local function teleportToRift()
    local riftInstance = isRiftValid()
    if not riftInstance then 
        print("❌ No rift found to teleport to!")
        return false 
    end
    
    if hasTeleportedToRift then
        print("⏳ Already teleported to this rift!")
        return true
    end
    
    print("🚀 Attempting to teleport to rift...")
    
    -- Get the character
    local character = player.Character
    if not character or not character.Parent then
        print("❌ Character not found! Waiting for respawn...")
        task.wait(2)
        character = player.Character
        if not character or not character.Parent then
            print("❌ Still no character! Cannot teleport.")
            return false
        end
    end
    
    -- Get the humanoid root part or primary part
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
    if not rootPart then
        print("❌ No root part found!")
        return false
    end
    
    -- Get rift position (slightly above the display for landing)
    local riftPosition = riftInstance.Display.Position + Vector3.new(0, 5, 0)
    
    -- Check if we're already at the rift
    local distance = (rootPart.Position - riftPosition).Magnitude
    if distance < 20 then
        print("✅ Already near the rift!")
        hasTeleportedToRift = true
        return true
    end
    
    -- Teleport using CFrame
    local success = pcall(function()
        rootPart.CFrame = CFrame.new(riftPosition)
        print("✅ Teleported to rift at height: " .. math.floor(riftPosition.Y) .. " meters!")
        hasTeleportedToRift = true
        
        -- Send confirmation webhook
        if w_notify ~= "" then
            local message = string.format(
                "%s | User **%s** teleported to rift!\n> **Height:** %d meters",
                ACCOUNT_LABEL,
                localUsername,
                math.floor(riftPosition.Y)
            )
            sendWebhook(w_notify, { content = message })
        end
    end)
    
    if not success then
        print("❌ Failed to teleport to rift! Trying alternative method...")
        -- Alternative: Use the character's Humanoid to move
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            pcall(function()
                humanoid:MoveTo(riftPosition)
                print("✅ Using MoveTo to approach rift!")
            end)
        end
        return false
    end
    
    return true
end

local function checkAndReportRift()
    local riftInstance = isRiftValid()
    if not riftInstance then return end
    
    print("🎯 RIFT FOUND!")
    
    -- Auto teleport to rift if enabled
    if AUTO_TELEPORT_TO_RIFT then
        print("⏳ Waiting " .. TELEPORT_DELAY .. " seconds before teleporting...")
        task.wait(TELEPORT_DELAY)
        teleportToRift()
    end
    
    if w_main ~= "" then
        -- Get rift info
        local height = math.floor(riftInstance.Display.Position.Y)
        local playerCount = #Players:GetPlayers()
        local gameId = game.PlaceId
        local jobId = game.JobId
        
        -- ============ GET RIFT TIMER ============
        local discordTimestampValue = ""
        local surfaceGui = riftInstance.Display:FindFirstChild("SurfaceGui")
        local timerGui = surfaceGui and surfaceGui:FindFirstChild("Timer")
        
        if timerGui and timerGui:IsA("TextLabel") then
            local timerText = timerGui.Text
            local minutes = tonumber(string.match(timerText, "(%d+) ?m")) or 0
            local seconds = tonumber(string.match(timerText, "(%d+) ?s")) or 0
            
            if (minutes + seconds) > 0 then
                discordTimestampValue = string.format(
                    "<t:%d:R>",
                    os.time() + (minutes * 60) + seconds
                )
            end
        end
        
        -- ============ GET LUCK VALUE ============
        local luckValue = ""
        local iconPart = riftInstance.Display:FindFirstChild("Icon")
        local luckLabel = iconPart and iconPart:FindFirstChild("Luck")
        
        if luckLabel and luckLabel:IsA("TextLabel") then
            luckValue = luckLabel.Text
        end
        
        -- Generate Direct Server Link and Teleport Script
        local joinLink = "roblox://experiences/start?placeId=" .. gameId .. "&gameInstanceId=" .. jobId
        local teleportScript = string.format(
            'game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s")',
            gameId,
            jobId
        )
        
        -- Build ping message if enabled
        local pingMessage = ""
        if PING_EVERYONE then
            pingMessage = "@everyone **RIFT FOUND!** "
        end
        
        -- Add teleport status to fields
        local teleportStatus = "Not teleported"
        if hasTeleportedToRift then
            teleportStatus = "✅ Teleported!"
        end
        
        -- ============ BUILD EMBED FIELDS ============
        local embedFields = {
            { name = "Found By", value = localUsername .. " (" .. ACCOUNT_LABEL .. ")", inline = false },
            { name = "Rift Height", value = tostring(height) .. " meters", inline = false },
            { name = "Players", value = string.format("%d/12", playerCount), inline = false },
            { name = "Auto-Teleport Status", value = teleportStatus, inline = false }
        }
        
        -- Add Luck if available
        if luckValue and luckValue ~= "" then
            table.insert(embedFields, { name = "Luck", value = luckValue, inline = false })
        end
        
        -- Add Timer if available
        if discordTimestampValue and discordTimestampValue ~= "" then
            table.insert(embedFields, { name = "Ends", value = discordTimestampValue, inline = false })
        end
        
        -- Add Link and Teleport Script
        table.insert(embedFields, { name = "Direct Server Link", value = "```\n" .. joinLink .. "\n```", inline = false })
        table.insert(embedFields, { name = "Teleport Script", value = "```lua\n" .. teleportScript .. "\n```", inline = false })
        
        -- ============ BUILD PAYLOAD ============
        local payload = {
            embeds = {{
                title = RIFT_NAME .. " Found!",
                description = "A rift has been located.",
                color = 65280,
                fields = embedFields,
                footer = { text = "Webhook v7.4" }
            }}
        }
        
        -- Send the embed
        sendWebhook(w_main, payload)
        task.wait(0.5)
        
        -- Send the link with optional ping
        local linkPayload = { content = joinLink }
        if PING_EVERYONE then
            linkPayload = { content = pingMessage .. joinLink }
        end
        sendWebhook(w_main, linkPayload)
        
        if PING_EVERYONE then
            print("🔔 @everyone ping sent for rift at " .. height .. " meters!")
        end
    end
end

-- ============ HOPPING WITH RETRY LOGIC ============
local function hopServers()
    if isHopping or isRiftValid() then return end
    
    isHopping = true
    print("🔍 Finding random server... Available:", #SERVER_LIST)
    
    if #SERVER_LIST > 0 then
        -- Create a copy of the server list to work with
        local availableServers = {}
        for _, id in ipairs(SERVER_LIST) do
            if id ~= game.JobId then
                table.insert(availableServers, id)
            end
        end
        
        if #availableServers > 0 then
            -- Try up to MAX_RETRY_ATTEMPTS different servers
            local maxAttempts = math.min(MAX_RETRY_ATTEMPTS, #availableServers)
            local success = false
            
            for attempt = 1, maxAttempts do
                -- Check if rift appeared during retries
                if isRiftValid() then
                    print("🎯 Rift appeared! Stopping retries.")
                    break
                end
                
                -- Pick a random server from remaining list
                local randomIndex = math.random(1, #availableServers)
                local target = availableServers[randomIndex]
                
                -- Remove it so we don't try again
                table.remove(availableServers, randomIndex)
                
                print(string.format("🔄 Attempt %d/%d - Hopping to: %s", attempt, maxAttempts, target))
                
                -- Send notification to Discord
                if w_notify ~= "" then
                    local message = string.format(
                        "%s | User **%s** is hopping.\n> **To:** %s\n> **Players:** Under %d\n> **Attempt:** %d/%d",
                        ACCOUNT_LABEL,
                        localUsername,
                        target,
                        MAX_PLAYER_COUNT,
                        attempt,
                        maxAttempts
                    )
                    sendWebhook(w_notify, { content = message })
                end
                
                task.wait(1)
                
                -- Try to teleport
                local teleportSuccess = pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, target, Players.LocalPlayer)
                end)
                
                if teleportSuccess then
                    print("✅ Teleport successful!")
                    success = true
                    break
                else
                    print("❌ Teleport failed! (Server may be full, dead, or private)")
                    print("🔄 Trying another server...")
                    task.wait(2)  -- Brief pause before next attempt
                end
            end
            
            -- If all attempts failed
            if not success then
                print("❌ All teleport attempts failed. Rejoining...")
                pcall(function()
                    TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
                end)
            end
        else
            print("❌ No other servers available. Rejoining...")
            pcall(function()
                TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
            end)
        end
    else
        print("❌ No servers in list. Rejoining...")
        pcall(function()
            TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
        end)
    end
    
    task.delay(HOP_COOLDOWN, function()
        print("✅ Hop cooldown finished!")
        isHopping = false
    end)
end

-- ============ MAIN LOOP ============
print("🚀 Auto-Hopper Started! Loaded", #SERVER_LIST, "servers from GitHub")
print("📊 Looking for servers with under", MAX_PLAYER_COUNT, "players")
print("🔄 Will retry up to", MAX_RETRY_ATTEMPTS, "servers if teleport fails")
if PING_EVERYONE then
    print("🔔 @everyone ping is ENABLED for rift finds!")
else
    print("🔕 @everyone ping is DISABLED")
end
if AUTO_TELEPORT_TO_RIFT then
    print("🚀 Auto-teleport to rift is ENABLED (delay: " .. TELEPORT_DELAY .. "s)")
else
    print("🚫 Auto-teleport to rift is DISABLED")
end
print("⏳ Waiting for rift detection...")

while true do
    if isRiftValid() then
        if not riftActive then
            riftActive = true
            hasTeleportedToRift = false  -- Reset for new rift
            print("🎯 RIFT FOUND! Stopping hops.")
            checkAndReportRift()
        else
            print("⏳ Rift still active - waiting...")
        end
    else
        if riftActive then
            riftActive = false
            hasTeleportedToRift = false
            print("❌ Rift ended! Resuming hops.")
        end
        
        if not isHopping then
            hopServers()
        end
    end
    
    task.wait(RIFT_CHECK_DELAY)
end