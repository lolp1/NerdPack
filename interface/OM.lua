local _, NeP = ...
local DiesalGUI = NeP._G.LibStub('DiesalGUI-1.0')
local L = NeP.Locale

local statusBars = {}
local statusBarsUsed = {}
local dOM = 'Enemy'

local bt = {
	{key = 'Enemy', text = 'Enemies'},
	{key = 'Friendly', text = 'Friendlies'},
	{key = 'Dead', text = 'Dead Units'},
	{key = 'Critters', text = 'Critters'},
	{key = 'Roster', text = 'Roster'},
	{key = 'Objects', text = 'Objects'},
	{key = 'AreaTriggers', text = 'AreaTriggers'},
	{key = 'Memory', text = 'Memory (ALL)'},
}
local combo_eval = {key = "list", list = bt, default = "Enemy"}
local gui_eval = {key = 'NePOMgui', width = 500, height = 250, header = true, title = 'ObjectManager GUI'}

local OM_GUI = NeP.Interface:BuildGUI(gui_eval)
NeP.Interface:Add(L:TA('OM', 'Option'), function() OM_GUI.parent:Show() end)
local dropdown = NeP.Interface:Combo(combo_eval, OM_GUI.parent, {key="OM_GUI", offset = 0})
dropdown:SetPoint("TOPRIGHT", OM_GUI.parent.header, "TOPRIGHT", 0, 0)
dropdown:SetPoint("BOTTOMLEFT", OM_GUI.parent.header, "BOTTOMLEFT", (gui_eval.width-100), 0)
dropdown:SetEventListener('OnValueChanged', function(_,_, value) dOM = value end)
OM_GUI.parent:Hide()

local function getStatusBar()
	local statusBar = NeP._G.tremove(statusBars)
	if not statusBar then
		statusBar = DiesalGUI:Create('StatusBar')
		OM_GUI.window:AddChild(statusBar)
		statusBar:SetParent(OM_GUI.window.content)
		OM_GUI.parent:AddChild(statusBar)
		statusBar.frame:SetStatusBarColor(1,1,1,0.35)
	end
	statusBar:Show()
	table.insert(statusBarsUsed, statusBar)
	return statusBar
end

local function recycleStatusBars()
	for i = #statusBarsUsed, 1, -1 do
		statusBarsUsed[i]:Hide()
		NeP._G.tinsert(statusBars, NeP._G.tremove(statusBarsUsed))
	end
end

local function GetTable()
	local tmp = {}
	for _, Obj in pairs(NeP.OM:Get(dOM, true)) do
		tmp[#tmp+1] = Obj
	end
	table.sort( tmp, function(a,b) return a.distance < b.distance end )
	return tmp
end

local function RefreshGUI()
	local offset = -5
	recycleStatusBars()
	for _, Obj in pairs(GetTable()) do
		local SB = getStatusBar()
		SB.frame:SetPoint('TOP', OM_GUI.window.content, 'TOP', 2, offset )
		local name = (Obj.name or '???')
		if name:len() > 25 then
			name = name:sub(0,25) .. '...'
		end
		SB.frame.Left:SetText(('|cff'..NeP.Core:ClassColor(Obj.key, 'hex')) .. name)
		local txt = ''
		if not Obj.tbl then
			txt = txt
			..'( |cffff0000NO_TABLE|r! )'
		end
		txt = txt ..'( '
		if Obj.id and Obj.id ~= 0 then
			txt = txt
			..'|cffff0000ID|r: '
			..(Obj.id or '??')
		end
		if Obj.health and Obj.health ~= 0 then
			txt = txt
			..' |cffff0000Health|r: '
			..(Obj.health or 0)
		end
		if Obj.range and Obj.range < 999 then
			txt = txt
			..' |cffff0000Range|r: '
			..(NeP.Core:Round(Obj.range or 0))
		end
		if Obj.distance and Obj.distance < 999 then
			txt = txt
			..' |cffff0000Dist|r: '
			..(NeP.Core:Round(Obj.distance or 0))
		end
		txt = txt .. ' )'
		SB.frame.Right:SetText(txt)
		SB.frame:SetScript('OnMouseDown', function() NeP.Protected.TargetUnit(Obj.key) end)
		SB:SetValue(Obj.health or 0)
		offset = offset -18
	end
end

NeP._G.C_Timer.NewTicker(0.1, (function()
	if OM_GUI.parent:IsShown() then
		RefreshGUI()
	end
end), nil)
