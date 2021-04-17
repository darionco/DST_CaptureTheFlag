local CTFInit = use('scripts/tools/CTFInit');
local CTF_MISC_CONSTANTS = use('scripts/constants/CTFMiscConstants');

local function master_post_init(inst)
    inst.components.sleepingbag.hunger_tick = CTF_MISC_CONSTANTS.SLEEP_HUNGER_PER_TICK;
    inst.components.sleepingbag.health_tick = CTF_MISC_CONSTANTS.SLEEP_HEALTH_PER_TICK;
end

CTFInit:Prefab('bedroll_straw', nil, master_post_init);
CTFInit:Prefab('bedroll_furry', nil, master_post_init);
