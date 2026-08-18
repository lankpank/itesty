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
        "07a0f6dc-da79-412c-943b-2c6d17ba3beb",
        "0cb74f02-9bd7-4e31-bd1a-b60e49335e3f",
        "deb94fc7-fa42-4302-802e-0401ebc57e75",
        "93ae2ace-3c35-4161-abc0-7cc54e7d23f3",
        "16575443-0aea-4295-a083-deddaad58e01",
        "8ea8cf0a-993c-4cb6-827a-9e1efa232a4f",
        "8431155f-0ce5-40fe-b6c2-9d6f212cfd89",
        "6d15d728-af5e-43f3-bdf2-0d2dbdd7e5e0",
        "b91c0207-d8b9-498b-94d4-4ae1415b2573",
        "4820d998-b0d6-49ce-a3b9-063b83173c1b",
        "f9852c42-d6fc-48ac-9de8-49098389b0db",
        "c82a2094-bbda-4f61-9f77-022328779e72",
        "b5936253-3320-49ca-828a-b4b6f0f5a352",
        "5d687f6c-d3e8-40d5-a3f0-f6320a1b0027",
        "098bed69-dc65-488d-8374-b1f6a8e2c880",
        "29f850d4-7a19-435c-918a-ba97a8321904",
        "553382ee-7fb4-46d0-8e5d-69227ac75798",
        "5e7ad112-852a-4250-bcfe-f22b1a1b9c2a",
        "1697716d-e304-40a7-84d2-0640a24046d1",
        "444f5401-a82f-4b6b-bb8c-1714256e2ff0",
        "7ad90140-96a1-44a7-92df-18562b37aae9",
        "b995a159-2714-4231-ad00-1b6d4d56497c",
        "f5e862d0-2dac-4086-b038-e49d378e9b1c",
        "a9f25543-4ff3-4365-91f2-c02da7d0db05",
        "9d81b3ba-5196-4264-a04c-d666f4bd1c82",
        "7ff9a5b8-d0a1-4160-a169-1e8c2022a023",
        "1a1d0eda-ca51-4e3a-aff0-a327b152dd75",
        "f0025375-e785-44d7-8d31-41025242d777",
        "7eabe8e1-1fc6-4fe6-b1db-ae07db8e102d",
        "5b8bb393-8e23-4881-9146-9629cbd52118",
        "88e05080-c7f2-4276-9c46-15223d91a872",
        "eba2b2bb-424e-4394-a3cd-c5d3abfb1c6e",
        "a01f50fc-ba68-4200-ac84-7c1f64ad32d6",
        "e31a9e72-26b3-4c16-abe1-e5987de54d41",
        "b88a04c2-a179-4f31-afc0-5a205f110c8b",
        "bf714821-0858-43df-9ebd-fd4da4ba8862",
        "0cde7c07-408c-4511-95f5-ee8a94671481",
        "cb6d2b31-16b4-4929-b10a-e6e91fcbde70",
        "91553f32-2804-40a4-bba7-415def469ab2",
        "4dd39641-4f7e-4551-9770-e695e6a4f533",
        "107b187b-856a-4a48-974d-2d7862241c02",
        "2f575aec-bfb5-42d6-b182-f4e89d1883d2",
        "831fe6a2-d889-48b9-95a4-78a476f2c533",
        "4ff5838b-7f23-4161-b53d-000c35a8dc69",
        "eacbc315-de53-4515-b85f-d7e9e7641e57",
        "4cb86965-2af5-401a-a7ea-7916d74680a2",
        "58096eba-7bce-42e2-bfe7-0305991c7f7f",
        "31696358-7f5e-4960-be40-9f8a9a1cdc51",
        "7929a04f-a161-4370-b26b-d7f03a234cca",
        "36aa1403-74e3-4504-83e9-cf817804b3d1",
        "a13d6b4d-d155-4c9e-8178-0b38c3b5aea5",
        "4a139570-fd3e-4107-b7a4-f6ac57f7acfb",
        "90af7cd6-eeed-43b4-8778-4df39a2440a7",
        "5ea35beb-7b27-43aa-af59-df54fde74d78",
        "7fda0bc7-2473-4649-b68f-0f39da57e489",
        "fe8dbf1e-199d-4f24-9c72-22e54ab2f274",
        "a32c855c-068a-4a78-a751-d1d9dc1d10b0",
        "3b4740ae-9d8c-46b8-bd4b-5afaf07a89f7",
        "be9c341b-07c2-4ca1-8839-f10c6b0a096e",
        "89c6a7fb-6df6-4524-88d2-12eddff00bf1",
        "1d289d56-afd5-4a07-81e5-870b88672c97",
        "fd826100-b3e3-4637-bcda-65cc52871ac3",
        "dda28dbb-2c31-4ad8-89b0-7350dfc8fdd6",
        "a7d205eb-7342-4aaa-902a-84cf31fd813b",
        "450c35c7-99e6-4b13-a044-46810bf869da",
        "411120b4-104b-4a03-ae40-651ddabc5851",
        "67de99ef-6a1e-4c6f-9675-6e2876328c65",
        "b1d84ee1-2ccb-443d-9a40-88ae6c6ff1fa",
        "e96fc9f6-7521-46a0-b578-e6d263b8b8dc",
        "3ced04e5-5052-4841-b7c4-a5076878ad09",
        "71162a88-545e-4525-95c5-5559492dc515",
        "c1ab91d8-cecb-4939-9c04-42d4e523ee31",
        "cee604b5-48d2-42f6-b94f-ae70f7a2a211",
        "7a53eb6d-a4fd-4677-83f9-79b9773a3a93",
        "68eccbab-d86a-4dd9-8000-b2534c4658d4",
        "53726046-3b19-4da5-a9fa-fc05efbfdd43",
        "4e0241ce-96fa-4ccf-b806-dbb5c15c2648",
        "fb1658fa-ef2a-4a19-af6d-d271e1b1a95b",
        "d75ac0c8-8151-427a-aedf-6057bba89d06",
        "2fe9531f-48ed-4f61-8539-e7acbca32c32",
        "c738cebe-11d1-4f08-a921-29753cd14524",
        "1291f9f8-bdbe-4c71-898c-e6252815f4af",
        "27dde5dd-c88e-4ec5-9e16-948fec1c933c",
        "43563649-b5bc-4ba7-a67a-5714a3a31857",
        "12440ac0-2ed2-4880-8d18-840bb81f07a0",
        "eae49aca-86ca-4c29-aecf-dd3fcb7a4bca",
        "0a646de9-a479-41da-a411-1dabbc542924",
        "a9eee6e7-8a05-4d7b-b984-ff5d28c0f4f7",
        "ec0da5cb-252a-4db5-ae38-0988ff13960d",
        "ccf30676-7819-45a7-a61b-ac2777fd8b2a",
        "482d510a-0838-4c3b-8f15-f1ab409bfb8a",
        "d7e82540-fb00-4031-a46b-8b2769a7439b",
        "d7e82540-fb00-4031-a46b-8b2769a7439b",
        "c1ddbe09-e1de-4c96-b038-d6063d73f6a6",
        "04c78215-96b7-4646-b660-d350c1352b59",
        "400bbc56-bd06-46f4-bff9-d7d8b794818d",
        "9cd2e0c4-9bac-410e-8095-3405d446f181",
        "0a66b29b-9099-42d0-b3c2-3636715742c5",
        "01cf8320-eee0-4adc-b34b-db8035fb2f23",
        "4dc27090-230d-40e9-8bfa-09919637f508",
        "f5506f52-7bab-4f94-8359-dc10a15d7f53",
        "09833c49-1d45-4403-bd10-cb254f2b681a",
        "39973e1a-0097-49e9-97f4-ea84ee89f625",
        "4e430d8c-a778-4896-b664-fa740df34870",
        "7b86e70a-c8e0-46c6-a810-cbd9ba580e8c",
        "1c078902-0b6f-491b-915e-98270fd8ad2e",
        "156ef5fc-0a30-4ef4-8102-2a8685c9053c",
        "54dd16bd-f6d6-48dc-a81b-bc46e1b0d7a9",
        "cbe854c6-64cf-4974-af90-10a153fc1c9e",
        "a88cb15d-add9-441e-921a-0893a38b0306",
        "9717c469-8b99-4055-a99c-2de54b5fb077",
        "ba1e47f3-080a-4397-b0d4-9de9aa6e286d",
        "5d6463bd-e275-4ac8-a264-0f3830179d58",
        "ae932b1e-5a9d-4630-950f-9406443f319e",
        "19b6e3d9-73bb-4a56-b19f-d329efb8db27",
        "b188ff00-7cfb-48d3-a7dc-aa4b07bbb23e",
        "0548ce19-977b-44e9-bcc1-04d7e31e3a35",
        "bde5410b-b6ce-400c-bffd-c726b5c86bf8",
        "f6c5b3b5-e6fb-4d85-abcd-f70249743051",
        "4cb71cef-b291-4c24-ac56-ada87454df18",
        "4380ca0a-41e4-4eea-8559-a3c87451fc0b",
        "9740e82a-f547-446a-9bb7-546190d60cf9",
        "8811e88d-82e4-4a69-8f65-7616bc02e30f",
        "dca13098-40b1-4a70-bdc4-8178f97efdac",
        "29db7c59-02c8-4f5b-bf88-81690db38f9d",
        "72b62530-e3fb-44b9-b538-9b57826f9033",
        "79731d7a-8dfe-449b-89dc-8bce3a166bb2",
        "b621bdaf-3e6f-47a8-accc-2792b43d2a0a",
        "24550369-09cb-4daf-b06b-075797f303fa",
        "5968a146-617d-44ff-8dbf-1cf722c78810",
        "79f78d07-0078-400b-860b-1be805c641f2",
        "c738cebe-11d1-4f08-a921-29753cd14524",
        "609c1ae3-78ad-4bf1-9d10-2ef50f462c66",
        "5bb29d09-fbca-42d6-b3cc-90c03e2a35bb",
        "14cdf152-2c38-430e-b90b-1d5775227c7c",
        "c735b818-c189-4e31-906a-041e45f9207b",
        "82f9fd0f-bf5f-4990-8a13-e7ab49d235bf",
        "3d0fb13b-b10f-4129-b454-88949aad8a0c",
        "7cf29a0e-3f28-4c5d-b2e4-b1fc31ba3610",
        "a5b35da6-7b6a-4edf-9315-5ac041e95dbf",
        "45e9333b-2d61-4c2b-809b-0a437783bd39",
        "a99d6e45-f2d7-4c19-8b6d-21bfc447733e",
        "e1abb39c-534d-41ab-a032-6c7fb83537f0",
        "1497b168-3acf-45e8-8138-924f2aae5323",
        "21e54fed-15e7-4376-95d4-b27c2b890a48",
        "5de424c5-a2d3-4323-8e45-3afed6031ea0",
        "d49c7acf-7940-4a00-95f5-1c71b6bf88a6",
        "6445b58c-a773-4107-a784-1e4676db67a4",
        "4052f169-dd13-4cf6-8cec-c5c8a7795cd4",
        "67fde8b9-23f3-480c-ace8-2c35453d646e",
        "e69a1942-bae7-48f9-abbc-9ae88ca1ed05",
        "ef4d4280-7257-48b9-b451-332201646df3",
        "5dc21757-28e8-4ddc-bfa1-220af7195cbc",
        "8e6896d5-5d97-4428-a3a2-0b05ba52e145",
        "c180b859-2e11-42b0-b315-8fdde54036d1",
        "8295f947-0739-4983-86c8-d1e46d7b7025",
        "ad6f1026-d2cb-4ae0-9eef-f96e1a8e8cda",
        "31b7820d-ba75-42ff-b892-5777f0cc8756",
        "dd182e43-c0d3-4b82-8bfb-229188e56c1d",
        "2eb83174-d0cb-482b-9dd8-02d0655e9dbb",
        "24b300e1-ab2b-4c9d-8fe4-581d83669f9c",
        "1ef3fa57-0b74-490f-941e-8061653e7892",
        "9e4516a4-a8ec-44f9-8ace-ade816e787a9",
        "775253c9-4413-4bea-aa63-84894ac1b033",
        "6fefb891-9794-42eb-a78e-cfc1151f021a",
        "d64271f8-6d58-44b1-835b-3fea207c40ab",
        "d0a9f2a2-2797-4de4-bedf-5a27e7cb1558",
        "ace69ad2-acfc-4ff8-b116-e8718d7eee6f",
        "f61db174-8227-4458-9b2c-3da9b6dcb6d8",
        "a20de517-6c50-434e-8c26-7fbf8cb8a676",
        "215c7ae6-8c3d-433d-bf83-62f66699d32f",
        "7f132245-7e81-4d92-a579-ca59643c0243",
        "db32530f-50db-4959-a665-1f9850953197",
        "a7cbe2cb-7b1a-4b41-8f83-87885b99adfe",
        "c5dea984-c735-4f83-a757-e97741de0364",
        "8d4d37d1-18f5-48e1-91aa-d059cf690a73",
        "9c5b71d8-99d8-4610-b2c7-ab0acc4cc6db",
        "bb380440-7c9f-4333-82a2-56942eb78a17",
        "12cb133c-bd66-43d6-9817-edd9dbb533b2",
        "f0b285d9-3a56-42f2-905a-eccf414a9056",
        "cd3ef91e-239f-4c76-913f-84ab196b1e7b",
        "53a5daa1-a9ed-40f2-8b63-dea6fa7d7922",
        "4b69b460-c90f-4f2c-a7e1-2f79d7a105bd",
        "bbe78414-0e9a-4435-a2ca-c3f28357028f",
        "c56d3915-88f5-4071-b9c4-28cd685f7918",
        "c32e7f5b-02d5-4721-b174-6ee5647bc3b8",
        "8256bebd-7208-4345-8b66-42961ad7445a",
        "77f1bd1c-ac85-4ef1-a83e-c6c2514c97f2",
        "65432332-eab3-40b2-b1c3-59dcdd13a2a2",
        "56a0aff9-dc12-4c70-8a79-2bc9229250fe",
        "943a5261-8a60-458e-867c-16d5d611c73d",
        "8bc7913c-974d-497d-ac5c-70e246ea8614",
        "8bc7913c-974d-497d-ac5c-70e246ea8614",
        "9f4e1be7-0698-4397-ba7a-0cd221e1ec3b",
        "5019ba2e-92a3-41ee-9131-0d7e53623127",
        "3d5ac487-fb0f-4cea-b245-c44905fc5f43",
        "b4335777-3393-4e63-bbe0-2ab9a93e92c6",
        "f57ff41e-31b3-475e-8ed4-7ff374d847fa",
        "fce2024c-620f-42b6-b54c-a97a812d8901",
        "00cf3bad-921a-4802-82fe-a51cf4b7bf99",
        "b564ddd8-b104-4f52-92be-c79d5e065eb0",
        "9f8ec50c-4942-48a3-82bb-84c09787ab6f",
        "7015aa98-5102-44ad-9ff8-04779c417a58",
        "e9b55a88-43e2-4580-b2ac-51d985709e2c",
        "2262b53b-d2e2-4341-8773-6a1b668e9fff",
        "24c3869d-08c4-4744-9b31-f33486511e1f",
        "dcca9bbe-d43a-47a8-8ba9-9953c0fce369",
        "a2d571c8-deda-4432-8586-1fd663028316",
        "9a8d4a60-9fa4-43cf-8d40-14ab2758db41",
        "cf5370ae-5e72-4e86-83b5-ebc3b2e95bc3",
        "89e2374f-98a2-476c-8d0a-cbe43238e63f",
        "24ff08a6-f4bf-432f-8946-ef031500091c",
        "962e10d7-c6f1-4940-b3fa-713c2483845f",
        "86c9f997-9511-44c4-8d21-3aa9df03a869",
        "bc0520f6-35e9-43d6-b68b-c895e6274dbf",
        "20e7c337-40fe-4313-a0b9-e3ce9523234f",
        "eb2609ae-b125-40a9-b14b-a25596ec574a",
        "76f8f848-3e2c-47e6-a913-1220c36a72af",
        "4498c809-36d1-485f-9368-87568d9e0510",
        "d455d018-cbf1-4a19-9b20-dff9c7326b03",
        "5fdb4df3-316b-4137-8820-31c10ae00c7f",
        "3df3a4d6-1027-4d85-9222-a557aaf780c6",
        "3ab10afe-1a71-411d-b680-4f749113178c",
        "c68ead7c-b288-46b5-aa04-3bdadafd4d1b",
        "a573e634-9e77-43d4-be42-235ab50196a4"
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