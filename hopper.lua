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
local RIFT_NAME = "shadow-rift"  -- Change to "dark-rift" or whatever rift you want
local RIFT_PATH = workspace.Rendered.Rifts
local RIFT_CHECK_DELAY = 1
local HOP_COOLDOWN = 10
local MAX_RETRY_ATTEMPTS = 10  -- How many servers to try before giving up
local AUTO_TELEPORT_TO_RIFT = true  -- Set to true to auto-teleport to rift when found
local TELEPORT_DELAY = 2  -- Seconds to wait before teleporting to rift

-- NEW: Pre-hop delay configuration
local PRE_HOP_DELAY = 70  -- Seconds to wait before hopping after checking for rift

-- ============ EGG SCAN CONFIGURATION ============
local SCAN_FOR_EGG = true  -- Set to true to scan and teleport to egg after rift
local TARGET_EGG_NAME = "Dark Rift Egg"  -- Change to the egg you want to teleport to
local EGG_SCAN_DELAY = 0.5  -- Seconds to wait after rift teleport before scanning for egg
local TELEPORT_TO_EGG_DELAY = 1  -- Seconds to wait before teleporting to egg

-- ============ PING CONFIGURATION ============
local PING_EVERYONE = false  -- Set to true to ping @everyone when rift is found

-- Webhooks
local w_main = "https://discord.com/api/webhooks/1443518513934237706/SYlpNc5bZqXECZAYf98HD5yjrIZqmsKhSyzTArormuUv_V5HAZWB7nv2yQxufw0ix4v7"
local w_notify = "https://discord.com/api/webhooks/1497653143981396051/y64QfolU0nyeIMaQfGhLOrOFRenDfrBSI15SGMYMy1iUNCQSubtpNf_QO-kL-5ThBiJg"

