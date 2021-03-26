---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-26 12:48 a.m.
---

local function CTFCreateNetVar(inst, name, type, store)
    local key = 'ctf_' .. name;
    local result = { var = type(inst.GUID, key, key), event = key };
    if store then
        store[name] = result;
    else
        inst[name] = result;
    end
    return result;
end

return CTFCreateNetVar;
