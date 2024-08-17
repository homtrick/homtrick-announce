local webhook = 'INSERT_WEBHOOK_HERE'

local useChat = Config.useChat
local useTxAdmin = Config.useTxAdmin
local useOxLib = Config.useOxLib

function SendWebhookMessage(webhook, message, title, colour)
    local date = os.date('*t')
        if date.day < 10 then date.day = '0' .. tostring(date.day) end
        if date.month < 10 then date.month = '0' .. tostring(date.month) end
        if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
        if date.min < 10 then date.min = '0' .. tostring(date.min) end
        if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
        local embed = {
        {
            ["color"] = (colour or 3034278),
            ["title"] = "**"..title.."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = '@'..Config.LongName..' | Date: '.. date.day ..'/'.. date.month ..'/'.. date.year ..' - '.. date.hour ..':'.. date.min ..':'.. date.sec ..'',
                ["icon_url"] = Config.EmbedLogo,
            },
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end


RegisterCommand(Config.command, function(source, args, rawCommand)
    local message = table.concat(args, " ")
    local name = GetPlayerName(source)
    local discordIdentifier = ""
    for k,v in pairs(GetPlayerIdentifiers(source)) do
        if string.match(v, "^discord:") then
            discordIdentifier = string.gsub(v, "^discord:", "")
        end
    end
    if IsPlayerAceAllowed(source, Config.permission) then
        if useChat then
            TriggerClientEvent('chat:addMessage', -1, {
                color = {255, 255, 255},
                multiline = false,
                args = {'^1[ANNOUNCEMENT] ^1['..name..']^0: '..message}
            })
        elseif useTxAdmin then
            TriggerClientEvent('txcl:showAnnouncement', -1, message, name)
        elseif useOxLib then
            TriggerClientEvent('ox_lib:notify', -1, {
                title = 'Announcement by '..name,
                description = ''..message,
                type = 'error',
                showDuration = 8000,
                position = Config.OXLIBNotificationPosition,
            })
        end
        SendWebhookMessage(webhook, '🧑🏻 Player: **'..name..'** \n📄 Discord: [<@'..discordIdentifier..'>] \n 🚨Executed Command: **ANNOUNCE** \n 💬 Message: **'..message..'**', ''..Config.ShortName..' | Announcement System', 3939707)
    else
        TriggerClientEvent('ox_lib:notify', source, {
            description = 'Access Denied',
            type = 'error',
            showDuration = 8000,
            position = Config.OXLIBNotificationPosition,
        })
    end
end, false)