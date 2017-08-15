local _, NeP          = ...
local LibStub     = LibStub
local strupper    = strupper
local CreateFrame = CreateFrame
local DiesalGUI   = LibStub('DiesalGUI-1.0')
local DiesalTools = LibStub('DiesalTools-1.0')
local SharedMedia = LibStub('LibSharedMedia-3.0')

function NeP.Interface.Text(_, element, parent, offset)
	local tmp = DiesalGUI:Create('FontString')
	tmp:SetParent(parent.content)
	parent:AddChild(tmp)
	tmp = tmp.fontString
	tmp:SetPoint('TOPLEFT', parent.content, 'TOPLEFT', 5, offset)
	tmp:SetPoint('TOPRIGHT', parent.content, 'TOPRIGHT', -5, offset)
	tmp:SetText((element.color and '|cff'..element.color or '')..element.text)
	tmp:SetJustifyH(element.align or 'LEFT')
	tmp:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), element.size or 10)
	tmp:SetWidth(parent.content:GetWidth())
	element.offset = (element.offset or 0) + tmp:GetStringHeight()
	if element.align then tmp:SetJustifyH(strupper(element.align)) end
	return tmp
end

function NeP.Interface:Header(element, parent, offset)
	element.size = element.size or 13
	local tmp = self:Text(element, parent, offset)
	-- Only when loaded
	NeP.Core:WhenInGame(function()
		element.color = element.color or element.master.color
		tmp:SetText((element.color and '|cff'..element.color or '')..element.text)
	end, 1)
	tmp:SetJustifyH(element.align or 'CENTER')
	return tmp
end

function NeP.Interface.Rule(_, element, parent, offset)
	local tmp = DiesalGUI:Create('Rule')
	parent:AddChild(tmp)
	tmp:SetParent(parent.content)
	tmp.frame:SetPoint('TOPLEFT', parent.content, 'TOPLEFT', 5, offset)
	tmp.frame:SetPoint('BOTTOMRIGHT', parent.content, 'BOTTOMRIGHT', -5, offset)
	element.offset = element.offset or tmp.frame:GetHeight() + 1
	return tmp
end

function NeP.Interface.Texture(_, element, parent, offset)
	local tmp = CreateFrame('Frame')
	tmp:SetParent(parent.content)
	tmp:SetPoint(element.align or 'TOPLEFT', parent.content,
		element.align or 'TOPLEFT', 5+(element.x or 0), offset-3+(element.y or 0))
	tmp:SetWidth(parent:GetWidth()-10)
	tmp:SetHeight(element.height)
	tmp:SetWidth(element.width)
	tmp.texture = tmp:CreateTexture()
	tmp.texture:SetTexture(element.texture)
	tmp.texture:SetAllPoints(tmp)
	element.offset = element.offset or tmp:GetHeight() + 1
	return tmp
end

function NeP.Interface:Checkbox(element, parent, offset, table)
	local key = element.key_check or element.key
	local default = element.default_check or element.default
	local tmp = DiesalGUI:Create('CheckBox')
	parent:AddChild(tmp)
	tmp:SetParent(parent.content)
	tmp:SetPoint('TOPLEFT', parent.content, 'TOPLEFT', 5, offset)
	tmp:SetEventListener('OnValueChanged', function(_, _, checked)
		NeP.Interface:Write(table.key, key, checked)
	end)
	-- Only when loaded
	NeP.Core:WhenInGame(function()
		tmp:SetChecked(NeP.Interface:Fetch(table.key, key, default or false))
	end)
	tmp.text = self:Text(element, parent, offset-3)
	tmp.text:SetPoint('TOPLEFT', parent.content, 'TOPLEFT', 20, offset)
	tmp.text:SetPoint('TOPRIGHT', parent.content, 'TOPRIGHT', -5, offset)
	if element.desc then
		element.text=element.desc
		tmp.desc = self:Text(element, parent, offset-element.offset)
		element.offset = element.offset + tmp.desc:GetStringHeight()
	end
	return tmp
end

function NeP.Interface:Spinner(element, parent, offset, table)
	local key = element.key_spin or element.key
	local default = element.default_spin or element.default
	local tmp = DiesalGUI:Create('Spinner')
	parent:AddChild(tmp)
	tmp:SetParent(parent.content)
	tmp:SetPoint('TOPRIGHT', parent.content, 'TOPRIGHT', -5, offset)
	-- Only when loaded
	NeP.Core:WhenInGame(function()
		tmp:SetNumber(NeP.Interface:Fetch(table.key, key, default))
	end)
	--Settings
	tmp.settings.width = element.width or tmp.settings.width
	tmp.settings.min = tmp.settings.min or element.min
	tmp.settings.max = element.max or tmp.settings.max
	tmp.settings.step = element.step or tmp.settings.step
	tmp.settings.shiftStep = element.shiftStep or tmp.settings.shiftStep
	tmp:ApplySettings()
	--tmp:SetStylesheet(self.spinnerStyleSheet)
	tmp:SetEventListener('OnValueChanged', function(_, _, userInput, number)
		if not userInput then return end
		NeP.Interface:Write(table.key, key, number)
	end)
	tmp.text = self:Text(element, parent, offset)
	element.offset = tmp:GetHeight() + 1
	if element.desc then
		element.text=element.desc
		tmp.desc = self:Text(element, parent, offset-element.offset)
		element.offset = element.offset + tmp.desc:GetStringHeight()
	end
	return tmp
