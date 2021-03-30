---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-30 9:35 a.m.
---

local CTFInit = use('scripts/tools/CTFInit');
local CTFTeamCombat = require('teams/CTFTeamCombat');

local function master_post_init(inst)
    if inst.event_listening.working and inst.event_listening.working[inst] then
        inst:RemoveEventCallback('working', inst.event_listening.working[inst][1]);
    end

    if inst.event_listening.attacked and inst.event_listening.attacked[inst] then
        for _, fn in ipairs(inst.event_listening.attacked[inst]) do
            local info = debug.getinfo(fn, 'S');
            if info and info.source and info.source:match('prefabs[/\\]deerclops.lua$') then
                inst:RemoveEventCallback('attacked', fn);
                break;
            end
        end
    end

    if inst.event_listening.newcombattarget and inst.event_listening.newcombattarget[inst] then
        for _, fn in ipairs(inst.event_listening.newcombattarget[inst]) do
            local info = debug.getinfo(fn, 'S');
            if info and info.source and info.source:match('prefabs[/\\]deerclops.lua$') then
                inst:RemoveEventCallback('newcombattarget', fn);
                break;
            end
        end
    end

    if inst.components.combat then
        inst.components.combat:SetRetargetFunction(1, function(self)
            if self.data and self.data.ctf_team_tag then
                local range = inst:GetPhysicsRadius(0) + 8;
                return CTFTeamCombat.findEnemy(self, range, self.data.ctf_team_tag);
            end
            return nil;
        end);
    end
end

CTFInit:Prefab('deerclops', nil, master_post_init);
