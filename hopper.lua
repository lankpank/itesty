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
        "fc3214ed-422d-4bbf-b3ad-c22431bbaebd",
        "534c0c28-ea7f-4367-a2bb-4e11d3dab350",
        "75798b9d-3a44-4b51-9a2f-f2f933d5221d",
        "1993a767-50fa-4c92-96ab-d4585fcb6c11",
        "bf814909-a58b-4e80-af9d-854a4c49d6b7",
        "db0ccca7-f52b-43fd-9593-614434921196",
        "3df3a4d6-1027-4d85-9222-a557aaf780c6",
        "9ea3e6f7-dcb6-4712-808e-591b94c401e9",
        "1aca2134-69f2-4259-8430-2c205f11b32e",
        "cc6fafac-2aac-4e68-9c7a-26b78189af79",
        "3e2411ae-6da6-46a9-8e63-6a0773107199",
        "e09039bd-d1e5-4974-b4cb-c6b68ca83d9e",
        "c17e7d35-c99c-4c98-bfa3-7420a0ece36d",
        "50b16701-f0fb-403e-a403-f608e4e183c0",
        "a6e0d7f4-0404-46e0-b0da-dda79b16aaca",
        "1392232a-7115-4326-a3b1-0bdf389583d9",
        "3a0ffe85-4589-46be-9c1e-dd2fcc8f4947",
        "f6cc4703-57a7-4406-b935-4b1dc0397db1",
        "00cf3bad-921a-4802-82fe-a51cf4b7bf99",
        "20e7c337-40fe-4313-a0b9-e3ce9523234f",
        "23cf3990-13c0-448a-99e1-386486e1b715",
        "a052622d-6d7b-48ea-aea0-1bdb3e8ddc44",
        "86561815-b9de-4504-a3e9-4245048906ea",
        "1992d373-2418-49c0-a44c-fab4be95b8e6",
        "d35b1de8-b671-4b91-8922-de7f79ba9046",
        "215c7ae6-8c3d-433d-bf83-62f66699d32f",
        "2a8eec2d-847f-4497-a1ea-afd37f9a6308",
        "4b69b460-c90f-4f2c-a7e1-2f79d7a105bd",
        "f5a95558-c154-4843-b92d-eeae7018eca1",
        "db32530f-50db-4959-a665-1f9850953197",
        "e52c298a-83f5-46d0-aff6-967a60c9c0d3",
        "caa62ade-3edc-4275-a4c3-7ad1e89936e4",
        "c5dea984-c735-4f83-a757-e97741de0364",
        "c943a6f4-f443-461d-a0b1-61988cd0e8e7",
        "6eb69a27-6b40-4537-9f7d-568644b75243",
        "a35f19fd-fe08-478b-a28a-50331d27dee7",
        "e42f8340-8f21-442a-8a6e-cac596ec8bda",
        "deeb9fef-e2ce-479c-addb-6e029d8074eb",
        "79cb8038-9226-4d0c-90d6-ffd511684b00",
        "e9f7d5fe-918b-4736-aec1-cb5b4758b484",
        "1c0ac1aa-df77-467b-b2c3-056ed47ff1d4",
        "e83a45da-d09e-49d6-9cc9-b6a549f3922e",
        "267582fe-d242-4afd-815c-a8a814c1415a",
        "fce2024c-620f-42b6-b54c-a97a812d8901",
        "1c1fb1fc-9585-4257-92ba-4a602bda93fa",
        "6fef377e-ca7a-44c2-a18d-4ce8d147c3d2",
        "244b53a3-af06-460c-b4a4-0fd8a9f602af",
        "962e10d7-c6f1-4940-b3fa-713c2483845f",
        "3c360255-428c-48b0-89c7-c0ecd2f59d1f",
        "89db2a13-7f3a-4b42-b9f2-2a5d078bb7b2",
        "dd65646d-f756-4e70-b962-c4e50f6a4f78",
        "32b8050f-0d11-4b74-8a94-26a3fb9584ea",
        "c422ab76-f84b-4541-a17b-956750a91f75",
        "4298d5e8-b482-4456-bfd1-58ea5889212d",
        "dc142b29-7d66-4cfd-a2a7-e88b6e80a8b5",
        "c537cc08-c1dc-41f9-a779-2f0189520ecf",
        "d9992d7d-c731-4f6d-8f51-653d84f5ac7c",
        "30cf64a4-2480-4975-bb88-e97df4c408bc",
        "83ef013d-1f76-4031-8c54-ae143ad6be8f",
        "bc0520f6-35e9-43d6-b68b-c895e6274dbf",
        "1e855c96-5c67-4368-982b-683da09b0ac8",
        "d330cf81-808c-4163-be8c-913680dd0c2e",
        "870d73e9-290d-4893-aea6-75d4ff93247f",
        "812249eb-fcdd-4465-8e12-9d3c65f8eaae",
        "4018821b-309b-459a-b3ee-9e902f5eace9",
        "3d4c06c5-2e1d-46a9-81f6-57b20073cc6f",
        "ed9dabcf-927e-4a66-8a11-f7c01a926aee",
        "519c360d-84c2-4228-a560-3f403879701b",
        "7f9b3e63-a8b2-4793-a04e-dfd9bf4f0a13",
        "d9a8a9f5-ca5e-4963-ad8d-d5237f4d8a5c",
        "0d6096bf-fc3f-4209-b53a-604fa994e012",
        "2660b2bd-899f-4292-9b7e-1c16888ac66d",
        "dcca9bbe-d43a-47a8-8ba9-9953c0fce369",
        "a573e634-9e77-43d4-be42-235ab50196a4",
        "5019ba2e-92a3-41ee-9131-0d7e53623127",
        "d0b42b7d-2240-406a-b43a-9afab2c462ec",
        "f7a4bdba-bf6d-478c-bbc6-d83c4a8fc20a",
        "cd3ef91e-239f-4c76-913f-84ab196b1e7b",
        "8bc7913c-974d-497d-ac5c-70e246ea8614",
        "d64271f8-6d58-44b1-835b-3fea207c40ab",
        "bf2fc08c-587f-4b4e-836c-913c53054cb9",
        "845409c1-4263-4cc3-94ff-628f10549a21",
        "313c81f2-6721-4b08-b80f-e3027e999863",
        "611e1b64-f149-45a1-b96a-1cdf0757e7f1",
        "86c9f997-9511-44c4-8d21-3aa9df03a869",
        "b564ddd8-b104-4f52-92be-c79d5e065eb0",
        "ddfb52bd-b86b-4e61-8964-ef8d65902676",
        "5b8b54f5-0b72-4302-9265-cf7b16694ab2",
        "80223565-9068-4a6d-bf72-a1e6e5fd45f2",
        "35013c51-e760-4e46-a8f4-9bbe81cfd7a6",
        "1833c6db-27c5-4884-bc72-19aeeb85b131",
        "0fb37ae8-a9ac-4bc1-8595-de98a1494fc0",
        "943a5261-8a60-458e-867c-16d5d611c73d",
        "2660b2bd-899f-4292-9b7e-1c16888ac66d",
        "dcca9bbe-d43a-47a8-8ba9-9953c0fce369",
        "a573e634-9e77-43d4-be42-235ab50196a4",
        "5019ba2e-92a3-41ee-9131-0d7e53623127",
        "d0b42b7d-2240-406a-b43a-9afab2c462ec",
        "f7a4bdba-bf6d-478c-bbc6-d83c4a8fc20a",
        "cd3ef91e-239f-4c76-913f-84ab196b1e7b",
        "8bc7913c-974d-497d-ac5c-70e246ea8614",
        "d64271f8-6d58-44b1-835b-3fea207c40ab",
        "bf2fc08c-587f-4b4e-836c-913c53054cb9",
        "845409c1-4263-4cc3-94ff-628f10549a21",
        "313c81f2-6721-4b08-b80f-e3027e999863",
        "611e1b64-f149-45a1-b96a-1cdf0757e7f1",
        "86c9f997-9511-44c4-8d21-3aa9df03a869",
        "b564ddd8-b104-4f52-92be-c79d5e065eb0",
        "ddfb52bd-b86b-4e61-8964-ef8d65902676",
        "5b8b54f5-0b72-4302-9265-cf7b16694ab2",
        "35013c51-e760-4e46-a8f4-9bbe81cfd7a6",
        "0fb37ae8-a9ac-4bc1-8595-de98a1494fc0",
        "943a5261-8a60-458e-867c-16d5d611c73d",
        "fbcc1907-8029-4011-a409-a06f2df727ac",
        "7e35c3f7-47e5-46b7-9aa9-c68c14ea6516",
        "c3ce8cb3-3870-49a5-9e30-19b69cbfc03e",
        "cde17e07-a9e6-42cf-8fed-8103e2f5cbb4",
        "0a5d21d6-3d3e-4695-8012-ba7490882f9a",
        "7349c62c-6a93-43db-b560-efdde8d478fe",
        "5be46351-4a03-474f-9d64-9a6599f2f826",
        "2262b53b-d2e2-4341-8773-6a1b668e9fff",
        "eb770233-9ec7-44ed-af54-4ca0d3c76430",
        "752cb95d-78d8-4eb7-81f4-68669e31bfcb",
        "99737309-c7aa-4ef5-988c-a101b2cdbb9b",
        "e8264bf7-72fc-4c58-a433-7e39d4cd6740",
        "3d5ac487-fb0f-4cea-b245-c44905fc5f43",
        "12a1e322-bc5e-422b-a392-31e2a688c1ed",
        "61e882f2-983e-4161-82ef-9fa701778fac",
        "8b0d8369-dc1f-4463-88ac-c9553b5d16f2",
        "292fe893-ffc6-4e30-80b9-7eed7c256c14",
        "49d9a106-4ba4-4737-960f-6af500c19d5e",
        "7d1fce63-ae8a-4061-bdd2-3c839a9238f5",
        "addaeaaf-f4cb-4b45-b5c5-80c846feb9ab",
        "ea4014eb-ee13-43e0-a6af-bbb14c878ec3",
        "dcaf2d6b-d4c3-4ef2-8375-7fd78e4e8fb5",
        "a9b0ee6b-a918-45e3-bedb-3c274441f12c",
        "24ff08a6-f4bf-432f-8946-ef031500091c",
        "545b9b5f-9d8c-44ac-a1c7-c5bfcd140ee0",
        "71703cca-59d9-4d50-b7e5-01bdaceae99a",
        "1833c6db-27c5-4884-bc72-19aeeb85b131",
        "29836902-a831-47b8-9143-8773d9d1199f",
        "edbe55e3-52d1-4475-a4fd-d46cfc9da123",
        "918933a7-5b97-423e-9e5f-331987b5cf8a",
        "329e115d-9c49-483a-a76c-26328fe7ebad",
        "7f807ee2-9f49-495c-96fa-051d84b26d12",
        "1ea23fd5-1d7b-4650-bacd-b3b609fba81d",
        "103eed94-b7ec-4865-90ee-475a17bc6d1a",
        "99654c5c-8a7f-4b08-839b-25363023cbda",
        "fe8515c4-a9d1-458a-a18e-15c24f9fe1df",
        "954329c5-5957-4692-823b-02f893509917",
        "5e202e53-24cd-477a-ba88-18a002df4371",
        "57527f6f-f581-4cf7-bf19-ecc35e73b76a",
        "3c3efe20-d69e-45c9-ade5-f1660c95f027",
        "bc88317f-9ac7-4df1-a4a5-736b547ff593",
        "651aaddb-646e-403d-a52e-2da310c580be",
        "6e9a89be-1a21-4077-af62-c9326ed0bdb2",
        "346236f6-33c3-42cf-9085-b1ec11cf76e6",
        "0a85945e-778c-4015-ab03-41fa3215f0a9",
        "18109e5f-c0f3-43d5-b209-697ad8501dd9",
        "72769aa4-e1a1-459d-8e52-cae0f507c160",
        "efbd8e35-0706-4096-9324-25e28ec4751e",
        "ca7d9dcd-5659-4564-afe8-e0f9b5163946",
        "8ed7269a-ecad-4946-958c-5c1dd1514c02",
        "72cf54cb-e875-4a17-b2ad-ba10d77c82a7",
        "780725f8-4d84-4c17-9b4b-984717fd410e",
        "3dc9ea09-500d-4350-89e2-22e5ab748abe",
        "d455d018-cbf1-4a19-9b20-dff9c7326b03",
        "4f158300-36e7-4fff-84ba-b57a8d1d15bf",
        "219c20b8-356f-406a-ac4d-e908cfe45fad",
        "80b5cb23-9d53-4e43-b0d3-d27ec256387b",
        "f4377600-88df-42a9-b69e-bb0de9908a63",
        "ce2e7bc6-b1a5-4f5b-bd11-850709f68c60",
        "d4fa9dec-29c4-42f6-8b07-24ef2a014af6",
        "9761fd22-8795-4190-9238-aeb9b10e07cf",
        "44ffe831-b607-42f9-9c96-3f18238e53c1",
        "bb380440-7c9f-4333-82a2-56942eb78a17",
        "00eba82a-375b-457d-8d5c-cc6386ef0895",
        "696c512e-5137-4dd6-805a-a5893de13ce7",
        "805bb54d-590c-489e-8c5a-ba68dcfaa566",
        "829f1195-778c-4071-869c-f207e45ecc50",
        "c327085c-ff60-4523-b81b-b9f10fe0fd26",
        "3ab10afe-1a71-411d-b680-4f749113178c",
        "fa509cb6-22ca-4006-a97e-a8161c18e90e",
        "f0b285d9-3a56-42f2-905a-eccf414a9056",
        "d12cbb8c-36b8-4ddc-8639-b12021d06abb",
        "f55d4cf3-712e-4e12-b723-96ef2d104f90",
        "cf5370ae-5e72-4e86-83b5-ebc3b2e95bc3",
        "4cc57add-23a9-4252-8f76-3ae5049f9ec6",
        "b4b787c6-8198-4d68-b062-a2a7c106e7d8",
        "77a33cf2-89ea-45d3-a2ed-2097a423255f",
        "25bafc3f-148e-4ff8-87b7-16dd871ddcbf",
        "4283e946-9da0-431e-9c10-6dc9d3ca89e9",
        "b4335777-3393-4e63-bbe0-2ab9a93e92c6"
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