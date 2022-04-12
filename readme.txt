Phase Encounter Library by vitellary#1950

a library containing a global PhaseEncounter variable, which can be extended to give encounters a series of dialogue and waves based on phases!
to use, make an encounter extend PhaseEncounter instead of Encounter, and add phases and turns using addPhase(), addTurnToPhase(), randomDialogueForPhase() and randomWavesForPhase()
for an example of how to use this, see the example_phase_encounter in the libraries encounters folder

the following is a list of functions that PhaseEncounter uses:

addPhase(turns, index): adds a phase to the encounter.