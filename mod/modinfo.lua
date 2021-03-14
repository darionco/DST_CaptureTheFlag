if folder_name == 'DST_CaptureTheFlag' then
    name = 'Warsak! [LOCAL]'
elseif folder_name == 'workshop-2417788343' then
    name = 'Warsak! [STAGING]'
else
    name = 'Warsak!'
end

description = 'Capture the flag themed mod!'
author = 'fibonacci618, JayLil & aligura'
version = '0.10.0'

forumthread = ''

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true
client_only_mod = false
server_only_mod = true

api_version = 10

local options = {};
for i = 1, 64 do
    options[#options + 1] = {description = '' .. i, data = i};
end

configuration_options = {
    {
        name = 'CTF_MIN_PLAYERS_TO_START',
        label = 'Min player count',
        options = options,
        default = 2,
        hover = 'The game will start when the specified number of players join the game'
    },
}
