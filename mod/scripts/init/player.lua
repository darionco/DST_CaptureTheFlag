---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-01-17 2:10 p.m.
---

--AddPrefabPostInit('player_classified', function (inst)
--    inst:DoTaskInTime(0, function(pc)
--        print('======================================== player_classified');
--        local player = pc.entity:GetParent();
--        CTFPlayer(player);
--    end);
--end);

AddPlayerPostInit(function(inst)
    print('======================================== AddPlayerPostInit');
    CTFPlayer(inst);
end);
