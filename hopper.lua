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
        "ed323196-e1c6-4901-88f4-d59401c0f4a3",
        "7f51939c-f8e3-4015-bd92-0ee11080b755",
        "228f63f5-dc4d-4a44-aabc-2e8bb1c14d0b",
        "89fde069-9745-4400-8f25-4d06433a5872",
        "919cd4dd-8b57-4f80-ad2c-6934dc79f62b",
        "0e8a3f6d-f77d-47c1-b8e3-b514670e2ed7",
        "1b8baf03-cc52-49fb-9384-0bfcfbb8ce67",
        "4df35a74-1d99-49eb-b9fd-fab3bca652be",
        "23e65a78-1de3-44b4-a884-63b36d13f22d",
        "d67d3241-9cbd-48ea-8fa4-eae4cd122491",
        "36ca4ca4-3236-4239-8c79-ba1c652ba9e6",
        "cc235706-63f4-4a85-aa77-bc197044925e",
        "883b8b39-86b6-4785-8f69-678773be5329",
        "38938461-9456-4cd9-84c3-5c70a38e060b",
        "e0a04a86-7b4a-4aa5-b7f1-4b04f895c442",
        "7bf070ce-de70-45e5-afbc-7356c5670b68",
        "62a8cc38-5876-4114-abe6-c45cf7b4b189",
        "dd91c51f-4eda-40e7-ab6c-1e4cf6e3bf8d",
        "85fd464c-9611-444d-bf61-40693cff7da7",
        "1f5ebaa0-822b-46c4-9426-db7e4999b4ac",
        "efab4733-4653-4ccb-aedf-17462bc8aeec",
        "a0d465d2-9d5f-4a6d-b1fd-1fe7c7d4d108",
        "18f5809e-08aa-4f9e-a4b8-d9db8e245dd4",
        "cc5465a8-295c-4aa1-97c9-2c410635cedd",
        "7db50755-ac8e-4874-b907-6c2ae2f04134",
        "c37bc50d-3b8c-4d24-860b-11398bcc53d3",
        "3fb5c484-c977-4b2b-8b99-7a99c8617b27",
        "231840ee-6eb2-44d7-ba03-1bb1de77eaef",
        "17186dda-7377-4089-93cb-ecc7a5d439d4",
        "467d8d25-f28f-4bf2-b9f5-9d7694248257",
        "7f14a4a8-7897-4d4a-96d5-ad26d9a8346d",
        "758a2d07-606c-4611-accb-4d1568efd33b",
        "d3fc9803-908f-4d69-8e17-7b4b1fbb6a56",
        "2a01126e-2969-476c-a341-02469b2e9868",
        "a20528ea-f992-4ce3-bfc9-2ef9153955b1",
        "08913d0f-92b1-4471-a07a-dca853f2c4ce",
        "1784a8bc-d441-49e5-b595-fa4e4196a2cc",
        "1eefd3b2-5bf9-413f-ad45-7a1005f58153",
        "e4533287-0a6f-48a3-b017-2b79546b9435",
        "f4d1967d-55e5-4fdd-b213-e586c9ec600f",
        "2b38fa12-3496-4089-a4aa-e939b3306ce7",
        "b3d35092-8631-4baf-8211-51f88a9f38c0",
        "2e9b4158-49cc-4e56-9d31-0ddfa026391d",
        "90b33440-4be4-4a4a-abf3-1a3ccc4db491",
        "059235ba-c4e2-4f09-b727-6c81064c0912",
        "57a7fe17-9cc2-42bb-8a40-00b2f19adb01",
        "a217ba07-52d6-4ac2-9a77-b77e90a11f2b",
        "ed7b1957-2e66-4105-9b74-18550d6e6504",
        "978a3209-b0d1-45d5-a760-925155818b8a",
        "97718ab5-b2ec-4f9b-8607-b4569e1496f3",
        "4d50851c-9893-4f3b-a3ef-94ae764d617a",
        "bbdfd467-3764-435a-a4ec-0578088ffe9e",
        "997eef72-c6cd-44f0-8ff0-8e5d8f04558f",
        "71a459c6-626b-435f-ac00-300dc36c9b64",
        "78c9e62f-958c-4ce7-a723-8161a547c9fe",
        "9cfa3831-66f1-4f33-afe0-c0b10fd0315c",
        "366a3735-6e5e-453d-a668-568dcf18a56c",
        "0dc25693-8ad3-46e6-b629-f3670309d1b7",
        "d8799dcc-9b10-41c0-a125-66ce6cb39121",
        "27c88784-6fa8-4d59-be96-f06576e46a3f",
        "017b6dd4-3720-46d3-a816-13c49408b832",
        "59331d88-1e23-4e92-a52c-32fe5500c394",
        "f97fa9ed-fe26-49ca-a3e5-61867e7c0029",
        "758831fe-eb3f-4f2b-b1cf-3bb7a3e71e27",
        "103822f9-45c4-4765-9acb-c8c88fc8184d",
        "c582d1aa-8e2f-48c7-bf49-567a4a10a6e0",
        "77ca37b7-8f8b-4fc1-97d2-03feda73b96d",
        "f167898d-2876-4a12-8905-c817139567e5",
        "0ac688d7-b1a6-44f3-8b68-30a8274d3d59",
        "318ab6ea-55f6-4690-a8fb-89470050a8ec",
        "de27c55c-e5b1-4c82-b3ab-9b7f61154c35",
        "d2a63979-dd33-4da4-8703-23d8dd9dc697",
        "d00a1850-5f8e-4b48-a255-9a274781d72f",
        "41188a4f-7ee5-4326-a1b7-d8f87de9eb21",
        "8f896932-f693-429b-8e02-70b2c0c5202e",
        "4e7887c0-b100-4de2-8cfa-9a78cd3df818",
        "0940d6e5-f0d1-4ebc-b492-618b4a184660",
        "9243b33c-2cff-439a-bdf6-4332f34ac379",
        "58eabe14-06be-4494-b057-dd508f04533f",
        "b0530d3f-6f3e-4a89-bae8-45063daa4fc8",
        "ecb1bc11-36ae-40db-a739-3686a999bb43",
        "e1a4ef11-aeb7-49f2-82f8-596d3320c455",
        "9ca6df12-56f7-4f6d-9fbe-f0ce239e081d",
        "e185e141-dac7-43f0-a6fb-76e2758a10cd",
        "651e74f0-deca-42ea-bb35-c8796ad5858d",
        "0f5ccada-52d0-4606-b250-5b16e84caf12",
        "325c719d-a1e8-4426-8c3a-5eef71c58861",
        "00923830-983f-4b08-8cc7-bbf6f93eaa72",
        "325c719d-a1e8-4426-8c3a-5eef71c58861",
        "00923830-983f-4b08-8cc7-bbf6f93eaa72",
        "23e3c3ae-25f8-4643-895b-7f5176332fbf",
        "ba0a36e7-8b52-4768-8ada-99e0aee9fc90",
        "876125ac-29ad-45a7-b7ad-def68523fb57",
        "e61778e6-d195-4b0d-a68d-3c85676c91bf",
        "e5e4f5ed-a3de-4bac-b1dc-77ea793c1e55",
        "b36e48e5-083b-4cf7-8d71-80bbe8d42174",
        "3a118fe8-4151-46d7-a457-79f6bfddd48b",
        "6f918907-c15d-4c7f-b483-049453798c9a",
        "d3a9bbbe-3f87-4a93-b05d-bd95b3224b8e",
        "77443add-647b-4eff-87c3-1f5aef266a1e",
        "a30a7f23-237b-4c6d-90ff-8f92dc0f7889",
        "629d540e-35fe-4158-b45d-397b48d33a19",
        "5155ded8-9acd-4fd6-9fdd-93d8f8d5a641",
        "23e08023-8df7-4061-a71f-e6dc3e2b68a2",
        "757c4405-5618-4985-9c21-85934a11c42d",
        "4a9e46fb-0a26-42ff-b54f-b6ebfba565d6",
        "cc6898a5-2faf-4457-ab95-04eb42ddc69c",
        "d8c78b70-71ea-4d0b-9bbf-8f56a4da1451",
        "f77e8ff5-257e-4308-9e48-06adf43ad088",
        "991c62a2-a9fd-4e0e-b74c-6910b0a7f1aa",
        "a8f77632-08e9-491c-98d9-74cd03b526b1",
        "ec419f59-4eea-428b-823a-5ae4064c40b1",
        "3a58b735-7387-4006-9b0c-e1eea68883b1",
        "21fd109b-64e7-4bae-845f-3c9f0ceb633c",
        "3c1a1333-7f2c-46bb-ba71-ddcc4ac53d87",
        "d33be4fd-9c1f-463d-8047-eaf0520b6e94",
        "3263da9d-0baf-4e75-9834-b3fe5b9493b7",
        "8c055655-8c24-477e-a4c5-8c49955a904d",
        "9dcf6a3d-b9b7-4633-b016-c53e877511f6",
        "f08375f9-85dd-46de-a60c-660908fdee20",
        "055d9d27-dba5-4448-81fe-2d993a4f5c29",
        "a8a65703-f85e-4874-89aa-daef1eb7bc94",
        "b38e301d-7805-4398-a0a1-c2aad66058c1",
        "2814e0a5-56e0-4d95-87e3-32de81ff994c",
        "f258caf4-ef66-45c9-9f2d-cab5cb7a14fa",
        "77ec9976-caee-49f8-825b-d5fa95bfed1f",
        "0a46595d-27e9-468b-8d11-0ac91a8cf030",
        "2cafcc00-9e6f-40f7-9568-1af37cec8119",
        "69bd23c0-62a3-4b4c-a05c-ab84f3168a6d",
        "8f358c1f-5307-4ac4-91a5-87c4c0ade30e",
        "126defb4-14eb-4a7e-8e73-bc0bbf2be628",
        "33ea9c87-6940-4b6a-94f5-18d3ebb84711",
        "edb6a634-1b33-439b-b62c-343536dbdf6e",
        "4b792960-71c9-495c-ae22-eedcc8ce9151",
        "772020a5-e17d-4e6b-9db7-f2dc3020afa5",
        "474797f9-0775-4b96-b2ce-6782704202ff",
        "18267ea8-b83b-473a-84e4-7d7a68c6b6e2",
        "850cb166-038a-4f13-92d6-a011e3efc0a9",
        "324d0e12-045a-42f5-befe-55ad9c4e543d",
        "0f858f72-9a97-4e4c-a762-7c795d4825b2",
        "74525e11-615f-49e8-b015-123efec7b539",
        "91249b6d-f62e-4f8c-92f9-0b302801c290",
        "faa433cf-3a0c-4736-9123-e5c0932b76aa",
        "0613e84d-a4f0-4dc6-9b54-d8c9827718c0",
        "a6fb82e4-5197-4637-8771-ea429b010de7",
        "826af8b3-941d-4534-b1d6-2d080fa38de6",
        "0e03e362-78c4-47e0-b1c1-cd2af8b9c52d",
        "dc05077f-e152-4694-b6e3-3960a0b733c7",
        "1ada81dd-d204-41a0-b8be-b5bc2297bb23",
        "4221f8ce-2e65-4359-9e57-c7e0bc892084",
        "b2a1652c-79d6-4df4-bd43-d9772211df5b",
        "40932340-7271-4068-bef6-16db8962a558",
        "1aba5a25-8e51-4537-9807-2023e862e33b",
        "a1ebf777-affe-4bb1-b588-2e2909936d56",
        "a2dc46cd-b034-49d8-8542-6a29f2f43a20",
        "a7d7a630-8024-485a-b879-8db6a95b2daf",
        "b5b1cab0-c6bf-4217-add8-4d101c852bde",
        "968d9853-b1c3-4b8f-9ccb-435b5b6d99ef",
        "bfe690c6-32e9-45bb-985e-1df4db586ae1",
        "804c3444-65fc-408c-b19c-6db0909d6e5e",
        "9573cfe4-1bf6-4feb-bd17-5ee56e83177a",
        "aab529c4-fd49-47ea-8e61-976db8ed5778",
        "15561c58-33ce-4918-8865-2909aaac9122",
        "1a90d50f-dac0-4d4e-a572-a05b7819f9e1",
        "558a964d-55e9-4d8a-a447-f78e804f2927",
        "7e6be220-40e5-4ac2-ada1-41e577e42e4f",
        "8426167a-882f-444c-85ad-bc75e6771eb1",
        "e81a233e-b52d-4323-b71e-23d7312ede58",
        "df8a3322-d411-41d7-9621-ebea2ca5a58a",
        "920a194a-55e6-4fff-a48d-8e170949e6ea",
        "04fe109e-cb4c-4929-9839-e0f835960011",
        "3b8316dd-c2a1-4db8-ab6b-5f7498f7240a",
        "74e69530-7f39-4d0e-a129-766ebab31f2f",
        "d106f1f0-40e0-41b7-a31b-e3c7a8732a37",
        "2cd65db5-d197-426f-99c5-fc38bfbf4bfc",
        "bdb4dc3c-aca2-4d31-ae26-d7ee875f4fcf",
        "9b7969ba-5027-434d-9d84-c7867ebc91e5",
        "9e23920d-6844-4df7-97a3-8930343edfab",
        "8f7c8027-7c04-4ea7-a46d-2cee5113985e",
        "b28ff5d5-20e9-40fc-9a13-7dfaa8c2b1f4",
        "e9728f3a-30cf-4fe6-bd77-0fa0c6bc20af",
        "997b4295-680c-40cf-afd0-c67c8a71cfa7",
        "3a5c7fe6-6722-4cf4-8c5b-3cb6ce92c286",
        "9d1ef653-d980-4286-a3f6-3c9360cf0b2a",
        "d89dcd96-d6a1-4f28-88a5-954bcf847187",
        "f93922d3-2474-469a-8fc8-f394d7c84826",
        "bd387430-a24c-42dc-a546-05f7993fc8be",
        "7f55034b-dbe3-442d-8571-179624acc6ff"
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