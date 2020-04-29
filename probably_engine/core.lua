local _, gbl = ...

gbl.PE = {}

-- STOP if PE is actualy loaded
if _G.ProbablyEngine then
  gbl.core:Print('Found ProbablyEngine, not attaching our wrapper.'
  .. 'NeP can read ProbablyEngine\'s combat routines if you disable it.')
  return;
end

_G.ProbablyEngine = gbl.PE
