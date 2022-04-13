# Phase Encounter Library by vitellary#1950

a library for [kristal](https://github.com/KristalTeam/Kristal) containing a global `PhaseEncounter` variable, which can be extended to give encounters a series of dialogue and waves based on phases! each phase contains a series of tables, defining a sequence of turns with data for dialogue and waves to be used at the end of every turn.

to use, make an encounter extend PhaseEncounter instead of Encounter, and add phases and turns using addPhase(), addTurnToPhase(), randomDialogueForPhase() and randomWavesForPhase()

for an example of how to use this, see the [example_phase_encounter](https://github.com/vitellaryjr/PhaseEncounters/blob/main/scripts/battle/encounters/example_phase_encounter.lua) in the libraries encounters folder

## Functions

the following is a list of functions that PhaseEncounter uses:

`addPhase(turns, index)`: adds a phase to the encounter. `turns` is a table containing a series of tables, each defining a single turn (see Defining Turns below to see what each table should contain), and `index` is an optional value that determines what number this phase should be at, defaulting to going after all previously added phases. `index` can also be a string, which allows the player to define a phase that does not come in a sequence numerically  
`addTurnToPhase(turn, phase_index, turn_index)`: adds a turn to a phase. `turn` is a single table defining a turn (see Defining Turns below), `phase_index` is a value determining which phase to add the turn to (defaulting to the current phase), and `turn_index` is a number determining what number this turn should be at in the phase (defaulting to going after all previously defined turns).  
`randomDialogueForPhase(dialogue, index)`: defines random dialogue to be played at the end of a phase; after each turn of a phase has been passed, the encounter will begin randomly selecting dialogue from this value. `dialogue` is a table of values, each defining dialogue to be selected (see Defining Turns below to see how to format defined dialogue), and `index` is an optional value that determines which phase the dialogue should be used for, defaulting to the most recently defined numerical phase.  
`randomWavesForPhase(waves, index)`: defines random waves to be selected from at the end of a phase. `waves` is a table of values, each defining a wave to be selected (see Defining Turns below to see how to format a wave), and `index` is an optional value that determines which phase the dialogue should be used for, defaulting to the most recently defined numerical phase.  
`randomTextForPhase(text, index)`: defines random text to be selected from for encounter text at the end of a phase. `text` is a string or a table of strings that can be selected from, and `index` is an optional value that determines which phase the dialogue should be used for, defaulting to the most recently defined numerical phase.  
`setDialogueOverride(dialogue)`: defines dialogue that will be used a single time, replacing whichever dialogue would be said normally during the turn. `dialogue` is a table of dialogue data (see Defining Turns below to see how to format dialogue).  
`incrementPhase(amt)`: advances the phase of the encounter. is not called automatically by any code; the user must define when they want phases to advance. `amt` is an optional number defining how many phases to advance by (defaulting to 1).  
`incrementPhaseTurn(amt)`: advances the turn count of the current phase. called automatically by `PhaseEncounter:onTurnEnd()`; if you don't want turns to automatically progress, override `onTurnEnd()` for your encounter. `amt` is an optional number defining how many turns to advance by (defaulting to 1).  
`setPhase(index)`: sets the phase of the encounter to the specified index  
`setPhaseTurn(index)`: sets the turn count of the current phase to the specified index  

## Defining Turns

each turn is represented by a table, and can define 3 fields within this table: `dialogue`, `wave`, and `text`. when a turn occurs, it will retrieve data from these three fields every turn to apply encounter text, make enemies say dialogue, and set a specific wave. an example of a turn table looks like this:

```lua
{
  dialogue = {
    [enemy_instance] = "hi!!"
  },
  wave = "example_wave",
  text = "* Something is happening.",
}
```

each of these fields can be defined in numerous different ways. the following sections document all ways one can define each field

### Dialogue

`dialogue` can be defined as a string, a table, or a function
* if `dialogue` is either a string or a table of strings, then the first active enemy in the encounter will say the defined string(s)  
* if `dialogue` is a function, then the function will be called like a [battle cutscene](https://github.com/KristalTeam/Kristal/wiki/Cutscenes), taking a cutscene instance as an argument
* if `dialogue` is a table with either string or EnemyBattler indexes, then each enemy that has an index will say the defined string or table of strings defined for them. when providing string indexes, the string should refer to an enemy's ID; if you need to specify a particular enemy (eg. the second `dummy` enemy in an encounter), you can type the ID followed by a colon and the index of that type of enemy (eg. `dummy:2`)  

### Wave

`wave` can be defined as either a string or a table
* if `wave` is a string, it will be used as the wave ID to be selected
* if `wave` is a table of strings, it will randomly select a string to be used as the wave ID
* if `wave` is a table with string indexes, it can define the fields `wave` and `enemy`: `wave` will be the wave ID or a table of random wave IDs to be used, and `enemy` is either an enemy ID or an enemy instance which will be used to get which enemy the wave should be associated with (used by bullets to determine how much damage to deal). if `enemy` is not defined for a wave, then a random active enemy will be selected

### Text

`text` can be defined as a string to be used at the start of a turn
