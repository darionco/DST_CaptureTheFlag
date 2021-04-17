local CTFInit = use('scripts/tools/CTFInit');
local CTF_CHARACTER_CONSTANTS = use('scripts/constants/CTFCharacterConstants');


CTFInit:Prefab('glowberrymousse', nil, function(inst)
    inst.components.edible.healthvalue = CTF_CHARACTER_CONSTANTS.WARLY.FOOD.glowberrymousse.health;
    inst.components.edible.hungervalue = CTF_CHARACTER_CONSTANTS.WARLY.FOOD.glowberrymousse.hunger;
end);

CTFInit:Prefab('potatosouffle', nil, function(inst)
    inst.components.edible.healthvalue = CTF_CHARACTER_CONSTANTS.WARLY.FOOD.potatosouffle.health;
    inst.components.edible.hungervalue = CTF_CHARACTER_CONSTANTS.WARLY.FOOD.potatosouffle.hunger;
end);

CTFInit:Prefab('monstertartare', nil, function(inst)
    inst.components.edible.healthvalue = CTF_CHARACTER_CONSTANTS.WARLY.FOOD.monstertartare.health;
    inst.components.edible.hungervalue = CTF_CHARACTER_CONSTANTS.WARLY.FOOD.monstertartare.hunger;
end);

CTFInit:Prefab('freshfruitcrepes', nil, function(inst)
    inst.components.edible.healthvalue = CTF_CHARACTER_CONSTANTS.WARLY.FOOD.freshfruitcrepes.health;
    inst.components.edible.hungervalue = CTF_CHARACTER_CONSTANTS.WARLY.FOOD.freshfruitcrepes.hunger;
end);

CTFInit:Prefab('bonesoup', nil, function(inst)
    inst.components.edible.healthvalue = CTF_CHARACTER_CONSTANTS.WARLY.FOOD.bonesoup.health;
    inst.components.edible.hungervalue = CTF_CHARACTER_CONSTANTS.WARLY.FOOD.bonesoup.hunger;
end);

CTFInit:Prefab('moqueca', nil, function(inst)
    inst.components.edible.healthvalue = CTF_CHARACTER_CONSTANTS.WARLY.FOOD.moqueca.health;
    inst.components.edible.hungervalue = CTF_CHARACTER_CONSTANTS.WARLY.FOOD.moqueca.hunger;
end);

