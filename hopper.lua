task.wait(40)  -- Wait for game to fully load

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
        "9e58ada0-a953-4f8e-ae2a-04f0280a6698",
        "8741de03-5657-418c-8c65-3688c8c3e630",
        "6c9521ff-8467-43e9-9bbd-d19d294ec2d9",
        "47be5bdb-6035-4c82-b0f7-707466712b72",
        "ae240c51-526e-4600-bd67-746f4aae97b1",
        "8f896932-f693-429b-8e02-70b2c0c5202e",
        "c37bc50d-3b8c-4d24-860b-11398bcc53d3",
        "e61778e6-d195-4b0d-a68d-3c85676c91bf",
        "629d540e-35fe-4158-b45d-397b48d33a19",
        "e5e4f5ed-a3de-4bac-b1dc-77ea793c1e55",
        "aab529c4-fd49-47ea-8e61-976db8ed5778",
        "e4533287-0a6f-48a3-b017-2b79546b9435",
        "b257454a-6730-4cc0-bdc7-dc9e3b5519ff",
        "26c4c7ad-7e57-4fb4-b467-7552e4329fb1",
        "cc5465a8-295c-4aa1-97c9-2c410635cedd",
        "3a58b735-7387-4006-9b0c-e1eea68883b1",
        "62a8cc38-5876-4114-abe6-c45cf7b4b189",
        "e0a04a86-7b4a-4aa5-b7f1-4b04f895c442",
        "772020a5-e17d-4e6b-9db7-f2dc3020afa5",
        "e34d87ce-7a94-4b2c-b445-f7dea74b4fb5",
        "9bb7d72a-e8dc-4b0e-a39c-9c69c7cb489e",
        "af789856-a316-4e60-9273-26b77257ee8a",
        "3c1a1333-7f2c-46bb-ba71-ddcc4ac53d87",
        "997eef72-c6cd-44f0-8ff0-8e5d8f04558f",
        "89fde069-9745-4400-8f25-4d06433a5872",
        "a20528ea-f992-4ce3-bfc9-2ef9153955b1",
        "d2a63979-dd33-4da4-8703-23d8dd9dc697",
        "b0530d3f-6f3e-4a89-bae8-45063daa4fc8",
        "31d68743-b5b2-43e9-8b04-d5d67077caa2",
        "d305febb-43f5-44b2-b80c-38f05a47a76d",
        "0940d6e5-f0d1-4ebc-b492-618b4a184660",
        "318ab6ea-55f6-4690-a8fb-89470050a8ec",
        "21fd109b-64e7-4bae-845f-3c9f0ceb633c",
        "474797f9-0775-4b96-b2ce-6782704202ff",
        "23e08023-8df7-4061-a71f-e6dc3e2b68a2",
        "0e8a3f6d-f77d-47c1-b8e3-b514670e2ed7",
        "0613e84d-a4f0-4dc6-9b54-d8c9827718c0",
        "e81a233e-b52d-4323-b71e-23d7312ede58",
        "0e03e362-78c4-47e0-b1c1-cd2af8b9c52d",
        "e1a4ef11-aeb7-49f2-82f8-596d3320c455",
        "dd91c51f-4eda-40e7-ab6c-1e4cf6e3bf8d",
        "241435be-02ce-42bb-b52c-2e2bda261ff3",
        "a9be9f9d-cf8d-4293-ae2d-5632251aa8b0",
        "cc235706-63f4-4a85-aa77-bc197044925e",
        "00923830-983f-4b08-8cc7-bbf6f93eaa72",
        "ba0a36e7-8b52-4768-8ada-99e0aee9fc90",
        "3fb5c484-c977-4b2b-8b99-7a99c8617b27",
        "c009e80b-d7b4-4ab0-b538-a44eeea867b3",
        "23e3c3ae-25f8-4643-895b-7f5176332fbf",
        "08913d0f-92b1-4471-a07a-dca853f2c4ce",
        "efab4733-4653-4ccb-aedf-17462bc8aeec",
        "d3fc9803-908f-4d69-8e17-7b4b1fbb6a56",
        "1814f36f-f021-4e21-8b8e-9a5896cb909f",
        "7bf070ce-de70-45e5-afbc-7356c5670b68",
        "325c719d-a1e8-4426-8c3a-5eef71c58861",
        "a7d7a630-8024-485a-b879-8db6a95b2daf",
        "467d8d25-f28f-4bf2-b9f5-9d7694248257",
        "17186dda-7377-4089-93cb-ecc7a5d439d4",
        "059235ba-c4e2-4f09-b727-6c81064c0912",
        "33ea9c87-6940-4b6a-94f5-18d3ebb84711",
        "876125ac-29ad-45a7-b7ad-def68523fb57",
        "228f63f5-dc4d-4a44-aabc-2e8bb1c14d0b",
        "2b38fa12-3496-4089-a4aa-e939b3306ce7",
        "010ed1da-886a-47ae-a1fc-7bd10258b2cd",
        "ed7b1957-2e66-4105-9b74-18550d6e6504",
        "e66b350d-6776-41d2-ac4a-8ce5b97dcecd",
        "055d9d27-dba5-4448-81fe-2d993a4f5c29",
        "883b8b39-86b6-4785-8f69-678773be5329",
        "4d50851c-9893-4f3b-a3ef-94ae764d617a",
        "ad9e0d2b-dfdf-435c-b11a-5e6c806c72c9",
        "919cd4dd-8b57-4f80-ad2c-6934dc79f62b",
        "cc6898a5-2faf-4457-ab95-04eb42ddc69c",
        "757c4405-5618-4985-9c21-85934a11c42d",
        "a217ba07-52d6-4ac2-9a77-b77e90a11f2b",
        "78c9e62f-958c-4ce7-a723-8161a547c9fe",
        "38938461-9456-4cd9-84c3-5c70a38e060b",
        "1eefd3b2-5bf9-413f-ad45-7a1005f58153",
        "c582d1aa-8e2f-48c7-bf49-567a4a10a6e0",
        "6f918907-c15d-4c7f-b483-049453798c9a",
        "f167898d-2876-4a12-8905-c817139567e5",
        "ecb1bc11-36ae-40db-a739-3686a999bb43",
        "d8799dcc-9b10-41c0-a125-66ce6cb39121",
        "5155ded8-9acd-4fd6-9fdd-93d8f8d5a641",
        "91249b6d-f62e-4f8c-92f9-0b302801c290",
        "74525e11-615f-49e8-b015-123efec7b539",
        "57a7fe17-9cc2-42bb-8a40-00b2f19adb01",
        "826af8b3-941d-4534-b1d6-2d080fa38de6",
        "1b8baf03-cc52-49fb-9384-0bfcfbb8ce67",
        "a30a7f23-237b-4c6d-90ff-8f92dc0f7889",
        "36ca4ca4-3236-4239-8c79-ba1c652ba9e6",
        "e185e141-dac7-43f0-a6fb-76e2758a10cd",
        "4df35a74-1d99-49eb-b9fd-fab3bca652be",
        "558a964d-55e9-4d8a-a447-f78e804f2927",
        "894f7fbc-d20a-456f-94b7-d8f6008d696a",
        "8c055655-8c24-477e-a4c5-8c49955a904d",
        "126defb4-14eb-4a7e-8e73-bc0bbf2be628",
        "a8a65703-f85e-4874-89aa-daef1eb7bc94",
        "71a459c6-626b-435f-ac00-300dc36c9b64",
        "3263da9d-0baf-4e75-9834-b3fe5b9493b7",
        "2cafcc00-9e6f-40f7-9568-1af37cec8119",
        "758a2d07-606c-4611-accb-4d1568efd33b",
        "31d0414f-cd6c-410f-94e5-7e88ae2e575d",
        "1f5ebaa0-822b-46c4-9426-db7e4999b4ac",
        "991c62a2-a9fd-4e0e-b74c-6910b0a7f1aa",
        "9dcf6a3d-b9b7-4633-b016-c53e877511f6",
        "b6bc6812-4cdc-4a9c-a01b-dc43acb9335a",
        "f08375f9-85dd-46de-a60c-660908fdee20",
        "85fd464c-9611-444d-bf61-40693cff7da7",
        "ef889a64-ed2e-45d8-abaa-ae2f7f8aa8f7",
        "40932340-7271-4068-bef6-16db8962a558",
        "b36e48e5-083b-4cf7-8d71-80bbe8d42174",
        "b5b1cab0-c6bf-4217-add8-4d101c852bde",
        "478cd5ac-343d-4451-8c7b-0c449f47ecfd",
        "2814e0a5-56e0-4d95-87e3-32de81ff994c",
        "4b792960-71c9-495c-ae22-eedcc8ce9151",
        "74385fe2-554e-407b-b2a6-cd8d19a44060",
        "ec419f59-4eea-428b-823a-5ae4064c40b1",
        "ad8a48ee-e210-40c4-87b2-bac518c3faaa",
        "04fe109e-cb4c-4929-9839-e0f835960011",
        "0a46595d-27e9-468b-8d11-0ac91a8cf030",
        "faa433cf-3a0c-4736-9123-e5c0932b76aa",
        "8ee826cc-6b66-4e27-89eb-328fdb8865ca",
        "a7efc8ac-02ef-4838-9e30-f2a3bb00d8c8",
        "9b7969ba-5027-434d-9d84-c7867ebc91e5",
        "5e4636a9-afd5-40d1-8bba-55d183e6d416",
        "804c3444-65fc-408c-b19c-6db0909d6e5e",
        "77ec9976-caee-49f8-825b-d5fa95bfed1f",
        "2cd65db5-d197-426f-99c5-fc38bfbf4bfc",
        "18267ea8-b83b-473a-84e4-7d7a68c6b6e2",
        "850cb166-038a-4f13-92d6-a011e3efc0a9",
        "b88ee19a-194d-42cb-ac2d-b48d54cc8b77",
        "324d0e12-045a-42f5-befe-55ad9c4e543d",
        "4f5842bd-e5a3-4fd1-a287-42032b4475a1",
        "d8c78b70-71ea-4d0b-9bbf-8f56a4da1451",
        "7e6be220-40e5-4ac2-ada1-41e577e42e4f",
        "7f55034b-dbe3-442d-8571-179624acc6ff",
        "e5c78b62-52f7-4371-8cfd-95f148cdf831",
        "69bd23c0-62a3-4b4c-a05c-ab84f3168a6d",
        "c99e5357-9909-4dbb-b78b-ffa465d84eb8",
        "2e4e1f19-deb7-41c6-ba9d-857fb7ed36f4",
        "edb6a634-1b33-439b-b62c-343536dbdf6e",
        "0ba85f68-3686-4ba9-a2d0-be81b19dd8e7",
        "74e69530-7f39-4d0e-a129-766ebab31f2f",
        "25e21261-b210-4230-a05d-35ef076aec99",
        "b2a1652c-79d6-4df4-bd43-d9772211df5b",
        "69e3a22b-6146-4652-a76e-e5833d001966",
        "e447ccf8-609d-45c9-a3f3-8ae7cdaa065f",
        "e9728f3a-30cf-4fe6-bd77-0fa0c6bc20af",
        "4a9e46fb-0a26-42ff-b54f-b6ebfba565d6",
        "b28ff5d5-20e9-40fc-9a13-7dfaa8c2b1f4",
        "c3627097-356f-4a7b-b7ab-e4074d2097ca",
        "997b4295-680c-40cf-afd0-c67c8a71cfa7",
        "e0064d6d-b6b9-4ebc-9a49-db01a4c1a995",
        "bcbe9424-0f10-4d3f-94dd-26b650a849c3",
        "d89dcd96-d6a1-4f28-88a5-954bcf847187",
        "eff355e5-caa1-42b4-83ca-06d3f2dd3603",
        "2da87d85-c2c0-42f4-a650-60dd5a3ba668",
        "cb0b1b4f-d6fa-4383-89fc-2614db9020b6",
        "8426167a-882f-444c-85ad-bc75e6771eb1",
        "9d1ef653-d980-4286-a3f6-3c9360cf0b2a",
        "8a342cb4-2913-491c-88a4-29af6747f3d0",
        "0ac688d7-b1a6-44f3-8b68-30a8274d3d59",
        "ded5dfe9-6a7c-47f6-874e-97c541062bff",
        "792e99fd-8712-4ffe-b267-cdd3f042401b",
        "8f358c1f-5307-4ac4-91a5-87c4c0ade30e",
        "e69c35d7-4517-4093-acbb-0a2088b5539a",
        "18747ea2-33fa-488a-9a3e-a5e331fa7cc0",
        "dc05077f-e152-4694-b6e3-3960a0b733c7",
        "fd0704fe-a4d1-4836-8c4a-e852eb9813ff",
        "d106f1f0-40e0-41b7-a31b-e3c7a8732a37",
        "a2dc46cd-b034-49d8-8542-6a29f2f43a20",
        "c5dcfbd5-23a9-421e-b065-c04535b8e0f5",
        "4221f8ce-2e65-4359-9e57-c7e0bc892084",
        "9573cfe4-1bf6-4feb-bd17-5ee56e83177a",
        "3a5c7fe6-6722-4cf4-8c5b-3cb6ce92c286",
        "8a8ed303-c8dd-486c-8d2c-d2c755aeaccd",
        "1a90d50f-dac0-4d4e-a572-a05b7819f9e1",
        "3b24821c-66f0-410c-8274-1e9e95febe1e",
        "bfe690c6-32e9-45bb-985e-1df4db586ae1",
        "9599fb91-a54a-44d1-aed6-7ea8cf322d64",
        "920a194a-55e6-4fff-a48d-8e170949e6ea",
        "3b8316dd-c2a1-4db8-ab6b-5f7498f7240a",
        "6921f3ef-729c-4e81-8305-bb1db8c97fa8",
        "0f858f72-9a97-4e4c-a762-7c795d4825b2",
        "df8a3322-d411-41d7-9621-ebea2ca5a58a",
        "bdb4dc3c-aca2-4d31-ae26-d7ee875f4fcf",
        "1aba5a25-8e51-4537-9807-2023e862e33b",
        "9e23920d-6844-4df7-97a3-8930343edfab",
        "8f7c8027-7c04-4ea7-a46d-2cee5113985e",
        "a1ebf777-affe-4bb1-b588-2e2909936d56",
        "07ff5da2-cb5e-415f-bde3-6f9ef7baa4b5",
        "15561c58-33ce-4918-8865-2909aaac9122",
        "108f66a8-2211-45c8-9e1f-2a639e1c6e4c",
        "5e206d84-a8e7-4ca6-8f8c-b4baf39a5158",
        "bd387430-a24c-42dc-a546-05f7993fc8be",
        "968d9853-b1c3-4b8f-9ccb-435b5b6d99ef",
        "f93922d3-2474-469a-8fc8-f394d7c84826",
        "a0491ac6-48aa-4f13-939a-e21093c19a69",
        "5ecbbe66-9dbb-4a76-b759-8a2d643fb097",
        "1f55fd19-c57f-40ee-a882-b540b9d29ddc",
        "48d884b0-883d-46f8-a36f-0f3ebc058129",
        "b1e6e9ba-4231-479c-b531-3ba2115968fb",
        "fea8188a-c50e-43f3-8433-00974c0890e7",
        "a5446885-ac1a-4091-9f3f-9e22c124790f"
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