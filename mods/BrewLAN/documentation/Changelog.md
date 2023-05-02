# BrewLAN changelog

All changes by Sean Wheeldon (Balthazar) unless otherwise stated.

## 0.8.9.9.1

### 2022-02-23

* Added `string.match` and `string.gmatch`.

### 2022-02-25

* "New" mod *Meteor Showers*. By new I mean I started it in 2015 and only just finished it.

### 2022-02-27

* SIO: Added additional fall back for anti-projectile weapons that don't limit target by categories.

### 2022-03-01

* SIO: Fixed `effectiveLayerCaps` not getting `bp`.
* `string.gmatch` now redirects to `string.gfind` instead of re-implementing it.
* Toxotai missile now has a name.
* Meteor Showers: Removed some unneeded data.

### 2022-03-02

* Mild optimisation to Iyadesu.

### 2022-03-03

* Fixed DE language strings having line breaks bricking things.
* Fixed some missing default values in blueprints.lua.

### 2022-03-04

* Penetration: Added a UEF T3 Strike Fighter.

### 2022-03-05

* Penetration: Updated threat values and replaced the UEF aircraft icons.
* R&D: Fixed potentially not making a research item for research locked units.
* R&D: Reduced the energy cost of researching non-penetrator aircraft.

### 2022-03-07

* Moved the Independence Engine size values into the blueprint proper.

### 2022-03-08

* Fixed numerous translation export issues.
* Purged `:GetEntityId()`

### 2022-03-09

* Minted some phat coins.

### 2022-03-10

* Gave node structures the node category to make sure they get the node icon.
* Finished basic coin infrastructure. (New mod)

### 2022-03-28

* Penetration: New (unfinished) Cybran carpet bomber.

### 2022-03-30

* Penetration: Finished the Cybran T3 Carpet Bomber.

### 2022-03-31

* NFTea: Stuff.

### 2022-05-10

* Penetration: New (untextured) tech 1 Cybran carpet bomber.

### 2022-05-12

* Penetration: Finished the Cybran T1 Carpet Bomber.

### 2022-05-19

* Caffe Corretto: Created models for Aeon Engineering, Regen, and Shield Regen nodes.

### 2022-05-21

* Caffe Corretto: Created buff effects for the coming Aeon nodes.

### 2022-05-28

* Caffe Corretto: Finished initial balance for Aeon nodes.

### 2022-05-30

* Added an Aeon T3 mobile TML.

### 2022-05-31

* Added an attach and hat points, death animations, distance models, and text strings for the Aeon T3 mobile TML.

### 2022-06-20

* Fixed the Pillar of Prominence.

### 2022-07-23

* Fixed the description of the mobile air staging.

### 2022-08-07

* Engineering ships can pause now. Cybran T3 engineering ship now shows queue.

### 2022-08-17

* Fixed the `canPathTerrain` function in path marker generator.

### 2022-09-29

* Finished the visuals for the Aeon T3 carpet bomber.

### 2022-09-30

* Finished the Aeon T3 carpet bomber.
* Fixed T3 carpet bomber description clashing with UEF Strike fighter description.

### 2022-10-16

* Added new icon variants large-classic, medium, and medium-classic.

### 2022-11-29

* Overlay category fixes to match reality on 23 units.

### 2022-12-03

* Set spawn menu buttons to use prefs.

### 2022-12-07

* Created a War Table unit.

### 2022-12-08

* Fixed UEF T4 mobile sensor build effects and ability tooltip.

### 2022-12-08

* Created the model and textures for `SRA4212`.

### 2022-12-14

* Finished `SRA4212`; Orlok.

### 2022-12-23

* Potential fix for Craters mod breaking at map edges.

### 2022-12-27

* Started the Aeon T1 Carpet Bomber.

### 2022-12-29

* Finished the appearance of the Aeon T1 Carpet Bomber.

### 2023-01-21

* Added treadmarks for Cybran field engineer front treads.

### 2023-02-12

* Fixed a potential crash with Tea Party if a unit has a non-personal shield without a shield radius.

### 2023-02-21

* Fixed Simurgh being able to assist with constructions, and also prevented it from teleporting structures onto itself if something allows it to again.

### 2023-03-01

* Overhauled the cheat spawn menu.
* Footprint dummy units now use lowercase IDs.
* Fixed a potential non-issue when skirt is smaller than size for footprint dummies.

### 2023-03-05

* Removed some unused stuff from createunit.

### 2023-03-14

* Fixed the cheat spawn callback not checking if cheating is enabled.

### 2023-05-02

* Research dummy units no longer use the dummy class so they don't crash on FAF.
