task.wait(10)  -- Wait for game to fully load

-- Loaded from GitHub: lankpank/itesty
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local localUsername = player.Name

-- ============ CONFIGURATION ============
local ACCOUNT_LABEL = "HopperBot"
local MAX_PLAYER_COUNT = 11
local RIFT_NAME = "overlord-rift"  -- Change to "dark-rift" or whatever rift you want
local RIFT_PATH = workspace.Rendered.Rifts
local RIFT_CHECK_DELAY = 1
local HOP_COOLDOWN = 10
local MAX_RETRY_ATTEMPTS = 10  -- How many servers to try before giving up
local AUTO_TELEPORT_TO_RIFT = true  -- Set to true to auto-teleport to rift when found
local TELEPORT_DELAY = 2  -- Seconds to wait before teleporting to rift

-- NEW: Pre-hop delay configuration
local PRE_HOP_DELAY = 60  -- Seconds to wait before hopping after checking for rift

-- ============ EGG SCAN CONFIGURATION ============
local SCAN_FOR_EGG = true  -- Set to true to scan and teleport to egg after rift
local TARGET_EGG_NAME = "Overlord Egg"  -- Change to the egg you want to teleport to
local EGG_SCAN_DELAY = 0.5  -- Seconds to wait after rift teleport before scanning for egg
local TELEPORT_TO_EGG_DELAY = 1  -- Seconds to wait before teleporting to egg

-- ============ PING CONFIGURATION ============
local PING_EVERYONE = true  -- Set to true to ping @everyone when rift is found

-- Webhooks
local w_main = "https://discord.com/api/webhooks/1443518513934237706/SYlpNc5bZqXECZAYf98HD5yjrIZqmsKhSyzTArormuUv_V5HAZWB7nv2yQxufw0ix4v7"
local w_notify = "https://discord.com/api/webhooks/1497653143981396051/y64QfolU0nyeIMaQfGhLOrOFRenDfrBSI15SGMYMy1iUNCQSubtpNf_QO-kL-5ThBiJg"

