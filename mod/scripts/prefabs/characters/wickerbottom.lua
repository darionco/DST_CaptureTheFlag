---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-02-14 11:40 p.m.
---
local require = _G.require;
local CTF_TEAM_CONSTANTS = require('constants/CTFTeamConstants');

STRINGS.NAMES.BOOK_SILVICULTURE = 'Heart Tart Art';
local WICKERBOTTOM_BOOK_SILVICULTURE_HEAL = 150;
local WICKERBOTTOM_BOOK_SILVICULTURE_HUNGER = 60;
local WICKERBOTTOM_BOOK_SILVICULTURE_RANGE = 30;

STRINGS.NAMES.BOOK_BRIMSTONE = 'Humpty Dumpty';
local WICKERBOTTOM_BOOK_BRIMSTONE_DAMAGE = 0.3;
local WICKERBOTTOM_BOOK_BRIMSTONE_RANGE = 10;
local WICKERBOTTOM_BOOK_BRIMSTONE_DAMAGE_ALLIES = 0.2;
local WICKERBOTTOM_BOOK_BRIMSTONE_TAGS = { '_combat', '_health' };

AddPrefabPostInit('book_silviculture', function(inst)
    if inst.components and inst.components.book then
        inst.components.book.onread = function(f_inst, reader)
            if reader:HasTag(CTF_TEAM_CONSTANTS.TEAM_PLAYER_TAG) and reader.data and reader.data.ctf_team_tag then
                local teamTag = reader.data.ctf_team_tag;
                local x, y, z = reader.Transform:GetWorldPosition();
                local ents = TheSim:FindEntities(x, y, z, WICKERBOTTOM_BOOK_SILVICULTURE_RANGE, { teamTag });
                for _, v in ipairs(ents) do
                    if v.components then
                        if v.components.health then
                            v.components.health:DoDelta(WICKERBOTTOM_BOOK_SILVICULTURE_HEAL, nil, CTF_TEAM_CONSTANTS.TEAMMATE_HEAL, nil, inst);
                        end

                        if v.components.hunger then
                            v.components.hunger:DoDelta(WICKERBOTTOM_BOOK_SILVICULTURE_HUNGER);
                        end
                    end
                end
            end
            return true;
        end
    end
end);

AddPrefabPostInit('book_brimstone', function(inst)
    if inst.components and inst.components.book then
        inst.components.book.onread = function(f_inst, reader)
            if reader:HasTag(CTF_TEAM_CONSTANTS.TEAM_PLAYER_TAG) and reader.data and reader.data.ctf_team_tag then
                local teamTag = reader.data.ctf_team_tag;
                local x, y, z = reader.Transform:GetWorldPosition();
                local ents = TheSim:FindEntities(x, y, z, WICKERBOTTOM_BOOK_BRIMSTONE_RANGE, WICKERBOTTOM_BOOK_BRIMSTONE_TAGS);
                for _, v in ipairs(ents) do
                    if v:IsValid() and not v:IsInLimbo() then
                        local maxHealth = v.components.health:GetMaxWithPenalty();
                        local damage;
                        if v:HasTag(teamTag) then
                            damage = WICKERBOTTOM_BOOK_BRIMSTONE_DAMAGE_ALLIES * maxHealth;
                        else
                            damage = WICKERBOTTOM_BOOK_BRIMSTONE_DAMAGE * maxHealth;
                        end

                        if v.components then
                            if v.components.combat then
                                v.components.combat:GetAttacked(reader, damage, nil);
                            elseif v.components.health then
                                v.components.health:DoDelta(-damage, nil, f_inst.prefab);
                            end
                        end
                    end
                end
            end
            return true;
        end
    end
end);
