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