-- ============ SERVER LIST (Auto-updated) ============
local SERVER_LIST = {
        "ded5dfe9-6a7c-47f6-874e-97c541062bff",
        "4f97e826-423c-4d33-8864-dbaef050c0a3",
        "b03ba380-bb2f-4959-a0d9-c0bd59d4f2d2",
        "7282136a-cdcd-4590-a035-35910d98058c",
        "92520717-9e37-47d4-b953-8218b8d2e1fb",
        "584c0a0c-1e28-4835-8ef1-4190eeb4788e",
        "7f55034b-dbe3-442d-8571-179624acc6ff",
        "90408f07-aa64-42dd-9098-b025795c6b07",
        "8c783fe9-cfa2-49bb-925e-8a7fb0f3244c",
        "1fdd4010-5703-42fc-bb35-fdc56e6175f4",
        "041133d4-e50e-4f02-9761-dcec4fd53d34",
        "d2f5dfa0-f397-4098-9a22-845f052f27bf",
        "9f230d47-cbeb-45e6-8b2b-d5bdc5914797",
        "7f8b4e1e-7dca-4e20-96c9-f6da76107c8f",
        "d547231b-2808-4c3e-972c-1d9438e17427",
        "38a46986-e036-473e-8e5e-2aa934ad11b5",
        "4221f8ce-2e65-4359-9e57-c7e0bc892084",
        "8a8ed303-c8dd-486c-8d2c-d2c755aeaccd",
        "8957c5c9-8fe1-4e13-b5df-bb92021500c8",
        "3740dc76-12f4-4d52-81f6-906137d7f729",
        "bb2520b6-c7ea-452d-a584-589305ca3fc2",
        "69e3a22b-6146-4652-a76e-e5833d001966",
        "324d0e12-045a-42f5-befe-55ad9c4e543d",
        "b291fdce-b964-46a2-a599-79e5dc717b26",
        "d3a11208-4e0d-4e15-8ac0-04864ed4c76c",
        "8d55c360-3006-4f3b-b021-d96426cf48fc",
        "cbd1c7c6-687f-4eb4-814c-3a8a42dd8b2e",
        "ede4fe20-0141-48b4-a229-8dc0ea84a014",
        "9b7969ba-5027-434d-9d84-c7867ebc91e5",
        "f363d2d7-b860-47b3-8b01-dfae5791f206",
        "ef08da69-172e-48ae-b156-f725c0b3e442",
        "d0876ff9-a167-4984-98fa-b0eb15bf715f",
        "95ce5447-9d19-4986-903f-c1c406d725d5",
        "521588a6-9ce4-4eda-ab9d-270994839d30",
        "b2a1652c-79d6-4df4-bd43-d9772211df5b",
        "c103a8bb-81a6-44fe-8a68-e2e2aaa4796f",
        "e9728f3a-30cf-4fe6-bd77-0fa0c6bc20af",
        "5856d84e-a60f-4e24-8f68-7a62946dd3bf",
        "81caaeaf-24ec-4d30-bebd-202bda6c0654",
        "5a5f1ded-36df-4b63-9035-2b2d1736d84b",
        "c77b9fa2-93d1-488b-9d96-947b7a18c0fd",
        "d6a867eb-853c-4b81-99f7-118ef26d155f",
        "f5704b76-f81b-40bb-9ca8-50b099a0a43a",
        "108f66a8-2211-45c8-9e1f-2a639e1c6e4c",
        "9f0ed94c-9515-4f75-96aa-42f56a9c6e89",
        "9699bbb9-461e-488a-b376-ec5801f7393e",
        "f7840e5b-0b4c-4994-a4f7-5e92032a1368",
        "792e99fd-8712-4ffe-b267-cdd3f042401b",
        "9573cfe4-1bf6-4feb-bd17-5ee56e83177a",
        "5b104000-60e1-4146-b841-33cbac6f9396",
        "f4332eea-fb4b-4dce-a82f-9862ab2956ef",
        "93d81cf3-da94-4510-961d-82327dd969c7",
        "3a58b735-7387-4006-9b0c-e1eea68883b1",
        "13d0a107-d92b-4b4b-89cc-65a439d83109",
        "eff355e5-caa1-42b4-83ca-06d3f2dd3603",
        "e35562c2-aeee-46ad-aeed-8bf4cbdeb618",
        "1132e72b-78e5-45ce-9115-3c369c4d744e",
        "69ebc3ae-8e60-48b6-956d-54a41cd4ce85",
        "a8a65703-f85e-4874-89aa-daef1eb7bc94",
        "850cb166-038a-4f13-92d6-a011e3efc0a9",
        "654dc562-f5e2-4d57-92a2-28ebbd8638c1",
        "e0064d6d-b6b9-4ebc-9a49-db01a4c1a995",
        "79858c93-a171-4b4d-b6e0-8e60c2fa0080",
        "3263da9d-0baf-4e75-9834-b3fe5b9493b7",
        "61d57556-9ff7-4805-8f4d-e2c7e0c0260a",
        "e71dbcd0-aa86-490b-8b23-742943ad33c5",
        "f77e8ff5-257e-4308-9e48-06adf43ad088",
        "b44f95b3-9041-4c2a-a137-de8422319f4e",
        "02d1010e-50d5-4d11-bb1f-984f8434d078",
        "0238e3a1-5c5b-4f6e-9886-16a57c9929b2",
        "56f3e323-a034-406b-b94c-efdeb403fb00",
        "f0996e25-d4da-459d-a88b-90fdb8f92eb9",
        "390cf100-f6a1-4600-81da-963495fca64c",
        "74e69530-7f39-4d0e-a129-766ebab31f2f",
        "77e0fd3e-e654-4043-ba18-7ecf978c5aed",
        "1d9c9fdc-1758-4539-8123-28e5dc554d84",
        "49ab9eab-3b01-4ece-9070-371e91b21467",
        "69fef36e-a3cd-4d2f-a19f-986df8d158ae",
        "a5a04caa-f75b-446b-ad5e-f3e417b0d4a2",
        "5c759a37-442e-4593-bab9-e291ee1e972e",
        "fdf605ab-8566-4a69-ae32-048053baa0cd",
        "ce5c9b9e-f667-4345-aea8-63bd45a37832",
        "c699f455-669a-4718-96d1-2a05ccea8d39",
        "4c6228c8-e341-428c-9800-59f393770214",
        "28489db1-627d-4745-b45e-6b02f4c58b1b",
        "0f858f72-9a97-4e4c-a762-7c795d4825b2",
        "e7eb114f-6b6b-493e-8200-34dd43e926de",
        "f0996e25-d4da-459d-a88b-90fdb8f92eb9",
        "390cf100-f6a1-4600-81da-963495fca64c",
        "74e69530-7f39-4d0e-a129-766ebab31f2f",
        "77e0fd3e-e654-4043-ba18-7ecf978c5aed",
        "1d9c9fdc-1758-4539-8123-28e5dc554d84",
        "49ab9eab-3b01-4ece-9070-371e91b21467",
        "69fef36e-a3cd-4d2f-a19f-986df8d158ae",
        "a5a04caa-f75b-446b-ad5e-f3e417b0d4a2",
        "5c759a37-442e-4593-bab9-e291ee1e972e",
        "fdf605ab-8566-4a69-ae32-048053baa0cd",
        "c699f455-669a-4718-96d1-2a05ccea8d39",
        "4c6228c8-e341-428c-9800-59f393770214",
        "28489db1-627d-4745-b45e-6b02f4c58b1b",
        "0f858f72-9a97-4e4c-a762-7c795d4825b2",
        "e7eb114f-6b6b-493e-8200-34dd43e926de",
        "61ae9643-d9f8-49ab-81a2-8752f09da756",
        "0173ee59-f260-4a3f-b91c-8bc4b1e673eb",
        "c0cf59f8-054e-417f-ab9c-3d28a94ff1d5",
        "c0ae6f0a-5957-4c1d-925b-eca63cc1b1d6",
        "d89dcd96-d6a1-4f28-88a5-954bcf847187",
        "f88c4aaa-2cf5-4562-83f5-9daa14eccec3",
        "4c95baf4-87f0-4736-b97d-7c0d5aa40af4",
        "b691191e-883a-46ef-85ac-c0c5466839a1",
        "09aff9ff-649d-46ae-8e9f-fb8461301f4e",
        "a8a65703-f85e-4874-89aa-daef1eb7bc94",
        "2d8df2c9-c04e-43eb-b0dd-a5f7d5ed1f4d",
        "90fdbee6-6a55-4540-a593-ded58b6c46d7",
        "ebe524c2-bfb5-4afe-9de3-6818b28c82df",
        "ce5c9b9e-f667-4345-aea8-63bd45a37832",
        "e0064d6d-b6b9-4ebc-9a49-db01a4c1a995",
        "6ae6e6e3-29c0-4f79-97e6-b160c9549126",
        "6921f3ef-729c-4e81-8305-bb1db8c97fa8",
        "6c248f5b-7fc3-43a2-9c0d-9e67ba0e98e7",
        "a47e1b11-af08-4350-a2d8-cdcd73e2548d",
        "b0e3dd75-8f2d-42b3-b687-7433843d53f8",
        "47be5bdb-6035-4c82-b0f7-707466712b72",
        "ceba35aa-7e85-4e1d-96c8-9362318ae06b",
        "befabdbe-8f42-4229-9630-5f6aa78c5084",
        "77ec9976-caee-49f8-825b-d5fa95bfed1f",
        "a1ebf777-affe-4bb1-b588-2e2909936d56",
        "ee769c0d-0963-4720-98bf-268808a8b73b",
        "eacea845-dce5-41a7-a559-57f6e038d4aa",
        "f08375f9-85dd-46de-a60c-660908fdee20",
        "11590b6b-3b65-4b72-8dad-11bfad1c9753",
        "fd60f008-bfad-4c35-a30e-5b05d23694ca",
        "cf9ce47c-5aea-446f-9b01-c98eb205c7fe",
        "042d327e-3030-4dca-abac-1b161d11227b",
        "aab529c4-fd49-47ea-8e61-976db8ed5778",
        "782434cd-7a2d-4776-b957-06929d652833",
        "d3fb4788-50ad-4d51-be05-aebe23c54aad",
        "4d41c8e7-c6ce-403c-ab31-d9c767dfed41",
        "8a342cb4-2913-491c-88a4-29af6747f3d0",
        "6eede3b0-9846-4ed2-8812-bf024430a03a",
        "14cf083d-0ef1-4069-aeb6-9e8de85838ff",
        "8bd62bbb-7355-4257-b1ae-16ce6c8be8a5",
        "705beab1-5e40-43ce-8315-5eccf039b988",
        "b5cc09b1-d069-476e-8d53-d08ac6620a93",
        "e34d87ce-7a94-4b2c-b445-f7dea74b4fb5",
        "7b4f5292-dfcb-49da-991d-d2c89bd50b05",
        "126defb4-14eb-4a7e-8e73-bc0bbf2be628",
        "d39d4382-8c1d-4895-bb47-da73546d5138",
        "755464f0-e90e-432b-b0aa-5d96c22552c1",
        "4bc6dd8e-3df0-47ed-a210-c76a760aa12d",
        "15ea386a-bdf8-4e20-883b-82ab98b8a270",
        "18747ea2-33fa-488a-9a3e-a5e331fa7cc0",
        "9b23baf4-c924-46c9-83ca-8a946b9a85a8",
        "cd2312d3-c8c6-47f5-8888-e564534c83c7"
    }

