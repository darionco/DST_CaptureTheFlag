local require = _G.require;
local CTF_TEAM_CONSTANTS = require('constants/CTFTeamConstants');

local function ctf_ondrop(inst)
            local team = CTFTeamManager:getPlayerTeam(inst.userid);
                local portablecookpot_item = SpawnPrefab("portablecookpot_item");
                    if team then
                        portablecookpot_item:AddTag(CTF_TEAM_CONSTANTS.TEAM_ITEM_TAG);
                        team:registerObject(portablecookpot_item, nil);
                    end
                local portablespicer_item = SpawnPrefab("portablespicer_item");
                    if team then
                        portablespicer_item:AddTag(CTF_TEAM_CONSTANTS.TEAM_ITEM_TAG);
                        team:registerObject(portablespicer_item, nil);
                    end
end

return ctf_ondrop