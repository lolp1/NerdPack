local NeP, g = NeP, NeP._G

NeP.Init = {}

NeP.CR.current_spec = g.GetSpecializationInfo(g.GetSpecialization());
NeP.Interface.ResetCRs()
NeP.CR:Set()

NeP.Listener:Add("NeP_CR", "PLAYER_SPECIALIZATION_CHANGED", function(unitID)
	if unitID ~= 'player' then return end
	NeP.CR.current_spec = g.GetSpecializationInfo(g.GetSpecialization());
	NeP.Interface.ResetCRs();
	NeP.CR:Set()
end)

NeP.Listener:Add("NeP_CR", "PLAYER_ENTERING_WORLD", function()
	local current_spec = g.GetSpecializationInfo(g.GetSpecialization())
	if current_spec == NeP.CR.current_spec then return end
	NeP.CR.current_spec = current_spec;
	NeP.Interface.ResetCRs();
    NeP.CR:Set()
    NeP.Buttons:UpdateButtons()
end)

NeP.Listener:Add('NeP_Buttons','ACTIONBAR_SLOT_CHANGED', function ()
	NeP.Buttons:UpdateButtons()
end)