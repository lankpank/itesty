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
        "ba1b261f-b391-4bf8-b82b-4a2fed8ab002",
        "b8862293-22d2-48d8-a0fc-b98f11d2ade2",
        "9ea3e6f7-dcb6-4712-808e-591b94c401e9",
        "119f9ac9-52fd-4c64-b3be-016b58fe082f",
        "6d093fa9-643e-481f-9dd8-0e6c71b71500",
        "d32c17cf-abac-41bd-b8ab-11f839ad2d72",
        "af2f236e-dd61-436d-ab96-cd5d49a9bc2e",
        "09007c43-38e5-4c17-bb12-7b95437c6849",
        "db0ccca7-f52b-43fd-9593-614434921196",
        "0a5d21d6-3d3e-4695-8012-ba7490882f9a",
        "e3156f8e-c807-4f1d-b31e-f1c74030fe4b",
        "75798b9d-3a44-4b51-9a2f-f2f933d5221d",
        "daaa42d7-c147-4b2f-85ea-7e51a2866c56",
        "abda56c2-0a30-4ac9-9c27-c054549de668",
        "c35f577c-21dd-47ab-9376-7b4030920d9c",
        "75325d71-f7a3-4520-8e8d-be679b3ea139",
        "e2cf2923-c1f8-4bbe-b9cd-eeb5fcf1a5ea",
        "805bb54d-590c-489e-8c5a-ba68dcfaa566",
        "032ac3dd-f91f-4934-ac9c-c4d0569b8331",
        "a565f633-b2e9-464b-b1ff-7cc279520b55",
        "244b53a3-af06-460c-b4a4-0fd8a9f602af",
        "dcca9bbe-d43a-47a8-8ba9-9953c0fce369",
        "72d78c0d-5c7b-443b-9360-f65341fba6c8",
        "219c20b8-356f-406a-ac4d-e908cfe45fad",
        "66efb49e-4831-4770-8643-025910b03f9d",
        "99737309-c7aa-4ef5-988c-a101b2cdbb9b",
        "1833c6db-27c5-4884-bc72-19aeeb85b131",
        "02e9d626-8153-4355-a30d-fbfe51697c95",
        "519c360d-84c2-4228-a560-3f403879701b",
        "fbbf006e-ef97-48cb-86e7-71cf67049118",
        "c537cc08-c1dc-41f9-a779-2f0189520ecf",
        "6fef377e-ca7a-44c2-a18d-4ce8d147c3d2",
        "267582fe-d242-4afd-815c-a8a814c1415a",
        "a35f19fd-fe08-478b-a28a-50331d27dee7",
        "d64271f8-6d58-44b1-835b-3fea207c40ab",
        "e52c298a-83f5-46d0-aff6-967a60c9c0d3",
        "addaeaaf-f4cb-4b45-b5c5-80c846feb9ab",
        "b774064f-29bf-406b-bd16-33101990dc29",
        "ebef4aa1-d93f-4873-bee2-59501df6d092",
        "ddfb52bd-b86b-4e61-8964-ef8d65902676",
        "ca7d9dcd-5659-4564-afe8-e0f9b5163946",
        "2a02aeaf-0dc2-4782-b981-163712f3a40f",
        "86561815-b9de-4504-a3e9-4245048906ea",
        "b884661d-0565-48c5-a96f-ff65b876c4c6",
        "a9b0ee6b-a918-45e3-bedb-3c274441f12c",
        "5b8b54f5-0b72-4302-9265-cf7b16694ab2",
        "fe8515c4-a9d1-458a-a18e-15c24f9fe1df",
        "f4377600-88df-42a9-b69e-bb0de9908a63",
        "29836902-a831-47b8-9143-8773d9d1199f",
        "b564ddd8-b104-4f52-92be-c79d5e065eb0",
        "a1f9a3a2-83ab-46bb-a72d-d5d9d45c2191",
        "60b5fa4b-fdc5-4a6b-980a-33176098d254",
        "fb2c146f-96ab-4a08-a6bb-a462c8e0abbc",
        "cc6fafac-2aac-4e68-9c7a-26b78189af79",
        "f55d4cf3-712e-4e12-b723-96ef2d104f90",
        "f3874852-c008-44b5-8433-7add59e7266a",
        "90dc98ea-b9f2-4b9e-92b2-a3501fda70fa",
        "10b9618e-4bb2-4703-95d2-61075e756cea",
        "ae0c99ad-e39c-468a-a925-3f56965ddd6d",
        "c3aae993-b50e-459a-a7f6-7c5bd33b0bcf",
        "3df3a4d6-1027-4d85-9222-a557aaf780c6",
        "49d9a106-4ba4-4737-960f-6af500c19d5e",
        "f316618f-27b5-4c6a-8044-2d0414156f17",
        "bf814909-a58b-4e80-af9d-854a4c49d6b7",
        "4ec1f05b-63ba-46ad-b0d0-13a78df76a69",
        "833a6e43-0456-4892-80de-85b4fd783d7a",
        "8761c924-759d-4383-b9e4-275830e9bee7",
        "472d7495-c226-45de-b842-1f1b2aaf0ccc",
        "4faf80a7-8781-4620-ba02-96ebad719295",
        "bd3bd4e9-659f-4e35-a41f-60e01f0183e7",
        "2b6faf24-d0fa-4ec3-a04a-96e567540bb7",
        "f9edefba-2007-47f5-9e33-ed3d98499fb3",
        "dcca9bbe-d43a-47a8-8ba9-9953c0fce369",
        "4b69b460-c90f-4f2c-a7e1-2f79d7a105bd",
        "6a7aa21e-6dd8-4db4-a928-259ee5713a8f",
        "c943a6f4-f443-461d-a0b1-61988cd0e8e7",
        "8a16b02f-ad82-4f46-b7ab-bdf15d908b57",
        "c3ce8cb3-3870-49a5-9e30-19b69cbfc03e",
        "edbe55e3-52d1-4475-a4fd-d46cfc9da123",
        "ae0c99ad-e39c-468a-a925-3f56965ddd6d",
        "c3aae993-b50e-459a-a7f6-7c5bd33b0bcf",
        "3df3a4d6-1027-4d85-9222-a557aaf780c6",
        "f316618f-27b5-4c6a-8044-2d0414156f17",
        "bf814909-a58b-4e80-af9d-854a4c49d6b7",
        "4ec1f05b-63ba-46ad-b0d0-13a78df76a69",
        "833a6e43-0456-4892-80de-85b4fd783d7a",
        "8761c924-759d-4383-b9e4-275830e9bee7",
        "472d7495-c226-45de-b842-1f1b2aaf0ccc",
        "4faf80a7-8781-4620-ba02-96ebad719295",
        "bd3bd4e9-659f-4e35-a41f-60e01f0183e7",
        "2b6faf24-d0fa-4ec3-a04a-96e567540bb7",
        "ddeab0bd-75e7-44c6-8c1f-c326950c8c36",
        "f0ebfffd-2ea2-43ec-8a07-43c029b2f779",
        "cf5370ae-5e72-4e86-83b5-ebc3b2e95bc3",
        "5369b82b-67f4-442d-a651-e175aa6b2bec",
        "68e6804a-a393-4600-b454-400fa7ee9337",
        "dc142b29-7d66-4cfd-a2a7-e88b6e80a8b5",
        "534c0c28-ea7f-4367-a2bb-4e11d3dab350",
        "2ebddeb0-4904-44d0-9a0a-db90cc6d9b26",
        "708e697f-e979-4541-bd64-8b8aa8cd4402",
        "fbcc1907-8029-4011-a409-a06f2df727ac",
        "292fe893-ffc6-4e30-80b9-7eed7c256c14",
        "5dd3fb9f-0361-49a9-9934-c7cb538205bd",
        "ef4ce70a-1703-40de-941c-18f22594f141",
        "6e1d9873-053f-4c77-acb2-9886f84eb221",
        "f1aa1339-63cf-424f-9b07-b20eb52fe12c",
        "8a8298ff-b236-4aa5-83bd-b94c7eed1068",
        "ea4014eb-ee13-43e0-a6af-bbb14c878ec3",
        "e173e19d-5a2e-47dc-a63b-a18ea4eca476",
        "00cf3bad-921a-4802-82fe-a51cf4b7bf99",
        "f7a4bdba-bf6d-478c-bbc6-d83c4a8fc20a",
        "f6523ef0-07c6-41f3-9be9-929203793662",
        "7b048ceb-8c3e-494c-97b1-0b28b33b08b5",
        "f5a95558-c154-4843-b92d-eeae7018eca1",
        "d055e564-d786-4c11-8bb0-b811c4569d8e",
        "a7e1e599-dabe-487f-b258-5f3938c05574",
        "5be46351-4a03-474f-9d64-9a6599f2f826",
        "eb770233-9ec7-44ed-af54-4ca0d3c76430",
        "4617043e-1f61-4b65-838e-94d622230ca2",
        "0a85945e-778c-4015-ab03-41fa3215f0a9",
        "1aca2134-69f2-4259-8430-2c205f11b32e",
        "26f65e20-382a-4f2e-8131-e1d7dd435436",
        "b43eccb4-0b19-4059-8c35-531b3dfb825c",
        "c0cfb40f-5873-4ed6-b6fa-6d520f21a38d",
        "8cd5b550-de40-4073-8041-1f9fe67caef8",
        "8a3ce0d2-ff63-4401-a96d-5ccd40decbb0",
        "215c7ae6-8c3d-433d-bf83-62f66699d32f",
        "3910f188-79f6-465b-8f40-767eb9842d23",
        "07b86222-128a-4df3-af2d-493a38370b8e",
        "c30ccfd7-701d-44c5-8e2f-563093f8727d",
        "bf2fc08c-587f-4b4e-836c-913c53054cb9",
        "7d1fce63-ae8a-4061-bdd2-3c839a9238f5",
        "4cddce8e-2df2-4b3d-9cc3-a4bf1e947322",
        "545b9b5f-9d8c-44ac-a1c7-c5bfcd140ee0",
        "89db2a13-7f3a-4b42-b9f2-2a5d078bb7b2",
        "6130f131-a4dd-4989-aded-6f5bffc19cb4",
        "6cea7292-403c-445a-90c0-7f0e2792bee9",
        "1ddf8fda-b757-4ed4-b0c0-80450fd30acd",
        "752cb95d-78d8-4eb7-81f4-68669e31bfcb",
        "fce2024c-620f-42b6-b54c-a97a812d8901",
        "86a1472b-1901-44fb-a25c-a684aaa6805f",
        "7f9b3e63-a8b2-4793-a04e-dfd9bf4f0a13",
        "1ec08f8f-7331-462d-af69-ab97a956fe00",
        "63d7517b-259a-4e64-a8df-17191bd08efe",
        "79cb8038-9226-4d0c-90d6-ffd511684b00",
        "1ea23fd5-1d7b-4650-bacd-b3b609fba81d",
        "918933a7-5b97-423e-9e5f-331987b5cf8a",
        "61ca5bf0-e3d8-4a32-aad6-2abd492f200c",
        "83ef013d-1f76-4031-8c54-ae143ad6be8f",
        "0adabece-973c-4ced-8281-5ff0aa3d2678",
        "1524c426-36b4-4ecf-8450-75bb0f05115a",
        "ed9dabcf-927e-4a66-8a11-f7c01a926aee",
        "bc88317f-9ac7-4df1-a4a5-736b547ff593",
        "6eb69a27-6b40-4537-9f7d-568644b75243",
        "efbd8e35-0706-4096-9324-25e28ec4751e",
        "032a9251-3005-475d-986b-7c04a074760b",
        "75675648-82c3-4a86-9558-a7f2b7333448",
        "40ed5047-a56d-44b2-afa0-f3bbc6e5cd48",
        "dd65646d-f756-4e70-b962-c4e50f6a4f78",
        "f060da56-6ab2-4d8b-ad7f-d2e84b6c2052",
        "1fc74a5f-e218-4f2c-a745-c80fd23da8c6",
        "870d73e9-290d-4893-aea6-75d4ff93247f",
        "1c0ac1aa-df77-467b-b2c3-056ed47ff1d4",
        "a3c98c28-f52c-4a92-901b-180cfc25118a",
        "ae932c3b-3c54-4dc5-9cf0-e5b4924a7cad",
        "de6423c5-a785-4906-8bd0-82725e9499b5",
        "2262b53b-d2e2-4341-8773-6a1b668e9fff",
        "696c512e-5137-4dd6-805a-a5893de13ce7",
        "d455d018-cbf1-4a19-9b20-dff9c7326b03",
        "c17e7d35-c99c-4c98-bfa3-7420a0ece36d",
        "eed70e15-05b4-4fa6-830c-1387c03c1552",
        "1dd06d30-d28f-421f-ad09-53a91359a3f1",
        "57c9ff3c-f601-47fb-a8bd-7e5094705fd1",
        "c8a69efa-f65d-42cd-8e9c-d711b284cc51",
        "7b09aaa6-cf9b-4c7a-a2d4-5597c423ea01",
        "3e139f39-5bc7-4730-bc29-1889069cf9fe",
        "cd557402-6814-4ab6-b590-4546455a2116",
        "a052622d-6d7b-48ea-aea0-1bdb3e8ddc44",
        "57527f6f-f581-4cf7-bf19-ecc35e73b76a",
        "cc7c80ca-1bc5-4cc4-9f0d-4be2bbc5edf7",
        "4cc57add-23a9-4252-8f76-3ae5049f9ec6",
        "24ff08a6-f4bf-432f-8946-ef031500091c",
        "20e7c337-40fe-4313-a0b9-e3ce9523234f",
        "cde17e07-a9e6-42cf-8fed-8103e2f5cbb4",
        "797fc57d-b88a-4989-a33c-34022513bd1e",
        "e83a45da-d09e-49d6-9cc9-b6a549f3922e",
        "470b52ed-682f-401c-a69d-a9295d674732",
        "dd551475-d4ef-4203-bf16-8d1104c0feaa",
        "e9f7d5fe-918b-4736-aec1-cb5b4758b484",
        "5019ba2e-92a3-41ee-9131-0d7e53623127",
        "2660b2bd-899f-4292-9b7e-1c16888ac66d",
        "aafc23b3-6e32-40e8-96f9-5a2046ef3c99",
        "268f3a6e-82d9-4eb6-ba49-2d1800ed5f85",
        "6843c188-211e-45b5-a8bb-4a7529304e20",
        "954329c5-5957-4692-823b-02f893509917",
        "79cb8038-9226-4d0c-90d6-ffd511684b00",
        "6cea7292-403c-445a-90c0-7f0e2792bee9",
        "611e1b64-f149-45a1-b96a-1cdf0757e7f1",
        "6daefda7-157d-4c68-918d-dd712ba692d6",
        "49d9a106-4ba4-4737-960f-6af500c19d5e",
        "683c69b9-5cd7-4a67-a3a6-378f182050a9",
        "829f1195-778c-4071-869c-f207e45ecc50",
        "8ed7269a-ecad-4946-958c-5c1dd1514c02",
        "7349c62c-6a93-43db-b560-efdde8d478fe",
        "b4b787c6-8198-4d68-b062-a2a7c106e7d8",
        "f5dfb1c3-1466-4932-a2d9-39f6435cf650",
        "3d5ac487-fb0f-4cea-b245-c44905fc5f43",
        "d9992d7d-c731-4f6d-8f51-653d84f5ac7c",
        "65432332-eab3-40b2-b1c3-59dcdd13a2a2",
        "f1e542b0-28c6-4dfa-be7b-53d971a49c8e",
        "e42f8340-8f21-442a-8a6e-cac596ec8bda",
        "2228153e-9667-455e-8c4e-f1a17c0d1638",
        "313c81f2-6721-4b08-b80f-e3027e999863",
        "d12cbb8c-36b8-4ddc-8639-b12021d06abb",
        "2710efe8-e9a3-481a-b6eb-6345e532c7e8",
        "e9b55a88-43e2-4580-b2ac-51d985709e2c",
        "d35b1de8-b671-4b91-8922-de7f79ba9046",
        "c7258f75-eb72-4495-bd4c-36d71117718c",
        "651aaddb-646e-403d-a52e-2da310c580be",
        "1992d373-2418-49c0-a44c-fab4be95b8e6",
        "c422ab76-f84b-4541-a17b-956750a91f75",
        "be6e14e3-ed24-4b95-8cb0-fcf600c648ef",
        "3ab10afe-1a71-411d-b680-4f749113178c",
        "32b8050f-0d11-4b74-8a94-26a3fb9584ea",
        "3c360255-428c-48b0-89c7-c0ecd2f59d1f",
        "76777c94-2625-4306-be91-40714fb7fa76",
        "b006070a-26d2-4940-babc-4abaf01db07b",
        "72cf54cb-e875-4a17-b2ad-ba10d77c82a7",
        "12a1e322-bc5e-422b-a392-31e2a688c1ed",
        "6db0d276-8cad-47d1-953c-338868961bc7",
        "033a8318-1054-4d4f-9457-910182e5b027",
        "77a33cf2-89ea-45d3-a2ed-2097a423255f",
        "53bc8262-683a-4ac1-af2c-a27e5d6022e7",
        "3c3efe20-d69e-45c9-ade5-f1660c95f027",
        "9c5b71d8-99d8-4610-b2c7-ab0acc4cc6db",
        "35013c51-e760-4e46-a8f4-9bbe81cfd7a6",
        "f6cc4703-57a7-4406-b935-4b1dc0397db1",
        "2b5d4c3b-a6a4-4f45-b012-17e71657136e",
        "f69c8686-6c7e-450f-a9e6-63f1f86880ac",
        "6b15de8c-d6b6-4a8e-9e22-0faf6488a85b"
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