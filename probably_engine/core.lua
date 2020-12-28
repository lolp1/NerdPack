local _, NeP = ...

NeP.PE = {}

-- STOP if PE is actualy loaded
if _G.ProbablyEngine then
  NeP.core:Print('Found ProbablyEngine, not attaching our wrapper.'
  .. 'NeP can read ProbablyEngine\'s combat routines if you disable it.')
  return;
end

_G.ProbablyEngine = NeP.PE
