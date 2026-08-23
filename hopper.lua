task.wait(50)  -- Wait for game to fully load

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
local RIFT_NAME = "shadow-rift"
local RIFT_PATH = workspace.Rendered.Rifts
local RIFT_CHECK_DELAY = 1
local HOP_COOLDOWN = 10
local MAX_RETRY_ATTEMPTS = 10  -- How many servers to try before giving up
local AUTO_TELEPORT_TO_RIFT = true  -- Set to true to auto-teleport to rift when found
local TELEPORT_DELAY = 1  -- Seconds to wait before teleporting to rift

-- ============ PING CONFIGURATION ============
local PING_EVERYONE = false  -- Set to true to ping @everyone when rift is found

-- Webhooks
local w_main = "https://discord.com/api/webhooks/1443518513934237706/SYlpNc5bZqXECZAYf98HD5yjrIZqmsKhSyzTArormuUv_V5HAZWB7nv2yQxufw0ix4v7"
local w_notify = "https://discord.com/api/webhooks/1497653143981396051/y64QfolU0nyeIMaQfGhLOrOFRenDfrBSI15SGMYMy1iUNCQSubtpNf_QO-kL-5ThBiJg"

-- ============ SERVER LIST (Auto-updated) ============
local SERVER_LIST = {
        "cd818179-52a6-4290-8b17-ba24fc1067a8",
        "b22a0d3e-f34d-4f72-8e16-689b468e34e5",
        "71d8ed84-1406-4e01-adc4-aed0f3a9aae6",
        "584c0a0c-1e28-4835-8ef1-4190eeb4788e",
        "18747ea2-33fa-488a-9a3e-a5e331fa7cc0",
        "fd7cde31-7ac6-457f-a485-b03f3803b5bf",
        "3263da9d-0baf-4e75-9834-b3fe5b9493b7",
        "eff355e5-caa1-42b4-83ca-06d3f2dd3603",
        "25e21261-b210-4230-a05d-35ef076aec99",
        "2e4e1f19-deb7-41c6-ba9d-857fb7ed36f4",
        "6be8e6a1-0009-48e7-ae82-001be213bde3",
        "aab529c4-fd49-47ea-8e61-976db8ed5778",
        "8f7c8027-7c04-4ea7-a46d-2cee5113985e",
        "2cd65db5-d197-426f-99c5-fc38bfbf4bfc",
        "2a31a8ca-0c52-4a6e-a902-27578a758420",
        "74e69530-7f39-4d0e-a129-766ebab31f2f",
        "2da87d85-c2c0-42f4-a650-60dd5a3ba668",
        "5c12d1ed-65e8-4a3d-87fd-39e5519d8161",
        "3a58b735-7387-4006-9b0c-e1eea68883b1",
        "108f66a8-2211-45c8-9e1f-2a639e1c6e4c",
        "06bb0c99-329d-4355-be5b-7a4f8c3c86d4",
        "2a1c5a8f-181a-4c27-9bb8-885d361b0076",
        "9b23baf4-c924-46c9-83ca-8a946b9a85a8",
        "2cafcc00-9e6f-40f7-9568-1af37cec8119",
        "782434cd-7a2d-4776-b957-06929d652833",
        "b6a0d48b-64a3-4ae7-8dc5-730d5638c7fd",
        "bd5fe28e-7f9b-4c0b-aba7-d851029930a7",
        "edb6a634-1b33-439b-b62c-343536dbdf6e",
        "18267ea8-b83b-473a-84e4-7d7a68c6b6e2",
        "93d81cf3-da94-4510-961d-82327dd969c7",
        "3b24821c-66f0-410c-8274-1e9e95febe1e",
        "f7840e5b-0b4c-4994-a4f7-5e92032a1368",
        "e090189f-5077-4053-a7e8-e4635f6a8fc1",
        "60311a85-f7b3-4a40-895d-03f77c75b49d",
        "0ba85f68-3686-4ba9-a2d0-be81b19dd8e7",
        "47be5bdb-6035-4c82-b0f7-707466712b72",
        "6921f3ef-729c-4e81-8305-bb1db8c97fa8",
        "b2a1652c-79d6-4df4-bd43-d9772211df5b",
        "9fb67dff-1336-4e5c-9053-527b2f8b7f20",
        "5149ca71-245d-4b96-9e4e-db9732029a2b",
        "f0996e25-d4da-459d-a88b-90fdb8f92eb9",
        "0f858f72-9a97-4e4c-a762-7c795d4825b2",
        "b88ee19a-194d-42cb-ac2d-b48d54cc8b77",
        "e81a233e-b52d-4323-b71e-23d7312ede58",
        "7e38267d-3239-4893-ade5-990d220cac36",
        "920a194a-55e6-4fff-a48d-8e170949e6ea",
        "a0491ac6-48aa-4f13-939a-e21093c19a69",
        "4c95baf4-87f0-4736-b97d-7c0d5aa40af4",
        "69e3a22b-6146-4652-a76e-e5833d001966",
        "a7efc8ac-02ef-4838-9e30-f2a3bb00d8c8",
        "8a342cb4-2913-491c-88a4-29af6747f3d0",
        "3a5c7fe6-6722-4cf4-8c5b-3cb6ce92c286",
        "d106f1f0-40e0-41b7-a31b-e3c7a8732a37",
        "46244d11-6b13-4aea-a334-18e172048bb7",
        "1aba5a25-8e51-4537-9807-2023e862e33b",
        "29fa8987-3ccd-41dd-8749-f018d98989a4",
        "befabdbe-8f42-4229-9630-5f6aa78c5084",
        "b6bc6812-4cdc-4a9c-a01b-dc43acb9335a",
        "8426167a-882f-444c-85ad-bc75e6771eb1",
        "5b104000-60e1-4146-b841-33cbac6f9396",
        "792e99fd-8712-4ffe-b267-cdd3f042401b",
        "a2dc46cd-b034-49d8-8542-6a29f2f43a20",
        "9e23920d-6844-4df7-97a3-8930343edfab",
        "40932340-7271-4068-bef6-16db8962a558",
        "15561c58-33ce-4918-8865-2909aaac9122",
        "b5b1cab0-c6bf-4217-add8-4d101c852bde",
        "0a46595d-27e9-468b-8d11-0ac91a8cf030",
        "a8a65703-f85e-4874-89aa-daef1eb7bc94",
        "126defb4-14eb-4a7e-8e73-bc0bbf2be628",
        "9f99ebde-9378-4f35-b640-ed7de8f0469c",
        "d3a11208-4e0d-4e15-8ac0-04864ed4c76c",
        "f93922d3-2474-469a-8fc8-f394d7c84826",
        "0613e84d-a4f0-4dc6-9b54-d8c9827718c0",
        "5e206d84-a8e7-4ca6-8f8c-b4baf39a5158",
        "8ee826cc-6b66-4e27-89eb-328fdb8865ca",
        "8dbd6524-be72-4af0-8056-63171ebd73f8",
        "997b4295-680c-40cf-afd0-c67c8a71cfa7",
        "b1e6e9ba-4231-479c-b531-3ba2115968fb",
        "d0876ff9-a167-4984-98fa-b0eb15bf715f",
        "f4332eea-fb4b-4dce-a82f-9862ab2956ef",
        "74385fe2-554e-407b-b2a6-cd8d19a44060",
        "126defb4-14eb-4a7e-8e73-bc0bbf2be628",
        "9f99ebde-9378-4f35-b640-ed7de8f0469c",
        "d3a11208-4e0d-4e15-8ac0-04864ed4c76c",
        "f93922d3-2474-469a-8fc8-f394d7c84826",
        "0613e84d-a4f0-4dc6-9b54-d8c9827718c0",
        "5e206d84-a8e7-4ca6-8f8c-b4baf39a5158",
        "8ee826cc-6b66-4e27-89eb-328fdb8865ca",
        "8dbd6524-be72-4af0-8056-63171ebd73f8",
        "997b4295-680c-40cf-afd0-c67c8a71cfa7",
        "b1e6e9ba-4231-479c-b531-3ba2115968fb",
        "d0876ff9-a167-4984-98fa-b0eb15bf715f",
        "f4332eea-fb4b-4dce-a82f-9862ab2956ef",
        "74385fe2-554e-407b-b2a6-cd8d19a44060",
        "324d0e12-045a-42f5-befe-55ad9c4e543d",
        "e5c78b62-52f7-4371-8cfd-95f148cdf831",
        "558a964d-55e9-4d8a-a447-f78e804f2927",
        "9b7969ba-5027-434d-9d84-c7867ebc91e5",
        "cb0b1b4f-d6fa-4383-89fc-2614db9020b6",
        "e090189f-5077-4053-a7e8-e4635f6a8fc1",
        "b0aa31ec-75fe-4e27-b213-99b395a74fa6",
        "27e0c89e-2f94-4676-aa52-0d89d3a5877e",
        "38a46986-e036-473e-8e5e-2aa934ad11b5",
        "894f7fbc-d20a-456f-94b7-d8f6008d696a",
        "8a8ed303-c8dd-486c-8d2c-d2c755aeaccd",
        "77ec9976-caee-49f8-825b-d5fa95bfed1f",
        "a8a65703-f85e-4874-89aa-daef1eb7bc94",
        "b5b1cab0-c6bf-4217-add8-4d101c852bde",
        "7e38267d-3239-4893-ade5-990d220cac36",
        "bfe690c6-32e9-45bb-985e-1df4db586ae1",
        "5ecbbe66-9dbb-4a76-b759-8a2d643fb097",
        "d89dcd96-d6a1-4f28-88a5-954bcf847187",
        "e34d87ce-7a94-4b2c-b445-f7dea74b4fb5",
        "a5446885-ac1a-4091-9f3f-9e22c124790f",
        "b28ff5d5-20e9-40fc-9a13-7dfaa8c2b1f4",
        "a73b40be-fb4d-462c-9064-bf0a036becfe",
        "04fe109e-cb4c-4929-9839-e0f835960011",
        "eadcde1c-2334-4f71-9028-f7e34475816a",
        "5c759a37-442e-4593-bab9-e291ee1e972e",
        "fd0704fe-a4d1-4836-8c4a-e852eb9813ff",
        "c99e5357-9909-4dbb-b78b-ffa465d84eb8",
        "96460441-8527-4ccf-b83c-16e2e2821bf2",
        "3401aaec-09e2-4fbb-a306-07b0bfa8a34d",
        "9f0ed94c-9515-4f75-96aa-42f56a9c6e89",
        "5e4636a9-afd5-40d1-8bba-55d183e6d416",
        "07ff5da2-cb5e-415f-bde3-6f9ef7baa4b5",
        "cca73c96-630b-43f2-91c3-1f0315f5b893",
        "1a90d50f-dac0-4d4e-a572-a05b7819f9e1",
        "a1428e8e-4e9e-4189-a69b-c8f874b0c7ec",
        "2814e0a5-56e0-4d95-87e3-32de81ff994c",
        "91249b6d-f62e-4f8c-92f9-0b302801c290",
        "ef889a64-ed2e-45d8-abaa-ae2f7f8aa8f7",
        "ccda4eb8-72f6-48c2-96c0-1b9b56c3853e",
        "1f55fd19-c57f-40ee-a882-b540b9d29ddc",
        "8f358c1f-5307-4ac4-91a5-87c4c0ade30e",
        "79858c93-a171-4b4d-b6e0-8e60c2fa0080",
        "ad8a48ee-e210-40c4-87b2-bac518c3faaa",
        "4221f8ce-2e65-4359-9e57-c7e0bc892084",
        "fea8188a-c50e-43f3-8433-00974c0890e7",
        "df8a3322-d411-41d7-9621-ebea2ca5a58a",
        "478cd5ac-343d-4451-8c7b-0c449f47ecfd",
        "c3627097-356f-4a7b-b7ab-e4074d2097ca",
        "850cb166-038a-4f13-92d6-a011e3efc0a9",
        "aa1f7b41-ccc0-45cb-9676-30551fa27ef2",
        "c60e7cbe-4bf7-48f1-8954-120354d77953",
        "f08375f9-85dd-46de-a60c-660908fdee20",
        "755464f0-e90e-432b-b0aa-5d96c22552c1",
        "e69c35d7-4517-4093-acbb-0a2088b5539a",
        "bdb4dc3c-aca2-4d31-ae26-d7ee875f4fcf",
        "c77b9fa2-93d1-488b-9d96-947b7a18c0fd",
        "9d32090f-4d37-4f36-88e4-2974486870cd",
        "804c3444-65fc-408c-b19c-6db0909d6e5e",
        "a1ebf777-affe-4bb1-b588-2e2909936d56",
        "ef503b6a-de6d-4b61-819d-54661b616c3f",
        "c87b2e17-30f1-41a4-8a07-9621dd0cfa57",
        "ce6bde23-c433-4300-abb4-5a0fb9755777",
        "0173ee59-f260-4a3f-b91c-8bc4b1e673eb",
        "0885cdf0-22f1-4df3-b09f-5223008da20c",
        "3b8316dd-c2a1-4db8-ab6b-5f7498f7240a",
        "c5dcfbd5-23a9-421e-b065-c04535b8e0f5",
        "42a3ead3-0277-4a9f-8a26-5bb48e016f3f"
    }