-- ============ SERVER LIST (Auto-updated) ============
local SERVER_LIST = {
        "f8ef5e0c-5439-4c6d-bef8-4a5fa733126c",
        "7f55034b-dbe3-442d-8571-179624acc6ff",
        "7f8b4e1e-7dca-4e20-96c9-f6da76107c8f",
        "f88c4aaa-2cf5-4562-83f5-9daa14eccec3",
        "1c931f81-24ba-4d7f-b42d-266aab497033",
        "81c0a7a3-6c4a-4611-a55e-0401409933f6",
        "92e4ef60-4063-411f-9e37-a67d5846d45e",
        "69fef36e-a3cd-4d2f-a19f-986df8d158ae",
        "28489db1-627d-4745-b45e-6b02f4c58b1b",
        "b691191e-883a-46ef-85ac-c0c5466839a1",
        "d6a867eb-853c-4b81-99f7-118ef26d155f",
        "a64c5ab2-079a-449f-8cc0-17f840723dd8",
        "c77b9fa2-93d1-488b-9d96-947b7a18c0fd",
        "55286f17-0303-4bec-85e8-cc8b6fd69eaf",
        "4802212f-427e-4ad4-9749-aa1a1f17416e",
        "3740dc76-12f4-4d52-81f6-906137d7f729",
        "9f230d47-cbeb-45e6-8b2b-d5bdc5914797",
        "e35562c2-aeee-46ad-aeed-8bf4cbdeb618",
        "31d0414f-cd6c-410f-94e5-7e88ae2e575d",
        "3263da9d-0baf-4e75-9834-b3fe5b9493b7",
        "af83a909-1ae4-4713-be14-246fb8d5cee2",
        "07a4236c-7490-4683-ac2f-6805e4d1927e",
        "6c248f5b-7fc3-43a2-9c0d-9e67ba0e98e7",
        "92520717-9e37-47d4-b953-8218b8d2e1fb",
        "c0cf59f8-054e-417f-ab9c-3d28a94ff1d5",
        "4c6228c8-e341-428c-9800-59f393770214",
        "ce5c9b9e-f667-4345-aea8-63bd45a37832",
        "9fb67dff-1336-4e5c-9053-527b2f8b7f20",
        "ede4fe20-0141-48b4-a229-8dc0ea84a014",
        "bd387430-a24c-42dc-a546-05f7993fc8be",
        "df8a3322-d411-41d7-9621-ebea2ca5a58a",
        "79858c93-a171-4b4d-b6e0-8e60c2fa0080",
        "ded5dfe9-6a7c-47f6-874e-97c541062bff",
        "b2a1652c-79d6-4df4-bd43-d9772211df5b",
        "55b1baec-09f0-41eb-b5a6-7af41f42d58d",
        "4d41c8e7-c6ce-403c-ab31-d9c767dfed41",
        "d3a11208-4e0d-4e15-8ac0-04864ed4c76c",
        "6ae6e6e3-29c0-4f79-97e6-b160c9549126",
        "11493991-a10a-4674-b088-42de9a876cee",
        "c0ae6f0a-5957-4c1d-925b-eca63cc1b1d6",
        "d2f5dfa0-f397-4098-9a22-845f052f27bf",
        "b6a0d48b-64a3-4ae7-8dc5-730d5638c7fd",
        "f7840e5b-0b4c-4994-a4f7-5e92032a1368",
        "7f3c938a-9815-472b-adf3-341f39825d72",
        "71a3f9c7-b879-45b1-ac5f-21d9d2121260",
        "d39d4382-8c1d-4895-bb47-da73546d5138",
        "18747ea2-33fa-488a-9a3e-a5e331fa7cc0",
        "4221f8ce-2e65-4359-9e57-c7e0bc892084",
        "b1003645-9b9e-48b3-b20b-3a91eb21d855",
        "0173ee59-f260-4a3f-b91c-8bc4b1e673eb",
        "49ab9eab-3b01-4ece-9070-371e91b21467",
        "5b104000-60e1-4146-b841-33cbac6f9396",
        "ebe524c2-bfb5-4afe-9de3-6818b28c82df",
        "e9728f3a-30cf-4fe6-bd77-0fa0c6bc20af",
        "4c95baf4-87f0-4736-b97d-7c0d5aa40af4",
        "0dbc5e2e-51b9-4e93-b9e8-a5138e3fad13",
        "8a8ed303-c8dd-486c-8d2c-d2c755aeaccd",
        "792e99fd-8712-4ffe-b267-cdd3f042401b",
        "108f66a8-2211-45c8-9e1f-2a639e1c6e4c",
        "38a46986-e036-473e-8e5e-2aa934ad11b5",
        "3204bc56-d849-4328-9fac-e22d4e6097ac",
        "383ba4d5-c4c8-400a-ab72-5a8fe822fc71",
        "fea8188a-c50e-43f3-8433-00974c0890e7",
        "7282136a-cdcd-4590-a035-35910d98058c",
        "cf9ce47c-5aea-446f-9b01-c98eb205c7fe",
        "17de3b59-15e7-43fc-8ca8-2add17f4d01b",
        "f77e8ff5-257e-4308-9e48-06adf43ad088",
        "13d0a107-d92b-4b4b-89cc-65a439d83109",
        "0238e3a1-5c5b-4f6e-9886-16a57c9929b2",
        "041133d4-e50e-4f02-9761-dcec4fd53d34",
        "5a5f1ded-36df-4b63-9035-2b2d1736d84b",
        "81caaeaf-24ec-4d30-bebd-202bda6c0654",
        "47be5bdb-6035-4c82-b0f7-707466712b72",
        "eff355e5-caa1-42b4-83ca-06d3f2dd3603",
        "042d327e-3030-4dca-abac-1b161d11227b",
        "61d57556-9ff7-4805-8f4d-e2c7e0c0260a",
        "a5a04caa-f75b-446b-ad5e-f3e417b0d4a2",
        "390cf100-f6a1-4600-81da-963495fca64c",
        "ef08da69-172e-48ae-b156-f725c0b3e442",
        "e71dbcd0-aa86-490b-8b23-742943ad33c5",
        "fd60f008-bfad-4c35-a30e-5b05d23694ca",
        "c3009eac-a3bd-4611-9fe5-a95c730993d3",
        "83dd5659-433d-4f40-b754-16a38907f3a8",
        "75b14f1a-842a-4f41-8b31-fe0a53c380c9",
        "fdf605ab-8566-4a69-ae32-048053baa0cd",
        "b44f95b3-9041-4c2a-a137-de8422319f4e",
        "126defb4-14eb-4a7e-8e73-bc0bbf2be628",
        "90408f07-aa64-42dd-9098-b025795c6b07",
        "8c783fe9-cfa2-49bb-925e-8a7fb0f3244c",
        "cbd1c7c6-687f-4eb4-814c-3a8a42dd8b2e",
        "2d8df2c9-c04e-43eb-b0dd-a5f7d5ed1f4d",
        "d89dcd96-d6a1-4f28-88a5-954bcf847187",
        "8d55c360-3006-4f3b-b021-d96426cf48fc",
        "02d1010e-50d5-4d11-bb1f-984f8434d078",
        "782434cd-7a2d-4776-b957-06929d652833",
        "782434cd-7a2d-4776-b957-06929d652833",
        "ccda4eb8-72f6-48c2-96c0-1b9b56c3853e",
        "bd5fe28e-7f9b-4c0b-aba7-d851029930a7",
        "e7eb114f-6b6b-493e-8200-34dd43e926de",
        "c7d154e6-4aa3-45e1-b29c-d56a5945e839",
        "ef08da69-172e-48ae-b156-f725c0b3e442",
        "d0876ff9-a167-4984-98fa-b0eb15bf715f",
        "34cc6e79-c69d-40a8-834f-ec1b3752e4aa",
        "aab529c4-fd49-47ea-8e61-976db8ed5778",
        "755464f0-e90e-432b-b0aa-5d96c22552c1",
        "dcd14dc7-7eea-464f-a00d-b8ffc5c1c63a",
        "1fdd4010-5703-42fc-bb35-fdc56e6175f4",
        "a0491ac6-48aa-4f13-939a-e21093c19a69",
        "705beab1-5e40-43ce-8315-5eccf039b988",
        "3a58b735-7387-4006-9b0c-e1eea68883b1",
        "f4332eea-fb4b-4dce-a82f-9862ab2956ef",
        "8957c5c9-8fe1-4e13-b5df-bb92021500c8",
        "850cb166-038a-4f13-92d6-a011e3efc0a9",
        "f5704b76-f81b-40bb-9ca8-50b099a0a43a",
        "9699bbb9-461e-488a-b376-ec5801f7393e",
        "a1ebf777-affe-4bb1-b588-2e2909936d56",
        "521588a6-9ce4-4eda-ab9d-270994839d30",
        "0d56238e-db92-4078-9cfc-48240e688c57",
        "77ec9976-caee-49f8-825b-d5fa95bfed1f",
        "bb2520b6-c7ea-452d-a584-589305ca3fc2",
        "455d3781-afdb-4f0b-acbc-ec45df263c58",
        "d3fb4788-50ad-4d51-be05-aebe23c54aad",
        "03b48d3f-103e-4656-9587-f1e13be2e0d4",
        "9b23baf4-c924-46c9-83ca-8a946b9a85a8",
        "90fdbee6-6a55-4540-a593-ded58b6c46d7",
        "61ae9643-d9f8-49ab-81a2-8752f09da756",
        "c103a8bb-81a6-44fe-8a68-e2e2aaa4796f",
        "ceba35aa-7e85-4e1d-96c8-9362318ae06b",
        "f363d2d7-b860-47b3-8b01-dfae5791f206",
        "a47e1b11-af08-4350-a2d8-cdcd73e2548d",
        "d547231b-2808-4c3e-972c-1d9438e17427",
        "d8e1d0e4-60b7-48bd-9b2b-6cc24bd98f3e",
        "09aff9ff-649d-46ae-8e9f-fb8461301f4e",
        "f08375f9-85dd-46de-a60c-660908fdee20",
        "9f0ed94c-9515-4f75-96aa-42f56a9c6e89",
        "56f3e323-a034-406b-b94c-efdeb403fb00",
        "0525e880-0f71-4d69-95da-8505c266d4f9",
        "324d0e12-045a-42f5-befe-55ad9c4e543d",
        "4f97e826-423c-4d33-8864-dbaef050c0a3",
        "4bc6dd8e-3df0-47ed-a210-c76a760aa12d",
        "77e0fd3e-e654-4043-ba18-7ecf978c5aed",
        "c99e5357-9909-4dbb-b78b-ffa465d84eb8",
        "5c759a37-442e-4593-bab9-e291ee1e972e",
        "584c0a0c-1e28-4835-8ef1-4190eeb4788e",
        "93d81cf3-da94-4510-961d-82327dd969c7",
        "1132e72b-78e5-45ce-9115-3c369c4d744e",
        "7c0b9963-1202-4dd9-9e4f-2fe7b2880878",
        "69e3a22b-6146-4652-a76e-e5833d001966",
        "14cf083d-0ef1-4069-aeb6-9e8de85838ff",
        "478cd5ac-343d-4451-8c7b-0c449f47ecfd",
        "c699f455-669a-4718-96d1-2a05ccea8d39",
        "b0e3dd75-8f2d-42b3-b687-7433843d53f8",
        "ee769c0d-0963-4720-98bf-268808a8b73b",
        "8bd62bbb-7355-4257-b1ae-16ce6c8be8a5",
        "654dc562-f5e2-4d57-92a2-28ebbd8638c1",
        "95a4ce3b-e232-45dc-963c-c24c42a0e1f5",
        "1d9c9fdc-1758-4539-8123-28e5dc554d84",
        "2b5e67e3-3a6a-4831-a5aa-7eaef021a396",
        "4a8b9e16-515e-4586-b615-cfe7c99cb391",
        "5856d84e-a60f-4e24-8f68-7a62946dd3bf",
        "e34d87ce-7a94-4b2c-b445-f7dea74b4fb5",
        "a8a65703-f85e-4874-89aa-daef1eb7bc94",
        "58e0f265-0a22-43cf-bbbd-263f6932e36a",
        "f0996e25-d4da-459d-a88b-90fdb8f92eb9",
        "8a342cb4-2913-491c-88a4-29af6747f3d0",
        "0f858f72-9a97-4e4c-a762-7c795d4825b2",
        "28cbebf8-6888-4be2-9ace-bd88749983d0",
        "befabdbe-8f42-4229-9630-5f6aa78c5084",
        "e0064d6d-b6b9-4ebc-9a49-db01a4c1a995",
        "b03ba380-bb2f-4959-a0d9-c0bd59d4f2d2",
        "11590b6b-3b65-4b72-8dad-11bfad1c9753",
        "15ea386a-bdf8-4e20-883b-82ab98b8a270",
        "7b4f5292-dfcb-49da-991d-d2c89bd50b05",
        "f810c48d-b84a-4ec0-a31c-bd6d029662c5",
        "923f4dfd-f401-42d8-85d4-f473906d44e3",
        "74e69530-7f39-4d0e-a129-766ebab31f2f",
        "1292b8da-5cc8-475a-9507-402977bf7219",
        "ac97a7e9-f475-4e79-b9ae-0efa74296421"
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