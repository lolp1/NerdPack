local NeP, g = NeP, NeP._G

local KEYBINDS = {
  -- Shift
  ['shift']    = function() return g.IsShiftKeyDown() end,
  ['lshift']   = function() return g.IsLeftShiftKeyDown() end,
  ['rshift']   = function() return g.IsRightShiftKeyDown() end,
  -- Control
  ['control']  = function() return g.IsControlKeyDown() end,
  ['lcontrol'] = function() return g.IsLeftControlKeyDown() end,
  ['rcontrol'] = function() return g.IsRightControlKeyDown() end,
  -- Alt
  ['alt']      = function() return g.IsAltKeyDown() end,
  ['lalt']     = function() return g.IsLeftAltKeyDown() end,
  ['ralt']     = function() return g.IsRightAltKeyDown() end,
}

NeP.DSL:Register("keybind", function(_, Arg)
  Arg = Arg:lower()
  return (KEYBINDS[Arg] and KEYBINDS[Arg]() or g.IsKeyDown(Arg:upper())) and not g.GetCurrentKeyBoardFocus()
end)

NeP.DSL:Register("mouse", function(_, Arg)
  Arg = tonumber(Arg:lower())
  return g.IsMouseButtonDown(Arg) and not g.GetCurrentKeyBoardFocus()
end)
