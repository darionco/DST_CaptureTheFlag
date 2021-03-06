name = 'Warsak!'
description = 'Capture the flag themed mod!'
author = 'fibonacci618, JayLil & aligura'
version = '0.8.1'

forumthread = ''

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true
client_only_mod = false
server_only_mod = true

api_version = 10

configuration_options = {
    {
        name = 'CTF_MIN_PLAYERS_TO_START',
        label = 'Min player count',
        options =    {
            {description = '1', data = 1},
            {description = '2', data = 2},
            {description = '3', data = 3},
            {description = '4', data = 4},
            {description = '5', data = 5},
            {description = '6', data = 6},
            {description = '7', data = 7},
            {description = '8', data = 8},
            {description = '9', data = 9},
            {description = '10', data = 10},
            {description = '11', data = 11},
            {description = '12', data = 12},
            {description = '13', data = 13},
            {description = '14', data = 14},
            {description = '15', data = 15},
            {description = '16', data = 16},
        },
        default = 2,
        hover = 'The game will start when the specified number of players join the game'
    },
}
