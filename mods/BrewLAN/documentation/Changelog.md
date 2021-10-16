# BrewLAN changelog

All changes by Sean Wheeldon (Balthazar) unless otherwise stated.

## 2020-03-30|0.8.9.1

* Debug tools: Prevented the DPS test units from trying to rename projectiles.

  ### 2020-04-27

  * Started rework of Abyss Crawler to have legs instead.

  ### 2020-05-05

  * Altered the leg animation of the Abyss Crawler to be 8 phase rather than 2 phase.
  * Adjusted the turn circle and other movement characteristics of the Abyss Crawler to work better with the walk animation.

  ### 2020-05-13

  * Changed tarmac calls happening before the parent OnCreate class, which now breaks FAF, because they rejected my fix for the timing issue they added in that function.
  * Added a break in the blueprints.lua to prevent duplicate categories.

  ### 2020-05-17

  * Fixed the shading groups on the Cybran T2 mass storage.

  ### 2020-06-04

  * Rebalanced the Aeon engineering station, moved it from Paragon Game to BrewLAN, and recreated the appearance.

  ### 2020-06-06

  * Fixed the strategic icon of the Aeon engineering station.

  ### 2020-06-10

  * R&D: Removed the adjacency definitions for the old size of Gantry.

  ### 2020-06-11

  * Crystal Hill: Lobby options now loaded by FAF.
    * Renamed some of the variables for clarity.
  * TeaD: Lobby options will now loaded by FAF.
  * Crate Drop: Lobby options will now break the lobby options of the other two on FAF, for no good reason I can identify.
  * Update the language documents. Mostly for the lobby strings move from SCD.

  ### 2020-06-17

  * Spawn Menu: Gave it the ability to dynamically categorise by mod.
  * Spawn Menu: Removed the Product category.

  ### 2020-06-20

  * Spawn Menu: Added code for truncating long mod names semi-intelligently.

  ### 2020-06-22

  * Spawn Menu: Added code for wrapping the mod name buttons and expanding the text area.

  ### 2020-06-23

  * Spawn Menu: Fixed an error if BrewLAN isn't enabled.
  * Spawn Menu: Renamed the Mod tab to Source, and added a 'Core Game' initial option.

  ### 2020-06-25

  * R&D: Added the Seraphim Pentration Fighter.

  ### 2020-07-07

  * Crate Drop: Minimum crates is now 1. Affects maps smaller than 5k.
  * Crate Drop: Will now reroll if Unit:AddKills() isn't a function. (FAF)

  ### 2020-07-15

  * Finished the model for the new Seraphim Experimental Sniper Bot.

  ### 2020-07-20

  * Finished the Seraphim Experimental Sniper Bot.

  ### 2020-07-22

  * Spawn Menu: Fixed a minor spacing issue when exactly 6n-1 mods were enabled.

  ### 2020-08-03

  * R&D: Started the Cybran T3.5 Gunship.

  ### 2020-08-05

  * R&D: Finished the appearance of the Cybran T3.5 Gunship.

  ### 2020-08-06

  * Caffe Corretto: Fixed the smoothing groups on the UEF T2&3 AAPDs and T3 PD, and replaced the icons.
  * Updated the distance models and icon for the Abyss Crawler.
  * Created icons for several unselectable and placeholder units.
  * Updated and rearranged status doc.

  ### 2020-08-08

  * Fixed UEF ACU and SACU drones causing a script error when a parent Iyadesu dies.

  ### 2020-08-09

  * MD: Started the Seraphim abomination class experimental.

  ### 2020-08-10

  * Restructured the scripts for engineering structure units.

  ### 2020-09-11

  * MD: Finished the model of the Seraphim abomination class experimental.
  * Set up infastructure for walking units to have the walk animations reverse when going backwards.
  * Gave the following walking units the ability to go backwards, or fixed moonwalking for:
    * Sisha-Ah: Experimental Sniper Bot - Can now go backwards
    * Iyadesu: Experimental Reconstruction Engineer - No longer moon-claws
    * Abyss Crawler: Experimental Transport - Can once again go backwards

  ### 2020-09-14

  * Fixed the Absolution not being able to path through structures.
  * Changed Gantry restriction filtering so that units with both the LAND and NAVAL categories are buildable during both modes.
  * UI Spawn menu: Changed filters so amph-floating units aren't restricted from the land category if they also have the naval category, and visa versa.
  * R&D: Fixed the Seraphim penetration fighter icon having no alpha.

  ### 2020-09-17

  * R&D: Fixed wind turbines dying just before updating causing an error.

  ### 2020-09-21

  * MD: Finished the Seraphim abomination Suedath-Zmara, after over 40 hours total work hours.

  ### 2020-09-22

  * Rebranded unit mods to have the "BrewLAN: " prefix.
  * Optimised the Arthrolab to use worldspace sliders instead of personal sliders with a multiplier.
  * Independence Engine now limits the platform height to the flight elevation of the unit being built.
  * R&D: Seraphim tidal generator will now leave a wreck.

  ### 2020-09-23

  * R&D: Added UEF Tidal Generator.
  * Moved the aircraft from R&D to a new mod *BrewLAN: Penetration*.
  * Moved the Retributor from R&D to *BrewLAN: Magnum Dong*, the big spooky experimental units mod.
  * Air: AI that use the Sorian CustomUnits docs will now build the T3.5 aircraft, and the T2 UEF Combat Fighter.
  * Spawn Menu: Name filter will now always reduce "BrewLAN:" to "BL:".
  * Spawn Menu: Added a non default faction category
  * Spawn Menu: Simplified the 'Type' category filters, and added a 'Surface' category for floaters and hover units.
  * Spawn Menu: Refined the search criteria for research items.
  * Spomeniki: Fixed the T2 categorised Mars rovers having tech 1 factory built categories.

  ### 2020-09-24

  * Adjusted the balance of the Seraphim Experimental Sniper.
  * Adjusted the walk animation of the Seraphim Experimental Sniper so it no longer noticeably self intersects with the body.
  * Removed the heading arc limitations from the Solaris.
  * Reduced the selection area of the Ivan so it no longer counts sections below the ground.

  ### 2020-09-25

  * Reworked Ivan, mechanically:
    * Removed the scripted repeat orders function and buttons.
      * It now just does it if it's not told to stop.
        * Bug: Building 3 or more while it has active attack orders results in it a volley of firing 3 before continuing building, and giving max velocity to the last of the three, usually causing it to leave the map.
        * If more than 3 are being made, excess will be stockpiled.
    * Gave it the ability to pause.
    * Added construction sound effects.
    * Capped the number of prepared drop-pods to 999.
    * It no longer deletes units when it finishes building them:
      * Created units are stored like a carrier
      * Drop pods are given the actual units to transport rather than just the ID
      * You can now see what is actually inside the Ivan
      * You can now see what is in the drop pod projectiles
    * On shield-hit behaviour for the new style is currently undefined.
    * Units can be removed from the structure directly, with weird undesired effects.
    * Stored units surviving the artillery getting destroyed is currently non-functioning.

  ### 2020-09-26

  * Added an extra filter field to the cheat spawn menu for menu sort.
  * The fix for bombers killing themselves against the Iron Curtain now passes normal damage.
  * Bubble shields now disable when getting shoved in Ivan drop pods.
  * Units that come out of drop pods can now be targeted correctly.
  * Personal shields get reset if the unit was in a drop pod that impacted a shield.
  * Units that have fallen out of drop pods that impacted a shield are now stunned for a duration proportional to the fall distance.

  ### 2020-09-28

  * Increased Ivan attack ground tries, so it will fire volleys of 10 before it goes back to building again.
  * Drop pod units that impact shields now take fall damage proportional to the distance, their size, and their max health.

  ### 2020-10-03

  * Ivan now uses a separate dummy unit to store units so that deployed units aren't destroyed when the Ivan is.

  ### 2020-10-05

  * Units in drop-pod storage can now survive the artillery dying again.

  ### 2020-10-08

  * Scarab can now walk backwards.
  * Fixed drop pod units being able to see what's below the pod while in the air.
  * Ivan no longer uses the dummy unit storage method and now fakes it locally.
  * Ivan now has a deploy button for ejecting units from the base.
    * The target location isn't respected.
  * Units fired from Ivan no longer have visio of the ground below the drop pod.

  ### 2020-10-20

  * UEF T3 anti-tactical: Trickshot changes:
    * Shrunk by around 28%.
    * Moved the treads slightly further out on the model.
  * Started work on an auto-path node generation script.

  ### 2020-10-21

  * Progressed on path node generation script, accurate unpathable map, ect.

  ### 2020-10-23

  * Finished the LoS function for the path node generation script.

  ### 2020-10-27

  * R&D: Moved wind thread generation out of CreateResources and into CreateInitialArmyGroup so it doesn't get killed by Adaptive maps.
  * R&D: Moved the R&D AI init functions into OnCreateAI and CreateBrainShared and out of CreateInitialArmyGroup.
  * R&D: Restructured BrewRND AI table so it no longer creates instancing issues.
  * R&D: Instances of the BrewRND AI table now gets `nil`'d once all research is complete.
  * Seraphim T1 shield, on death now checks it has an animator to destroy before trying to destroy it.
  * R&D: Removed some unused values from the research centre bp's.
  * R&D: Prevented research centres from being added to factory builder managers.
  * R&D: Commented out some log and warning events.

  ### 2020-10-31

  * Finished the basic features of the path marker generator script. Still to do:
    * It doesn't check for unpassable terrain types.
    * It doesn't check for water, and just outputs amph nodes.
    * It doesn't generate midway markers for long path sections.
    * It doesn't generate for large flat areas a long distance from any unpassable features.
    * It doesn't deal with "alcoves" inside a single unpassable feature.

  ### 2020-11-03

  * Pathfinder script changes:
    * Now uses VDist2Sq instead of VDist2 (speeds it up by around 30-50%).
    * Now takes into account unpassable terrain types.
    * Now uses heap instead of stack for tracking contiguous areas (prevents stack overflow on some maps).
    * Removed some unnecessary data tracking that is no longer referenced by the script.
  * Did more work on the model and texture of Trickshot.

  ### 2020-11-08

  * Wall and gate script changes:
    * Gate slider now uses world-space units instead of unit-space * the difference.
    * Tarmac texture now applied at the same time as other units, instead of on create.
    * GetBlueprint references cleaned up and replaced for efficiency.
  * Footprint dummy unit no longer causes errors when used by mines and wall gates for path blocking/unblocking.

  ### 2020-11-12

  * New mod: *BrewLAN: Tea Party*, for the new commissioned unit: Deluge Class; an Aeon dreadnought-type battlecruiser.

  ### 2020-11-14

  * Turrets: Created a new proof-of-concept adjacency node that buffs the health of units built by a factory.

  ### 2020-11-15

  * Turrets: Created a Cybran factory adjacency node that activates or deactivates factory built unit stealth and/or cloak.
  * Turrets: Refined the factory health node to use the new factory adjacency node scripts.

  ### 2020-11-17

  * Brew Air: Fixed the cloak on the penetration fighters.
  * Brew Air: Finished Xiphos: Cybran T3 Interdiction Gunship.

  ### 2020-11-18

  * Fixed Trickshot having Structure armour instead of Normal armour.
  * Brew Air: New Cybran experimental based off the Arsenal Bird.

  ### 2020-11-19

  * EIO: Factory type check will now check the categories of blueprint-ID defined build categories.
  * EIO: Will now ignore weapon categories on a unit if it only has death weapons.
  * EIO: Now distinguishes between 10k+ damage and 50k+ nuke weapons. (Large icons only)

  ### 2020-11-20

  * EIO: Re-exported all icons with better compression.
  * EIO: Small icons now has the nuke size differentiation.
  * EIO: Large is now available to the public.

  ### 2020-11-23

  * New mod: *Cityscapes*. Generates civilian cities at unused player locations on maps with a defined civilian player.

  ### 2020-11-24

  * Cityscapes: The very basics of UEF city generation is complete.
  * Cityscapes: Now clears props from roads, cleans up the planning units, spawns lamp posts, and spawns vehicles.

  ### 2020-11-25

  * Cityscapes: City generation planning now has waits when removing a failed segment to prevent it from affecting future attempts.
  * Cityscapes: City generation planning now randomises the order of directions it will crawl.
  * Cityscapes: City generation planning now ends after a random number of crawls instead of fixed, leading to less diamonds.
  * Cityscapes: Structure selection weights changed so that the Samantha Clarke statue can actually actualy spawn.
  * Cityscapes: Vehicle selection weights changed so that the truck can actually spawn.
  * Cityscapes: Replaced the if-else block on roads with a binary table switch.
  * New mod: *BrewLAN: Bletchley Park*, houses intel units that used to be packaged with R&D.
  * Re-keyed the build description LOC tags for units moved out of R&D.
  * Cityscapes: Added textures for 0-way road connection.

  ### 2020-11-27

  * R&D: AI's that don't properly handle the builder limit restriction for building research centres will now cancel additional centres.
  * R&D: All research items now are glowy messes instead of using default shaders.

  ### 2020-11-28

  * TeaParty: Deluge now has a unique 69th variant.

  ### 2020-12-01

  * Created new mod icons for Cityscapes and TeaParty.

  ### 2020-12-02

  * Cityscapes: Fixed prop removal co-ordinates
  * Cityscapes: Fixed the 4 way road being flipped.
  * Cityscapes: Agricultural structures can now spawn in blocks.
  * Cityscapes: Added basic walls around the cities.
  * Cityscapes: Added turrets along border walls.
  * Cityscapes: Civilian structures involved in city generation now have no pop cap cost.
  * Cityscapes: Each city now has a power generator based on its size.

  ### 2020-12-03

  * Cityscapes: City generation is now split into simultaneous threads, one per city.
  * Cityscapes: Individual city threads will now abort the city if it fails to spawn a power generator.
  * Cityscapes: Small structures are now processed before roads to allow small cities to also be cancelled if they fail to spawn a generator.
  * Cityscapes: Added an icon and build description for the civilian city wall.
  * Cityscapes: Refactored code so that it can support random factions per city.
  * Cityscapes: Added basic versions of Aeon and Cybran faction city generation as reskins of the UEF. They don't look as good yet.
  * Cityscapes: UEF city generation now includes the large admin structure.

  ### 2020-12-04

  * Fixed the following blueprints.lua functions from causing crash on diskwatch of merge bps.
    * R&D: TableFindSubstrings
    * BubbleTea: BubbleTeaRubbsOffGazUI
  * Cityscapes: Moved the Samantha Clarke statue from small structures to large, so it gets an entire block.
  * Cityscapes: Did a balance pass on UEF building health and costs, corrected hitboxes, reduced skirts, and unified LOD cutoffs.
  * Cityscapes: Added a kitbashed large residential building.
  * Cityscapes: Changed the popcap break condition.
  * Cityscapes: Changed the normals on the UEF wall.

  ### 2020-12-05

  * TeaParty: Fixed a tautological check.
  * Cityscapes: Moved city data and generation function out of the script and into ScenarioUtilities.lua.
  * Cityscapes: Moved the Aeon and Cybran city data out into their own mods.
  * Cityscapes: Generation crawler will no longer retry places if it already crawled to them from a different direction.
    * This speeds up generation by around a factor of 4 or more.
  * Cityscapes: Fence props will now spawn around some large structures, and small power generators.
  * Cityscapes: "car park" prop groups can now spawn in some empty spaces and in dead-end painted carparks.
  * Cityscapes: City radius setting now moved into data.
  * Cityscapes: Replaced the truck prop with one that's the correct size, and made it more common.

  ### 2020-12-06

  * Cityscapes: The unit spawn function will now run the weighted bp get function recursively for nested blueprint sets.
  * Cityscapes: Added a BlueprintId value to the city blueprint for external reference.
  * Cityscapes: Generation script can now handle both props and units.
  * Spomeniki: Now adds most of it's props into the Cityscapes UEF city generation.

  ### 2020-12-07

  * Tea Party: Deluge shield impact script now scales with size changes that may happen to it.
  * Tea Party: Added a launch script to give anti-shield weapons better target priorities.
  * Crate Drop: Fixed the FAF lobby option from breaking all FAF lobby options.
  * Cityscapes: Generation script now has a radius override.
  * Cityscapes: Location selector script now has lobby options.

  ### 2020-12-08

  * Removed some unneeded imports from walls.lua, and added copyright info.
  * Cityscapes: CreateSquareBlockCity function can now support rectangular blocks.

  ### 2020-12-09

  * FAF lobby will now load LOC files for Crate Drop, TeaD, Crystal Hill, & Cityscapes.

  ### 2020-12-11

  * Cityscapes: Added new lobby option to define team of cities spawned around players, and to pick additional starting locations.
  * Cityscapes: Fixed an error related to a data table potentially not existing.
  * Fixed the Vaxis hologram having a broken model.
  * Reverted "Removed some unneeded imports from walls.lua". It was needed.
  * Fixed BrewLAN loading after R&D and breaking things in FAF.
  * Fixed wall tarmacs being applied at the wrong time.
  * Bubble Tea: Fixed Aeon shield on FAF.
  * Bubble Tea: Moved the projected shield size calculations to the projectee.
  * Bubble Tea: Projected shield position not takes into account Y collision offset.
  * Cityscapes: Created icon for wide residential structure.
  * Caffe Corretto: Created icon for factory nodes.
  * Caffe Corretto: Fixed factory stealth node having the wrong description.
  * Cityscapes: Set up lobby options for outside of FAF.

  ### 2020-12-13

  * Waterlag: Made the leg check more efficient and no longer use categories.
  * Cityscapes: New skyscraper structure and new vehicle.

  ### 2020-12-14

  * Special fabricators now use the dynamic balance function.
  * Renamed Gantry Homogeniser so it no longer has "BrewLAN" in the name.
  * Fixed a broken script link in the Darkness.

  ### 2020-12-15

  * Cityscapes: Two new skyscraper structures.

  ### 2020-12-16

  * Penetration: Tomcat burst cannons are no longer restricted to air units, but can now only target units in the air.
  * Penetration: Tomcat missiles can now only target aircraft, but on any layer.

  ### 2020-12-17

  * Cityscapes: Added a distance model to the skyscraper that was missing it.

  ### 2020-12-18

  * Pathfinder script:
    * Now has a toggle for land/water/amph path nodes.
    * (Done previously but only just versioned:) Added an option for a cut off for ignoring small contiguous areas of blocking.

  ### 2020-12-19

  * Fixed the shading groups of the Bessemer Reactor.

  ### 2020-12-20

  * Changed parts of the textures of the Retributor.
  * Cityscapes: Fixed city generation threads that hadn't made it out of the planning phase before pop cap was reached leaving the planning structures behind.
  * Cityscapes: Set up the planning script for city docks.

  ### 2020-12-22

  * Cityscapes: Set up basics for city dock generation.

  ### 2020-12-27

  * Cityscapes: Largely, but not completely, finished dock generation.

  ### 2020-12-28

  * Cityscapes: Added small ships to dock generation.

  ### 2020-12-29

  * Cityscapes: Fixed the ship spawn function on north/south facing docks.

  ### 2021-01-11

  * Pathfinder script: Added a output visualisation to the generation script.

  ### 2021-01-12

  * Pathfinder script: Water path nodes no longer take the seabed into account, and take MinWaterDepth into account.
  * Pathfinder script: Amphibious nodes now take MaxWaterDepth into account.
  * Pathfinder script: Added some basic toggles and controls to the control unit for easier testing.
  * Pathfinder script: Changed some variable names, added a grid infill for flat areas, and added some more visualisation options.

  ### 2021-01-13

  * Pathfinder script: Created voronoi edge culling function options.
  * Pathfinder script: Started grid contiguous check option.

  ### 2021-01-14

  * Pathfinder script: Finished grid contiguous check option.
  * Pathfinder script: Cleaned up some variables and comments.

  ### 2021-01-15

  * Pathfinder script: Set the voronoi edge cull value to be easier to configure.

  ### 2021-01-28

  * Cityscapes: Crane now generates over a container prop, instead of randomly down the whole pier, fixing bad crane position spawns.
  * Cityscapes: Added a gradient flatten function that adds a slopes along the road to a pier, fixing "drive off a cliff" roads.
  * Cityscapes: Last set of containers that spawn now flatten under themselves just in case it was only flat in the middle.

  ### 2021-01-30

  * Fixed the Seraphim Armoured Fabricator losing it's regen on FAF.

  ### 2021-02-01

  * Defined Class1Capacity for transports.

  ### 2021-02-03

  * Bletchley Park: Finished the texture of the UEF experimental mobile sensor.

  ### 2021-02-04

  * Bletchley Park: Renamed the Coleman sensor to the Welchman, after Gordon Welchman.
  * Bletchley Park: Balanced and created text strings for the experimental mobile sensor.
  * Removed hard references to the BrewLAN UID.
  * Replaced references to the PRODUCTBREWLAN category with references to bp.Source.
  * Changed the BrewLAN path function into a string, so it's only called once.
  * Removed the PRODUCTBREWLAN category from all units.
  * Cleaned up the blueprints of the Aeon aircrafts and buildings.
  * Fixed the armour class of the Orbos.
  * Simplified the target priorities of the Nihiloid.

  ### 2021-02-05

  * The upgrade assignment function no longer assumes tables exist, and checks first.
  * Added a distance model to the Aeon T2 mass storage.
  * Fixed formation move for the Absolution.
  * Flame Lotus can now leave a wreckage on the seabed.
  * Cleaned up the blueprints of the Aeon land units, UEF units, and Cybran aircraft.
  * Fixed Vaxis jammer holograms not having a defined movement speed.
  * Fixed a nil recoil value on the Patch Class engineer boat.
  * Fixed the tread scrolling on the UEF T1&3 field engineers. Which I'm fairly sure I'd fixed before.
  * Realigned the treadmarks on the UEF T1 field engineer.
  * Unified the selection outlines of the UEF field engineers.

  ### 2021-02-06

  * Removed the TeaD build categories from units.
  * Scripted TeaD to actively search for things that look like turrets to make buildable.
  * Set the floating mines (T2 & T3) to be built on the sub layer, rather than the water layer.
  * The slope to terrain script now only triggers on land and seabed, instead of not-water.
  * Mine collision boxes are no longer out of align when built on the sub layer.
  * Optimised some GetBlueprint function calls.
  * Cleaned up the blueprints of Cybran structures.
  * TeaD: Cleaned up the blueprints.
  * TeaD: Removed the Cybran creep units.
  * TeaD: Removed the `PRODUCTTEAD` category.

  ### 2021-02-07

  * Cleaned up the blueprints of Cybran land units and ships, and all Seraphim units.
  * Fixed the Seraphim experimental factory not leaving a wreckage.
  * Fixed the Seraphim field engineers not leaving wrecks on the seabed.
  * Made hologram units silent.
  * Updated translation documents.

  ### 2021-02-08

  * Paragon Game: Cleaned up the blueprints and removed the `PRODUCTPARAGONGAME` category.
  * Spomeniki: Cleaned up the blueprints and removed the `PRODUCTSPOMENIKI` category.
  * Fixed the Seraphim assault bot bp broken in that phase of the cleanup.
  * Crate Drop: Cleaned up the blueprints and removed the `PRODUCTCRATEDROP` category.
  * Magnum Dong: Cleaned up the blueprints and removed the two mismatched PRODUCT categories.
  * New mod: Wonky Resources. Allows extractors and hydrocarbons to be built on wonky terrain.

  ### 2021-02-09

  * Debug Tools: Created a script to identify some issues with unit strategic icons.
  * Fixed Sera T3 assault bot having a generic land unit icon instead of a bot icon.
  * R&D: Research Centres now have new research factory icons instead of generic structure icons.
  * Novax centre now has a new intel factory icon instead of intel structure icon.
  * Scarab now has a new antimissile bot icon instead of antimissile land icon.

  ### 2021-02-10

  * Created graphics for all new strategic icons.

  ### 2021-02-11

  * Finished a script to assemble all the strategic icons.
  * Created new strategic icon sets, large and small. (around 8k image files).
  * Changed the Penetrator Bombers to use `icon_bomber3_missile` instead of `icon_bomber3_directfire` and cleaned up their blueprints.

  ### 2021-02-13

  * Caffee Corretto: Cleaned up the blueprints and removed the `PRODUCTBREWLANTURRETS` category.
  * Caffee Corretto: Changed the icon of the damage boost node from `icon_structure3_generic` to `icon_node3_directfire`.
  * Caffee Corretto: Fixed the Maelstrom not leaving a wreck on water.
  * Caffee Corretto: Changed the icon of the factory health node from `icon_structure3_generic` to `icon_node3_cross`.
  * Caffee Corretto: Changed the icon of the accuracy boost node from `icon_structure3_generic` to `icon_node3_artillery`.
  * Caffee Corretto: Changed the icon of the factory stealth toggle node from `icon_structure3_generic` to `icon_node3_counterintel`.
  * Changed the icons of the satellites from `icon_fighter_` to `icon_satellite3_`.
  * Removed the observation satellite AI names from the counterintel satellite.
  * Tea Party: Removed the `PRODUCTBREWTEAPARTY` category.
  * Bubble Tea: Removed the useless pause command, the `PRODUCTBREWLANSHIELDS` category, and cleaned up the blueprints.
  * R&D: Cleaned up the Aeon blueprints.

  ### 2021-02-14

  * Fixed an Iyadesu exploit where you could reclaim the drone and keep the recipes forever.
  * Fixed an exploit with the lattice shield where you could reclaim the tower and keep the drones.

  ### 2021-02-15

  * R&D: Fixed AI not being able to upgrade research centres.

  ### 2021-02-18

  * Caffee Corretto: Fixed the name of the Factory Stealth Node not having the correct LOC tag.
  * Cityscapes: Fixed container reclaim randomisation breaking on FAF because they removed a value.
  * Fixed a crash on FAF with BrewLAN enabled and Magnum Dong not enabled.
  * The `CQUEMOV` category on FAF is now given to any unit from a BrewLAN mod with the `NEEDMOBILEBUILD` category, because I can't be bothered to maintain it as an ID list.

  ### 2021-02-19

  * Returned the `ENGINEER` category to the UEF engineering resource buildings and final upgrade for the Seraphim engineering station.
    * This was removed because of an engine crash where AI's would try to order 'engineer' structures like regular engineers and cause an exception.
    * This had the side effect of causing them to be unable to actually build.
    * This is a potentially temporary experimental change, which will likely determine the fate of the engineering structures if the crash is still an issue.
  * Updated translations.

  ### 2021-02-21

  * Changed the description of BrewLAN AI to make it more clear that it's for AI using BrewLAN units.
  * Fixed the Slink not decloaking on fire if it's controlled by an AI.

  ### 2021-02-22

  * Removed BuildOnLayerCaps from each mobile unit and each structure not built on just land from BrewLAN.
  * Fixed the Cybran special extractor not being buildable underwater.
  * Changed the icon background on all special extractors to be `amph` instead of `land`.
  * Sanitised use of BuildOnLayerCaps in blueprints.lua.
  * Gantry Homogeniser: Sanitised use of BuildOnLayerCaps in blueprints.lua.
  * Waterlag:
    * Sanitised use of BuildOnLayerCaps.
    * Added some additional sanity checks.
    * For structures with collision boxes not touching the surface before hand, gave them the `HOVER` category so torpedo units that can't hit them won't try.
    * For units with collision boxes that touch the surface or go through it, it now lowers the collision box by 0.5 and makes it taller by 0.5 instead of just lowering it by 0.25.
  * Ivan script no longer checks BuildOnLayerCaps.
  * Removed the unused Ivan dummy unit.

  ### 2021-02-23

  * Paragon Game: Slightly reworked the UEF paragon to include a tesseract and replace the normals.

  ### 2021-02-24

  * Cityscapes: Made the civ wall buildable by field engineers.
  * Cityscapes: Shrunk the collision model of the civ wall to better match the model.

  ### 2021-03-02

  * Cityscapes: Removed some extraneous data from the block dummy.

  ### 2021-03-07

  * Water Guard: Fixed a potential nil table check, and made the damage calculation only care about collision box size, and added a collision box offset check.

  ### 2021-03-08

  * Expert Camo: Included a fix for the vanilla terrain type issue by just overwriting the function.
  * Water Guard: Some optimisations.

  ### 2021-03-12

  * Stonks.

  ### 2021-03-19

  * Penetrators: Added a Cybran T2 Combat Fighter.
  * Penetrators: Fixed the Condor only being buildable from T3 factories.
  * Changed the build menu sorting of the T1 torpedo bombers and T1 gunships.

  ### 2021-03-20

  * Penetrators: Cleaned up the blueprints.
  * Bletchley Park: Set the footprint of the UEF T4 mobile sensor to 6x6 so it gets the `IgnoreStructures` flag.
  * Fixed the Independance Engine having the 'LAND' category instead of 'AIR'.
  * Gave the Gantry the AIR and NAVAL categories to account for it being able to do those.
  * Did some work on the updated auto-icon-selection scripts that supercede EIO.

  ### 2021-03-21

  * TeaParty: No longer removes the `SHIELD` category from units with large `ShieldProjectionRadius` values but a small `ShieldSize` value. So basically just the Pillar of Prominence.

  ### 2021-03-25

  * Penetrators: Changed the build sorting of the Raptor to always be before the Janus.
  * Did some more work on the strategic icon overhaul.

  ### 2021-03-27

  * Cleaned up the BrewLAN Megalith egg stuff.
  * Crystal Hill: Cleaned up the blueprints.

  ### 2021-03-28

  * Penetrators: Changed the ID of the Cybran T2 Fighter to be more consistent with the rest of the mod.
  * Fixed categories of Vaxis being copies of Burning Star.

  ### 2021-03-30

  * R&D: Fixed research items of mods loaded after R&D not having build descriptions.

  ### 2021-03-31

  * Fixed UEF engineering resource structures not producing if their active consumption is higher than their production.
  * Restricted the UEF engineering resource structures to only building tech 1 defences, even on R&D.
  * 'Fixed' the BpId key name being inconsistent.
  * Changed a few persistent LOG functions to use SPEW instead.
  * Removed `Experimental Icons Overhaul`.
  * New mod: `Strategic Icons Overhaul`; replaces EIO, and effects all tech levels. Comes with 3 graphical variants.
  * Changed the icons of the BrewLAN UI mods.
  * Crystal Hill: Fixed the objective marker script searching the whole map for objective markers and using the first it finds.
    * Now it searches just the centre of the map, and checks which is closest to the centre.

  ### 2021-04-01

  * Released the Stonks.
  * Updated the version number in the mod_info that should have been updated years ago to not match the release.

  ### 2021-04-02

  * Replaced the models of the Aeon T2 & T3 mines.
  * Moved Suedath-Zmara from Magnum Dong to BrewLAN.
  * Fixed the Suedath-Zmara not having defined translation strings for build description and button toggle tooltips.
  * Magnum Dong: Changed the icon and description to reflect that Zmara isn't in it anymore.

  ### 2021-04-03

  * Fixed some potential warnings related to Zmara dying while using one of its melee weapons.
  * Fixed the seam on and minor shading issues on the Cybran T1 air staging.
  * Added some extra lights to the Cybran T1 air staging.
  * R&D: Set the category dump unit to be unspawnable.
  * Replaced the model of the Rupture.

  ### 2021-04-04

  * Removed the UEF mobile air staging.
  * Cityscapes: Script will no longer try to process non-existent water stuff. (Fixes Aeon and Cybran cities.)

  ### 2021-04-05

  * Fixed the skirt of the Absolution.

  ### 2021-04-06

  * Replaced the model and texture of the anti artillery.

  ### 2021-04-07

  * Fixed the life bars of the UEF tech 2 storages.
  * SIO: Added the option for logging the icon changes.
  * R&D: Renamed the hovercraft factory line category from `..AMPHFACTORY` to `..SURFACEFACTORY`.
  * Removed a bunch more useless blueprint values, mostly from storages.
  * Removed the following values from blueprints where the value meant nothing or was the default:
    * BankingSlope
    * DragCoefficient
    * WobbleSpeed
    * WobbleFactor
    * TurnRate
    * TurnRadius
    * SkirtOffsetX
    * SkirtOffsetZ
    * MaxSteerForce
    * MinSpeedPercent
    * SurfaceThreatLevel
    * RegenRate
    * SubThreatLevel
    * AirThreatLevel
    * EconomyThreatLevel
    * CollisionOffsetY
    * CollisionOffsetX
    * CollisionOffsetZ

  ### 2021-04-09

  * Cleaned up some dummy units.

  ### 2021-04-11

  * Replaced a few select instances of `LOG` with `_ALERT`. For reasons.
  * Finished Excalibur; tweaked the model, and replaced the UV and texture.
  * Excalibur now renders a fire clock.
  * Anti-armour point defences are now consistently labelled as their original directfire, rather than artillery.
  * Removed the following functionless categories:
    * `OVERLAYDIRECTFIRE`
    * `OVERLAYINDIRECTFIRE`
    * `OVERLAYANTIAIR`
    * `OVERLAYANTINAVY`
    * `OVERLAYCOUNTERMEASURE`
    * `PRODUCTBREWLANRND`
    * `PRODUCTBREWLANSHIELDS`
  * Removed the last remnants of the blueprint values:
    * SpawnRandomRotation
    * StrategicIconNameEIOOverride (formerly used by the defunct EIO)
    * PlaceholderMeshName
  * More blueprint cleaning.
  * Stargates can no longer connect to other stargates on a different layer.

  ### 2021-04-13

  * T2 storages now pass all of the data that they should to the core functions when they die.

  ### 2021-05-20

  * Reduced the number of string sub operations needed for the version check script.

  ### 2021-05-24

  * Added texture detail to the inside of the slide action on the Excalibur.
  * Minor optimisations for the Suthanus script.
  * Cleaned up the blueprint of the Aeon Decoy.

  ### 2021-05-29

  * Cleaned up a bunch of comments and references.
  * Removed all instances of # as a comment start from .lua files.

  ### 2021-05-30

  * Unified comment headers on some unit scripts.
  * Removed the removed the legacy check document dependency for the the Aeon Heavy Transport.

  ### 2021-05-31

  * Spomeniki: Added a torii gate.

  ### 2021-06-02

  * Penetration: Added Helios; the Aeon T3 Penetration Fighter.
  * Updated language strings. A large portion of French language updates from Markty_07.

  ### 2021-06-03

  * Penetration: Made Helios more shiny.
  * Refactored Gantry scripts to use a class rather than a heavily linked util script.
  * Gantry Homogeniser: Updated for refactored gantry scripts.
  * Gantry Hax: Updated for refactored gantry scripts.
  * Gantry stolen tech clause can now handle arbitrary factions.

  ### 2021-06-04

  * Simplified a few lua doc links to not need to reference the BrewLAN path.
  * Penetration: Made the Helios guns less shiny.

  ### 2021-06-06

  * Split off pre-2020 changelog to its own document. It was starting to take a while to save.

  ### 2021-06-07

  * Fixed WaterGuard.

  ### 2021-06-11

  * Bletchley Park: Fixed the death animation link for the Cybran omni still referencing BrewResearch.
  * Bletchley Park: Added the Seraphim dedicated omni.
  * Fixed a really rare script error in the Cybran T2 Energy Storage death.

  ### 2021-06-14

  * New mod: *Reinforcements*. Currently mostly a tech demo that only gives an Aeon light assault drop.
  * Defined water vision on units that should have 0 vision. Default is 10.
  * Removed some command caps from some dummy units.
  * Fixed the water vision of the Zmara.

  ### 2021-06-15

  * Gantry scripts now generically force experimental submarines to dive, instead of specifically checking for the Atlantis.
    * Within BrewLAN mods, this affects:
      * AI building the Tempest from the Independence Engine.
      * Players building Atlantis from-, and players and AI building Tempest from the Seraphim Naval Factory.
        * AI is restricted from building the Atlantis because they don't use it.
  * Fixed the DPA calc in the Strategic Icon selector and debug tools mod not treating MuzzleSalvoDelay and RackFireTogether correctly.

  ### 2021-06-16

  * Removed the `BUILTBYEXPERIMENTALSUB` category. Nothing uses it.
  * Fixed typos in the Helios build description. (Awaiting propagation to loc strings)

  ### 2021-06-17

  * Fixed the internal faction name of the Cybran Paragon, and the T2 and T3 research centres.
  * Fixed the Aeon shield wall having a Seraphim faction name.
  * Fixed the Absolution taking experimental footfall damage.

  ### 2021-06-18

  * Caffe Corretto: Tesla Coil death weapon now uses death weapon scripts.
  * Caffe Corretto: Removed some meaningless bp values from the Tesla Coil.

  ### 2021-06-19

  * Debug tools: Fixed the real-world DPS test functions referencing a typo.

  ### 2021-06-20

  * Updated Panopticon strings.

  ### 2021-06-24

  * New Hexatron model.

  ### 2021-06-29

  * Added a check to deal with FAF's hamfisted anti-strategic missile changes. It will work for any un-updated weapons or projectiles, it's not specific. Exactly how they should have done it.

  ### 2021-06-30

  * Slight optimisation on blueprints.lua; moved motiontype sanitisation to start of script and fleshed it out so everything else can rely on it.
  * Reworked the majority of blueprints.lua functions to all use minimal loops of the unit database. I don't have numbers on the effect of this.

  ### 2021-07-01

  * The unguided satellite function now actually deals enough damage to bypass regen.
  * Refactored satellite code so shared code is in a parent class, and so its unpack stages are initiated by the satellite not the station.
  * Changed the ID of the UEF observation satellite from `sea0002` to `sea3301`. The 000 number IDs have been bugging me, and they're going.
  * Changed the ID of the UEF counterintel satellite from `sea0003` to `sea4301`.
  * Changed the ID of the UEF ASF jammer dummy unit from `sea0004` to `sea4302`.
  * Defined class 1 capacity in the disabled UEF mobile air staging unit.
  * Bletchley Park: Fixed the Seraphim sensor having the name and description of the vanilla optics.
  * Fixed the observation satellite having native water vision.
  * Finished the texture and new walk animation for the new Hexatron model.

  ### 2021-07-02

  * Created a Hexatron death animation.
  * Rebalanced the Hexatron for the new model, and renamed it to Triseptitron.

  ### 2021-07-03

  * Fixed the normals and smoothing groups of the Iron Curtain.
  * Versioned the wiki script now that it's mostly complete.

  ### 2021-07-04

  * Gantry hax modules now work regardless of the mod load order, and will now no longer cause errors when loaded without BrewLAN.

  ### 2021-07-05

  * New UEF submarine. Texture unfinished.

  ### 2021-07-08

  * Finished the UEF T2 attack submarine.

  ### 2021-07-12

  * Mild optimisation to the Seraphim optics and gantry button hook.
  * Slightly reduced the effectiveness of Cochrane anti-torpedo.

  ### 2021-07-19

  * Added a Cybran missile tank.

  ### 2021-07-20

  * Fixed treads of missile tank, ~~and added target leading to missile.~~

  ### 2021-07-21

  * Fixed the anti-missile flares on the Helios being close to useless.
  * Toxotai missiles now track moving targets.

  ### 2021-08-05

  * Fixed UEF tidal generator having rebuild bonus on only the Aeon generator.
  * Added the Aeon tidal generator.
  * Changed active loop noise of tidal generators to wetter sounding ones.

  ### 2021-08-06

  * New mod that makes mines untargetable.

  ### 2021-08-09

  * Replaced the `SHIELD` category with `PERSONALSHIELD` on the Aeon shielded resource structures.

  ### 2021-08-12

  * Caffee Corretto: Tesla Coil now doesn't get damage reductions from effects that reduce its maintenance cost. It, however, still gets damage increases from effects that increase the maintenance cost.

  ### 2021-08-13

  * Caffee Corretto: Damage boost node now adds maintenance cost. This is only really useful for the Tesla coil.

  ### 2021-08-19

  * Fixed one of the weapons on the Solaris having the pitch and yaw ranges inverted.

  ### 2021-08-22

  * Triseptitron dumb fire rockets are now only marginally affected by most redirection effects.

  ### 2021-08-28

  * Fixed SIO crashing if a weapon didn't have a damage type.

  ### 2021-08-30

  * Debug Tools: Refactored the DPS check units, and moved the script so both reference instead of copy.

  ### 2021-08-31

  * Debug Tools: DPS test units now use a shared referenced mesh, instead of a copy.
  * Cityscapes: Wharf structure unit replaced with a prop.

  ### 2021-09-10

  * Bubble Tea: Pillar of Prominence rework: Can now protect other shields and unfinished structures.

  ### 2021-09-16

  * Crystal Hill: Removed radar and omni from the crystal vis entities.
  * Crystal Hill: Crystal blueprint cleanup, skirt alignment fix.
  * Removed GuardScanRadius from units that don't need it and only want the purple ring.

  ### 2021-09-22

  * Fixed ssl0324 having the 'land' icon instead of 'amph'.
  * Fixed ssa0105 having transport class 2 instead of 1.
  * Fixed ssl0311 having transport class 2 instead of 3.
  * Fixed ssl0320 having transport class 2 instead of 3.
  * Fixed ssa0211 having transport class 3 instead of 2.

  ### 2021-09-26

  * Removed the tech level and wreck from the Iyadesu drone. Also bp cleanup.
  * Replaced the icon of the Iyadesu and it's drone.

  ### 2021-09-29

  * Blueprint cleanup; removing redundant `bp.Interface` tables and `OVERLAYDEFENSE` categories.

  ### 2021-10-05

  * Blueprint cleanup:
    * Removed the remaining redundant `bp.Interface` tables.
    * Removed instances of `bp.UseOOBTestZoom` values.
  * Removed other redundant blueprint values from:
    * `sel3401`
    * `srl0403`
    * `seb4401`
    * `ssb4401`
    * `ssb4401_small`
    * `ssb4401_large`
    * `sas0401`
  * Minor optimisation to the drone script for the Iyadesu.

  ### 2021-10-06

  * `BrewLANNavalEngineerCatFixes` no longer references a redundant value.

  ### 2021-10-13

  * Purged the `MEDIUMWALL`, `MEDIUMWALLGATE`, `HEAVYWALL`, and `HEAVYWALLGATE` categories.
  * `SHIELDWALL` is now treated the same way as `WALL` in more situations.
  * Most cardinal walls will now connect to any other `WALL` category unit.
  * Renamed `BUILTBYHEAVYWALL` category to `BUILTBYTIER3WALL`.
  * Cleaned up cardinal wall blueprint data.
  * CamelCased some cardinal wall blueprint data keys and booled values to allow a simpler script.
  * Simplified and optimised the cardinal wall script.
  * The force factory build effect is now tied to the new `FACTORYBUILDERONLY` category instead of `GANTRY` and several wall categories.

  ### 2021-10-14

  * Fixed or added attach points on:
    * Aeon defence engineers
    * Triseptitron
    * Hedgehog
    * Seraphim T3 torpedo launcher
  * Slight refactor and optimisation of the Gantry share tech check.

  ### 2021-10-15

  * New mod collection: *BrewLAN: Cursed mods*.
  * Two new mods: *Igpay Atinlay* and *A Aaa*, which both change game text.
  * Moved the following to cursed mods:
    * *Invisible War*
    * *Knife Fight*
    * *Scathing Beetles*
    * *Stonks*
    * *Sudden Death*
  * New mod *Z̖a͓̻̯̠͚͠l̘̜̥̟̼g͚̜̗̙̠o̢̳̜͕͙*.
  * New mod *Spongemock*.

  ### 2021-10-16

  * Refactored LOC mods so that regardless of order, they always have access to the original text.
  * Pig Latin script no-double-translate check now works with any capitalisation.
