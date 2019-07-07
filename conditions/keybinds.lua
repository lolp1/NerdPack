local _, NeP = ...
local _G = _G

local KEYBINDS = {
  -- Shift
  ['shift']    = function() return NeP._G.IsShiftKeyDown() end,
  ['lshift']   = function() return NeP._G.IsLeftShiftKeyDown() end,
  ['rshift']   = function() return NeP._G.IsRightShiftKeyDown() end,
  -- Control
  ['control']  = function() return NeP._G.IsControlKeyDown() end,
  ['lcontrol'] = function() return NeP._G.IsLeftControlKeyDown() end,
  ['rcontrol'] = function() return NeP._G.IsRightControlKeyDown() end,
  -- Alt
  ['alt']      = function() return NeP._G.IsAltKeyDown() end,
  ['lalt']     = function() return NeP._G.IsLeftAltKeyDown() end,
  ['ralt']     = function() return NeP._G.IsRightAltKeyDown() end,
}

NeP.DSL:Register("keybind", function(_, Arg)
  Arg = Arg:lower()
  return KEYBINDS[Arg] and KEYBINDS[Arg]() and not NeP._G.GetCurrentKeyBoardFocus()
end)

NeP.DSL:Register("mouse", function(_, Arg)
  Arg = tonumber(Arg:lower())
  return NeP._G.IsMouseButtonDown(Arg) and not NeP._G.GetCurrentKeyBoardFocus()
end)
