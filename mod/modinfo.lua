if folder_name == 'DST_CaptureTheFlag' then
    name = 'Warsak! [LOCAL]'
elseif folder_name == 'workshop-2417788343' then
    name = 'Warsak! [STAGING]'
else
    name = 'Warsak!'
end

author = 'fibonacci618, JayLil & aligura'
version = '0.14.7'
forumthread = ''

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true
client_only_mod = false
server_only_mod = true

api_version = 10

-- localization
locale = locale or 'en';

-- default language
local CTF_STRINGS = {
    description = 'Capture the flag themed mod!', -- this should be updated
    options = {
        CTF_MIN_PLAYERS_TO_START = {
            label = 'Min player count',
            hover = 'The game will start when the specified number of players join the game',
        },
        CTF_LANGUAGE = {
            label = 'Language',
            hover = 'Select the game language or "Autodetect" to let the mod figure it out',
        },
    },
    gameModeDescription = '', -- TODO
};

-- russian
if locale == 'ru' then
    CTF_STRINGS.description = 'Захватить флага, тематический мод!';

    CTF_STRINGS.options.CTF_MIN_PLAYERS_TO_START.label = 'Мин. Количество игроков';
    CTF_STRINGS.options.CTF_MIN_PLAYERS_TO_START.hover = 'Игра начнется, когда к игре присоединится указанное количество игроков.';

    CTF_STRINGS.options.CTF_LANGUAGE.label = 'Язык';
    CTF_STRINGS.options.CTF_LANGUAGE.hover = 'Выберите язык игры или "Автоопределение", чтобы мод выбрал за Вас';

    CTF_STRINGS.gameModeDescription = ''; -- TODO
end

description = CTF_STRINGS.description;

local options = {};
for i = 1, 64 do
    options[#options + 1] = {description = '' .. i, data = i};
end

configuration_options = {
    {
        name = 'CTF_LANGUAGE',
        label = CTF_STRINGS.options.CTF_LANGUAGE.label,
        options = {
            { description = 'autodetect', data = false },
            { description = 'English', data = 'en' },
            { description = 'Русский', data = 'ru' },
        },
        default = false,
        hover = CTF_STRINGS.options.CTF_LANGUAGE.hover,
    },
    {
        name = 'CTF_MIN_PLAYERS_TO_START',
        label = CTF_STRINGS.options.CTF_MIN_PLAYERS_TO_START.label,
        options = options,
        default = 2,
        hover = CTF_STRINGS.options.CTF_MIN_PLAYERS_TO_START.hover,
    },
}

game_modes =
{
    {
        name = 'warsak',
        label = 'Warsak!',
        description = CTF_STRINGS.gameModeDescription,
        settings =
        {
            resource_renewal = false,
            ghost_sanity_drain = false,
            --ghost_enabled = false,
            no_avatar_popup = true,
            no_morgue_record = true,
            drop_everything_on_despawn = true,
        }
    },
    {
        name = 'warsak_boss_rush',
        label = 'Warsak! - Boss Rush',
        description = CTF_STRINGS.gameModeDescription,
        settings =
        {
            resource_renewal = false,
            ghost_sanity_drain = false,
            ghost_enabled = false,
            no_avatar_popup = true,
            no_morgue_record = true,
            drop_everything_on_despawn = true,
            level_type = "WARSAK_BOSS_RUSH",
        }
    },
}