-- ============ STATE ============
local isHopping = false
local riftActive = false
local hasTeleportedToRift = false
local hasTeleportedToEgg = false

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

-- ============ EGG SCAN SYSTEM ============
-- This replicates the scan system from the file you provided
local function scanForEgg(eggName)
    if type(eggName) ~= "string" or eggName == "" then
        print("❌ No egg name provided to scan for!")
        return nil
    end
    
    print("🔍 Scanning for egg: " .. eggName)
    
    -- Try to find the egg in workspace.Rendered.Eggs or through the chunker system
    local eggPosition = nil
    
    -- Method 1: Check Rendered.Eggs folder
    local rendered = workspace:FindFirstChild("Rendered")
    if rendered then
        local eggsFolder = rendered:FindFirstChild("Eggs")
        if eggsFolder then
            for _, eggModel in ipairs(eggsFolder:GetChildren()) do
                if eggModel:IsA("Model") and eggModel.Name == eggName then
                    local ok, pivot = pcall(function() return eggModel:GetPivot() end)
                    if ok and typeof(pivot) == "CFrame" then
                        eggPosition = pivot.Position
                        print("✅ Found egg '" .. eggName .. "' in Rendered.Eggs at position: " .. tostring(eggPosition))
                        break
                    end
                end
            end
        end
    end
    
    -- Method 2: Check through Chunker system (similar to the scan in your file)
    if not eggPosition then
        if rendered then
            for _, d in ipairs(rendered:GetDescendants()) do
                if d.Name == "Chunker" then
                    for _, inst in ipairs(d:GetDescendants()) do
                        if inst:IsA("Model") and inst.Name == eggName then
                            local ok, pivot = pcall(function() return inst:GetPivot() end)
                            if ok and typeof(pivot) == "CFrame" then
                                eggPosition = pivot.Position
                                print("✅ Found egg '" .. eggName .. "' in Chunker at position: " .. tostring(eggPosition))
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Method 3: Check workspace directly
    if not eggPosition then
        local eggModel = workspace:FindFirstChild(eggName)
        if eggModel and eggModel:IsA("Model") then
            local ok, pivot = pcall(function() return eggModel:GetPivot() end)
            if ok and typeof(pivot) == "CFrame" then
                eggPosition = pivot.Position
                print("✅ Found egg '" .. eggName .. "' in workspace at position: " .. tostring(eggPosition))
            end
        end
    end
    
    if not eggPosition then
        print("❌ Could not find egg: " .. eggName)
        return nil
    end
    
    return eggPosition
