---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-08 9:40 p.m.
---

local require = _G.require;
local CTF_CHARACTER_CONSTANTS = require('constants/CTFCharacterConstants');

AddPrefabPostInit('wendy', function(inst)
    if inst.components and inst.components.ghostlybond then
        inst.components.ghostlybond.onrecallcompletefn = function(_, ghost)
            ghost.components.health:SetPercent(0);
        end

        local OldSpawnGhost = inst.components.ghostlybond.SpawnGhost;
        inst.components.ghostlybond.SpawnGhost = function(self)
            OldSpawnGhost(self);
            if self.ghost then
                self.ghost.components.health:StartRegen(
                        CTF_CHARACTER_CONSTANTS.WENDY.ABI_REGEN_AMOUNT,
                        CTF_CHARACTER_CONSTANTS.WENDY.ABI_REGEN_PERIOD,
                        true
                );
                self.ghost.components.health:SetVal(1);

                self.ghost:ListenForEvent('ctf_attack', function()
                    local x, y, z = self.ghost.Transform:GetWorldPosition();
                    local ents = TheSim:FindEntities(x, y, z, 2.5, { '_combat' });
                    local teamTag = inst.data.ctf_team_tag;
                    local damage = self.ghost.components.health.currenthealth;
                    for _, v in ipairs(ents) do
                        if v ~= self.ghost and not v:HasTag(teamTag) and v:IsValid() and not v:IsInLimbo() then
                            if v.components and v.components.combat then
                                v.components.combat:GetAttacked(inst, damage, nil);
                            end
                        end
                    end
                end);
            end
        end
    end
end);

AddStategraphState('wilson', State{
    name = 'ctf_summon_abigail',
    tags = { 'doing', 'busy', 'nodangle', 'canrotate' },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation('wendy_channel')
        inst.AnimState:PushAnimation('wendy_channel_pst', false)
        inst.AnimState:SetTime(52 * FRAMES)

        if inst.bufferedaction ~= nil then
            local flower = inst.bufferedaction.invobject
            if flower ~= nil then
                local skin_build = flower:GetSkinBuild()
                if skin_build ~= nil then
                    inst.AnimState:OverrideItemSkinSymbol('flower', skin_build, 'flower', flower.GUID, flower.AnimState:GetBuild() )
                else
                    inst.AnimState:OverrideSymbol('flower', flower.AnimState:GetBuild(), 'flower')
                end
            end

            inst.sg.statemem.action = inst.bufferedaction
        end
    end,

    timeline =
    {
        TimeEvent(0 * FRAMES, function(inst)
            if inst.components.talker ~= nil and inst.components.ghostlybond ~= nil then
                inst.components.talker:Say(GetString(inst, 'ANNOUNCE_ABIGAIL_SUMMON', 'LEVEL'..tostring(math.max(inst.components.ghostlybond.bondlevel, 1))), nil, nil, true)
            end

            inst.sg.statemem.fx = SpawnPrefab(inst.components.rider:IsRiding() and 'abigailsummonfx_mount' or 'abigailsummonfx')
            inst.sg.statemem.fx.entity:SetParent(inst.entity)
            inst.sg.statemem.fx.Transform:SetRotation(inst.Transform:GetRotation())
            inst.sg.statemem.fx.AnimState:SetTime(0) -- hack to force update the initial facing direction

            if inst.bufferedaction ~= nil then
                local flower = inst.bufferedaction.invobject
                if flower ~= nil then
                    local skin_build = flower:GetSkinBuild()
                    if skin_build ~= nil then
                        inst.sg.statemem.fx.AnimState:OverrideItemSkinSymbol('flower', skin_build, 'flower', flower.GUID, flower.AnimState:GetBuild() )
                    end
                end
            end
        end),

        TimeEvent((53 - 52) * FRAMES, function(inst) inst.SoundEmitter:PlaySound('dontstarve/characters/wendy/summon') end),
        TimeEvent((62 - 52) * FRAMES, function(inst)
            if inst:PerformBufferedAction() then
                inst.sg.statemem.fx = nil
            else
                inst.sg:GoToState('idle')
            end
        end),
        TimeEvent((74 - 52) * FRAMES, function(inst)
            inst.sg:RemoveStateTag('busy')
            if inst.components.talker ~= nil then
                inst.components.talker:ShutUp()
            end
        end),
    },

    events =
    {
        EventHandler('animqueueover', function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState('idle')
            end
        end),
    },

    onexit = function(inst)
        inst.AnimState:ClearOverrideSymbol('flower')
        if inst.sg.statemem.fx ~= nil then
            inst.sg.statemem.fx:Remove()
        end
        if inst.bufferedaction == inst.sg.statemem.action then
            inst:ClearBufferedAction()
        end
    end,
});
