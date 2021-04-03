---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-04-03 12:44 p.m.
---

local CTFInit = use('scripts/tools/CTFInit');
local CTF_ARMOUR = use('scripts/constants/CTFArmourConstants');

local function master_post_init(inst)
    local OldOnEquip = inst.components.equippable.onequipfn;
    local OldOnUnequip = inst.components.equippable.onunequipfn;

    inst.components.equippable:SetOnEquip(function(f_inst, owner)
        OldOnEquip(f_inst, owner);
        owner:AddTag('beefriend');
    end);

    inst.components.equippable:SetOnUnequip(function(f_inst, owner)
        OldOnUnequip(f_inst, owner);
        owner:RemoveTag('beefriend');
    end);

end

CTFInit:Prefab('hivehat', nil, master_post_init);