-- ============ STATE ============
local isHopping = false
local riftActive = false
local hasTeleportedToRift = false
local hasExecutedRemoteEvents = false  -- New flag to track remote execution

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

-- ============ REMOTE EVENT EXECUTION ============
local function executeRemoteEvents()
    if hasExecutedRemoteEvents then
        print("⏳ Remote events already executed for this rift!")
        return
    end
    
    print("📡 Executing remote events...")
    
    -- Wait 1 second before first event
    task.wait(1)
    
    -- First remote event: Secret Event
    local success1, err1 = pcall(function()
        local args = {
            "PurchaseEventBoard",
            "Secret Event"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        print("✅ Secret Event remote fired!")
    end)
    
    if not success1 then
        print("❌ Failed to fire Secret Event remote:", err1)
    end
    
    -- Wait 1 second before second event
    task.wait(1)
    
    -- Second remote event: Celestial Event
    local success2, err2 = pcall(function()
        local args = {
            "PurchaseEventBoard",
            "Celestial Event"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        print("✅ Celestial Event remote fired!")
    end)
    
    if not success2 then
        print("❌ Failed to fire Celestial Event remote:", err2)
    end
    
    if success1 and success2 then
        hasExecutedRemoteEvents = true
        print("✅ All remote events executed successfully!")
    end
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
        -- Execute remote events after teleport
        executeRemoteEvents()
        return true
    end
    
    -- Teleport using CFrame
    local success = pcall(function()
        rootPart.CFrame = CFrame.new(riftPosition)
        print("✅ Teleported to rift at height: " .. math.floor(riftPosition.Y) .. " meters!")
        hasTeleportedToRift = true
        
        -- Execute remote events after teleport
        executeRemoteEvents()
        
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
                -- Execute remote events after move
                task.wait(2) -- Wait a bit for movement
                executeRemoteEvents()
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
    else
        -- If auto teleport is disabled, still execute remote events if near rift
        if hasTeleportedToRift then
            executeRemoteEvents()
        end
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
        
        -- Add remote execution status
        local remoteStatus = "Not executed"
        if hasExecutedRemoteEvents then
            remoteStatus = "✅ Remotes executed!"
        end
        
        -- ============ BUILD EMBED FIELDS ============
        local embedFields = {
            { name = "Found By", value = localUsername .. " (" .. ACCOUNT_LABEL .. ")", inline = false },
            { name = "Rift Height", value = tostring(height) .. " meters", inline = false },
            { name = "Players", value = string.format("%d/12", playerCount), inline = false },
            { name = "Auto-Teleport Status", value = teleportStatus, inline = false },
            { name = "Remote Events", value = remoteStatus, inline = false }
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
            hasExecutedRemoteEvents = false  -- Reset remote execution flag
            print("🎯 RIFT FOUND! Stopping hops.")
            checkAndReportRift()
        else
            print("⏳ Rift still active - waiting...")
        end
    else
        if riftActive then
            riftActive = false
            hasTeleportedToRift = false
            hasExecutedRemoteEvents = false  -- Reset remote execution flag
            print("❌ Rift ended! Resuming hops.")
        end
        
        if not isHopping then
            hopServers()
        end
    end
    
    task.wait(RIFT_CHECK_DELAY)
end