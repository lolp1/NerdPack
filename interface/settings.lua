local n_name, NeP = ...
local L           = function(val) return NeP.Locale:TA('Settings', val) end
local DiesalStyle = LibStub("DiesalStyle-1.0")

function NeP.Interface:Update()
  NeP.ButtonsSize = NeP.Config:Read(n_name..'_Settings', 'bsize', 40)
  NeP.ButtonsPadding = NeP.Config:Read(n_name..'_Settings', 'bpad', 2)
  NeP.OM.max_distance = NeP.Config:Read(n_name..'_Settings', 'OM_Dis', 100)
  self:RefreshToggles()
end

local config = {
key = n_name..'_Settings',
title = n_name,
  subtitle = L('option'),
  width = 250,
  height = 270,
  config = {
		{ type = 'header', text = n_name..' |r'..NeP.Version..' '..NeP.Branch, size = 14, align = 'Center'},

    { type = 'spacer' },{ type = 'ruler' },{ type = 'spacer' },
    { type = 'header', text = L('UI_Settings') },
    { type = 'spinner', text = L('bsize'), key = 'bsize', min = NeP.min_width, default = 40},
		{ type = 'spinner', text = L('bpad'), key = 'bpad', default = 2},
    { type = 'spinner', text = L('brow'), key = 'brow', step = 1, min = 1, max = 20, default = 10},

    { type = 'ruler' },{ type = 'spacer' },
    { type = 'header', text = L('OM_Settings') },
    { type = 'spinner', text = L('OM_Dis'), key = 'OM_Dis', step = 10, min = 40, max = 300, default = 100, desc = L("OM_Dis_desc")},

    { type = 'spacer' },{ type = 'ruler' },
		{ type = 'button', text = L('apply_bt'), callback = function() NeP.Interface:Update() end },

	}
}

NeP.STs = NeP.Interface:BuildGUI(config)
NeP.Interface:Add(n_name..' '..L('option'), function() NeP.STs.parent:Show() end)
NeP.STs.parent:Hide()

NeP.Core:WhenInGame(function()
  NeP.Interface:Update()
end)
