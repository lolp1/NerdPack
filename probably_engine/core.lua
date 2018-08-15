local _, gbl = ...

gbl.PE = {}

if ProbablyEngine then
  gbl.core:Print('Found ProbablyEngine, not attaching our load.\nNeP can read ProbablyEngine\'s combat routines if you disable it.')
  return;
end

ProbablyEngine = gbl.PE