end

local function teleportToEgg(eggName)
    if type(eggName) ~= "string" or eggName == "" then
        print("❌ No egg name provided to teleport to!")
        return false
    end
    
    if hasTeleportedToEgg then
        print("⏳ Already teleported to this egg!")
        return true
    end
    
    print("🔍 Scanning for egg: " .. eggName)
    
    -- Wait a moment for the chunker to load
    task.wait(1)
    
    -- Scan for the egg position
    local eggPos = scanForEgg(eggName)
    
    if not eggPos then
        print("❌ Could not find egg position for: " .. eggName)
        return false
    end
    
    print("🚀 Attempting to teleport to egg: " .. eggName)
    
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
    
    -- Add a small offset to land above the egg
    local targetPosition = eggPos + Vector3.new(0, 5, 0)
    
    -- Check if we're already at the egg
    local distance = (rootPart.Position - targetPosition).Magnitude
    if distance < 20 then
        print("✅ Already near the egg: " .. eggName)
        hasTeleportedToEgg = true
        return true
    end
    
    -- Teleport using CFrame
    local success = pcall(function()
        rootPart.CFrame = CFrame.new(targetPosition)
        print("✅ Teleported to egg: " .. eggName .. " at height: " .. math.floor(targetPosition.Y) .. " meters!")
        hasTeleportedToEgg = true
        
        -- Send confirmation webhook for egg teleport
        if w_notify ~= "" then
            local message = string.format(
                "%s | User **%s** teleported to egg **%s**!\n> **Height:** %d meters",
                ACCOUNT_LABEL,
                localUsername,
                eggName,
                math.floor(targetPosition.Y)
            )
            sendWebhook(w_notify, { content = message })
        end
    end)
    
    if not success then
        print("❌ Failed to teleport to egg! Trying alternative method...")
        -- Alternative: Use the character's Humanoid to move
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            pcall(function()
                humanoid:MoveTo(targetPosition)
                print("✅ Using MoveTo to approach egg!")
            end)
        end
        return false
    end
    
    return true
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
    
    -- Reset egg teleport state for new scan
    hasTeleportedToEgg = false
    
    -- Auto teleport to rift if enabled
    if AUTO_TELEPORT_TO_RIFT then
        print("⏳ Waiting " .. TELEPORT_DELAY .. " seconds before teleporting to rift...")
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
            teleportStatus = "✅ Teleported to rift!"
        end
        
        -- Add egg scan status
        local eggStatus = "Not scanned"
        if SCAN_FOR_EGG then
            eggStatus = "Scanning for: " .. TARGET_EGG_NAME
            if hasTeleportedToEgg then
                eggStatus = "✅ Teleported to: " .. TARGET_EGG_NAME
            end
        else
            eggStatus = "Disabled"
        end
        
        -- ============ BUILD EMBED FIELDS ============
        local embedFields = {
            { name = "Found By", value = localUsername .. " (" .. ACCOUNT_LABEL .. ")", inline = false },
            { name = "Rift Height", value = tostring(height) .. " meters", inline = false },
            { name = "Players", value = string.format("%d/12", playerCount), inline = false },
            { name = "Rift Teleport Status", value = teleportStatus, inline = false },
            { name = "Egg Teleport Status", value = eggStatus, inline = false }
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
                footer = { text = "Webhook v7.4 - Egg Scan Enabled" }
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
    
    -- ============ SCAN AND TELEPORT TO EGG ============
    if SCAN_FOR_EGG and TARGET_EGG_NAME and TARGET_EGG_NAME ~= "" then
        print("⏳ Waiting " .. EGG_SCAN_DELAY .. " seconds before scanning for egg...")
        task.wait(EGG_SCAN_DELAY)
        
        print("🔍 Attempting to scan and teleport to egg: " .. TARGET_EGG_NAME)
        
        -- Try multiple times to find the egg
        local maxScanAttempts = 5
        for attempt = 1, maxScanAttempts do
            print("🔄 Egg scan attempt " .. attempt .. "/" .. maxScanAttempts)
            
            local success = teleportToEgg(TARGET_EGG_NAME)
            if success then
                print("✅ Successfully teleported to egg: " .. TARGET_EGG_NAME)
                break
            else
                if attempt < maxScanAttempts then
                    print("⏳ Waiting 2 seconds before retrying egg scan...")
                    task.wait(2)
                else
                    print("❌ Failed to teleport to egg after " .. maxScanAttempts .. " attempts")
                end
            end
        end
    end
end

-- ============ HOPPING WITH RETRY LOGIC ============
local function hopServers()
    if isHopping or isRiftValid() then return end
    
    -- ============ PRE-HOP DELAY ============
    -- Simply wait before hopping, no re-check
    print("⏳ Waiting " .. PRE_HOP_DELAY .. " seconds before hopping...")
    task.wait(PRE_HOP_DELAY)
    -- ========================================
    
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
print("⏳ Pre-hop delay:", PRE_HOP_DELAY, "seconds")  -- NEW
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
if SCAN_FOR_EGG then
    print("🥚 Egg scan is ENABLED (target: " .. TARGET_EGG_NAME .. ")")
    print("⏳ Egg scan delay: " .. EGG_SCAN_DELAY .. "s")
else
    print("🥚 Egg scan is DISABLED")
end
print("⏳ Waiting for rift detection...")

while true do
    if isRiftValid() then
        if not riftActive then
            riftActive = true
            hasTeleportedToRift = false  -- Reset for new rift
            hasTeleportedToEgg = false   -- Reset egg teleport state
            print("🎯 RIFT FOUND! Stopping hops.")
            checkAndReportRift()
        else
            print("⏳ Rift still active - waiting...")
        end
    else
        if riftActive then
            riftActive = false
            hasTeleportedToRift = false
            hasTeleportedToEgg = false
            print("❌ Rift ended! Resuming hops.")
        end
        
        if not isHopping then
            hopServers()  -- Pre-hop delay is now inside this function
        end
    end
    
    task.wait(RIFT_CHECK_DELAY)
end