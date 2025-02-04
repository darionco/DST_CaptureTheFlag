---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-02-17 6:12 p.m.
---
local require = _G.require;
local LoadingWidget = require "widgets/redux/loadingwidget"

-- No need to patch the loading screen on dedicated servers
if not TheNet:IsDedicated() then
    _G.GetLoaderAtlasAndTex = function(_)
        return 'images/ctf_loading_screen_01.xml', 'loading_screen_01.tex';
    end

    local LoadingScreenAssets = {
        Asset('ATLAS', 'images/ctf_loading_screen_01.xml'),
        Asset('IMAGE', 'images/ctf_loading_screen_01.tex'),
    };
    RegisterPrefabs(Prefab('MOD_CTF_LOADING_SCREEN', function() end, LoadingScreenAssets, nil));
    TheSim:LoadPrefabs({ 'MOD_CTF_LOADING_SCREEN' });

    local OldKeepAlive = LoadingWidget.KeepAlive;
    LoadingWidget.KeepAlive = function(self, arg1)
        TheSim:LoadPrefabs({ 'MOD_CTF_LOADING_SCREEN' });
        return OldKeepAlive(self, arg1);
    end

    local OldSetEnabled = LoadingWidget.SetEnabled;
    LoadingWidget.SetEnabled = function(self, enabled)
        if enabled then
            if self.legacy_fg then
                self.root_classic:RemoveChild(self.legacy_fg);
                self.legacy_fg:Kill();
                self.legacy_fg = nil;
            end

            if self.bg then
                --self:RemoveChild(self.bg);
                --self.bg:Kill();
                --self.bg = nil;
                self.bg:SetTexture(GetLoaderAtlasAndTex());
            end
        end

        OldSetEnabled(self, enabled);
    end
end