end

function NeP.Interface:Checkspin(element, parent, offset, table)
	element.key_check = element.key..'_check'
	element.default_check = element.check or element.default_check
	element.key_spin = element.key..'_spin'
	element.default_spin = element.spin or element.default_spin
	local tmp = self:Checkbox(element, parent, offset, table)
	element.text = ''
	element.desc = nil
	tmp.spin = self:Spinner(element, parent, offset, table)
	element.offset = tmp.spin:GetHeight()+1
	return tmp
end

function NeP.Interface:Combo(element, parent, offset, table)
	local tmp = DiesalGUI:Create('Dropdown')
	parent:AddChild(tmp)
	tmp:SetParent(parent.content)
	tmp:SetPoint('TOPRIGHT', parent.content, 'TOPRIGHT', -5, offset)
	--tmp:SetStylesheet(self.comboBoxStyleSheet)
	tmp:SetHeight(element.size or 10)
	local orderdKeys = { }
	local list = { }
	for i, value in pairs(element.list) do
		orderdKeys[i] = value.key
		list[value.key] = value.text
	end
	tmp:SetList(list, orderdKeys)
	tmp:SetEventListener('OnValueChanged', function(_, _, value)
		NeP.Interface:Write(table.key, element.key, value)
	end)
	-- Only when loaded
	NeP.Core:WhenInGame(function()
		tmp:SetValue(NeP.Interface:Fetch(table.key, element.key, element.default))
	end)
	if element.text then
		tmp.text2 = self:Text(element, parent, offset)
	end
	element.offset = tmp:GetHeight()
	if element.desc then
		element.text=element.desc
		tmp.desc = self:Text(element, parent, offset-element.offset)
		element.offset = element.offset + tmp.desc:GetStringHeight()
	end
	return tmp
end

function NeP.Interface:Button(element, parent, offset)
	local tmp = DiesalGUI:Create('Button')
	parent:AddChild(tmp)
	tmp:SetParent(parent.content)
	tmp:SetText(element.text)
	tmp:SetWidth(element.width or parent.content:GetWidth()-10)
	tmp:SetHeight(element.height or 20)
	--tmp:SetStylesheet(self.buttonStyleSheet)
	tmp:SetEventListener('OnClick', element.callback)
	element.offset = tmp:GetHeight() + 1
	if element.desc then
		element.text=element.desc
		tmp.desc = self:Text(element, parent, offset-element.offset)
		element.offset = element.offset + tmp.desc:GetStringHeight()
	end
	tmp:SetPoint(element.align or "TOP", parent.content, 0, offset)
	return tmp
end

function NeP.Interface:Input(element, parent, offset, table)
	local tmp = DiesalGUI:Create('Input')
	parent:AddChild(tmp)
	tmp:SetParent(parent.content)
	tmp:SetPoint('TOPRIGHT', parent.content, 'TOPRIGHT', -5, offset)
	if element.width then tmp:SetWidth(element.width) end
	-- Only when loaded
	NeP.Core:WhenInGame(function()
		tmp:SetText(NeP.Interface:Fetch(table.key, element.key, element.default or ''))
	end, 9)
	tmp:SetEventListener('OnEditFocusLost', function(this)
		NeP.Interface:Write(table.key, element.key, this:GetText())
	end)
	tmp.text = self:Text(element, parent, offset-3)
	if element.desc then
		element.text=element.desc
		tmp.desc = self:Text(element, parent, offset-element.offset)
		element.offset = element.offset + tmp.desc:GetStringHeight()
	end
	return tmp
end

function NeP.Interface.Statusbar(_, element, parent)
	local tmp = DiesalGUI:Create('StatusBar')
	parent:AddChild(tmp)
	tmp:SetParent(parent.content)
	tmp.frame:SetStatusBarColor(DiesalTools:GetColor(element.color))
	if element.value then tmp:SetValue(element.value) end
	if element.textLeft then tmp.frame.Left:SetText(element.textLeft) end
	if element.textRight then tmp.frame.Right:SetText(element.textRight) end
	return tmp
end
