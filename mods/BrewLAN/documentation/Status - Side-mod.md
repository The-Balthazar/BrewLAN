# Side-mod status

## BrewLAN modules
Mods that require BrewLAN to be functional. For the most part these are totally dormant if they are enabled and BrewLAN isn't.

### BrewLAN UI
#### Engineer Tab
Field engineer UI changes. Completely inactive without BrewLAN, even while enabled.
* Overwrites the two functions completely when active.
* Completely optional, for compatibility.
* Is overwritten by the support commander upgrade manager thing in GazUI and such.

#### Spawn Menu
Replaces the alt-f2 cheat spawn menu.
* Has filters for active mods.
* Works on all versions of Supreme Commander including the original.
* A slight variant is included with both FAF and LOUD.

### BrewLAN: Gantry AIx 1–3
* These are difficulty increasing AIx cheat mods that affect the Gantry, and give it increased production speed. With different caveats.
  1. Linear increases in build speed and resource cheats over time.
  2. Player-mass gated exponential increase in build speed and resources.
  3. Like 2, but offers discounts instead of resources.
* These also function as demonstrations on modding other mods non-destructively.

### BrewLAN: Gantry Homogeniser
Makes all the faction Gantries function the same. Graphically this looks weird with some of them.

## Extra units
Units that I wanted to make, but either I didn't want directly in BrewLAN, or caused such a difference in gameplay that they should be optional.

### BrewLAN: Bubble Tea
Adds experimental shields.
* Aeon shield doesn't work on FAF.

### BrewLAN: Caffe Corretto
Adds lots of extra turrets.
* Turrets are built by field engineers, so requires BrewLAN.
* Has no criteria for being 'finished' as a mod; it's just turrets.

### BrewLAN: Research & Daiquiris
Functionally separates the hardware and software of tech levels and blueprints.
* You unlock tech levels by researching them, and everything gets to build the new things.
* Contains units that don't fit in Bubble Tea or Caffe Corretto.
* Adds tech level research and generates research items for some units.
* Adds new units:
  * Tech 1-3 Research Centre (3 per faction)
  * Tech 1-3 Hovercraft Factory (3 for Aeon)
  * Tech 1 Wind Turbine (Each faction)
  * Tech 1 Tidal Generator (UEF and Seraphim)
  * Tech 2 Light Power Generators (Each faction)
  * Tech 3 Omni-Sensor (UEF/Aeon/Cybran)
    * Standard Tech 3 Omni-Sensor structures are now just radar.
* Currently missing planned units:
  * Dedicated omni sensor (Seraphim)
  * Tidal Generator (Cybran/Aeon)
  * Hovercraft Factory (Seraphim) maybe (UEF/Cybran)
  * Submarine factory (UEF/Cybran/Aeon/Seraphim)
  * Possibly an implementation of seaplane factories.

### BrewLAN: Penetration
Adds alternative tech 2 air units, and extended tech 3 air units:
* Tech 2 Tactical Bomber (Each faction except Aeon which is directly in BrewLAN)
* Tech 2 Combat Fighter (UEF)
* Tech 3 Penetrator Bombers (Each faction)
* Tech 3 Penetration Fighters (Each faction)
* Tech 3 Interdiction Gunships (Cybran)
Planned:
* Fighter/Bomber (Aeon)
* Combat Fighters (Cybran/Seraphim)

### BrewLAN: Magnum Dong
Adds new experimental units:
* Experimental Mobile Artillery (Cybran)

## Gameplay
Mods that alter gameplay in a fixed way, and new game modes.

### Antimass
Swaps mass and energy production.
* Multiplies the new energy production by 10.
* Divides the new mass production by 10.

### Corrosive Ocean
* Being in the water cause exponential damage.
* Maybe play on a map with HOT LAVA graphics instead of water.

### Crystal Hill
* King of the hill style: Spawns a crystal dead center of the map.
  * Controlling it at the end of 20 mins causes game win.
  * A change of hands below the 5 minute mark causes the time to increase back to 5 minutes.
* While spawning the crystal will remove the nearest civilian building in the area, and will occupy its space. If any area near enough.
* Fully functional except the AI doesn't care yet.
* Language strings exist for English, German & French.

### Metal World
* Removes MEX position requirements, and mass points.
* Fully functional, except real AI control.
  * AI gets some hardcore hax to prevent breaking them. (For sorian AI.)

### Paragon Game
* Few vs Many asymmetric style gameplay.
  * Player(s) on the smallest team(s) get a paragon, SACU, and shields.
* Uses all default language strings.

### TeaD
* Tower Defense mod. Where you defend a cup of tea.
* Not finished, but functional.

### Waterlag
* Adds aquatic abilities to each building that isn't a factory, wall, silo, or experimental.
* Spawns an entity that looks like legs underneath UEF and Cybran buildings that were made aquatic by waterlag and don't have defined floatation bones.

## RNG bullshit
Mods that alter gameplay with random effects.

### Cost Variance
* Adds a +/- 50% random cost variation to all non-economic units, and alters some stats to match.

### Crate Drop
* Adds a random Tiberian Sun style crate drop.
  * Rewards include hats.

### Lucky Dip
* Designed as mod for situations where you have two mods that you want to run, but both add overlapping units, and you don't want the overlap.
* It situations it is programmed to handle, for each player, it will go through each set of 'conflicts', and disable all but one of them.
* In situations where not all the mods are enabled, it will choose from the existing units in each conflict set.
* It is only partially set up for BlackOps and BrewLAN, and also some of the FAF versions of the BlackOps units.
* Do you get a Manticore this game or a Hades? How about your opponent?
* Conflicts are defined in the /hook/lua/aibrain.lua file, in an easy to edit way.

## Plenus
Satisfaction guaranteed; mods with sim-side aesthetic changes and meta-mods.

### Damage Numbers
* Creates damage number popups.
* You can only see popups on your units, so that's where they appear for you.

### Experimental Icons Overhaul
* Doesn't work on FAF for scd reasons.
* Dynamically changes units experimental icons from a circle to something useful.
  * Has a system that includes comparative weapon DPS for deciding icons.
* Specifically tested for use with Total Mayhem, Experimental Wars, BlackOps, 4th Dimension, and X'Treme Wars.

### Pulchritudinousity
* For taking better screenshots:
  * Increases the view distances of models and tarmacs 1000x.
  * Makes spawned in units auto-give themselves tarmacs.

### Expert Camo
* Framework mod for alternative unit skins.
* Not currently utilised by any BrewLAN mod.
* Was developed for one idea that was ultimately dropped, and another that has yet to be attempted.
* Included because it the GOBIS of unit reskins.

### Debug tools
* Not recommended for regular gameplay, especially around Cybran.
* Creates a large number of log outputs for unit location, LOUD threat, DPS calculations, ect.
* Includes a unit that can be shot and calculates the effective DPS of the units.
  * This is output into the log in a format that is CSV friendly.

### Baristas
* Lists each units origin mod.
* This only accounts for units that existed at run time.
* Some script altered and/or script created units may not be represented.
