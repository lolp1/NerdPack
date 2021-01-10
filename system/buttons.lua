local _, NeP = ...

NeP.Buttons = {
	buttons = {}
}

local nBars = {
	"ActionButton",
	"MultiBarBottomRightButton",
	"MultiBarBottomLeftButton",
	"MultiBarRightButton",
	"MultiBarLeftButton"
}

-- this seems to be missing now....
-- added this from old dumps and seems to work...
local function ActionButton_CalculateAction (self, button)
	if ( not button ) then
		button = SecureButton_GetEffectiveButton(self);
	end
	if ( self:GetID() > 0 ) then
		local page = SecureButton_GetModifiedAttribute(self, "actionpage", button);
		if ( not page ) then
			page = GetActionBarPage();
			if ( self.isBonus and (page == 1 or self.alwaysBonus) ) then
				local offset = GetBonusBarOffset();
				if ( offset == 0 and BonusActionBarFrame and BonusActionBarFrame.lastBonusBar ) then
					offset = BonusActionBarFrame.lastBonusBar;
				end
				page = NUM_ACTIONBAR_PAGES + offset;
			elseif ( self.isExtra ) then
				page = NUM_ACTIONBAR_PAGES + GetExtraBarOffset();
			elseif ( self.buttonType == "MULTICASTACTIONBUTTON" ) then
				page = NUM_ACTIONBAR_PAGES + GetMultiCastBarOffset();
			end
		end
		return (self:GetID() + ((page - 1) * NUM_ACTIONBAR_BUTTONS));
	else
		return SecureButton_GetModifiedAttribute(self, "action", button) or 1;
	end
end

function NeP.Buttons:UpdateButtons()
	NeP._G.wipe(self.buttons)
	for _, group in ipairs(nBars) do
		for i =1, 12 do
			local button = _G[group .. i]
			if button then
				local actionType, id = NeP._G.GetActionInfo(ActionButton_CalculateAction(button, "LeftButton"))
				if actionType == 'spell' then
					local spell = NeP._G.GetSpellInfo(id)
					if spell then
						self.buttons[spell] = button
					end
				end
			end
		end
	end
end
