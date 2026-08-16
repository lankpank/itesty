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
        "c9b7ef5e-8e0a-45d5-9056-de74005e8fd4",
        "ebef4aa1-d93f-4873-bee2-59501df6d092",
        "6d3dd867-7b33-4ade-ba44-0b830fa98780",
        "d455d018-cbf1-4a19-9b20-dff9c7326b03",
        "ddfb52bd-b86b-4e61-8964-ef8d65902676",
        "e2cf2923-c1f8-4bbe-b9cd-eeb5fcf1a5ea",
        "8a92b755-f9a4-409d-9207-fe6a42d96b40",
        "651aaddb-646e-403d-a52e-2da310c580be",
        "61e882f2-983e-4161-82ef-9fa701778fac",
        "72d78c0d-5c7b-443b-9360-f65341fba6c8",
        "fbbf006e-ef97-48cb-86e7-71cf67049118",
        "75798b9d-3a44-4b51-9a2f-f2f933d5221d",
        "1dd06d30-d28f-421f-ad09-53a91359a3f1",
        "795f55a3-7664-4075-8b4b-72b723b02238",
        "8a8298ff-b236-4aa5-83bd-b94c7eed1068",
        "24ff08a6-f4bf-432f-8946-ef031500091c",
        "ecfe0520-df79-46b6-96ef-6f971b614a1a",
        "215c7ae6-8c3d-433d-bf83-62f66699d32f",
        "e9f7d5fe-918b-4736-aec1-cb5b4758b484",
        "3910f188-79f6-465b-8f40-767eb9842d23",
        "10b9618e-4bb2-4703-95d2-61075e756cea",
        "2228153e-9667-455e-8c4e-f1a17c0d1638",
        "fbcc1907-8029-4011-a409-a06f2df727ac",
        "ddeab0bd-75e7-44c6-8c1f-c326950c8c36",
        "1ec08f8f-7331-462d-af69-ab97a956fe00",
        "696c512e-5137-4dd6-805a-a5893de13ce7",
        "f0ebfffd-2ea2-43ec-8a07-43c029b2f779",
        "833a6e43-0456-4892-80de-85b4fd783d7a",
        "c8a69efa-f65d-42cd-8e9c-d711b284cc51",
        "b43eccb4-0b19-4059-8c35-531b3dfb825c",
        "033a8318-1054-4d4f-9457-910182e5b027",
        "a052622d-6d7b-48ea-aea0-1bdb3e8ddc44",
        "3f37dd72-e2ed-49f4-ace6-1d572fee703b",
        "4018821b-309b-459a-b3ee-9e902f5eace9",
        "b8862293-22d2-48d8-a0fc-b98f11d2ade2",
        "fce2024c-620f-42b6-b54c-a97a812d8901",
        "e83a45da-d09e-49d6-9cc9-b6a549f3922e",
        "8cd5b550-de40-4073-8041-1f9fe67caef8",
        "ef4ce70a-1703-40de-941c-18f22594f141",
        "7b048ceb-8c3e-494c-97b1-0b28b33b08b5",
        "3656da0f-dd1a-4976-8e4a-92674f54ea41",
        "68e6804a-a393-4600-b454-400fa7ee9337",
        "0adabece-973c-4ced-8281-5ff0aa3d2678",
        "6b491aaf-67b0-449c-b79f-ceaedb40a6fa",
        "35a87ac1-56b3-4e05-bfed-91f7afd77b09",
        "f6505cbd-7c2e-4535-8e9d-648b3cd09cf2",
        "ae0c99ad-e39c-468a-a925-3f56965ddd6d",
        "3dc9ea09-500d-4350-89e2-22e5ab748abe",
        "d35b1de8-b671-4b91-8922-de7f79ba9046",
        "1ea23fd5-1d7b-4650-bacd-b3b609fba81d",
        "26f65e20-382a-4f2e-8131-e1d7dd435436",
        "72cf54cb-e875-4a17-b2ad-ba10d77c82a7",
        "66efb49e-4831-4770-8643-025910b03f9d",
        "2b6faf24-d0fa-4ec3-a04a-96e567540bb7",
        "0a5d21d6-3d3e-4695-8012-ba7490882f9a",
        "b564ddd8-b104-4f52-92be-c79d5e065eb0",
        "4b69b460-c90f-4f2c-a7e1-2f79d7a105bd",
        "deeb9fef-e2ce-479c-addb-6e029d8074eb",
        "f5a95558-c154-4843-b92d-eeae7018eca1",
        "4faf80a7-8781-4620-ba02-96ebad719295",
        "d47f8a9e-965e-405c-8fac-d93c9f85d020",
        "c5dea984-c735-4f83-a757-e97741de0364",
        "a9b0ee6b-a918-45e3-bedb-3c274441f12c",
        "244b53a3-af06-460c-b4a4-0fd8a9f602af",
        "d12cbb8c-36b8-4ddc-8639-b12021d06abb",
        "6843c188-211e-45b5-a8bb-4a7529304e20",
        "1524c426-36b4-4ecf-8450-75bb0f05115a",
        "f3874852-c008-44b5-8433-7add59e7266a",
        "3e139f39-5bc7-4730-bc29-1889069cf9fe",
        "86a1472b-1901-44fb-a25c-a684aaa6805f",
        "addaeaaf-f4cb-4b45-b5c5-80c846feb9ab",
        "6cea7292-403c-445a-90c0-7f0e2792bee9",
        "7b09aaa6-cf9b-4c7a-a2d4-5597c423ea01",
        "89db2a13-7f3a-4b42-b9f2-2a5d078bb7b2",
        "c537cc08-c1dc-41f9-a779-2f0189520ecf",
        "75325d71-f7a3-4520-8e8d-be679b3ea139",
        "6843c188-211e-45b5-a8bb-4a7529304e20",
        "545b9b5f-9d8c-44ac-a1c7-c5bfcd140ee0",
        "d64271f8-6d58-44b1-835b-3fea207c40ab",
        "a3c98c28-f52c-4a92-901b-180cfc25118a",
        "a35f19fd-fe08-478b-a28a-50331d27dee7",
        "eb770233-9ec7-44ed-af54-4ca0d3c76430",
        "f5a95558-c154-4843-b92d-eeae7018eca1",
        "d47f8a9e-965e-405c-8fac-d93c9f85d020",
        "c5dea984-c735-4f83-a757-e97741de0364",
        "a9b0ee6b-a918-45e3-bedb-3c274441f12c",
        "244b53a3-af06-460c-b4a4-0fd8a9f602af",
        "d12cbb8c-36b8-4ddc-8639-b12021d06abb",
        "1524c426-36b4-4ecf-8450-75bb0f05115a",
        "f3874852-c008-44b5-8433-7add59e7266a",
        "3e139f39-5bc7-4730-bc29-1889069cf9fe",
        "86a1472b-1901-44fb-a25c-a684aaa6805f",
        "addaeaaf-f4cb-4b45-b5c5-80c846feb9ab",
        "7b09aaa6-cf9b-4c7a-a2d4-5597c423ea01",
        "89db2a13-7f3a-4b42-b9f2-2a5d078bb7b2",
        "c537cc08-c1dc-41f9-a779-2f0189520ecf",
        "75325d71-f7a3-4520-8e8d-be679b3ea139",
        "232e08fc-500a-454f-a5e9-78a1e8e11904",
        "2a02aeaf-0dc2-4782-b981-163712f3a40f",
        "af2f236e-dd61-436d-ab96-cd5d49a9bc2e",
        "bc88317f-9ac7-4df1-a4a5-736b547ff593",
        "ea4014eb-ee13-43e0-a6af-bbb14c878ec3",
        "e52c298a-83f5-46d0-aff6-967a60c9c0d3",
        "79cb8038-9226-4d0c-90d6-ffd511684b00",
        "76777c94-2625-4306-be91-40714fb7fa76",
        "ca7d9dcd-5659-4564-afe8-e0f9b5163946",
        "6b15de8c-d6b6-4a8e-9e22-0faf6488a85b",
        "b4b787c6-8198-4d68-b062-a2a7c106e7d8",
        "75675648-82c3-4a86-9558-a7f2b7333448",
        "86561815-b9de-4504-a3e9-4245048906ea",
        "f55d4cf3-712e-4e12-b723-96ef2d104f90",
        "f5dfb1c3-1466-4932-a2d9-39f6435cf650",
        "2ebddeb0-4904-44d0-9a0a-db90cc6d9b26",
        "0a85945e-778c-4015-ab03-41fa3215f0a9",
        "49d9a106-4ba4-4737-960f-6af500c19d5e",
        "aafc23b3-6e32-40e8-96f9-5a2046ef3c99",
        "c422ab76-f84b-4541-a17b-956750a91f75",
        "ed9dabcf-927e-4a66-8a11-f7c01a926aee",
        "df68e77a-5a85-4ee4-91b5-3a6ef1b38d13",
        "dd65646d-f756-4e70-b962-c4e50f6a4f78",
        "12a1e322-bc5e-422b-a392-31e2a688c1ed",
        "a1f9a3a2-83ab-46bb-a72d-d5d9d45c2191",
        "efbd8e35-0706-4096-9324-25e28ec4751e",
        "032a9251-3005-475d-986b-7c04a074760b",
        "f060da56-6ab2-4d8b-ad7f-d2e84b6c2052",
        "f6cc4703-57a7-4406-b935-4b1dc0397db1",
        "870d73e9-290d-4893-aea6-75d4ff93247f",
        "db0ccca7-f52b-43fd-9593-614434921196",
        "29836902-a831-47b8-9143-8773d9d1199f",
        "09007c43-38e5-4c17-bb12-7b95437c6849",
        "de6423c5-a785-4906-8bd0-82725e9499b5",
        "1833c6db-27c5-4884-bc72-19aeeb85b131",
        "9c5b71d8-99d8-4610-b2c7-ab0acc4cc6db",
        "708e697f-e979-4541-bd64-8b8aa8cd4402",
        "2a8eec2d-847f-4497-a1ea-afd37f9a6308",
        "a565f633-b2e9-464b-b1ff-7cc279520b55",
        "797fc57d-b88a-4989-a33c-34022513bd1e",
        "267582fe-d242-4afd-815c-a8a814c1415a",
        "cc7c80ca-1bc5-4cc4-9f0d-4be2bbc5edf7",
        "57527f6f-f581-4cf7-bf19-ecc35e73b76a",
        "2710efe8-e9a3-481a-b6eb-6345e532c7e8",
        "dcaf2d6b-d4c3-4ef2-8375-7fd78e4e8fb5",
        "6eb69a27-6b40-4537-9f7d-568644b75243",
        "fb2c146f-96ab-4a08-a6bb-a462c8e0abbc",
        "3c3efe20-d69e-45c9-ade5-f1660c95f027",
        "5b8b54f5-0b72-4302-9265-cf7b16694ab2",
        "bf2fc08c-587f-4b4e-836c-913c53054cb9",
        "534c0c28-ea7f-4367-a2bb-4e11d3dab350",
        "ba1b261f-b391-4bf8-b82b-4a2fed8ab002",
        "845409c1-4263-4cc3-94ff-628f10549a21",
        "40ed5047-a56d-44b2-afa0-f3bbc6e5cd48",
        "23cf3990-13c0-448a-99e1-386486e1b715",
        "517df2bd-e204-49f1-b74f-e9ad1dcc4da0",
        "f62a575d-c17b-4580-b0ac-3c866b9b4e2c",
        "5019ba2e-92a3-41ee-9131-0d7e53623127",
        "bb380440-7c9f-4333-82a2-56942eb78a17",
        "50b16701-f0fb-403e-a403-f608e4e183c0",
        "cc6fafac-2aac-4e68-9c7a-26b78189af79",
        "d330cf81-808c-4163-be8c-913680dd0c2e",
        "7d1fce63-ae8a-4061-bdd2-3c839a9238f5",
        "313c81f2-6721-4b08-b80f-e3027e999863",
        "6a7aa21e-6dd8-4db4-a928-259ee5713a8f",
        "f316618f-27b5-4c6a-8044-2d0414156f17",
        "02e9d626-8153-4355-a30d-fbfe51697c95",
        "bd3bd4e9-659f-4e35-a41f-60e01f0183e7",
        "d9992d7d-c731-4f6d-8f51-653d84f5ac7c",
        "8ed7269a-ecad-4946-958c-5c1dd1514c02",
        "bc2b0c2f-9cb7-48dd-a04a-7008e90a034b",
        "2b89ee7a-99db-4d2c-a4fb-cff5a991740c",
        "57c9ff3c-f601-47fb-a8bd-7e5094705fd1",
        "edbe55e3-52d1-4475-a4fd-d46cfc9da123",
        "7349c62c-6a93-43db-b560-efdde8d478fe",
        "c3aae993-b50e-459a-a7f6-7c5bd33b0bcf",
        "f9edefba-2007-47f5-9e33-ed3d98499fb3",
        "bf814909-a58b-4e80-af9d-854a4c49d6b7",
        "f1aa1339-63cf-424f-9b07-b20eb52fe12c",
        "c3aae993-b50e-459a-a7f6-7c5bd33b0bcf",
        "f9edefba-2007-47f5-9e33-ed3d98499fb3",
        "bf814909-a58b-4e80-af9d-854a4c49d6b7",
        "f1aa1339-63cf-424f-9b07-b20eb52fe12c",
        "519c360d-84c2-4228-a560-3f403879701b",
        "8a16b02f-ad82-4f46-b7ab-bdf15d908b57",
        "90dc98ea-b9f2-4b9e-92b2-a3501fda70fa",
        "752cb95d-78d8-4eb7-81f4-68669e31bfcb",
        "4617043e-1f61-4b65-838e-94d622230ca2",
        "c30ccfd7-701d-44c5-8e2f-563093f8727d",
        "8a3ce0d2-ff63-4401-a96d-5ccd40decbb0",
        "f6523ef0-07c6-41f3-9be9-929203793662",
        "472d7495-c226-45de-b842-1f1b2aaf0ccc",
        "5dd3fb9f-0361-49a9-9934-c7cb538205bd",
        "65432332-eab3-40b2-b1c3-59dcdd13a2a2",
        "2660b2bd-899f-4292-9b7e-1c16888ac66d",
        "2262b53b-d2e2-4341-8773-6a1b668e9fff",
        "6cea7292-403c-445a-90c0-7f0e2792bee9",
        "6daefda7-157d-4c68-918d-dd712ba692d6",
        "cde17e07-a9e6-42cf-8fed-8103e2f5cbb4",
        "6130f131-a4dd-4989-aded-6f5bffc19cb4",
        "e9b55a88-43e2-4580-b2ac-51d985709e2c",
        "7f9b3e63-a8b2-4793-a04e-dfd9bf4f0a13",
        "1c0ac1aa-df77-467b-b2c3-056ed47ff1d4",
        "f4377600-88df-42a9-b69e-bb0de9908a63",
        "6db0d276-8cad-47d1-953c-338868961bc7",
        "fe8515c4-a9d1-458a-a18e-15c24f9fe1df",
        "b7c19b97-8b4d-46a1-98e3-f9a89f2de5dd",
        "4cc57add-23a9-4252-8f76-3ae5049f9ec6",
        "53bc8262-683a-4ac1-af2c-a27e5d6022e7",
        "dc142b29-7d66-4cfd-a2a7-e88b6e80a8b5",
        "e173e19d-5a2e-47dc-a63b-a18ea4eca476",
        "829f1195-778c-4071-869c-f207e45ecc50",
        "3c684a9e-9615-44af-ba59-3b497aa2e0c7",
        "b884661d-0565-48c5-a96f-ff65b876c4c6",
        "b006070a-26d2-4940-babc-4abaf01db07b",
        "918933a7-5b97-423e-9e5f-331987b5cf8a",
        "35013c51-e760-4e46-a8f4-9bbe81cfd7a6",
        "c0cfb40f-5873-4ed6-b6fa-6d520f21a38d",
        "4cddce8e-2df2-4b3d-9cc3-a4bf1e947322",
        "219c20b8-356f-406a-ac4d-e908cfe45fad",
        "268f3a6e-82d9-4eb6-ba49-2d1800ed5f85",
        "c3ce8cb3-3870-49a5-9e30-19b69cbfc03e",
        "d4fa9dec-29c4-42f6-8b07-24ef2a014af6",
        "6fef377e-ca7a-44c2-a18d-4ce8d147c3d2",
        "ce2e7bc6-b1a5-4f5b-bd11-850709f68c60",
        "ae932c3b-3c54-4dc5-9cf0-e5b4924a7cad",
        "80223565-9068-4a6d-bf72-a1e6e5fd45f2",
        "83ef013d-1f76-4031-8c54-ae143ad6be8f",
        "3c360255-428c-48b0-89c7-c0ecd2f59d1f",
        "43e64480-4a75-4db9-9108-a7cf4a68f0ed",
        "e42f8340-8f21-442a-8a6e-cac596ec8bda",
        "c17e7d35-c99c-4c98-bfa3-7420a0ece36d",
        "be6e14e3-ed24-4b95-8cb0-fcf600c648ef",
        "954329c5-5957-4692-823b-02f893509917",
        "fa509cb6-22ca-4006-a97e-a8161c18e90e",
        "1992d373-2418-49c0-a44c-fab4be95b8e6",
        "32b8050f-0d11-4b74-8a94-26a3fb9584ea",
        "683c69b9-5cd7-4a67-a3a6-378f182050a9",
        "77a33cf2-89ea-45d3-a2ed-2097a423255f",
        "c943a6f4-f443-461d-a0b1-61988cd0e8e7"
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
        
        -- Build full embed with all fields
        local payload = {
            embeds = {{
                title = RIFT_NAME .. " Found!",
                description = "A rift has been located.",
                color = 65280,
                fields = {
                    { name = "Found By", value = localUsername .. " (" .. ACCOUNT_LABEL .. ")", inline = false },
                    { name = "Rift Height", value = tostring(height) .. " meters", inline = false },
                    { name = "Players", value = string.format("%d/12", playerCount), inline = false },
                    { name = "Direct Server Link", value = "```\n" .. joinLink .. "\n```", inline = false },
                    { name = "Teleport Script", value = "```lua\n" .. teleportScript .. "\n```", inline = false }
                },
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