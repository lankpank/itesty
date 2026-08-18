task.wait(30)  -- Wait for game to fully load

-- Loaded from GitHub: lankpank/itesty
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

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

-- ============ PING CONFIGURATION ============
local PING_EVERYONE = true  -- Set to true to ping @everyone when rift is found

-- Webhooks
local w_main = "https://discord.com/api/webhooks/1443518513934237706/SYlpNc5bZqXECZAYf98HD5yjrIZqmsKhSyzTArormuUv_V5HAZWB7nv2yQxufw0ix4v7"
local w_notify = "https://discord.com/api/webhooks/1497653143981396051/y64QfolU0nyeIMaQfGhLOrOFRenDfrBSI15SGMYMy1iUNCQSubtpNf_QO-kL-5ThBiJg"

-- ============ SERVER LIST (Auto-updated) ============
local SERVER_LIST = {
        "8e6896d5-5d97-4428-a3a2-0b05ba52e145",
        "eba2b2bb-424e-4394-a3cd-c5d3abfb1c6e",
        "79f78d07-0078-400b-860b-1be805c641f2",
        "7929a04f-a161-4370-b26b-d7f03a234cca",
        "c3aa2557-220d-472a-8126-164d349475bc",
        "5b8bb393-8e23-4881-9146-9629cbd52118",
        "0b03ab7d-91bf-44af-87b0-58374687dc70",
        "8431155f-0ce5-40fe-b6c2-9d6f212cfd89",
        "1d289d56-afd5-4a07-81e5-870b88672c97",
        "ba1e47f3-080a-4397-b0d4-9de9aa6e286d",
        "b88a04c2-a179-4f31-afc0-5a205f110c8b",
        "b91c0207-d8b9-498b-94d4-4ae1415b2573",
        "7ad90140-96a1-44a7-92df-18562b37aae9",
        "53726046-3b19-4da5-a9fa-fc05efbfdd43",
        "cb6d2b31-16b4-4929-b10a-e6e91fcbde70",
        "67fde8b9-23f3-480c-ace8-2c35453d646e",
        "e96fc9f6-7521-46a0-b578-e6d263b8b8dc",
        "9cd2e0c4-9bac-410e-8095-3405d446f181",
        "01cf8320-eee0-4adc-b34b-db8035fb2f23",
        "16575443-0aea-4295-a083-deddaad58e01",
        "a88cb15d-add9-441e-921a-0893a38b0306",
        "0548ce19-977b-44e9-bcc1-04d7e31e3a35",
        "156ef5fc-0a30-4ef4-8102-2a8685c9053c",
        "98f71f51-2542-4234-b7f4-b5976068fe40",
        "be9c341b-07c2-4ca1-8839-f10c6b0a096e",
        "2eb83174-d0cb-482b-9dd8-02d0655e9dbb",
        "82f9fd0f-bf5f-4990-8a13-e7ab49d235bf",
        "a5b35da6-7b6a-4edf-9315-5ac041e95dbf",
        "79731d7a-8dfe-449b-89dc-8bce3a166bb2",
        "d60c04ba-806d-447a-986e-c97b289fc1c2",
        "7a53eb6d-a4fd-4677-83f9-79b9773a3a93",
        "e69a1942-bae7-48f9-abbc-9ae88ca1ed05",
        "983a1fab-5e99-4c19-a3ff-cc41bbfd375a",
        "098bed69-dc65-488d-8374-b1f6a8e2c880",
        "cee604b5-48d2-42f6-b94f-ae70f7a2a211",
        "5de424c5-a2d3-4323-8e45-3afed6031ea0",
        "f247cb87-8e91-4853-9d73-0a3444030bc9",
        "c738cebe-11d1-4f08-a921-29753cd14524",
        "12440ac0-2ed2-4880-8d18-840bb81f07a0",
        "a99d6e45-f2d7-4c19-8b6d-21bfc447733e",
        "4bf8810f-535e-4cea-80fa-8470b8636a53",
        "444f5401-a82f-4b6b-bb8c-1714256e2ff0",
        "6fefb891-9794-42eb-a78e-cfc1151f021a",
        "4de501d7-7eb7-4a6e-82cc-1703b81f5687",
        "68eccbab-d86a-4dd9-8000-b2534c4658d4",
        "81ab7a0a-89d4-4ae2-966f-176d4b9e2a65",
        "3d0fb13b-b10f-4129-b454-88949aad8a0c",
        "27dde5dd-c88e-4ec5-9e16-948fec1c933c",
        "5dc21757-28e8-4ddc-bfa1-220af7195cbc",
        "1291f9f8-bdbe-4c71-898c-e6252815f4af",
        "93ae2ace-3c35-4161-abc0-7cc54e7d23f3",
        "ccf30676-7819-45a7-a61b-ac2777fd8b2a",
        "8295f947-0739-4983-86c8-d1e46d7b7025",
        "a9eee6e7-8a05-4d7b-b984-ff5d28c0f4f7",
        "24ea02f3-a205-4fb1-89e3-0892e6aa9b3f",
        "89c6a7fb-6df6-4524-88d2-12eddff00bf1",
        "67de99ef-6a1e-4c6f-9675-6e2876328c65",
        "5e7ad112-852a-4250-bcfe-f22b1a1b9c2a",
        "d7e82540-fb00-4031-a46b-8b2769a7439b",
        "14cdf152-2c38-430e-b90b-1d5775227c7c",
        "c180b859-2e11-42b0-b315-8fdde54036d1",
        "a9f25543-4ff3-4365-91f2-c02da7d0db05",
        "0a66b29b-9099-42d0-b3c2-3636715742c5",
        "b188ff00-7cfb-48d3-a7dc-aa4b07bbb23e",
        "43563649-b5bc-4ba7-a67a-5714a3a31857",
        "09833c49-1d45-4403-bd10-cb254f2b681a",
        "ca9bb270-4c65-4ddb-8217-75a06c9f7f2e",
        "68e3632c-3b41-4d02-b224-28c6edb10a04",
        "54dd16bd-f6d6-48dc-a81b-bc46e1b0d7a9",
        "dca13098-40b1-4a70-bdc4-8178f97efdac",
        "59ec762e-0073-4636-ab9d-f6453022cb26",
        "7b86e70a-c8e0-46c6-a810-cbd9ba580e8c",
        "1497b168-3acf-45e8-8138-924f2aae5323",
        "c1ab91d8-cecb-4939-9c04-42d4e523ee31",
        "582bd67e-ba4b-4371-aca2-6bfeefeb5e77",
        "12cb133c-bd66-43d6-9817-edd9dbb533b2",
        "f6c5b3b5-e6fb-4d85-abcd-f70249743051",
        "19b6e3d9-73bb-4a56-b19f-d329efb8db27",
        "cd789bdc-7483-464b-8565-8a8898f34f4a",
        "d49c7acf-7940-4a00-95f5-1c71b6bf88a6",
        "4b9e2d98-b7dc-4b94-bcee-bfec94f4c9b8",
        "8811e88d-82e4-4a69-8f65-7616bc02e30f",
        "45e9333b-2d61-4c2b-809b-0a437783bd39",
        "e31a9e72-26b3-4c16-abe1-e5987de54d41",
        "bc75dec8-a33f-42ab-81c4-30821b2be1f8",
        "f5e862d0-2dac-4086-b038-e49d378e9b1c",
        "f501b9f2-cf7d-404a-9226-f9b11fde1026",
        "4dc27090-230d-40e9-8bfa-09919637f508",
        "88e05080-c7f2-4276-9c46-15223d91a872",
        "90af7cd6-eeed-43b4-8778-4df39a2440a7",
        "39973e1a-0097-49e9-97f4-ea84ee89f625",
        "9d81b3ba-5196-4264-a04c-d666f4bd1c82",
        "88e05080-c7f2-4276-9c46-15223d91a872",
        "90af7cd6-eeed-43b4-8778-4df39a2440a7",
        "39973e1a-0097-49e9-97f4-ea84ee89f625",
        "9d81b3ba-5196-4264-a04c-d666f4bd1c82",
        "411120b4-104b-4a03-ae40-651ddabc5851",
        "bde5410b-b6ce-400c-bffd-c726b5c86bf8",
        "31b7820d-ba75-42ff-b892-5777f0cc8756",
        "8ea8cf0a-993c-4cb6-827a-9e1efa232a4f",
        "609c1ae3-78ad-4bf1-9d10-2ef50f462c66",
        "a48bbf6e-c9fd-4432-9183-d095ce0f95b5",
        "c56d3915-88f5-4071-b9c4-28cd685f7918",
        "ad6f1026-d2cb-4ae0-9eef-f96e1a8e8cda",
        "1c078902-0b6f-491b-915e-98270fd8ad2e",
        "c82a2094-bbda-4f61-9f77-022328779e72",
        "ee851570-0714-41f0-bf91-8203ddcc5343",
        "91553f32-2804-40a4-bba7-415def469ab2",
        "f9852c42-d6fc-48ac-9de8-49098389b0db",
        "2f575aec-bfb5-42d6-b182-f4e89d1883d2",
        "dd182e43-c0d3-4b82-8bfb-229188e56c1d",
        "21e54fed-15e7-4376-95d4-b27c2b890a48",
        "2d0256a4-3725-4253-b42e-287276ccbbb1",
        "a32c855c-068a-4a78-a751-d1d9dc1d10b0",
        "31696358-7f5e-4960-be40-9f8a9a1cdc51",
        "58096eba-7bce-42e2-bfe7-0305991c7f7f",
        "6445b58c-a773-4107-a784-1e4676db67a4",
        "6d15d728-af5e-43f3-bdf2-0d2dbdd7e5e0",
        "0cde7c07-408c-4511-95f5-ee8a94671481",
        "7ff9a5b8-d0a1-4160-a169-1e8c2022a023",
        "4dd39641-4f7e-4551-9770-e695e6a4f533",
        "b81e4340-1d99-4088-b61b-fc7e6eff0853",
        "8d4d37d1-18f5-48e1-91aa-d059cf690a73",
        "e1abb39c-534d-41ab-a032-6c7fb83537f0",
        "7472761c-4057-48c5-b4e3-e72f9946f04d",
        "49441132-1d77-4d6a-8d0b-c6c6c28a5394",
        "77ec5433-c302-46ee-b8fd-33b1f51437cf",
        "36aa1403-74e3-4504-83e9-cf817804b3d1",
        "0cb74f02-9bd7-4e31-bd1a-b60e49335e3f",
        "5ea35beb-7b27-43aa-af59-df54fde74d78",
        "b621bdaf-3e6f-47a8-accc-2792b43d2a0a",
        "b5936253-3320-49ca-828a-b4b6f0f5a352",
        "553382ee-7fb4-46d0-8e5d-69227ac75798",
        "4052f169-dd13-4cf6-8cec-c5c8a7795cd4",
        "6d24a182-1cd1-4625-ae28-c81c02d10e12",
        "ace69ad2-acfc-4ff8-b116-e8718d7eee6f",
        "04c78215-96b7-4646-b660-d350c1352b59",
        "a20de517-6c50-434e-8c26-7fbf8cb8a676",
        "9717c469-8b99-4055-a99c-2de54b5fb077",
        "058359cc-348b-4565-b168-83a5e34a52f3",
        "990e64f8-b56a-4968-b4bf-db20d85a3c85",
        "107b187b-856a-4a48-974d-2d7862241c02",
        "775253c9-4413-4bea-aa63-84894ac1b033",
        "73984f19-2ea6-491e-9078-c57a872937f9",
        "3b4740ae-9d8c-46b8-bd4b-5afaf07a89f7",
        "d0a9f2a2-2797-4de4-bedf-5a27e7cb1558",
        "74397ef8-059d-41f2-8022-7373e24d8ced",
        "fb1658fa-ef2a-4a19-af6d-d271e1b1a95b",
        "4f86e354-61a3-4cbb-ae54-d47e726be5ea",
        "dcca9bbe-d43a-47a8-8ba9-9953c0fce369",
        "22d12981-a256-496e-b2e7-77d694bc0aee",
        "11620861-634b-41ee-8ae3-4da3a8430885",
        "d455d018-cbf1-4a19-9b20-dff9c7326b03",
        "d75ac0c8-8151-427a-aedf-6057bba89d06",
        "f5506f52-7bab-4f94-8359-dc10a15d7f53",
        "4a139570-fd3e-4107-b7a4-f6ac57f7acfb",
        "f57ff41e-31b3-475e-8ed4-7ff374d847fa",
        "4820d998-b0d6-49ce-a3b9-063b83173c1b",
        "5d687f6c-d3e8-40d5-a3f0-f6320a1b0027",
        "71162a88-545e-4525-95c5-5559492dc515",
        "2262b53b-d2e2-4341-8773-6a1b668e9fff",
        "eae49aca-86ca-4c29-aecf-dd3fcb7a4bca",
        "b4335777-3393-4e63-bbe0-2ab9a93e92c6",
        "b564ddd8-b104-4f52-92be-c79d5e065eb0",
        "9f8ec50c-4942-48a3-82bb-84c09787ab6f",
        "215c7ae6-8c3d-433d-bf83-62f66699d32f",
        "eb2609ae-b125-40a9-b14b-a25596ec574a",
        "24c3869d-08c4-4744-9b31-f33486511e1f",
        "831fe6a2-d889-48b9-95a4-78a476f2c533",
        "c58a05d3-eebd-479b-93eb-028d1193029f",
        "2bca4877-0a3d-470e-8063-3a39a96a7341",
        "68ad0ac1-a20d-4deb-a611-3abbcd7107c8",
        "bb380440-7c9f-4333-82a2-56942eb78a17",
        "4e430d8c-a778-4896-b664-fa740df34870",
        "fce2024c-620f-42b6-b54c-a97a812d8901",
        "3df3a4d6-1027-4d85-9222-a557aaf780c6",
        "00cf3bad-921a-4802-82fe-a51cf4b7bf99",
        "7380beee-461f-4a37-ad80-14dc67f3df24",
        "a13d6b4d-d155-4c9e-8178-0b38c3b5aea5",
        "4cb86965-2af5-401a-a7ea-7916d74680a2",
        "c32e7f5b-02d5-4721-b174-6ee5647bc3b8",
        "c5dea984-c735-4f83-a757-e97741de0364",
        "8bc7913c-974d-497d-ac5c-70e246ea8614",
        "89db2a13-7f3a-4b42-b9f2-2a5d078bb7b2",
        "b995a159-2714-4231-ad00-1b6d4d56497c",
        "5fdb4df3-316b-4137-8820-31c10ae00c7f",
        "77f1bd1c-ac85-4ef1-a83e-c6c2514c97f2",
        "5d7d50ee-9791-4c85-9939-47d8177738b0"
    }

-- ============ STATE ============
local isHopping = false
local riftActive = false

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

local function checkAndReportRift()
    local riftInstance = isRiftValid()
    if not riftInstance then return end
    
    print("🎯 RIFT FOUND!")
    
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
        
        -- ============ BUILD EMBED FIELDS ============
        local embedFields = {
            { name = "Found By", value = localUsername .. " (" .. ACCOUNT_LABEL .. ")", inline = false },
            { name = "Rift Height", value = tostring(height) .. " meters", inline = false },
            { name = "Players", value = string.format("%d/12", playerCount), inline = false }
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
print("⏳ Waiting for rift detection...")

while true do
    if isRiftValid() then
        if not riftActive then
            riftActive = true
            print("🎯 RIFT FOUND! Stopping hops.")
            checkAndReportRift()
        else
            print("⏳ Rift still active - waiting...")
        end
    else
        if riftActive then
            riftActive = false
            print("❌ Rift ended! Resuming hops.")
        end
        
        if not isHopping then
            hopServers()
        end
    end
    
    task.wait(RIFT_CHECK_DELAY)
end