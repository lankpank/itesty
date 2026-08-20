task.wait(30)  -- Wait for game to fully load

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
local RIFT_NAME = "overlord-rift"
local RIFT_PATH = workspace.Rendered.Rifts
local RIFT_CHECK_DELAY = 1
local HOP_COOLDOWN = 10
local MAX_RETRY_ATTEMPTS = 10  -- How many servers to try before giving up
local AUTO_TELEPORT_TO_RIFT = true  -- Set to true to auto-teleport to rift when found
local TELEPORT_DELAY = 2  -- Seconds to wait before teleporting to rift

-- ============ PING CONFIGURATION ============
local PING_EVERYONE = true  -- Set to true to ping @everyone when rift is found

-- Webhooks
local w_main = "https://discord.com/api/webhooks/1443518513934237706/SYlpNc5bZqXECZAYf98HD5yjrIZqmsKhSyzTArormuUv_V5HAZWB7nv2yQxufw0ix4v7"
local w_notify = "https://discord.com/api/webhooks/1497653143981396051/y64QfolU0nyeIMaQfGhLOrOFRenDfrBSI15SGMYMy1iUNCQSubtpNf_QO-kL-5ThBiJg"

-- ============ SERVER LIST (Auto-updated) ============
local SERVER_LIST = {
        "4de501d7-7eb7-4a6e-82cc-1703b81f5687",
        "c274d522-f2cf-4b02-bd2d-de12c9efeed9",
        "bf714821-0858-43df-9ebd-fd4da4ba8862",
        "0548ce19-977b-44e9-bcc1-04d7e31e3a35",
        "dca0e590-e4eb-41c1-a4e5-357f4cd8bfeb",
        "ee851570-0714-41f0-bf91-8203ddcc5343",
        "22d12981-a256-496e-b2e7-77d694bc0aee",
        "df3ca884-8e51-469b-ac29-fd5f87558016",
        "e021f074-179a-418f-b0c9-003e223785d7",
        "f4d92289-ec26-4adb-b5ae-70f457bc9ebb",
        "280acf7f-aeb9-44b2-8310-4f46b780f6d6",
        "005bccbc-c25c-4b17-a299-375f91961bf0",
        "460a5e64-50c7-4387-8d20-a5b4abf49ae8",
        "a02d5c94-f995-46bd-a02a-d888c61c413c",
        "e1abb39c-534d-41ab-a032-6c7fb83537f0",
        "afb54dbc-330d-462e-9481-7f6495f1a5e6",
        "b98ac0b5-88e6-4190-af68-1f2fde7b7af8",
        "b11af74f-afde-4095-bb70-687fb7d0653c",
        "85ff7b2b-dfab-4228-b974-154dcd35fcab",
        "8c770cfb-fe15-48f6-a2c9-ab0630948a01",
        "0ebd97b7-949c-47b0-9225-66b46863584f",
        "dda28dbb-2c31-4ad8-89b0-7350dfc8fdd6",
        "3b6d4153-d763-4842-9099-604b70c8d7be",
        "a0a12df3-4c54-4809-b2d3-4a09ab0621b3",
        "a9696202-e98c-47b2-8009-1c11a7bc4d3c",
        "b35f3640-286e-4967-bc8c-b543c21e0e74",
        "5c163e79-a699-45cb-a683-9f9028261603",
        "15606906-3b63-4c83-92e1-531538285aaa",
        "0256130b-ac85-4a6c-814c-992e0b56028b",
        "12440ac0-2ed2-4880-8d18-840bb81f07a0",
        "5836fd20-a1d7-42e0-827d-bb9a3d317e7a",
        "04c78215-96b7-4646-b660-d350c1352b59",
        "ccf30676-7819-45a7-a61b-ac2777fd8b2a",
        "c20995cf-8c33-4439-beb0-6fd298aa33a9",
        "62b981ff-f0e6-43ce-a69c-1b58836aea23",
        "640141a8-8eb4-48e7-8ba7-35956b69b42b",
        "237258f8-98a6-4009-af29-7fa753e02713",
        "f2875138-18fe-4a57-af5b-c0c042988723",
        "52661060-85a1-431a-b2d0-2f59f13b07c4",
        "a99d6e45-f2d7-4c19-8b6d-21bfc447733e",
        "8e6c65df-c792-4a95-9e6a-4e3ed1bf9479",
        "943b5062-732b-45b9-9e85-d1fae75c970e",
        "cc6a47c3-519e-405d-b4cb-aab84e1c7596",
        "319f469d-7232-45c0-9c15-02618b05b830",
        "553382ee-7fb4-46d0-8e5d-69227ac75798",
        "62eaa717-e3f3-4ffa-8b87-3bc4ecf6d8d8",
        "c3a268cf-758e-42ea-831c-21b7403aeadc",
        "0b03ab7d-91bf-44af-87b0-58374687dc70",
        "f5aa98f6-3ce2-4e38-be9b-0281619c3c72",
        "d656e960-d7d2-4568-8b02-fbe6dde3e5dd",
        "4dc27090-230d-40e9-8bfa-09919637f508",
        "4e0241ce-96fa-4ccf-b806-dbb5c15c2648",
        "da9c7383-c750-4b4f-917b-50c0b0835363",
        "7ce531d4-06fa-4f61-acae-38c1806a260e",
        "83e798bf-7fc3-41bb-8cc2-aafaf756e1d3",
        "24ea02f3-a205-4fb1-89e3-0892e6aa9b3f",
        "3da12df6-4284-4d83-bb31-e2297c6e9375",
        "1c078902-0b6f-491b-915e-98270fd8ad2e",
        "e96fc9f6-7521-46a0-b578-e6d263b8b8dc",
        "09026782-6904-4120-a60d-36186bcaa7e5",
        "9f39b826-3791-4353-878b-7b9554502803",
        "d49c7acf-7940-4a00-95f5-1c71b6bf88a6",
        "8ebecc3f-16a0-4bc4-bd3c-40e85abc65cc",
        "0a66b29b-9099-42d0-b3c2-3636715742c5",
        "0b49175b-4c4d-4dbc-8f00-3ab7f610938b",
        "6fefb891-9794-42eb-a78e-cfc1151f021a",
        "4a3fe893-bf72-41b3-a395-783eb8de00bb",
        "609c1ae3-78ad-4bf1-9d10-2ef50f462c66",
        "f58aa63a-857f-47aa-a328-0c2a416a077c",
        "a20de517-6c50-434e-8c26-7fbf8cb8a676",
        "1d4aab93-6189-4c94-b20a-fdb514fc859b",
        "2efe4fe4-4262-46c7-af21-f3e319cd91b0",
        "098bed69-dc65-488d-8374-b1f6a8e2c880",
        "7e7f59a0-87c9-4718-9645-ca2713891f2a",
        "cd789bdc-7483-464b-8565-8a8898f34f4a",
        "c207e1e7-2df2-4c34-8747-3484f00f5e24",
        "b88a04c2-a179-4f31-afc0-5a205f110c8b",
        "daabf1c9-0ea3-4fcc-a917-c9dcfc642fcf",
        "990e64f8-b56a-4968-b4bf-db20d85a3c85",
        "c52c7e3f-4f17-4e88-af10-5897d3ade294",
        "35d8d269-a3fa-4d80-9660-f0abd64b140b",
        "5746e449-e015-4bd2-8429-e19fd3f9fea2",
        "156ef5fc-0a30-4ef4-8102-2a8685c9053c",
        "abdb6513-89d3-49d4-9335-77f1a66754a6",
        "59ec762e-0073-4636-ab9d-f6453022cb26",
        "8c0817bf-bb50-44d8-92dc-20b9ec03c8cf",
        "8f9a351a-aa5e-4bb5-94de-01c5d645fbef",
        "ac8bd837-817a-4c0a-859e-37dc939a4e22",
        "8b6fdde3-5a8a-47c2-a972-6877b1dae2e0",
        "bcde8ca4-4667-4972-b85d-7a6176137680",
        "a88cb15d-add9-441e-921a-0893a38b0306",
        "05cb14db-381e-47ae-ba22-7626d20c8abf",
        "433667ef-43a0-4da6-803d-97fdd583c70c",
        "d21232d3-b140-4040-bf28-bae3290e85c0",
        "401ba821-5177-46ef-b8c8-e23824ca438a",
        "433667ef-43a0-4da6-803d-97fdd583c70c",
        "d21232d3-b140-4040-bf28-bae3290e85c0",
        "4c74ded1-18a5-4340-af6c-18495fefed85",
        "3d0d87d6-5e0b-415b-8fe9-7f387f9fe1a8",
        "d1605ca6-8c12-4597-99c8-4853f5c8424e",
        "11620861-634b-41ee-8ae3-4da3a8430885",
        "45ce2e54-1ae6-4bd7-b98b-06f03dee196f",
        "45faff78-6a94-432b-9f91-44fc3ffa8577",
        "c738cebe-11d1-4f08-a921-29753cd14524",
        "1a39afce-298f-4fc4-90ac-c589cb67b44a",
        "da0e1fd6-afa0-4de6-abfb-42cd03985a06",
        "8811e88d-82e4-4a69-8f65-7616bc02e30f",
        "bee6cc3b-5545-437a-af73-be1c6d9d8097",
        "4bf8810f-535e-4cea-80fa-8470b8636a53",
        "8f3d52be-4eec-4198-b539-89c78f8d513b",
        "8295f947-0739-4983-86c8-d1e46d7b7025",
        "ccb3b44a-cc30-4252-9b80-17745c79cc6f",
        "cf465955-35b4-4226-a31c-50d877ad0b54",
        "df8ec079-57d2-4af4-991f-5b2df28abfbc",
        "750da7aa-02b7-45fe-9900-b9f16aebc490",
        "3245830d-8c2f-4ef7-9ff4-5541f3798dbf",
        "2eb83174-d0cb-482b-9dd8-02d0655e9dbb",
        "737aa185-64ba-4e7c-b794-e18859a38e12",
        "f77e4b86-996a-474e-915f-3c4091e3eda5",
        "79f78d07-0078-400b-860b-1be805c641f2",
        "1720c437-8bcf-40c1-8586-dee018d1639b",
        "c3aa2557-220d-472a-8126-164d349475bc",
        "f247cb87-8e91-4853-9d73-0a3444030bc9",
        "bde5410b-b6ce-400c-bffd-c726b5c86bf8",
        "af31220e-31dd-4f76-98f7-06dae9bb7c59",
        "98f71f51-2542-4234-b7f4-b5976068fe40",
        "2f51d2f7-7f5f-469e-8850-c869874d4831",
        "74cc553b-b208-496e-a235-00122eeb21f7",
        "f4e88fab-3c13-4f33-b9b2-857d88a2d8f2",
        "4dd39641-4f7e-4551-9770-e695e6a4f533",
        "3e6ebb66-581a-4bc3-a29d-889dbd35c642",
        "7ff9a5b8-d0a1-4160-a169-1e8c2022a023",
        "3254e710-1129-4039-ba63-a1d090572485",
        "0cde7c07-408c-4511-95f5-ee8a94671481",
        "d971a946-e841-47eb-87fa-01ad43d55b28",
        "9e4516a4-a8ec-44f9-8ace-ade816e787a9",
        "83c46d15-be28-4d55-803b-f488683844d7",
        "55df9718-4d91-4461-ba99-84a0fddb1500",
        "23de996f-c5f5-4285-8d1f-28f4ce09d473",
        "ea4f5a13-48b5-4de7-b935-3e86a338c054",
        "eed2e947-b75b-4c20-9090-7c2699cb676a",
        "242d759d-ce71-4c45-ac9f-90c12ca9f071",
        "c56d3915-88f5-4071-b9c4-28cd685f7918",
        "6d24a182-1cd1-4625-ae28-c81c02d10e12",
        "b8c3e7e2-a7ea-4356-a258-4ff5575a8899",
        "08ea6467-7bd7-49c6-883e-2422de8a8602",
        "a5b35da6-7b6a-4edf-9315-5ac041e95dbf",
        "64139866-29d4-4a59-93eb-439b15f83ff5",
        "662a6b7b-156c-4ed7-9009-a33fb8fba2f0",
        "0a84d77f-c2a4-43d8-bd08-794e1ff4909c",
        "28174861-2f84-4c46-a55c-3c252b0b47ba",
        "6a2a8d37-d9cc-4e38-9293-45b8086cbcb0",
        "075e2bf4-74e8-4137-a15a-fc0af0849a5d",
        "368d2382-a1b3-4def-91f0-0a5c6fca8ad1",
        "12cb133c-bd66-43d6-9817-edd9dbb533b2",
        "c82a2094-bbda-4f61-9f77-022328779e72",
        "4c8c17cc-02e6-4009-a78b-d693015e9c2c",
        "98bb666d-7559-426a-a028-768b09ba03c4"
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