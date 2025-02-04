-- Don't use this on new screens! Use PopupDialogScreen with big longness
-- instead.
local require = _G.require;
local Screen = require "widgets/screen"
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local Menu = require "widgets/menu"
local TEMPLATES = require "widgets/templates"
local CTF_STRINGS = use('scripts/constants/CTFStrings');

local CTFInstructionsPopup = Class(Screen, function(self, title, text, buttons, timeout)
    Screen._ctor(self, "BigPopupDialogScreen")

    --darken everything behind the dialog
    self.black = self:AddChild(Image("images/global.xml", "square.tex"))
    self.black:SetVRegPoint(ANCHOR_MIDDLE)
    self.black:SetHRegPoint(ANCHOR_MIDDLE)
    self.black:SetVAnchor(ANCHOR_MIDDLE)
    self.black:SetHAnchor(ANCHOR_MIDDLE)
    self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
    self.black:SetTint(0,0,0,.75)

    self.proot = self:AddChild(Widget("ROOT"))
    self.proot:SetVAnchor(ANCHOR_MIDDLE)
    self.proot:SetHAnchor(ANCHOR_MIDDLE)
    self.proot:SetPosition(0,0,0)
    self.proot:SetScaleMode(SCALEMODE_PROPORTIONAL)

    --throw up the background
    self.bg = self.proot:AddChild(TEMPLATES.CurlyWindow(350, 260, 1, 1, 68, -40))
    self.bg.fill = self.proot:AddChild(Image("images/fepanel_fills.xml", "panel_fill_tiny.tex"))
    self.bg.fill:SetScale(1.3, 1)
    self.bg.fill:SetPosition(8, 12)

    --title
    self.title = self.proot:AddChild(Text(BUTTONFONT, 50))
    self.title:SetPosition(0, 135, 0)
    self.title:SetString(title)
    self.title:SetColour(0,0,0,1)

    --text
    if JapaneseOnPS4() then
        self.text = self.proot:AddChild(Text(NEWFONT, 28))
    else
        self.text = self.proot:AddChild(Text(NEWFONT, 30))
    end

    self.text:SetPosition(0, 5, 0)
    self.text:SetString(text)
    self.text:EnableWordWrap(true)
    self.text:SetRegionSize(800, 800)
    self.text:SetColour(0,0,0,1)

    --create the menu itself
    local button_w = 200
    local space_between = 20
    local spacing = button_w + space_between

    self.menu = self.proot:AddChild(Menu(buttons, spacing, true))
    self.menu:SetPosition(-(spacing*(#buttons-1))/2, -140, 0)
    self.buttons = buttons
    self.default_focus = self.menu
end)



function CTFInstructionsPopup:OnUpdate( dt )
    if self.timeout then
        self.timeout.timeout = self.timeout.timeout - dt
        if self.timeout.timeout <= 0 then
            self.timeout.cb()
        end
    end
    return true
end

function CTFInstructionsPopup:OnControl(control, down)
    if CTFInstructionsPopup._base.OnControl(self,control, down) then
        return true
    end
end

return function(cb)
    _G.TheFrontEnd:PushScreen(CTFInstructionsPopup(
            CTF_STRINGS.WELCOME.TITLE,
            CTF_STRINGS.WELCOME.TEXT,
            {
                {
                    text = CTF_STRINGS.WELCOME.DISCORD,
                    cb = function()
                        VisitURL(CTF_STRINGS.WELCOME.DISCORD_LINK);
                    end
                },
                {
                    text = CTF_STRINGS.WELCOME.OK,
                    cb = function()
                        _G.TheFrontEnd:PopScreen();
                        cb();
                    end
                },
                {
                    text = CTF_STRINGS.WELCOME.VIDEO,
                    cb = function()
                        VisitURL(CTF_STRINGS.WELCOME.VIDEO_LINK);
                    end
                },
            }
    ));
end
