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

## 2019-10-13|0.8.9

* Incremented numbers for static public release.
* Updated translation documents.

## 2019-01-06|0.8.4.1

* Fixed the Seraphim SACU having access to the un-upgraded tech 3 resource buildings after the field engineer upgrade.

  ### 2019-01-20

  * R&D: Removed the research for the disabled UEF hovercraft factory.
  * Replaced the CQUEMOV function with another that chooses units specifically instead of based on categories.
    * It now affects BrewLAN (and sub-mod) mobile experimental units, the observation satellite, and the UEF engineering resource buildings.

  ### 2019-01-26

  * Debug Tools: Added an installation check function to the speaker unit.

  ### 2019-01-27

  * Debug Tools: Created an icon for the flying DPS tester unit.
  * Debug Tools: Listed the installation validation ability on the speaker unit.

  ### 2019-01-31

  * Debug Tools: Added the reported version number to the BrewLAN validation check.
  * Metal World: Removed the weird AI hacks to get them to do anything at all.
  * Metal World: LOUD, Sorian, and vanilla AI now have proper defined behaviour.

  ### 2019-02-05

  * Crystal Hill: Removed the script reference to the Seraphim ACU for the warp-in effect.
  * Crystal Hill: Removed the dependency to civilian structures for the Crystal.

  ### 2019-02-12

  * Crystal Hill: Civilians can no longer take the Crystal after the first capture.
  * Crystal Hill: Removed unnecessary data from the blueprint files of the Crystal units.
  * Crystal Hill: Changed the footprint size and collision size of the Crystal units.

  ### 2019-02-13

  * Crystal Hill: Created some AI markers on the crystal.

  ### 2019-02-15

  * Spomeniki: Created a monument to Spirit and Opportunity.

  ### 2019-02-16

  * Spomeniki: Created a usable Opportunity unit.

  ### 2019-02-18

  * Spomeniki: Finished the script for Opportunity.

  ### 2019-02-19

  * Spomeniki: Created a usable Spirit unit. It's the same as Opportunity but produces less power and has a different texture.
  * Spomeniki: Added build descriptions and icons for Spirit and Opportunity.

  ### 2019-02-20

  * Spomeniki: MER script now resets the position of the dish array when closing the panels.

  ### 2019-02-21

  * New mod that makes wreckages disappear after a time, based on their cost and other factors.

  ### 2019-02-23

  * Added the UEF tech 3 mobile air staging platform.

  ### 2019-02-24

  * Fixed the transport attach node on the UEF mobile air staging, tweaked the tread-marks, and added a name.

  ### 2019-03-01

  * Stolen Tech: Fixed research items appearing in land units list.

  ### 2019-03-06

  * Paragon Game: Fixed Aeon engineering station having Seraphim build effects.
  * Updated UEF mobile air staging name based on vote results.

  ### 2019-03-08

  * Updated various strings to match the language document.
  * Mass Random: Fixed in LOUD.

  ### 2019-03-13

  * R&D: Fixed the Lancer landing half inside air staging platforms.
  * Fixes towards aircraft getting trapped on the mobile air staging if it starts moving while they are landed on it.
    * It no longer traps the aircraft, but it bricks the pad instead.

  ### 2019-03-14

  * R&D: Fixed the Seraphim and Aeon Penetration bombers not being able to land on air staging.
  * Fixed the UEF air staging trapping aircraft, or breaking when kicking out units, at the cost of ignoring move orders if occupied.

  ### 2019-03-21

  * Darkness no longer affects SACUs.
  * Minor optimisation for the Darkness.

  ### 2019-03-22

  * Removed obsolete anti-Panopticon code from the Darkness.
  * Additional optimisation for the Darkness.
  * Darkness now implicitly excludes the Orbos and Galactic Colossus with a category instead of explicitly by unit ID.
  * Novax no longer automatically builds the first satellite so people are more aware that it can build more than one.
  * Removed the obsolete code for automatically rebuilding satellites from the Novax, which hasn't functioned since the change to a satellite pop cap.

  ### 2019-04-07

  * Removed some more redundant code from the Darkness, and refactored it so it's easier to read.
  * Darkness will no longer try to affect mines, walls, and benign tagged units.

  ### 2019-04-09

  * R&D: Split off the factional differences of the research centres to child classes to remove the need to check self faction on SFX start.

  ### 2019-04-12

  * R&D: Starting research is now based on starting factories and engineers, not any random unit.
  * R&D: Added basic framework for the AI research manager to receive research orders.
  * R&D: Moved the majority of the AI control of the research centre to the AIBrain.
  * R&D: AI's will no longer rebuild research centres after they have completed all research.
  * R&D: AI's can now reclaim research centres if they are done with them.
  * R&D: AI will no longer research if they are low on resources.
  * ~~R&D: AI's are now completely prevented from building more than one research centre, since instructing them so wasn't enough.~~
    * AI engineers will apparently build something they aren't allowed to if it is queued up already.

  ### 2019-04-13

  * R&D: Moved the buff definitions to the buff definitions document.
  * R&D: Research request function will now parse requests for units that are category locked not individual unit locked.
  * R&D: AI build structure functions can now request specific research orders.

  ### 2018-04-14

  * R&D: Increased the amount of resources an AI needs to decide to start doing a research.

  ### 2019-04-16

  * Started an enhancement based rework of the Panopticon.

  ### 2019-04-22

  * Allowed the infrastructure of the Panopticon animation threads to allow for inactive arrays.
  * Finished setup of the reworked Panopticon animation thread to accept dish activations through enhancements.
    * R&D: Updated copy of said script.
  * Reworked the Panopticon blip visual intel thread to only exist when the enhancement is on.

  ### 2019-04-23

  * More optimisations for the Panopticon.
  * The Panopticon active consumption button is now only present when it does something.
  * Replaced the tarmac of the Panopticon with a slightly smaller one.
  * Slightly increased the size of the Gantry tarmac to fill the footprint better.

  ### 2019-04-24

  * Moved the Panopticon string sanitisation to game launch for better performance during.
  * Created the buff definitions for the Panopticon enhancements.
  * Finished the Panopticon enhancements to include the buffs.
  * Set the Panopticon intel to its base level without buffs.
  * Extended the legacy check document to support the RemoveBuff function.
  * Made the Darkness use the legacy check buff document so it doesn't crash on original SC.
    * It wont work, but it wont crash either.
  * Moved the darkness debuff definition to the buffdefinitions file.
  * Moved the Panopticon dish animation definitions to it's blueprint.
  * Updated the language documents.

  ### 2019-04-25

  * Removed the blank enhancement tabs from the Panopticon.
  * Made the Gantry/Heavy wall construction button overwrite slightly more efficient.
  * Created graphics and strings for a custom enhancements tab for the Panopticon.

  ### 2019-04-27

  * Replaced the model, textures, and animations of the Gantry.

  ### 2019-04-28

  * Set the Gantry arms to adjust based on the size of the unit being produced.
  * Removed the SIZE30 adjacency buff definitions since the Gantry is SIZE36 now.

  ### 2019-04-29

  * Fixed the Panopticon having free intel when first built.

  ### 2019-04-30

  * New mod: Ultimate Superweapons. Adds Age of Empires style wonders to the game. Currently barebones.

  ### 2019-05-09

  * Finished graphics for the Panopticon array enhancement buttons for all factions.
  * R&D: Created the majority of the model for a UEF Penetration Fighter.

  ### 2019-05-10

  * R&D: Finished the UEF Penetration Fighter, Tomcat, graphically. It's missing weapons.
  * R&D: Added anti-missile flares to the penetration fighters.

  ### 2019-05-11

  * R&D: Finished the Tomcat.

  ### 2019-05-12

  * Created some dormant code for use with Domino's mod support to create an 'Array' enhancement tab for the Panopticon.
  * Made the legacy section of the Gantry/Heavy wall build click modifier more efficient.

  ### 2019-05-22

  * Fixed BrewLANGantryBuildList looping through things 4x more than it should be and potentially passing nil.

  ### 2019-05-25

  * R&D: Added the UEF T2 Combat Fighter, Raptor.
    * Fans of realism may not like that I chose to make the Tomcat stronger than the Raptor. Tomcat is cooler.

  ### 2019-05-28

  * Started work on an Aeon Experimental Teleporter.

  ### 2019-05-29

  * Started a new mod that swaps the tech levels of units around. It's messy.

  ### 2019-05-30

  * Replaced the model and texture of the Slink.

  ### 2019-05-31

  * Prevented the Slink from spamming sound effects every 5 seconds that it's disabled.
  * R&D: Replaced the textures of the Cybran Research Centres.
  * R&D: Refactored textures to be relative instead of absolute path.
  * R&D: Changed the window texture on the UEF Research Centres.
  * R&D: Added models to the tech level research units so they can be seen while constructing.

  ### 2019-06-01

  * Replaced the normals and fixed smoothing groups on the Zenith.
  * Shrunk the Zenith slightly.

  ### 2019-06-02

  * Replaced the distance model of the Zenith with two new ones.
  * Created a unique model and texture for the Gannet.
  * Created new icons for the Slink and Gannet.

  ### 2019-06-03

  * Created a new model for the Pigeon.

  ### 2019-06-04

  * Textured the new Pigeon model.
  * Refactored weapons on the Pigeon to match model.
  * Replaced the icon of the Pigeon.
  * Pigeon now adopts an aggressive pitch when attacking.

  ### 2019-06-05

  * Redesigned the Aeon energy storage.
  * Set the collision model of the Aeon energy storage to be spherical.

  ### 2019-06-06

  * Redesigned the Aeon mass storage.
  * Set the collision model of the Aeon mass storage to be spherical.

  ### 2019-06-07

  * Aeon T2 Mass Storage now brings its outer segments up earlier.
  * Fixed the weird damage effects of:
    * UEF T2 wall
    * UEF T3 wall
    * UEF T3 wall gate
    * Aeon T2 wall
    * Seraphim T2 wall
    * Cybran T2 wall
    * Cybran T3 wall
    * Cybran T3 tall boi wall
    * Cybran T3 wall gate
  * Recreated the textures and UV mapping of the Aeon tech 1 air staging.
  * Fixed the UV mapping and normals of the Aspis.
  * Gave the Aspis better death animations.
  * Fixed the distance model of the Aspis not respecting animations.

  ### 2019-06-08

  * Set up script to generate dummy units with each possible footprint layout configuration. and tie each unit to one.

  ### 2019-06-09

  * Aeon Experimental Teleporter now uses footprint dummies for structure teleporter functions.
  * Mines now use the auto generated footprint dummies for removing path blocking.
  * Gate path blocker unit now uses a shared nil model from the footprint dummies rather than a copy of one.

  ### 2019-06-10

  * Seraphim T1&2 mines now have their own textures, and are more efficiently UV'd.
  * Seraphim T2 mine distance model now has less polies.

  ### 2019-06-11

  * Stolen Tech: No longer lists BrewLAN dummy units on the spawn menu.
  * Seraphim T1 shield generator changes:
    * Fixed the shader groups.
    * Slowed the activation animation so it looks less derpballs. (This required recreation for reasons)
    * Removed the ability to rebuild on T3 and T2 shield wrecks so you don't waste loads of mass.
    * Shrunk it slightly.
    * Replaced the death animation.
    * Made the death animation only play if it was active when it died.
  * Changed the selection overlay for the Seraphim T1 light artillery.
  * Replaced the UV and textures of the Seraphim T1 light air staging.
  * Replaced the LOD1 of the Seraphim light air staging, and fixed the death animation not applying to it.

  ### 2019-06-12

  * Recreated the textures and model of the LSD-Pulse.
  * LSD-Pulse can no longer get rebuild bonus on T2 & T3 wrecks.
  * Added some internal glowing lights to the Moldovite.
  * Fixed a small smoothing issue on the back of the Moldovites turret.
  * Scarab changes:
    * Re-rigged the legs and body.
    * Replaced the walk animation.
    * Removed it's ability to walk backwards.
    * Increased the firing tolerance so it's more likely to fire at missiles coming from behind it.
    * Removed it's ability to turn on the spot.
    * Added a leg fold animation when it is put in transport.
    * Added an adorable transport detach animation.
    * Recreated the launch unpack animation so it points higher up.
    * Added glowing lights to the body under the wings.
    * Gave it a simple death animation.
    * Fixed two pairs of minor UV issues on it's wings.

  ### 2019-06-13

  * Impaler changes:
    * Made it slightly more aerodynamic; it's now fatter at the front and thinner at the back.
    * Fixed minor smoothing issues at the wing backs.
    * Fixed a normals issue down the centre seam.
  * Raptor changes:
    * Lowered the model.
    * Fixed the size used during building and research.
  * Nuke mines now have the ability to auto-fire, and default to hold fire.

  ### 2019-06-14

  * Improved the UV mapping and textures on Resupply.
  * Resupply can now wear a hat.
  * Seagul changes:
    * Small texture reworks.
    * Replaced normals.
    * Fixed smoothing.
    * Changed team colour areas.
    * Reduced selection overlay area.
  * Fixed a minor UV error on the Pigeon, and added more texture details.

  ### 2019-06-16

  * R&D: Reduced Penetrator bomber flare spam in situations involving excess bombers and missiles.
  * R&D: Prevented the creation of flares after killed, but before crashing.

  ### 2019-06-17

  * R&D: Fixed it running the FAF version of the restriction check code any time there were restrictions.
  * R&D: Research items now receive the AIR/LAND/NAVAL categories of their parents so they can be restricted along with them.
  * Added an intermediate distance model for the Gantry and made it visible further away.
  * R&D: Added R&D items for restricted items to their respective restricted items lists.
  * Bubble Tea: Added shields to "no bubbles" restriction. Yes, this disables everything the mod adds.
  * R&D: Added the Retributor to the "game enders" restriction.
  * Added Panpticon and non-UEF mobile sensors to no-intel restriction.
    * They were all covered by the OMNI category anyway, but this has function for R&D.
  * UEF mobile anti-air loses it's radar ability with the no-intel restriction.

  ### 2019-06-18

  * Redid the UV and textures of the Seraphim engineering stations, and replaced the distance models.

  ### 2019-06-19

  * R&D: Added the regular Omni sensors and dedicated omni sensors to the Intel restriction.
  * R&D: Fixed the log warning for researching an item that shouldn't be researched not working.
  * Added the Seraphim optics tracking facility,  UEF observation satellite, and Seraphim T3 Sonar to the Intel restriction.
  * Fixed the nuke mine detonate on ctrl-k on FAF feature.
  * Refactored mines to use cached positions rather than doing extra function calls on detonate.
  * Refactored nuke mines to be more efficient on detonation.
  * Removed to no-longer used files from FAF previously used for compatibility.

  ### 2019-06-20

  * Regular shields are now visible under artillery shields.
  * Artillery shield visual model now closer matches it's collision model.
  * Bubble Tea: Fixed a script error when the Pillar of Prominence dies.
  * Bubble Tea: Fixed the alignment of its internal shield.
  * Bubble Tea: Aeon shield and it's projections now visible under regular shields.
  * Redesigned the UEF T1 artillery.

  ### 2019-06-21

  * Replaced the icons of the UEF T2 storages.

  ### 2019-06-23

  * Little Bertha changes:
    * Fixed the shading
    * Fixed and replaced the normal map
    * Cleaned up the UV map
    * Tweaked the albedo and specular
    * Replaced the distance model
  * Replaced the textures of the AP-12 Trapper with more appropriate lower resolution textures.

  ### 2019-06-24

  * Fixed the normal map on the Wally and Custodian.
  * Fixed the shading groups on the Wally and Custodian.
  * R&D: Removed some unnecessary data from the Aeon research centres and gave it relative texture links.
  * Added extra detail to the Guardian model.
  * Recreated the Guardian texture.

  ### 2019-06-25

  * Reused the old Guardian models as distance models.
  * Flame Lotus changes:
    * Redid the UV mapping and texture of the outside.
    * Aligned and simplified the treadmarks.
    * Gave it transport attach, detach, and death animations.
    * Replaced the distance model to match the new texture.

  ### 2019-06-27

  * Started the recreation of the Aeon Mobile Sensor.

  ### 2019-06-28

  * Finished the rework of the Aeon Mobile Sensor.

  ### 2019-07-04

  * Finished the redesign of the Albatross.
  * Replaced the icons of the Flame Lotus, Harpoon, and Guardian.

  ### 2019-07-05

  * Spy satellite now no longer has an intel toggle button until it's fully set up, rather than ignoring input from it's intel button until that time.
  * Added a counterintelligence satellite.
  * Split the listed abilities for satellite capacity indications so include the number provided.
  * Nightshade rebalance:
    * Increased radius to 50 from 20.
    * Decreased maintenance cost to 715 from 875.
    * Increased health to 450 from 300.

  ### 2019-07-09

  * Added UEF mobile anti-tactical defence.

  ### 2019-07-11

  * Longbow changes:
    * Recreated the UV.
    * Replaced the textures.
    * Implemented the originally planned feature to have it not always spawn with a head.
    * It now spawns without the dish graphic with the no intel restriction.
    * It no longer creates the intel animation thread under the no intel restriction.
    * Aligned the treadmarks.
    * Reduced the height of the collision box.
    * Aligned the selection box.
    * Moved the intel effect from the idle effects to the intel script to make it more reliable.
    * Replaced the distance models.
  * Fixed the shading on the door flaps on the distance models of the unnamed UEF mobile anti-tac.

  ### 2019-07-12

  * Refactored wall scripts to use cached positions.
  * Refactored gate scripts to use the auto generated footprint dummies.
  * Removed the wall dummy unit.
  * Fixed the broken BrewLAN installation fix function that broke when I removed the mine dummy unit.
  * BrewLAN will now complain in message form to you after 2 seconds if it's installed incorrectly.

  ### 2019-07-22

  * The build effect of the Seraphim Tech 3 Transport is no longer offset badly to the side.

  ### 2019-07-26

  * Added a target flatness check for the Aeon experimental teleporter.

  ### 2019-07-27

  * Refactored flatness check of Aeon teleporter so it wont interfere with the pathing of existing units at the target.

  ### 2019-07-30

  * Teleporter now deals with the following:
    * Adjacency of warped structures, and structures that were adjacent to them. (although not newly adjacent things)
    * The tarmacs of warped structures.
    * The cached positions of warped structures.
    * Flattening the area for structures in the new area.
    * All of the above for itself as well as things it teleports.
  * More teleporter things:
    * Refactored again to allow for a period of economy drain, and to dynamically calculate said drain.
    * Changed to use the actual teleport order, rather than the target area order.
    * Added a cool-down period after use. Period is defined by charge time.
    * Allowed to cancel.
    * Failed teleports that didn't fail because of a destroyed facility result in a cooldown proportional to how complete it was, and how long the cooldown would have been.
    * Targeting now respects the BlackOps anti-teleport units.
    * Gave it a build description.
    * Gave it a temporary icon to go with its temporary model.
  * Seraphim sonar now uses the correct localisation string for the personal teleporter ability.

  ### 2019-07-31

  * Teleporter now deals with the following:
    * Co-ordinates outside of map boundaries.
    * Pre-existing structures at the target.
  * BrewLAN modules mods are now contained within BrewLAN, and the BrewLAN_Modules folder has been retired.

  ### 2019-08-01

  * Fixed the teleporter using the wrong starting co-orinate for one axis of the occupancy check.
  * Re-organised the directory structure of BrewLAN UI, and renamed BrewLAN UI to BrewLAN UI: Engineering Tab.
  * Moved the UI parts (the only released parts) of the Stolen Tech mod to within the BrewUI folder as a UI mod called BrewLAN UI: Spawn Menu.
  * Retired the Stolen Tech mod.
  * Teleporter now respects mass and hydrocarbon points.

  ### 2019-08-02

  * Teleporter changes:
    * It will no longer try to do things to units that have died during the charge.
    * Reworked path blocking updates and adjacency calculations:
      * Merged both together, and used data from the path blocking updates for adjacency updates.
      * It now properly breaks old adjacencies in situations where it was a one way thing only tracked by a unit not warped.
      * It can now create new adjacencies at the new position.
        * In theory.

  ### 2019-08-06

  * Debug Tools: Added a function that is LOUD's EvenFlow rewritten to require the minimum amount of calculations required, and to be much shorter.
  * Debug Tools: Added a function that checks blueprint build time values against what EvenFlow would set them to and outputs that data as table log sorted by how different the two numbers are.

  ### 2019-10-13

  * Superweapons: Added icons and a progress bar for the player.
  * Disabled the Aeon teleporter for public release.

## 2019-01-03|84 (FAF minor patch)

* Created a function to add the FAF category CQUEMOV to function to mobile experimental mobile units.

## 2018-12-29|0.8.3

* Incremented version numbers for static public release.
* R&D: Removed hard requirement for BrewLAN.
* Gantry Homogeniser: Removed the no longer necessary build cat script.

## 2018-08-18|0.8.2

* Increased the cap cost of mines and walls:
  * Shield walls and tech 2 walls now cost 0.1 cap.
  * Armoured walls and gates cost 0.15 cap.
  * Cybran stacked walls cost 0.075 cap. (0.225 cap with both parts included)
  * Nuke mines now cost 1 cap.
* Fixed rebuild for seraphim tech 2 mass storage.
* Removed engineer category from engineering stations.
* Removed showqueue category from the Iron Curtain.
* Removed strategic category from tech 1 air staging.
* Fixes size category for tech 1 air staging.
* Removed defence and shield categories from shield walls.
* Removed defence categories from walls.
* Removed productsc1 category from Cybran tech 1 air staging.
* Removed defence and faction categories from BrewLAN projectiles.
* Added water vision to the Seraphim optic.
* Adopted LOUD weapon rigging changes for Aster.
* Reduced the size of the Aster anti-nuke.
* Changed the order of checks for the bomber self damage fix for performance.
* Improved performance on Gantry util for stolen tech.
* Gantry stolen tech clause now cares for experimental engineers, tech 3 factories, and experimental factories.
  * This means other factions gantries, and the Fatboy now count.
* Gave the Seraphim mobile optic the amphibious category.

  ### 2018-08-19

  * Gave the Moldovite the amphibious and submersible categories and updated it's target priorities.
  * Gave the Armillary the amphibious category and updated it's target priorities.
  * Moldovite can now leave a wreckage on the seabed.
  * Fixed Rupture having the structure armour class.
  * Removed defence category from Rupture, and gave it the amphibious category.
  * Gave the Metatron the amphibious category.
  * Changed some categories on the Absolution.
  * Replaced the radar and sonar categories with scout on the UX Dragonlady.
  * Replaced the bomber category with the torpedobomber category on the Albatross and Seagull.
  * Changed the target priorities of the Centurion, and changed the rigging of the missile launchers.
  * Removed the strategic categories from the tech 1 artilleries.
  * Removed the defence, intelligence, and counterintelligence categories from the mines.
  * Merged the weapon scripts of the Solaris, and simplified their target priorities.
  * R&D: Wind turbines now respect adjacency bonuses and resource multiplier modifications.
  * R&D: Wind turbines have been given adjacency bonuses to one another.
  * R&D: Lowered the max wind output of a turbine, pre-bonuses, to 25.
  * Moved the most of the new gantry tech share checks to launch, and added some additional checks at that time.
    * Armoured walls, research centres, megalith eggs, BrewLAN and FAF satellite facilities, the BlackOps Rift Arch, and LOUD Quantum Teleporters no longer apply.
    * ACUs now apply.
    * The Megalith and Iyadesu are now explicitly allowed.
    * Fatboy, Ivan, Tempest, CZAR and Atlantis and other aircraft carriers, still apply.
    * Quantum Gates apply when mods allow them to function as regular factories.

  ### 2018-08-20

  * R&D: Created the scripts for, and defined the balance for, tidal generators.

  ### 2018-08-20

  * R&D: Changed wind generator balance:
    * Health increased to 330 from 200.
    * Mass cost increased to 30 from 25.
    * Build time increased to 85 from 40.
    * Adjacency buff increased from 25% to 40%.
  * R&D: Tweaked the costs of tidal generators, and added strings for them.
  * Debug Tools: Make the DPS test units function on LOUD.
  * R&D: Added the Seraphim tidal generator.
  * R&D: Changed the description of the wind turbines to "Wind Generator" from "Power Generator".

  ### 2018-08-21

  * Defined the Centurions weapons as non-exclusive so they can fire together.
    * This actually makes a huge difference.
  * R&D: Removed the tarmac from the tidal generator.
  * R&D: Gave the Seraphim research centres distance models.
  * R&D: Changed the particle effects on the tidal generator.
  * Fixed the function that updates install directory causing a crash if Debug Tools isn't active.

  ### 2018-08-22

  * Stargate now warps projectiles.
  * Replaced normals on the Stargate.
  * R&D: Replaced the normals on the Seraphim research centres.

  ### 2018-08-23

  * Performance improvements for Panopticon.
  * Reduced the collision and build pool sizes of the Solaris while it's under construction.
  * Stargate warped projectiles now routed underground to prevent polytrails between the two gates.

  ### 2018-08-24

  * Tweaked the targeting on the Centurion.
    * Rear flak cannon now has a much larger AoE, less damage, and a considerably higher firing tolerance.
  * More Panopticon optimisation.
  * Added water vision to the Panopticon blips.
  * R&D: Added a Seraphim tech 2 power generator as a half way point between tech 1 and tech 2.
  * R&D: Research locked the default Seraphim tech 2 power generator.
  * Removed the engineer category from the engineering resource buildings.
  * R&D: Added the Seraphim tidal gen and light tech 2 gen to AI build lists.
  * R&D: Created adjacency buff definitions for the light tech 2 power gen.
  * R&D: Added strings for future unlockable aircraft.
  * Added an additional distance model for the Centurion between the current two.
  * Fixed inverted polys on the gatling gun on the Centurion.
  * Textured the gatling gun on the Centurion.
  * Excalibur now has an explosion radius where the projectile stops.
  * Fixed the footprint on the UEF and Cybran tech 1 air staging.

  ### 2018-08-25

  * Fixed the size spheres of the recon and decoy planes so they can be reliably shot.
  * Reduced the size spheres of the tech 1 gunships, torpedo bombers, tech 2 bomber, and Seraphim tech 3 gunship.
  * R&D: Reduced the size spheres of the tech 2 bombers.
  * Removed the size sphere from the Centurion.
  * Re-balanced the Aeon decoy plane.
  * Improved the CZAR speed matching of the Aeon decoy plane.
  * R&D: Added UEF tech 2 light power generator.
  * Added an Aeon tarmac for size 8 buildings.
    * Set the tech 2 storages and the Patron to use it.
  * Made the collision box of the Iyadesu narrower so it matches closer with main body, and includes less dead air.
  * Defined target nodes on the Iyadesu.
  * Added a Seraphim tarmac for size 8 buildings.
    * Applied to the tech 2 storages, tech 2 light power generator, and nuke defence.
  * Created a custom tarmac for the Stargate.

  ### 2018-08-26

  * Created the terrain type variants for the new Seraphim tarmacs, so they actually display on most default maps.
  * Paragon Game: Gave the Seraphim Paragon a unique model.
  * Paragon Game: Gave the Cybran Paragon a unique model.

  ### 2018-08-27

  * R&D: Fixed the research item descriptor field "Built by field engineer" having the wrong LOC and showing as "Built by engineer" instead.
  * Paragon Game: Fixed localisation and a few other minor things.
  * Removed unused sound effects from the Stargate.
  * Paragon Game: Improved the pre-set shield spawn positions.
  * Paragon Game: Changed the mod description.
  * New module: Gantry Homogeniser. Kills the factional diversity in the Gantries, and lets them all build anything.
  * Caffe Corretto: Disarmer weapon will no longer hide the bones of unturreted weapons.
  * Fixed the Iyadesu CheckBuildRestrictionsAllow function crashing if ScenarioInfo.Options.RestrictedCategories returns nil.
  * Merged the v81-FAF-develop changes.

  ### 2018-08-28

  * R&D: Added Aeon tech 2 light power generator.
  * R&D: Updated language strings.

  ### 2018-08-29

  * R&D: Added a "Built by experimental factory" ability for relevant research items.
  * R&D: 'Build by field engineer' now shows up on some research items not exclusive to field engineers.
  * R&D: Changed the default research cost mults from 1, 1, 2, 1 to 1, 1.25, 1.5, 1 for T1, 2, 3, & experimental.
  * R&D: Lowered the build rate of research centres.
  * R&D: Changed the research times of items to be based on the total output of the research centres.
  * R&D: Each Research centre now gain research discounts based on the total number of research items that specific centre has completed.
    * The buffs are a 1% reduction in mass, energy, and time for tech 1 research items, 2% for tech 2, 3% for tech 3, and 5% for experimental.
    * They are multiplicative for mass and energy, but additive for build speed, meaning diminishing returns for each.
  * Lowered the research energy cost multiplier of nuke mines to a third.

  ### 2018-08-30

  * R&D: Research completion buff no longer applies if the research failed or was cancelled.
  * R&D: Research completion buffs are now passed on to upgrades.
  * R&D: Added upgrade animations for UEF research centres.
  * R&D: Added Cybran tech 2 light power generator.

  ### 2018-08-31

  * Fixed the treadmarks on Cybran field engineers.
  * R&D: Cybran Tech 1&2 field engineers can no longer build both the ED4 and ED5.
  * The field engineer tech SCU upgrade now specifically restricts the regular tech 3 resource buildings, but only when the advanced ones exist.
    * This fixes the issue with them on getting nothing with R&D and on LOUD.

  ### 2018-09-01

  * New mod. Spomeniki.

  ### 2018-09-02

  * Spomeniki: New Spomenik.
  * Spomeniki: Tweaked spawn algorithms.
  * Allowed the Iyadesu to get blueprints from props if they have an associated BP.
  * Spomeniki: Added Ytho: Heavy Point Defence. Only buildable by the Iyadesu after reclaiming Spomenik Naroda.
  * Spomeniki: New Spomenik.
  * Spomeniki: Shrunk Naroda slightly.

  ### 2018-09-03

  * Spomeniki: Associated the disabled Cybran Decoy Plane with Spomenik Mramor.
  * Updated the stats of the disabled Cybran Decoy Plane, and changed the model from the spy plane model to an unused variant of the ASF.
  * Debug Tools: Now lists lod0 models in the units directory without a directly associated blueprint.
  * Updated the threat values of various units.
  * Updated the stats of the disabled UEF Decoy Plane, and changed the model from the spy plane model to the ASF model.
  * Corrected the ground collision offset after previous size-sphere changes to: Beguiler, UX Dragonlady, Selia, Souioz, Tornado, Pigeon, Respirer, Saksinokka, and Gannet.
  * UEF and Cybran Decoy Planes now get their stats movement matched to ASFs on game launch. They are still disabled. Cybran one can be built via Spomeniki.
  * R&D: Fixed a crash on *Supreme Commander* related to Seraphim not existing.
  * Moved some data to local for GetConstructEconomyModel to improve performance.
  * Did some additional arcane bullshit in GetConstructEconomyModel so it works on the original Supreme Commander.

  ### 2018-09-04

  * Spomeniki: New Spomenik.
  * Spomeniki: Changed the mod description.
  * New mod: Stolen Tech. Contains implementations of features from other things. Not as stolen as the name makes out.

  ### 2018-09-05

  * Started work towards having BrewLAN, its sub-mods, and its language documents no longer reference pre-existing entries in the language documents for unit names, descriptions and build descriptions.

  ### 2018-09-06

  * Removed the unused upgrade animations for the Aeon and UEF T1 shields.
  * Baked a number of stats into blueprints that were previously multipliers.
  * Simplified target priorities for a number of weapons.
  * Continued language and localisation changes.
    * Notable changes include:
      * Aeon and UEF mobile shield generator build descriptions in Polish, Chinese and Czech no longer reference Asylum and Parashield.
      * Tech 3 torpedo launchers and bombers are now prefixed with "Heavy", the Seraphim launcher being listed as a "Heavy Torpedo Platform" to match the conventions of the mobile sonars.
      * Cybran and UEF tech 3 mobile AA are now listed as "Mobile SAM Launcher"
      * Bubble Tea: Seraphim shield now listed as "Experimental Shield Lattice"
      * The second upgrade of Seraphim engineering stations are no longer have weirdly long in Polish, Chinese, Czech. One of them also referenced the Hive.
  * Reworked GetConstructEconomyModel so that is references the original when making changes, doesn't require the arcane bullshit to work on the original, and is a fraction of the length.

  ### 2018-09-07

  * R&D: Created Sanguine Tyrant: Cybran Tech 3 Penetrator Bomber.

  ### 2018-09-08

  * R&D: Sanguine Tyrant weapon systems and balance.

  ### 2018-09-09

  * Debug Tools: No longer logs unit data when Cybran construction drones are created.
  * R&D: Sanguine Tyrant changes:
    * Lowered health to 7215 from 7400.
    * Gave it functioning anti-missile flares.
    * Removed the old non-functioning anti-missile flares.
    * Tweaked the target priorities of the torpedoes.
    * Allowed it to wear hats.

  ### 2018-09-12

  * R&D: Created most of the model for Lancer.

  ### 2018-09-13

  * R&D: Finished the UEF Tech 3 Penetrator Bomber: Lancer.
  * R&D: Increased the fuel of the Sanguine Tyrant.
  * R&D: Defined a minimum range for the standoff missiles, so they hopefully miss less on attacks of opportunity.

  ### 2018-09-15

  * R&D: Fixed the tail UV mapping on the Lancer.
  * R&D: Fixed Lancer's script crashing if not spawned in. (derp)
  * R&D: Fixed a crash related to a race condition with GetFractionComplete on research centre items.

  ### 2018-09-17

  * Spomeniki: Made the monuments more likely to be spawned on the high points of the map.
  * R&D: Allowed Lancer to wear a hat.

  ### 2018-09-18

  * R&D: Added texture detail to the Lancer's wheels.
  * Spomeniki: Added a minimum distance between each spomenik.
  * Spomeniki: Made the 3 fists spomekik less likely, so it has the same chance as the others.

  ### 2018-09-19

  * Removed some old code from the drop-pod projectile code.
  * Gave the Absolution an attack reticule.

  ### 2018-09-21

  * Caffe Corretto: Added SACUs to the list of units the Tesla Coil can't stun.
  * Caffe Corretto: Tesla Coil now does a death discharge rather than a death EMP that didn't work.
  * Caffe Corretto: Power Adjacency now increases the maintenance consumption and damage of the Tesla Coil.
  * Caffe Corretto: Created a distance model for the Tesla Coil.

  ### 2018-09-23

  * Added real AI support for building Gantries. Regular and Sorian.
  * Bubble Tea: Removed the several categories from the drones of the lattice shield to prevent the AI from giving them orders.
  * Bubble Tea: Changed the threat values of the Seraphim shield so it's split between the drones.
  * Bubble Tea: Defined an icon override for the Seraphim shield drones with EIO active.
  * GantryUtils no longer causes an issue without Sorian AI active.
  * Fixed a case of AI unit data overwriting.

  ### 2018-09-25

  * Allowed vanilla non-cheating AI to build the BrewLAN optics buildings.
  * Cybran vanilla and Sorian AI will now build the ED3 and ED4 directly.
  * Vanilla and Sorian AI will now specifically build shields and engineering stations around Gantries.
  * Removed the old UEF Gantry built AI engineer control scripts.
  * Cybran vanilla and Sorian AI will now specifically build the Iron Curtain.
  * Seraphim vanilla and Sorian AI will now build engineering stations.
  * Allowed the Aeon vanilla and Sorian AI to upgrade T2 shields to T3 shields.

  ### 2018-09-26

  * Allowed the vanilla and Sorian AI to build and upgrade tech 1 shields.
  * Bubble Tea: Vanilla and Sorian AI now specifically build the shields, instead of occasionally building them instead of T3 shields.
  * Removed the category 'ENGINEER' from the Hives.
  * Made the railgun more reliable.
  * Fixed some duplicate platoon names.
  * Simplified the blueprints and changed the target priorities and categories of a number of units.
  * Walls no longer get rebuild bonus on the other factions equivalents.
  * Increased the rate of fire of Ivan by 50%.

  ### 2018-09-27

  * R&D: Lowered the energy cost of Penetrator Bomber research by 80%.
  * R&D: Lowered the build time of the Penetrator Bombers by 25%.

  ### 2018-09-28

  * R&D: Started the Seraphim Penetrator Bomber.

  ### 2018-09-29

  * R&D: Finished the Seraphim Penetrator Bomber.
  * Re-added the weapon category to the Ivan.
  * EIO: Changed indirect fire weapon calculation so it works if they have no weapon category.
  * EIO: Changed anti-navy and anti-air weapon calculations so they work if they have no weapon category.
  * EIO: Created all the remaining missing icon variations. All very unlikely, some potentially impossible.
  * Updated the readme file.

  ### 2018-09-30

  * EIO: Added an extra icon line for nuke weapon experimentals.
  * EIO: Created a double size icon range. Patreon exclusive until full release.

  ### 2018-10-02

  * Renamed BrewUI and the Gantry Hax mods.
  * Created a new module to house the BrewLAN AI functions.
  * Moved the majority of the AI functions from BrewLAN to BrewLAN: AI.
  * Removed unnecessary categories from more units.
  * Gave the Abyss Crawler water vision.
  * Gave water vision to the Seraphim Gantry.
  * Mines will no longer leave wreckages.
  * Seraphim tech 3 point defence is now categorised as size 4 not size 8.
  * Gave the Seraphim field engineers water vision.

  ### 2018-10-03

  * Aeon, Cybran and Seraphim Tech 1 torpedo bombers no longer count as bombers for AI.
  * Gave the Aeon tech 1 gunship a distance model.
  * Aeon tech 1 gunship now counts as tech 1 for air staging.
  * Removed an errant extra turret on the model of the Aeon tech 1 gunship left over from the old model.
  * Defined forced build spin for the Lancer so it doesn't clip with the factory.
  * Defined forced build spin for the Retributor and Abyss Crawler so they can't be in he Arthrolab sideways.
  * Fixed the Abyss Crawler.

  ### 2018-10-06

  * Aeon shielded mass extractor now disables it's shield when it disables production.

  ### 2018-10-18

  * R&D: Created the model and texture for the Aeon penetrator bomber.

  ### 2018-10-19

  * R&D: Added the Shrieker: Aeon Penetrator Bomber.
  * R&D: Improved the explosion on the missiles on the Sanguine Tyrant.

  ### 2018-10-20

  * R&D: Penetrator flares will now only deploy while airborne.

  ### 2018-10-29

  * R&D: Started work on the Cybran Penetration Fighter: Twilight Patron.

  ### 2018-11-01

  * R&D: Increased the flight height of the Twilight Patron so that bombers stop accidentally killing them.
  * R&D: Increased the texture resolution of the Twilight Patron.
  * R&D: Twilight Patron now cloaks while landed.

  ### 2018-11-04

  * Fixed my hooks of the Sorian AI platoons not correctly returning vanilla experimental behaviours.

  ### 2018-11-15

  * Stolen Tech: Changed the spawn menu filters so it doesn't rely so heavily on blueprint ID to filter units.

  ### 2018-11-25

  * AI: Refactored platoon.lua to use the original function first, whatever that may be.
  * AI: Added data for some FAF specific base templates.
  * Fixed a UI issue preventing the Stargate and Seraphim optics from working with FAF Nomads enabled.

  ### 2018-11-28

  * BrewLAN/R&D: Seraphim optics no longer gets the Satellite Uplink ability meant for the Seraphim dedicated omni that doesn't exist yet.

  ### 2018-12-06

  * Lucky Dip: Changed the description.
  * New mod: Mass Point Random; mass points are replaced with 0-5 mass points. Extracted from the unreleased infested mod.

  ### 2018-12-07

  * Moved the BrewLAN AI module into the modules sub-folder.

  ### 2018-12-08

  * R&D: Made the Twilight Patron more accurate.

  ### 2018-12-10

  * Created mod info files that are hidden in game for the mod categorisation directories.
    * These are specifically for the FAF vault release. They do nothing elsewhere.
  * R&D: You now get starting research based on starting units.

  ### 2018-12-11

  * Changed experimental factory unit assignment so they no longer receive FAF factory upgrade options that they can't use.
    * Side effect of this is that the Aeon and Seraphim experimental factories can now build field engineers.
  * Changed the build icon sort priority of the Aeon tech 2 defence engineer.

  ### 2018-12-12

  * Allowed the Gantry tarmac to appear rotated 180.
  * Added the following mods that used to be exclusive to the April 1st release and requestathon releases:
    * Knife Fight
    * Sudden Death
    * Invisible War
    * Scathing Beetles
    * Water Guard
  * Knife fight now has two knife options for units.
  * Scathing Beetles now works for both BrewLAN and Vanilla, and only affects anything if either is still using the original projectile.

  ### 2018-12-13

  * New mod, Rock Paper Scissors.
  * R&D: Research items now have defined build icon sort priorities.
  * R&D: Added a basic hovercraft factory for testing.

  ### 2018-12-14

  * R&D: Created the model for the Aeon Hovercraft Factory.

  ### 2018-12-15

  * R&D: Finished the Aeon Hovercraft Factories.

  ### 2018-12-15

  * RPS: Finished the script to generate the armor definitions table, which was more complicated than I was planning.
  * RPS: Corrected the blueprint script not properly handling experimental footfall damage.

  ### 2018-12-23

  * R&D: Removed some dependencies on BrewLAN.

  ### 2018-12-29

  * Caffe Corretto: Removed hard requirement for BrewLAN.

## 2018-08-09|81-FAF-develop (FAF exclusive release)

* Fixed transports.
* FAF Vault icon fix.

## 2018-08-09|0.8★ (No functional sim changes to BrewLAN, but changes to sub-mods)

* Localisation fixes.
* R&D: Sim-side localisation fix.

  ### 2018-08-12

  * R&D: Sorian and Vanilla AI behaviour
    * AI will now build a single research centre, and will rebuild if destroyed.
    * It will run through research at random, with intervals so it doesn't drain the economy.
    * Regular AI gets a 30% discount on research, AIx gets 60% and a 25% speed increase.
  * R&D: Research centres now all share a script.
    * This script also handles the AI research after it's built.
  * R&D: Ghetto research simulation now only triggers if the AI doesn't have the research platoon.

  ### 2018-08-12

  * R&D: Made work with LOUD.

  ### 2018-08-14

  * Caffe Corretto: Added Maelstrom. UEF Experimental AA. Effects unfinished.

  ### 2018-08-15

  * Debug Tools: Added a function to check units have the correct background image.

  ### 2018-08-16

  * Caffe Corretto: Added the weapons of Maelstrom and the disabled prototype disarmer turret to the default weapons files.
  * Debug Tools: Created a version of the DPS test unit that flies, for AA tests.
  * R&D: Deleted the hacky AI script.
  * Caffe Corretto: Finished the Maelstrom.

  ### 2018-08-18

  * Added the Maelstrom icon to the scd, and added translations for it.

## 2018-08-08|0.8 (v80 on FAF)

* Release version. The big 0.8. Git revision 666. BrewLAN is 9 years old in 2 and a half weeks.

## 2018-08-05|0.79900002479553 (Pronounced 0 point 7 9 9 floating point error)

* BrewLAN 0.8 release candidate 1.

  ### 2018-08-07

  * Crate Drop: Pings now spawns for correct player to see it.
  * Crate Drop: Pings now share a script.
  * Crate Drop is now *portable*.
    * This means it no longer requires the strict `/mods/brewlan_rng/cratedrop` directory structure.
    * Scripts now check file path locations, or used reference hooks.
    * The white headband top hat now has a it's own copy of the model, instead of a reference.
    * The mod icon is the only non-portable part of the mod.
  * Disabled nuke mines from tying to use the FAF feature to instantly detonate on ctrl-k, since it was causing an error.
  * Changed the death weapons of nuke mines so they also work on FAF.
  * The Crab Egg Salem is now buildable on the waters surface as well as land.
  * Tech 3 armoured gates now have a centre sections that appears when they're an end piece, corner piece, or alone.
  * Corrected targetting bones on armoured gates, so they go to the ground, not to the side, when closed.
  * Collision model fixes and tweaks:
    * Vishuum, Solaris, Uosthuum, Night Skimmer, Adramelech, Gantry, Excalibur, Ivan, CJ-00F4T-2, PW4TH12-ST Capacitor, Darkness, Recoil, Harrow, Procyon Offering, Absolution, Iyadesu, Bessemer Reactor, Engineering Mass Fabricator, LSD - Pulse, Metatron, Orbos, Nihiloid, Charis, Shielded Mass Extractor, Scarab, Moldovite, Novax Center, Wally, Custodian, Resupply, Aeon T2 Mass & Energy Storage, Guardian, Aster, Harpoon, Hexatron, Hedgehog, Cloakable Power Generator & Mass Fabricator, Cybran T2 Mass Storage, Ravitailler, Punisher, Poker, Operative, Uya-iyathan, Hyaliya, Iyaz, Iyazyn, Iyazyne, Athanne, Ilshatha, Othuushala, Athahaas, Iathu-uhthe, Yathesel, Suthanus, Chappa'ai, Iya, Iya, & Iya, Nightshade, Aezselen, Thaam-atha, Little Bertha, Flash Flood, Pillar of Prominence, Lamp, Uyalai, Iaathan, Neolith, Hiro, Superhot, Stouty, Shorty, Tesla Coil, Tyson, Sagan, & Hawking Campuses, Insight, Guidance, Enlightenment, Einstein, Schrodinger, & Heisenberg Facilities, Souiya, Iyathlabistle, Iyathlab, and Iyathluub.
  * Gave Nihiloid a wreckage.
  * Created a death animation for Lamp and Uyalai.
  * Corrected the selection priority of the Barwick & Stillson Classes.
  * Added the icons from Bubble Tea, Caffe Corretto, and Research & Daiquiris to BrewLAN.scd.
  * EIO: Made the description more concise.

  ### 2018-08-08

  * Added a distance model for Uyalai.
  * Added a Seraphim T3 Mobile Sensor Array.
  * Added build mode data for newer BrewLAN units that never got assigned.
  * Updated the language documents.

## 2017-01-18|0.7.9

* Paragon Game: Fixed an issue with civilian spawns.
* Paragon Game: Made the Paragon adjacency bonus not cause errors without BrewLAN enabled.

  ### 2017-01-19

  * Bubble Tea: Functionally finished the Aeon Experimental Shield Projector.

  ### 2017-01-20

  * Bubble Tea: Finished the model of the Aeon Experimental Shield Projector.

  ### 2017-01-21

  * Bubble Tea: Finished a texture for the Aeon Experimental Shield Projector, and gave it a description.

  ### 2017-01-25

  * Added an Aeon T2 mobile tactical missile defense.
  * Added a strategicicon for T2 mobile anti-missile.
  * Made the Aeon T3 mobile AA take up T3 transport slots instead of T2.
  * Re-enabled the Aeon T4 Air Factory, gave it a new model, a temporary texture, and a new script.
  * Bubble Tea: Added a distance model for the Aeon Shield Projector.

  ### 2017-01-26

  * Additional texture work on the Aeon T4 air factory.

  ### 2017-01-27

  * Aeon T4 Factory Changes:
    * New pathing area.
    * Updated texture.
    * Amended life-bar size and position.
    * Updated Build description.
  * Pulcheitudinousity: Made it not destroy the universe with certain mod combinations.
  * Fixed a potential compatibility issue with the unit.lua.
  * Waterlag: Fixed a potential compatibility issue with the unit.lua.

  ### 2017-01-29

  * Fixed the shader on the Independence Engine.
  * Added three distance models for the Independence Engine.
    * The normal quantity is one. This thing is too big for one.

  ### 2017-01-31

  * Baristas: New mod that dynamically adds in-game attribution for units by way of their abilities lists.
  * Added build animations to the Independence Engine.

  ### 2017-02-02

  * Ivan changes:
    * Units produced by it now have less max health rather than starting damage.
    * Pods that impact a shield now deal damage equal to the unit's mass value to that shield.
      * New tactic: firing 3735 mass Asters at them because you don't have a Mavor.
    * Pods that impact a shield no longer spawn the unit at all.
      * Previously it would spawn the unit then kill it, leaving a wreckage.
    * Units dropped somewhere they can't normally survive are now killed immediately instead of slowly.
    * Impacts now leave reclaimable remains of the drop-pod, which are worth 3 mass.
    * There is now a light flash when it impacts.
    * Fixed the specular texture for the projectile drop-pod.
  * Corrected a bunch of typos in the first part of the changelog.
  * Damage Numbers: A new mod that makes damage numbers appear.
    * Currently only works for your units taking damage.
  * Damage Numbers: Now shows both damage taken and dealt on self, as a workaround for the entity text only appearing for the controller.
  * Damage Numbers: Added a random quantity of spaces (0-5) either side of the number so they are sometimes off center.
  * Independence Engine now only moves its platform for the last 20% of the first unit in its queue.
    * It can't be assisted while the platform is moving, so this is a workaround compromise between function and aesthetics.

  ### 2017-02-04

  * Bubble Tea: Added a UEF Experimental Shield.
  * Bubble Tea: Aeon shield changes:
    * Energy cost up to 220000 from 200000.
    * Recharge time down to 100 from 110.
    * Regen rate 300 from 280.
    * Radius up to 70 from 60.
    * Built time 9000 from 8000.

  ### 2017-02-05

  * Bubble Tea: UEF Shield changes:
    * New AI names.
    * New name in English strings (default still the same).
    * Health up to 7000 from 6950.
    * Maintenance cost down to 2000 from 2500.
  * Bubble Tea: Aeon shield changes:
    * Health down to 4200 from 6950.
    * Maintenance cost down to 1600 from 2500.

  ### 2017-02-07

  * BrewUI: Now looks for textures in the BrewLAN directory.
  * Corrected a bunch of changelog 'typos' and typos.

  ### 2017-02-08

  * BrewUI: Fixed the broken factory idle tab from yesterdays change.

  ### 2017-02-09

  * Added a UEF T3 mobile AA. Stats temporary.

  ### 2017-02-10

  * Lucky Dip: Updated with T3 Mobile AAs for BlOps and FAF.
  * Lucky Dip: Moved unit table outside of function so it can be hooked.
  * Damage Numbers: No longer causes errors if something dies.
  * Added AI control for the Independence Engine.
  * Gantry now uses buffs for the AI cheats instead of direct modifiers.
  * Gantry AIxs 1 & 2: Reformatted and rebalanced for new Gantry code.
  * Gantry AIx 3: Same as 2, except it gives discounts instead of resources.
  * AI names for Independence Engine added.
  * EIO: Added Beam lifetime to the calculation.

  ### 2017-02-11

  * EIO: Started overhauled the DPS calculation system.

  ### 2017-02-12

  * EIO: Finished overhaul of DPS system. Its accurate about 97% of the time now.
  * Logger: New mod that outputs the DPS of weapons into the LOG.
  * UEF T3 mobile real AA changes and non-temp stats:
    * Name: NG3 Longbow
    * E: 12000
    * M: 850
    * Damage: 190 (DPS approx 319)
    * Health 5250
    * Radar: 350
    * Omni: 70
    * Vision: 35
    * Upkeep E: 750
    * Corrected turn animations for tracks.
    * Added dust kickup.
  * Rebalanced Alchemist:
    * Health: 7100 from 3500
    * Rof halved (DPS is now 427)
    * Enerhy per shot 250 from 1500
    * Energy storage 500 from 1500
    * Explosion 500 radius 1 from 2500 radius 2
  * Slink changes:
    * Can no longer attack land and sea
      * Description and designation changed to match
    * Health up to 2780 from 850
    * No longer has Jamming (still has cloak and stealth)
    * Energy 5870 from 8000
    * Mass 450 from 800
    * Build time 1800 from 4800
    * Upkeep 150 from 500
    * Damage 210 from 300
    * Distance model created
    * Slightly modified model
    * Updated texture
  * Aeon Decoy Plane is now T2, and has double its previous HP.
  * Changed the texture of the Anti-Artillery shield to differentiate it from normal shields.
  * Gave the anti-artillery shield a distance model.

  ### 2017-02-13

  * Improved the outputs of logger and the damage tester.
  * Improved mines:
    * All mines now have appropriate splat marks.
      * T2 UEF, Cybran, and Seraphim mines share splat marks with their factions strat bombers.
      * T1 and the Aeon T2 have default splat marks.
    * Cybran T2 mine has a better explosion.
    * All mines knock over and set fire to trees.
    * T1 & T2 mines now have different effects in water.
      * Seraphim T2 shares its water explosion with that of their T3 artillery.
      * Aeon, UEF, and Cybran T2 share an explosion based on the Seraphim explosion.
        * Cybran has extra effects to it.
      * T1 use their land explosion with an extra splash.
  * Non-UEF mobile strat defenses are no longer set to auto.
    * This fixes a long standing issue whereby they could get to 2/1 missiles.
  * Cybran mobile strat defense has a (partially complete) new model.
  * Darkened Slink specular texture a little.
  * Created test basis for a new 'freezing' mechanic.

  ### 2017-02-14

  * Beam wall codes now no longer tries to attach to dead units.
  * Beams now no longer overlay ad nauseum.
  * Mines no longer leave wreckages.
  * Mines now use the generic structure base script instead of the UEF structure base script.
  * Walls with build lists now use the generic factory base script instead of the Cybran land factory base script.

  ### 2017-02-15

  * Independence Engine now can be attacked from the ground. It has a spherical collision shape.
  * Independence Engine now has 8 different roll-off points, in the cardinal and primary intercardinal directions.
  * EIO & Logger: Fixed DPS for weapons that have their racks fire together.
  * Created a new tarmac for the Independence Engine, then shrunk it because all the exported files for it were 60mb.
    * They are still 12mb.

  ### 2017-02-16

  * Walls now have tarmacs again.
  * UEF walls now behave correctly when first built.
    * The bug was caused by the UEF built animations. Seriously.
  * Damage test unit now logs terrain type and looks like a 3310.

  ### 2017-02-17

  * UEF T3 walls and gates are now visible from further away.
  * Changelog and mod-status converted into markdown.
  * Mod-status document split into BrewLAN and sub-mods.

  ### 2017-02-18

  * Advanced wall scripts now check if the unit already has a tarmac before giving it a tarmac.
  * All units can now be drag-built. Most relevant for the Iyadesu.

  ### 2017-02-19

  * Restricted the Iyadesu to only being able to build units with a defined tech level.
    * This stops it from learning blueprints the UI doesn't allow it to be given orders to build.

  ### 2017-02-20

  * Gave the Aeon T3 mobile AA two distance models.
  * The distance model of the Iyadesu now matches the current model.
  * The collision model of the Iyadesu is now representative of its size.
  * The collision models of the T3 mobile AA's are now more representative of their sizes.
  * Updated the EN-US strings from the spreadsheet for BrewLAN and Bubble Tea. Process still isn't automated.
  * Iyadesu drones now fly higher.
  * Iyadesu drones now return if they get too far away.
  * New almost working sub-mod that will give map based re-skins for units.
  * Bubble Tea: Disabled the beam effect on the Aeon shield.
  * Expert Camo: Renamed from Expert Cammo.
  * Expert Camo: Added Mongoose RedRock texture.
    * It looks god-awful, but it works. Unlike the Centurion, which bugs out.

  ### 2017-02-21

  * Rewrote the Centurion script.
  * Removed the Centurion's sonar.
    * At one point it was going to have a depth charge weapon, but it got the anti-ASF laser instead.
  * Centurion now has a build cube for its build animation.
  * Created a new texture for the Centurion.

  ### 2017-02-22

  * Expert Camo: Removed most of the textures from the repo.
    * They have the potential to make space requirements spiral out of control.
    * I will provide them externally.
  * Expert Camo: Added 'Default' to the list of terrain types.
  * BrewLAN now runs on original SupCom (specifically only version 1.1.0).
    * By that I mean it no longer crashes it or breaks everything.
    * The degree to which any individual unit works varies substantially.
  * Damage Numbers: Fix for things getting one-shotted.
  * Overhauled the build mode data key assignment for the Gantry. (Build mode shortcut key is B)
    * Overlapping key values are now bumped to the next free value, instead of overwritten.
    * The priority order is Land, Air, Sea for tech 1-3. UEF, Cybran, Aeon, Seraphim for experimental.
    * Still to do: Fix build mode for experimentals putting the Gantry into command mode.
  * Added build mode key shortcuts for newer units that were lacking.
  * Added build mode bindings for building with field engineers.
    * Ran out of free keys for the actual field engineer units, pending a rework of that.

  ### 2017-02-23

  * Finished the rework of the key bindings. Field engineers and advanced resource buildings now have their build keys.

  ### 2017-02-24

  * Expert Camo: Now also works with Sup Com 1.1.0.
  * Atlantis Gantry roll-of script now moved to Gantry. Atlantis hook script removed.

  ### 2017-02-25

  * Decreased the collision size of the Longbow, Alchemist, and Slink.
  * Expert Camo: Overhauled so now, rather than auto generating skins for itself, it can be used as a framework for other mods that just contain the component files for it to assemble for them.

  ### 2017-02-26

  * Removed all the textures from Expert Camo.
  * Added new icons to SCD.
  * Changed the unit prefix of the units added by Paragon Game.
  * Fixed the accidentally broken Gantry building Atlantis.

  ### 2017-02-27 — 2017-03-02

  * Created Arthrolab: Cybran Experimental Land Factory.

  ### 2017-03-03

  * Aeon Experimental Factory now has the Gantry 'stolen tech' function.
  * Gantry 'stolen tech' function split into its own separate util function for all experimental factories.

  ### 2017-03-04

  * Adjusted the balance of the experimental factories:
    * Gantry:
      * Health to 112000 from 88000.
      * Energy to 156750 from 85050.
      * Mass still 9450.
      * Time to 7034 from 12600.
    * Independence engine:
      * Health: 80000.
      * Energy: 315000.
      * Mass: 7090.
      * Time 7000.
    * Arthrolab:
      * Health: 76000.
      * Energy: 85050.
      * Mass: 8790.
      * Time: 6580.

  ### 2017-03-06

  * Fixed the Scarab, which had at some point either lost bones, or gained dodgy bone references.
  * Added raised platform data for the Independence Engine so land units that end up inside it walk on it not in it.
  * All Experimental Factory code now works on original Supreme Commander.

  ### 2017-03-07

  * Gave the ADG a unique type class.
  * Expanded the range of version numbers from original SupCom that the scripts will look for.
  * Increased the max power drain per second of the Scathis Mk2.
    * Actual power drain per shot remains the same.
    * Rate of fire unassisted now increased.
    * Power generators around the Scathis now have no noticeable RoF effect.
  * Resource cost of Scathis Mk2 increased by a trivial amount.
  * Caffe Corretto: New mod for advanced field engineer weapon tech.
    * New unit: Accuracy Boost Node.
  * Updated icons for Cybran mobile strat defence.

  ### 2017-03-08 — 2017-03-09

  * Caffe Corretto: Experimented with a damage boost node.
    * Found out that the default buff function for damage does nothing.
      * Bypassed the default function.
        * Found out that the ChangeDamage function on a weapon just straight up doesn't work.

  ### 2017-03-11

  * Paragon Game: Fixed civilians not appearing.
  * Added the Cybran T3 Mobile Sensor Array.

  ### 2017-03-12

  * Citron fixes:
    * No longer draws power whilst moving.
    * No longer gets free intel and stealth when moved after disabling.
    * Fixed the normals on the track flaps.

  ### 2017-03-13 — 2017-03-14

  * Created a distance model for the Citron.
  * Made Citron leave ground markings behind when it retracts its mast.
  * Allowed units to leave from the sides of the Artholab.
    * Some units look hilarious climbing the side spikes.
    * It is quicker for production to have them leave from the front still.

  ### 2017-03-15

  * Added a placeholder version of the UEF T2 recon aircraft.

  ### 2017-03-19

  * Moved version check omni nerf fix from Darkness script to global buff script.
  * Improved FAF support.
  * Listed the stealth field ability on the Darkness.
  * Drop-pod script now uses the compatibility check version of buffs.

  ### 2017-03-22

  * Bubble Tea: Pillar of Prominence:
    * Fixed it constantly re-generating every shield bubble as a result of removing the beams.
    * Removed the left-over remnants of the beam code.
    * Units that were shielded by one when its shield was destroyed can now be shielded by it again.
      * This bug may have been caused by the above changes and never actually published, but if it wasn't it's fixed now.
    * Now stops generating new shields when disabled by damage.
    * Now stops generating new shields when disabled by a power outage.
    * It is now on the lookout for spontaneous shield outages, and stops generating shields in that case.
      * It now stops its animations and clears its particle effects in these events.
  * Bubble Tea: projected shields:
    * Added the beam effect removed from the projector to the projected shield script, appearing for 5 ticks when damaged.
    * The damage to deal to the projectors is now calculated once instead of once for each projector to damage.
    * The projected shields now check if the damage dealt would be lethal to the parent projectors.
    * Overkill damage resulting from a parent not having enough shield health is now re-distributed among other parents recursively. If there are no other parents the remaining is dealt to the unit.
    * Removed the default code for overkill calculation and regeneration from the projected shields, since they remain on 100% for their lifetime.
    * Projectiles no longer collide with the shields if they have no owners and shouldn't exist.
  * Gantry AIx 2: Fixed a reference to an old non-existent function.  

  ### 2017-03-23

  * Drop-pod remains no longer block pathing.
  * Listed the sonar and torpedo abilities of the Cybran T1 Torpedo Bomber.

  ### 2017-03-24

  * FAF: Fixed the cloakable resource buildings and stealth fields (mobile and building), and all mines, not using the cloak effect when they first cloak.
    * They were actually cloaked, but the script didn't realise.
    * This fix will also work for regular BrewLAN/BlackOps cross-play, since they use the same script.
    * In the case of the mines, they actually cloak on create, not on stop being built, so its graphically inaccurate, but applying the effect on create would look wrong and would revert when its finished being built.
  * Land mines now follow the slope of the terrain. It's *so* satisfying.
    * The Cybran T1 landmine needs its model re-orientating.
  * Drop-pod remains follow the slope of the terrain.
    * They are no longer spawned a random orientation, until I can translate the angles for arbitrary rotations.
  * The cardinal wall scripts now check for bone conflicts after setting bones by type. (This fixes the overlaps in the Aeon T2 wall, and the Cybran T3 wall.)
  * T1 and T2 walls currently also use the slope script.

  ### 2017-03-26

  * Moved the building sloping script from the wall parent class to the top level unit class, and required units have a bp trigger to use it.
    * Gave T1 walls, the T1 Cybran mine, and the Seraphim T3 shield wall the bp trigger.
      * Other mines still use their version of the code, because I don't want to edit 11 blueprints just yet.
      * The Cybran was an exception because it allowed use of the new option to pick axis and inversions, which the Cybran T1 mine and Seraphim T1 wall needed.
  * Bubble Tea: Moved the projector tracking table of bubbles created by the Aeon experimental shield to the unit the shield is covering.
    * This fixes the issue of damage getting split between ALL projectors instead of just the nearby ones.
  * Bubble Tea: Created a workaround for GAZ_UI breaking whenever you mouse-over a unit with a projected shield with enhanced unit-view enabled.
    * Units that could have a projected shield now have a ShieldMaxHealth defined as 1.
      * This only affects things that check there like GAZ_UI. The projected shields don't care.
  * Bubble Tea: Created a new shield mesh for the projected shields.

  ### 2017-04-02

  * Added a new bone positioning script for the UEF T2 wall.
  * Reduced the tarmac size of the UEF T2 wall.

  ### 2017-04-03

  * Moved the bone positioning script to be usable by any unit.
    * Of the walls, the script is still only used by the UEF T2 wall, due to the bone positioning of the other walls.
  * All mines now use the unit.lua defined terrain slope script.    
  * Ivan drop-pod remains now no longer spawn on top of units they land on.
  * Mines built in the water now sink a uniform distance below the surface.
  * Remains from drop-pods that land on flat terrain now have a random orientation again.

  ### 2017-04-04

  * Overhaul of the Experimental factory script backends.
    * They now all share the majority of their functional non-animation based scripts.
      * Each of the experimental factories has the full AI functionality of the Gantry.
  * Independence Engine can now build engineers.
  * AI controlled Arthrolab and Independence Engine can now build any experimental.
  * Independence Engine now only raises its platform for air units.
  * Arthrolab arm movements now more accurately based on unit sizes.
  * Defined minimum and maximum values for all arm positions.
  * Very large units and weirdly oblong units no longer spin in the Arthrolab.
    * Fatboy/Absolution size and shape is the maximum for spinning, as defined by the skirt size.
  * Gantry AIx Hax 1-3: Updated to modify the new linked gantry scripts.
    * This also means that versions 1 and 2 now also work with the Independence Engine and the Arthrolab.
  * Gantry AIx Hax 1: Refactored it so that it only creates one cheat thread per factory, not per factory per unit that factory has ever made.
    * Functionally the same for game purposes.

  ### 2017-04-06

  * Created a model and basic texture for the UEF T2 recon craft.

  ### 2017-04-07

  * Created a new texture for the UEF T2 wall.
  * Removed the gap in the UEF T2 wall's model visible on slopes with the new script.
  * Created a new damaged model for the UEF T2 wall. Currently unimplemented.

  ### 2017-04-08

  * Reclassified the Recon Craft and Decoy Craft as Recon Plane and Decoy Plane.
  * Gave the Recon Plane a build description.
  * Gave the Recon Plane a build icon.
  * Updated the US LOC from the translation document.
  * Started creating a proper texture for the UEF Recon Plane.

  ### 2017-04-12

  * Finished the texture of the UEF T2 recon plane, which was abandoned before between creating the changelog message and actually finishing it.
  * Doubled the air speed of the UEF spy satellite.
    * There is no reason for it to be as slow as its ion cannon predecessor.
    * It is still the slowest aircraft by a good margin.
  * Caffe Corretto: Added a prototype Seraphim T3 disarming point defence.
    * Currently it lacks effects and actual balancing, but it works and its funny.

  ### 2017-04-13

  * Added build description for currently non-existent Seraphim T2 spy plane.
  * FAF related changes:
    * Overhauled the balance matching script
      * It now takes into account any tables you tell it to instead of just mass and energy build costs, build time, and build speed, from the economy table.
      * Newly synced variables:
        * Maintenance cost and kill requirements on T3 transports.
        * T1 Gunship kill requirements.
        * T2 Aeon decoy plane movement stats against the ASF.
        * T3 torpedo bomber transport class.
      * It now has the data to, although not the capacity yet, to set a unit stats to an average of other units stats.
        * This will affect:
          * UEF T2 recon plane for build cost, intel, and transport class.
            * In FAF this means it is cheaper, has better radar, and uses air staging like a T1.
          * Aeon T2 decoy plane for transport class.
    * Added a new launch script which only triggers on FAF which:
      * Allows BrewLAN aircraft to cash into water.
    * T1 torpedo bombers now have AI guard scan variables.
    * T3 torpedo bombers now have unified AI guard scan radii.
      * Seraphim didn't have any, UEF had very large, Cybran had very small.
    * T3 transports:
      * Shields on the Seraphim and Aeon T3 transports are now categorised as transport shields for damage calculations.
      * Transport hover height set to 6, from 3.
      * Weapons are now willing to target from more layers.
  * Fixed the selection offset of the Cybran T3 transport.
  * Changed the build icon sort of the UEF T2 recon plane, so it sorts after Sparky, but before Janus.
  * Changed the unit ID of the Aeon T2 decoy plane to saa0201 from saa0310.

  ### 2017-04-14

  * FAF related changes:
    * FAF only additions:
      * BrewLAN hovering units can now wreckage on water.
    * Balance sync changes:
      * The average code has now been implemented.

  ### 2017-04-15

  * FAF related changes:
    * Balance sync changes:
      * Added functionality for syncing shields.
      * Mobile shield gen costs and shields now synced.
    * Unit changes:
      * Mobile shield gens given dummy weapons and spill over variables.
  * Fixed transport class of Seraphim T2 shield gen.
  * Fixed tread marks of the Aeon T3 mobile shield.

  ### 2017-04-16

  * Orbos technical changes (functionally almost identical):
    * Improved the script.
    * Changed DoT rate from 500 every 0.2 seconds to 250 every 0.1.

  ### 2017-04-17

  * Added a basic version of the Seraphim Experimental Naval Factory.

  ### 2017-04-18

  * Updated translation documents with auto generated strings.
  * Added auto generated translations for Spanish, Italian, Polish, and Chinese.
  * Added sanitisation checks to the Gantry build picker script.
  * Removed part of the build pre-set for the Seraphim experimental naval yard which was breaking things.

  ### 2017-04-19

  * Corrected the folder name for the Chinese translation document, which uses CN instead of the ISO 639-1 code ZH.
  * Fixed the gaps in the French and Russian language documents, which were causing issues.
  * Added an auto generated Czech language strings document.
  * Improved the auto generated translations regarding the name of the ability 'cloak'.

  ### 2017-04-20

  * Bubble Tea: Created a death animation for the UEF Experimental Shield.
  * Bubble Tea: Created a distance model for the UEF Experimental Shield.
  * Added the icons from Bubble Tea and Caffe Corretto to the brewlan.scd.
  * Bubble Tea: Created 3 death animations for the Pillar of Prominence.
  * Created unique distance models for the Seraphim Engineering Stations.

  ### 2017-04-21

  * Bubble Tea: Created two additional variants of the UEF Experimental Shield explosion.
  * Created a death animation for the Anti-Artillery shield.
  * Created a death animation for the Seraphim T1 Light Air Staging.

  ### 2017-04-22

  * Bubble Tea: UEF Shield now creates decal splats when panels hit the ground and when it finally explodes.
  * Bubble Tea: Corrected the texture and uv mapping of the UEF Shield.
  * Fixed the long standing but meaningless bug with the UEF T3 torpedo tower's floatation appearing at inappropriate times.
  * Fixed the texture reference on the Centurion distance model.

  ### 2017-04-23

  * Bubble Tea: Created 4 extra dying animation variants for the Pillar of Prominence.
  * Bubble Tea: Halved the radius of the Pillar of Prominence to what it should be. A mix-up with radius vs diameter that I never questioned.
  * Moved the field engineering ship assist AI thread to the field engineers lua file, and referenced it.

  ### 2017-04-24

  * Gave the UEF T1 field engineering boat a build speed.
    * HOW DID NO ONE NOTICE THIS.
  * Added a Cybran T1 field engineering boat.
  * Created string entries for Cybran T1-3 field engineering vessels.

  ### 2017-04-25

  * Bubble Tea: Fixed death animation breaking when it dies before it finishes construction.

  ### 2017-05-02

  * Created a better model for the Seraphim Experimental Naval Factory.

  ### 2017-05-04

  * Fixed the icon of the beguiler after breaking it whilst changing its unit code.
  * Independence Engine now uses the distance textures provided.

  ### 2017-05-13

  * Crate Drop: Added a new hat.

  ### 2017-05-15

  * Fixed gates blocking projectiles whilst closed.

  ### 2017-05-16

  * Gate target bones now move to the land surface whilst the gate is open.
  * Gates now use the their defined height to determine distance to move to close.
  * The segments of each gate now align to terrain height.

  ### 2017-06-12

  * Bubble Tea: Fixed issues related to reclaiming or script 'destroying' the Pillar of Prominence.

  ### 2017-07-05

  * Added an Aeon T3 mobile sensor array.

  ### 2017-07-13

  * Listed Metatron's hover ability.
  * Created icons for Metatron and the Franklin Class.

  ### 2017-08-03

  * Partially added a Seraphim T3 torpedo launcher.

  ### 2017-08-17

  * Added faction names and snarky comments to units missing faction names.

  ### 2017-09-01

  * Seraphim T3 Torpedo Launcher changes:
    * Now actually buildable.
    * No longer has torpedo defence.
    * Now has a transport class equal to that of a T3 unit.
    * Gave real stats.
    * Gave a unique name.
    * Gave a build description.
    * Gave an icon.

  ### 2017-09-13

  * Added faction names to the dummy Megalith egg units that have their faction names populated by launch scripts, which was causing issues for FAF having those values populated that late.

  ### 2017-12-23

  * Fixed Paragon Game unit ID references.

  ### 2017-12-27

  * Torpedo bombers are no longer immune to torpedoes while landed on the water.
  * Albatross no longer lands on the sea bed or flies through water.
    * Whilst cute, this allowed the Albatross to avoid any AA which is destroyed on contact with water, and also made them almost impossible to kill while landed.
      * While this second point would no longer be true now, the first point still stands.
  * Fixed Aeon T3 mobile sensor giving free intel when first constructed.
  * UEF T3 mobile AA no longer has its intel enabled from the get-go.
  * Cleaned up the script of the Armillary.
  * Reduced the target check interval of the Armillary from 0.3 to 1.5 so a group no longer aimbots everything out of the sky in a single shot.
  * Armillary will now prioritise targeting experimentals over bombers.

  ### 2017-12-28

  * Fixed the regen rate of the Seraphim Armoured Extractor, which was 0 instead of 10.

  ### 2018-01-03

  * UEF T1 Air Staging retexture.

  ### 2018-01-05

  * Added a non-functional unbuildable arbitrary-stats WIP UEF Experimental Point Defence, so I can work on it in America; I got a flight to go catch.

  ### 2018-01-17

  * Mostly finished the UEF Experimental Point Defence.

  ### 2018-01-19

  * Sorian AI can now build the Experimental Point Defence.
  * Caffe Corretto: Added a new UEF T3 turret. Field engineer only. It is literally torn off the Neptune.

  ### 2018-01-26

  * Increased the collision height of the UEF T1 air staging.
  * Renamed UEF Experimental Point Defence to Excalibur to match final results of poll.
  * Replaced beam weapon of Excalibur with a projectile railgun.
    * Removed splash damage.
    * Damage now dealt instantly instead of over 1 second.
    * Projectile penetrates targets.

  ### 2018-01-30

  * Reduced firing tolerance of Excalibur to 0 to prevent early fired shots that hit nothing.
  * Corrected ballistic calculation category of Excalibur to low arc, since it technically has an arc.
  * Excalibur now leads its targets, for times when that actually matters.
  * Fixed a case of the Longbow having intel effects active while intel is inactive.
  * Caffe Corretto: Added UEF T2 Anti-Armor Point Defence.

  ### 2018-02-01

  * Caffe Corretto: Icon and strings for T2 anti-armor point defense.
  * Adjusted the automatically chosen build list for builder walls:
    * Field engineer tech added.
    * Walls and mines now restricted.
  * Caffe Corretto: UEF T1 anti-armor point defense added.
  * Caffe Corretto: Fixed categorisation of Hiro so builder walls can build it.
  * Replaced icon for Guardian to better match icons of Caffe Corretto T1&2 AAPDs.
  * Caffe Corretto: Altered the life bar offset of Hiro.

  ### 2018-02-02

  * Paragon Game: Fix for FAF.

  ### 2018-02-04

  * Fixed Novax on FAF, which was broken because they fixed a typo in a place that isn't visible in game.

  ### 2018-02-06

  * Caffe Corretto: Added Cybran Experimental Point Defence.
  * Caffe Corretto: Fixed UEF T1&2 AAPD mod-origin categories.

  ### 2018-02-09

  * TeaD: Added translation support.
  * TeaD: Added unit descriptions for buildable units.
  * TeaD: Changed the unit code prefixes of buildable units from T to S.
    * The starting unit and the creeps are still prefix T.
  * Caffe Corretto: Added build description for Neolith.

  ### 2018-02-20

  * Created a new model for the Panopticon.
  * Massively increased the footprint size of the Panopticon.
  * Created idle animations for the Panopticon.

  ### 2018-02-21

  * Created new tarmac and icon for Panopticon.
  * Increased the size category of the Panopticon.
  * Finished Panopticon texture.

  ### 2018-02-23

  * Renamed the testing mod Blueprint Logger to Debug Tools.
  * Debug Tools: Moved the damage test unit to Debug Tools.
  * Debug Tools: Changed the log output of the damage test unit to CSV for graphing purposes.
  * Debug Tools: Tripled the size of the damage test unit, so its harder to miss.
  * Debug Tools: Made the damage test unit buildable.
  * Made the hinges of the Panopticon more blue.
  * TeaD: Made the cup black and updated the logo to the logo design, and fixed the specular map.

  ### 2018-03-07

  * Visual appearance rework for all aspects of the Iyadesu.
    * Notable functional changes include:
      * The firing arc of the laser is now only 30 degrees in front, instead of full 180.
      * The minimum range of the laser is now 4, from 10.
      * Drones now dock and are selectable, but still stay within a certain range of the parent.
  * Iyadesu laser damage per tick halved, but tick rate doubled. DPS identical.

  ### 2018-03-10

  * Changed the description of the Iyadesu to reflect its 8 BP cap.
  * Updated translation documents.
  * Created distance models for the Iyadesu.
  * Changed the particle effects and sound effects of the Iyadesu drones.

  ### 2018-03-13

  * Overhauled the adjacency bonuses of large buildings.
    * Independence Engine is now size 60.
    * Panopticon and Arthrolab are now size 36.
    * Souiya is now size 32.
    * Gantry remains size 20.
    * Stargate is now size 24.

  ### 2018-03-14

  * Fixed the rebuild bonus and tech level icon of Seraphim T1 artillery.

  ### 2018-03-15

  * Fixed the Stargate having the wrong size category, which was breaking ALL adjacency bonuses.
    * It should have been 24, but it was actually 32.
  * Added a new mod: Corrosive Ocean. It does what it sounds like. You probably wont be able to sustain a fleet.

  ### 2018-03-16

  * Added a melee attack to the Iyadesu.
    * Currently it uses beams, which will eventually be invisible.
  * Lowered the trample damage of the Iyadesu, to stop it from destroying as many of the reclaim targets clumsily.

  ### 2018-03-17

  * Fixed the icons for the units from Paragon game.

  ### 2018-03-20

  * Debug tools: Added log output to all units on creation for map making purposes.

  ### 2018-03-28

  * Removed unnecessary data from the observation Novax.
  * Logger: Added some test code for scaling intel with map size.
  * Logger: Added a speaker unit.
  * Logger: Moved the icon for the damage test unit to Logger.
  * Added the logger speaker icon to the brewlan.scd, because logger isn't getting its own .scd.
  * Crate Drop: Made the intel buff crit actually significant.
  * Logger: Commented out the test code for intel scaling, because it wasn't fully functional.
  * New mod: Research & Daiquiri's.
    * Currently only contains a UEF omni sensor.

  ### 2018-03-31

  * R&D: Added the UEF research centres.
  * R&D & other: Research locked various UEF units, this only takes affect while R&D is enabled, specifically:
    * All UEF Caffe Corretto units.
    * The UEF Experimental Shield from Bubble Tea.
    * The UEF Mines, T1 Artillery, and Panopticon from BrewLAN.
    * The omni sensor from R&D.
    * The grotesquely unfinished Seraphim disarming laser from Caffe Corretto. (This functionally disables it.)
  * R&D: Created a dynamic backend for creating research units.
  * R&D: Half the research costs of the Panopticon.
  * R&D: Added notes for what each research item is built by.
  * R&D: Added icons.

  ### 2018-03-31

  * R&D: Added a UEF T1 wind turbine.

  ### 2018-04-03

  * R&D: Added random wind.
  * R&D: Added an Aeon T1 wind turbine.
  * R&D: Moved class definitions to defaultunits.lua
  * R&D: Added icon for UEF wind turbine.
  * R&D: Research locked normal UEF power generator.

  ### 2018-04-09

  * Turrets: Added a Cybran Tech 3 Tesla Coil.

  ### 2018-04-10

  * Turrets: Gave the Tesla Coil ambient sounds.
  * Turrets: Increased the LOD0 cutoff of the Tesla Coil.
  * Turrets: Moved some stats of the Tesla Coil from the script to the BP.
  * Turrets: Increased the Tesla Coil stun duration to 6 ticks, from 5.
  * Turrets: Added an off button to the Tesla Coil.
  * Turrets: Created an icon for the Tesla Coil.
  * Turrets: Made the UEF Damage Boost Node work, enabled it, and finished it.

  ### 2018-04-12

  * Overhauled the Solaris script. Visual effects mostly the same, including the increasing speed each time the shield needs re-activating.
  * R&D & Turrets: Corrected some incorrect product codes, and unified RND codes.
  * Recalculated threat values of all BrewLAN mods' units based on a formula I am also developing for LOUD.
    * Most AIs other than LOUD don't use the threat values, so these are being balanced to LOUD.
  * Changed the listed ability on shield walls, and the shielded fabricator and power gen to be 'personal shield'.

  ### 2018-04-15

  * Overhauled T2 energy storage scripts. Weapon damage is now entirely variable based on energy in storage, as opposed to having 5 pre-set damage levels.
  * Logger: Now logs what the calculated threat values of selected units should be on launch.
  * Finished applying the recalculated threat values.
  * Removed the 'Volatile' ability listing from the Hades. It can overheat, but it's doesn't have a death weapon, which is what 'Volatile' should mean.
  * Removed the errant build rate value from the Hades, Absolution, and Stargate.
  * R&D: Changed the listed production value of the wind turbines to the average production, instead of the max.

  ### 2018-04-21

  * Logger: Updated threat script and threat values.

  ### 2018-05-01

  * R&D: Added tech level researches.

  ### 2018-05-02

  * R&D: Added temporary models for Aeon, Cybran and Seraphim research centres.
  * R&D: Research locked a bunch of units:
    * All mines
    * Advanced resource buildings
    * Tech 1 artillery
    * All units from Caffe Corretto
    * All units from Bubble Tea.
    * The Iron Curtain.
    * The Darkness.
    * The Suthanus (T4 artillery).
    * The Stargate.
    * The Aeon T1 power generator.
  * Turrets: Damage boost node is now volitile.
  * R&D: Added build descriptions.
  * R&D: Added icons.
  * R&D: Fixed the Aeon T3 research centre.
  * R&D: Removed the research restriction from the Iron Curtain.

  ### 2018-05-04

  * R&D: Updated the names of the non-UEF research centres to have their names.
  * R&D: Commented out the LOG messages for the creation of research items.
  * R&D: Reduced the build time of the tech 1 research centres from 400 to 250.
  * R&D: Fixed an issue with soft category defined upgrades in factories allowing factories to build factories.
  * R&D: Increased the health of tech 2 and tech 3 research centres to 6000 and 12000 respectively.

  ### 2018-05-14

  * Shields: Added a basic version of the Seraphim experimental shield:
    * Texture unfinished, no icons.
    * It lacks any of the damage share the final version will need for balance.
    * Currently in it's OP early production proof of concept form.

  ### 2018-05-15

  * Shields: Seraphim experimental shield now averages out the bubble health when it is disabled and re-enabled.
  * Shields: Removed some unnecessary data from the shield drones.
  * Shields: Lowered the health values of the outer drones.
  * Shields: Added death animations to the Seraphim shield.
  * Shields: Fixed the audio for the Seraphim shield and shield drones.

  ### 2018-05-16

  * Shields: New textures for Seraphim shield.
  * Resurrection Engineer compatibility with R&D.
    * For this it has to unrestrict the unit for the player as well as itself, meaning it could unrestrict things it should be able to.
  * R&D & Shields: Added icons for the Aeon turbine, tech 1 power generator research items, and Seraphim experimental shield and shield drones.
  * R&D: Fixed internal directory structure for icons.

  ### 2018-05-18

  * Shields: Added another death animation for the Seraphim shield.
  * Shields & BrewLAN: Removed errant range categories from experimental shields.

  ### 2018-05-23

  * Shields & BrewLAN: Unified visual range for experimental shields to be the same as shield range.

  ### 2018-05-24

  * Changed the shield bubble of the ADG.
  * R&D: Finished the UEF dedicated omni.
  * Moved the animation thread for the Panopticon to its own document, then referenced it for the Panopticon and the Coleman.
  * R&D: Created models for the Seraphim research centres, and fixed all the effects.
  * R&D: Reduced the research costs of the Suthanus to a 10th.
  * R&D: Reduced the research time of the Panopticon to match the costs.
  * R&D: Reduced the research costs of the Darkness by half.

  ### 2018-05-27

  * R&D: Added the UEF T2 tactical bomber. Texture unfinished.
  * R&D: Added the missing descriptions.

  ### 2018-06-12

  * R&D: Finished the texture of the UEF Tactical Bomber.
  * R&D: Gave the UEF Tactical Bomber a tailgun.
  * R&D: Created a script for the UEF Tactical Bomber.
  * R&D: Created a new projectile for the UEF Tactical Bomber.

  ### 2018-06-21

  * Changed the names of the T2 storage buffs to prevent a conflict with LOUD.

  ### 2018-06-24

  * Included the DEV_TEX map I use for icon creation. Created in 2009.

  ### 2018-06-28

  * Added a Seraphim jammer building.
  * Nightshade can no longer get rebuild bonus when built on the wreckage of the T2.
  * R&D: Added a Seraphim wind turbine, and research locked the regular power plant.
  * R&D: Fixed the Aeon turbine having UEF sounds.

  ### 2018-06-29

  * Gave the jammer building some dummy units like its campaign equivalent.

  ### 2018-07-01

  * Novax rework:
    * Satellite changes:
      * Increased the elevation to the max it can be without going off-screen on a 5km map.
      * Increased base speed.
      * Set it to have 60 seconds of fuel.
        * Since it can't refuel, this means it only gets to move at full speed for the first 60 seconds.
      * Removed the Omni, Sonar, and Radar, reduced the visual radius, and increased the water vision radius to match.
  * R&D & BrewLAN: Updated threat values.
  * Paragon Game: Fixed the Paragon size categories.

  ### 2018-07-03

  * Novax rework continued:
    * Uplink changes:
      * Now a factory.
      * Cost reduced by value of one satellite.
      * Satellites no longer free.
      * Classified as a 'satellite uplink' building.

  ### 2018-07-04

  * Novax rework continued:
    * Satellite changes:
      * Fuel is now proportional to map size
        * At full speed it can move 20km on a 20km map, and so on.
      * It is no longer subject to the parent/child interactions.
      * Sensors no longer active before unpack animation finishes.
  * Listed 'Satellite Uplink' as an Ability for the Archimedes.
    * It doesn't actually do anything for the observation satellite, it is assumed to be perma-linked the LOIC.
  * R&D & BrewLAN: Listed 'Satellite Uplink' as an ability for the Panopticon and the dedicated Omni.
    * It doesn't do anything for these yet, but for these it will.

  ### 2018-07-05

  * Novax rework continued:
    * Uplink changes:
      * Units with the uplink category now have a defined capacity for satellites.
      * If the capacity is exceeded no more can be built.
      * If no units with the category exist, satellites requiring uplink enter 'unstable orbit' mode or just die if unstable orbit mode is undefined.
      * Novax Centre has a capacity of 2.
      * Archimedes has a capacity of 0.
      * Panopticon has a capacity of 9001.
      * Coleman (from R&D) has a capacity of 3.
      * T3 Sensor Arrays (vanilla) each have capacities of 1.

  ### 2018-07-06

  * Added the Cybran T2 Field Engineering Ship.
  * Removed some errant categories on the UEF T2 Engineering Ship.

  ### 2018-07-07

  * Gave the Barwick Class Cybran T2 Field Engineering Ship a more unique set of textures.
  * Created new icons for the Novax Satellite and Barwick Class.
  * Fixed the uplink stats for the Coleman being applied to the Novax instead.
  * Removed the Icon Name field from the Novax satellite, which was overwriting the new icon in some instances.
  * Gave the Franklin class a more unique set of textures.
  * Listed the engineering suite ability on the Barwick Class.
  * Increased the max ground variation for building the Seraphim Experimental Naval Factory.
  * Fixed a script error with the modifications to the Seraphim Battleship if no restrictions are active.

  ### 2018-07-09

  * Fixed the inverted normals on the Night Skimmer. (9 Years that's been wrong.)

  ### 2018-07-14

  * Added land-seabed transition effects to the Iyadesu.
  * Added the Abyss Crawler: Cybran Experimental Transport.
  * Increased the maximum travel distance of the Arthrolab platform.
  * Corrected the threat value of the Cybran T3 engineering boat.
  * Workaround for the issue with the Abyss Crawler dumping units INTO THE ABYSS; DEEP IN THE HEART OF THE PLANET! Where they die shortly afterwards.

  ### 2018-07-15

  * Fixed a script issue with the Adremelech on LOUD.

  ### 2018-07-18

  * Included the original Novax Centre model for compatibility with FAF.
  * Removed some unnecessary code from the Night Skimmer.
  * Potentially fixed the Centurion occasionally flying with its landing gear extended.
  * Units now survive the Abyss Crawler dying, and are placed better when unloaded.
    * The placement on unload is a workaround and still has units placed in odd places for a tick.
  * Removed the ferry button from the Abyss Crawler.
    * Until I can find a way to remove the requirement of units having the category 'AIR' to set up ferry points,
      there is no point in having the button. Having the category will mean a portion of AA can target it,
      which negates half of the reason for the unit.
    * It can still assist ferry's set up by other units.

  ### 2018-07-19

  * R&D: Added a currently unnamed Cybran Experimental Tank, which is the Abyss Crawler, but with guns instead of transport arms.

  ### 2018-07-23

  * Added the dragbuild category to the Abyss Crawler. This changes nothing unless the unit is removed from BrewLAN.
  * R&D: Cybran Experimental Siege Tank is now an Experimental Mobile Artillery.
  * Fixed the GantryUtils causing an error on LOUD.
  * Blueprint units build cat changes now checks all categories are valid in a buildcat before adding them.

  ### 2018-07-24

  * Crystal Hill: Updated so that custom map markers can determine the hill location.
  * Crystal Hill: Commented out the old non-functioning Sorian AI code.
  * Slightly modified the height map on Dev-Tex.
  * Added an objective marker to the Dev-Tex map for use with Crystal hill.
  * Updated Dev-Tex to FA map markers.
  * Lowered the tread mark ticks rate for the Abyss Crawler.
  * Reduced the maximum firing angles of the Retributor's weapons.
  * Added target bones to the Retributor.
  * Removed the AA capability from the Retributor's Bolters.
  * EIO: Fixed the concatenation of 'naval' instead of 'navy'.
  * EIO: Added the missing mobilefactory navy air and land combinations.

  ### 2018-07-25

  * Abyss Crawler can no longer target high altitude aircraft.
  * Reworked most T2+ segmented walls and gates to match terrain slopes of the terrain.
    * Aeon T2 not included; Aeon build animation breaks this.
  * Cleaned up non-centralised terrain code.
  * Removed the remains of the Abyssal Persecutor.
    * If I ever re-visited the idea, I'd start from scratch anyway.
  * Gave the Retributor the ability to disable the main weapon.
  * Fixed R&D breaking field engineer exclusivity.
  * Gave the Iyadesu the Sacrifice ability.
      Why did I do this
      How damn sleep deprived am I?
      Fuck it; I need sleep.
  * Removed the Sacrifice ability from the Iyadesu again. That is an Aeon ability.
  * Gave the Retributor a death weapon.
  * Set the research multipliers of the Retributor to 0.2, 0.3, and 0.4 for time, mass, and energy respectively.
  * Fixed the issue with spherical vision radii on the satellite.

  ### 2018-07-26

  * Replaced the textures and distance models of the Aeon T1 pressure mine.
  * Replaced the distance model of the Seraphim T3 nuke mine.
  * Added a distance model for the Scarab.
  * Replaced the distance model for the Moldovite.
  * Replaced the distance model for the Flame Lotus.
  * Added a distance model for the Metatron.
  * Added a distance model to the Aeon Defence Engineers.
  * Changed the selection and build icon priorities of the Retributor.
  * Added distance models for the Saksinokka.
  * Added a distance model for the Beguiler.
  * Added distance models for the Impaler.
  * Added additional distance models for the Solaris.
  * Removed unused distance model textures for the Solaris.

  ### 2018-07-27

  * Inserted a distance model for the Orbos.
  * Gave the Orbos a death animation.
  * Added distance models for Flash Flood.
  * Fixed the distance model of the Nihiloid.
  * Replaced the distance model on the Pedestal.
  * Added a distance model for the Aeon Heavy Wall.
  * Created death animations for the Pedestal.
  * Moved the life bar of the Pedestal.
  * Paragon Game: Fixed a crash related to reloading individual blueprints through disk watch.
  * Added a distance model for the Dragonlady.
  * Replaced the distance model for the AM-12 Trap.
  * Fixed the distance model of the AM-12 Anti-Armor.
  * Removed unused distance model textures from Ivan.
  * Removed unused distance model textures from Recoil.
  * Added a distance model to Citadel.
  * Added a distance model to Harrow.
  * Fixed inverted normals on Ella.
  * Added distance models to the Longbow.
  * Removed unused distance model textures from the Armillary.
  * Replaced the model for the Respirer.
  * Overhauled the script of the Pigeon.

  ### 2018-07-28

  * Lowered the muzzle flash scale of the Respirer.
  * Merged script references on the Albatros.
  * Merged script references on the Centurion.
  * Slightly reworked the script of the Von Mayer Reactor.
  * Merged script references on the Archimedes.
  * Did a large number of nothing-burger changes to UEF scripts.
  * Gave the Cybran research centres new models.
  * Rebalanced the advanced resource buildings.
    * Reactors and fabricators are now slightly more expensive but produce more.
    * Extractors now cost less and produce slightly more.
    * All of them have R&D mod research costs of x1.25 instead of the x3 default of T3 units.
  * Added distance models to UEF research centres.
  * R&D: Prevented a crash caused by reloaded blueprints with diskwatch.
  * R&D: Fixed unit's that are longer in the Z direction having a research item that's too big.

  ### 2018-07-29

  * R&D: The height of research items now scales with the unit's height.
  * R&D: The mesh extents of research items now scale with the unit's original mesh extents.
  * R&D: Cybran research centres now have build effect bones.
  * Crystal Hill: Fixed hill stacking vis-entities.
  * Crystal Hill: Changed requirements for first capture to match subsequent captures.
  * Crystal Hill: Hill no longer does a log dump of ScenarioInfo every time it is captured.
  * Created the basic framework on a new control point style mod.
  * R&D: Added the Cybran T1 wind turbine.
  * R&D: Research locked the Cybran T1 p-gen.
  * R&D: The wind turbine rotor affecter is now destroyed when the unit is killed.
  * R&D: Cybran research centres now have Cybran sounds.
  * R&D: Aeon research centres now have Aeon sounds.

  ### 2018-07-30

  * Added a Seraphim tech 2 recon plane.
  * Set the Seraphim tech 2 recon planes stats to be the average of the tech 1 and tech 3 for balance matching.
  * Disabled the tech demo disarmer weapon.
  * Crate Drop: Fixed disk watch causing a crash on blueprint reload.
  * Fixed the old-Scathis-based model for the Hedgehog.
  * Gave an indication of how loaded the Hedgehog is or isn't.
  * Added a transport fold animation to the Hedgehog.
  * Created a distance model for the Hedgehog.

  ### 2018-07-31

  * Added a Cybran tech 2 stealth recon plane. It looks terrible. Getting reworked.
  * Added the Stillson Class: Cybran tech 3 field engineering ship.
  * Fixed the inverted normals on the Barwick Class.
  * Replaced the icons for the UEF and Aeon special fabricator and generators, and the Centurion, Ivan, and the Aspis.
  * Replaced the distance models for the Aeon shielded generator.
  * Fixed the observation satellite in FAF. This involved removing some code made redundant by the round-vision fix.
  * Bypassed the AShieldStructureUnit to prevent FAF from forcing bullshit on the Aegis and Pillar of Prominence. Who thought forcing specific animation scripts was a good idea? Honestly.
    * This doesn't make the Pillar work on FAF, but it does fix one if its new issues on FAF.
  * Changed Author credit on mod_info docs, because FAF truncates after any kind of punctuation for some reason, and it was crediting me by my first name alone.
  * Incremented the version number and UID of Crystal Hill, Paragon Game, TeaD, Waterlag, Gantry Hax 1-3, BrewUI, Pulchritudinousity, CrateDrop, and Lucky Dip.
    * They had been changed since 0.7.5.5 without updating the version number.
  * Improved the descriptions of the Gantry Hax modules, differentiated their UIDs, and defined them as conflicts of each other.
  * R&D: Re-adjusted the sizes, lifebar positions, and selection outlines of the wind turbines so that they match better.

  ### 2018-08-01

  * R&D: Added the Seraphim T2 bomber.
  * Replaced the icons for the Seraphim T3 gunship and research centres.
  * R&D: Removed unused icon for UEF turbine research.
  * Updated the language documents. All of them. Every last one.
  * Replaced the model for the Blade Raven: Cybran tech 2 stealth recon plane.
  * Created a distance model for the Blade Raven.
  * Fixed the stealth field on the Blade Raven.
  * Updated threat values for resource buildings and a few new things.
  * Created a distance model for the Seraphim T2 bomber.
  * Increased the damage of the T2 dedicated bombers by around 18.7%.
  * R&D: Added Reaper: Cybran T2 Tactical Bomber.

  ### 2018-08-02

  * R&D: Improved the texture on the Reaper.
  * R&D: Fixed the entry for Reaper's name, and updated the Russian translation.
  * Blade Raven's stealth field is no longer free, starts disabled, and has a toggle.
  * Set Excalibur to use firing solution instead of aim bone.
  * Removed the dodgy unfinished blade weapon from Iyadesu.
  * Iyadesu now respects build restrictions. On Steam, FAF, and LOUD.
  * Caffe Corretto and Research & Daiquiris now have BrewLAN listed as a requirement.
  * Paragon Game: Fixed old unitID references in restricted data.
  * R&D: Research items now respect build restrictions.
  * R&D: Halved the research costs of the tech 1 artillery.
  * R&D: Set the default time multipliers for research to be x1 for T1, 2, and 4, and 1.5 for T3.
  * R&D: Halved the research time of the tech 2 bombers.
  * R&D: Set the Coleman to be tagged as OMNI, not RADAR.
  * R&D: Lowered the build time of the Coleman.
  * R&D: Implemented T3 radar rework. Only applies where dedicated omni exists.
  * R&D: Created a super hacky script that makes the AI able to tech up.
  * R&D: Added the wind turbines to the T1EnergyProduction platoon.

  ### 2018-08-03

  * Tweaked some AI platoons.
  * Bubble Tea: Added the shields to AI platoon T3ShieldDefense.
  * R&D: Added T2 bombers to AI platoons.
  * Added the Abyss Crawler to T3AirTransport platoon.
  * Added the Iyadesu to T4LandExperimental1.
  * Added a Seraphim T3 mobile AA/TMD.
  * Replaced the textures on the UEF Engineering Resource buildings.
  * Changed Excalibur's aiming again.
  * R&D: Gave the Aeon research centres unique models.
  * R&D: Added the dedicated Omni and the Retributor to AI platoons.

  ### 2018-08-04

  * R&D: Added the Aeon Omni.
  * R&D: Gave the UEF Omni distance models.
  * R&D: Added the Cybran Omni. It's texture is unfinished.
  * R&D: Fixed the collision models of the Omni buildings.

  ### 2018-08-05

  * R&D: Finished the Cybran Omni.
  * Updated the language documents for BrewLAN and R&D.
  * R&D: Omni costs now directly based on original costs at run-time, to match balance.
  * R&D: Death animation for Cybran Omni.
  * TeaD: Removed from the gitignore list, which it had accidentally been placed on.
  * Lucky Dip: Fixed a potential issue with duplication of map spawned units.
  * In situations where the Independence Engine is forced to build land experimentals, it will now fold up again to allow them to leave without clipping.

## 2016-12-15|0.7.5.5

* Release version.

## 2016-01-05|0.7.5

* Removed the Iyadesu related wreckage prop changes, which due to script changes in the Iyadesu actually did nothing but cause FAF conflicts.

  ### 2016-01-25

  * LuckyDip: Added the Moldovite & Wraith to the selections.

  ### 2016-01-29

  * Removed the entity tracking tables from the Panopticon, and the vis entity removal scripts.

  ### 2016-02-15

  * Cost Variance: Build rate now altered by the combined random of mass and energy.
  * Cost Variance: Movement speed now altered by the combined random instead of just energy.
  * Cost Variance: Shield size is now altered by 20% of the energy random. Shield vertical offset altered to maintain the location of the top of the shield. If my tired maths is correct.

  ### 2016-02-21

  * Restricted units data update for FaF.
  * Added the UEF and Cybran T3 engineering stations to the FaF engineering stations restrictions.

  ### 2016-03-19

  * Increased the costs of the nuke mines. Energy x3, Mass x1.5, Time x2.
  * TeaD: Changed the anti-blocking script of the creeps from an instant wall destroy to a wall DoT.

  ### 2016-03-26

  * Corrected a typo in the heavy wall description.
  * MightyBlueDuck: Updated German translations for BrewLAN.
  * Disabled the Aeon T3 shield generator, pending real model.

  ### 2016-04-02

  * Ivan drop pods now deal damage equal to mass value to shields, and leave a wreckage of the unit when it does.
  * German fix from SchwererKreuzer.

  ### 2016-04-16

  * Did additional texture work for the Ivan.

  ### 2016-04-30

  * CrateDrop: Fixed the white headband top-hat, which has been broken since the directory structure change.

  ### 2016-05-15

  * Fixed the script and assignment of UpradesFromBase; allowing the T1 MeXes to upgrade to their 3.5 variants.
  * Fixed the upgrade issue on FaF.

  ### 2016-05-16

  * FaF unit fixes:
    * T3 UEF Satellite Uplink,
    * Panopticon,
    * UEF & Cybran T1 & T3 field engineers,
    * Cybran T2 Field Engineer.
  * Changed the UEF T1 & T3 field engineers to be more inline with the T2 on FaF.
  * Disabled SRS0401's weapons. (Hidden unfinished unit, has no weapon models.)
  * Fixed the upgrade issue on FaF.

  ### 2016-05-18

  * Commented out a number of logs, and logged some things in some comments.
  * Fixed the mines on FaF.
    * Mirrored the FaF nuke scripts, because they deleted the originals I referred to, and there is no safe way to check which to try to load.
  * Allowed the mines to function like the Fire Beetle on FaF.
    * That is to say, while on FaF, the mines suicide immediately with ctrl-k and also trigger their weapon.

  ### 2016-05-28

  * Increased the adjacency bonus for T2 power plants with the Gantry.
    * Surrounded the total price paid is now 50% instead of 91.6 recurring %.
      * For reference, with T1 its 75%, and with T3 its 25%.
  * BrewLAN no longer cares if its installed in the correct place. (Not true for all sub-mods yet.)
    * Used an adapted version of Manimals old mod locator script, and some crazy voodoo hax so it also applies to .bp files as well as .lua files.

  ### 2016-05-29

  * Fixed the script of the Aeon shielded mass extractor.

  ### 2016-06-01

  * Many things for the Aeon T3 Mobile Shield Generator.

  ### 2016-06-19

  * Added desync warnings for people who don't install BrewLAN properly.

  ### 2016-06-25

  * Heavy functional change to the Panopticon:
    * It now has radar radius of 6000 instead of 1200.
    * Increased base energy consumption to 10000, from 5000.
    * It now uses its current radar radius as its max view distance, instead of 8000.
    * It can no longer spy on support commanders.
    * It now uses only your own intel to decide what to view. This means:
      * Better performance:
        * Formerly, for each opponent, it would use that players intel, filter out units that that player didn't control and cloaked units, and add those units to its list. Then check again at a larger radius (its radius + Darkess stealth field radius) for Darkness facilities, and check the distances of units on the first list to Darkness facilities list, and remove any too close.
      * It now respects stealth:
        * There is no easy way of checking if a unit is affected by a stealth field in script, only if it is emitting a stealth field. This means in the old system it would have needed to something similar to the Darkness check for each stealth field generator. Now that it only checks your own intel it doesn't know about stealthed units or units in stealth fields to begin with.
      * Darkness facilities no longer get free immunity to the Panopticon:
        * If the Darkness loses power or you get intel on its location some other way, standard game rules on intel apply; its a building and its not going anywhere. It gets spied on.

  ### 2016-07-04

  * Finished the UV map of the Aeon T3 mobile shield generator, and gave it a good temporary texture.

  ### 2016-07-09

  * Aeon T3 mobile shield generator changes:
    * Changed balance, so it has more health, and less shield.
    * Swapped the treads animations.
    * Did additional work on the texture.
    * Gave it an icon.

  ### 2016-07-10

  * Added the Panopticon to the FAF no eyes restriction.
  * TeaD: Increased the down time after wave group bosses and damage tests.
  * TeaD: Added healer mobs after the first boss wave.
  * TeaD: Added large aircraft and shielded aircraft waves.
  * TeaD: Prevented the teacup from overflowing with health buffs.
  * TeaD: The first non-damage test boss is no longer tagged as damage test.
  * TeaD: Added a second boss wave. Currently tagged as 'Final Boss' so it is complete-able in its current state.

  ### 2016-07-11

  * TeaD: Added endless mode.

  ### 2016-07-17

  * Listed the Cybran T3 mobile stealth gen's amphibious ability.

  ### 2016-07-20

  * TeaD/BrewLAN: Made the field engineer mines buildable by TeaD engineer.
  * TeaD: Increased the view distance of the light radar from 20 to 60.
  * TeaD: Gave the light radar a custom model and icon.
  * TeaD: Made the collision model for the gate 0 size, so shots don't impact meaninglessly on them.
  * TeaD: Added a regen for walls that haven't been sapped in a second.

  ### 2016-07-21

  * Crystal Hill: The crystals no longer care if a player dies controlling one. That player retains the crystal even in death.

  ### 2016-07-25

  * Removed the ontransportattached/detached scripts from the Pidgeon; they seem to do nothing except cause FAF errors.

  ### 2016-07-26

  * TeaD: Added a tiny factory.
  * TeaD/BrewLAN: Field engineers now buildable by tiny factory.

  ### 2016-08-17

  * Overhauled the Iyadesu:
    * Now classified as Experimental Reconstruction Engineer.
    * Its reclaim now works as normal units except that if it reclaims a unit or wreckage it adds that unit or wreckages blueprint to its build list and spawns a drone.
      * This drone works like an engineering drone, except if it dies the Iyadesu loses access to the blueprint.
      * It has a limit of 8 drones.
    * It now also has the ability to rebuild destroyed buildings in the same way as the SACUs.
    * Gave it a new temporary model.
    * Made it bigger.
    * Removed its shield.

  ### 2016-08-21

  * The UEF engineering resource buildings can now build up to T3 storage of their respective type.
    * Notably this means they can now build the BrewLAN T2 storages and the BlOps T3 storage.
  * Finished the first overhaul of the Megalith egg backend. (I have a second planned.)
  * Added the Slink, Hedgehog, and House to the Megalith build lists.
  * Altered file hierarchy.
  * Antimass: Changed the icon.

  ### 2016-08-22

  * Ivan now gets a 40% discount on units.
  * Units build by Ivan have 40% less health than usual.
  * Fixed an issue with the Ivan related to clearing orders after firing its last unit with scripted repeat orders.

  ### 2016-08-26

  * Iyadesu now has a beam weapon.
  * Rewrote the script for the Stargate. Main in game differences:
    * Event horizon is a different entity with different shaders.
    * It now performs a two chevron dial animation before connecting.
      * This dialing animation is based on where the target gate actually is.
      * There are 81 dialing addresses. Gates near enough to one another will have the same address. This changes nothing.
    * Units dying on impact on the iris now award kills to the gate.
    * Fixed a bug that may or may not have existed before which bricked gates if you just re-dialed another gate.
    * Added veterancy levels.
    * Added a sound effect to the iris impacts.

  ### 2016-09-03

  * Stargate new longer dialing sequence, with more efficient address calculation.
  * Added Hexatron: Cybran T3 Mobile Missile Platform.
    * Weapon not finished.
      * Sometimes it doesn't fire.
      * The explosion graphic is about 20x too big.
      * It uses the graphic of shells instead of missiles.
      * There isn't a reload animation yet.

  ### 2016-09-04

  * Created a custom projectile for Hexatron.
  * Reclassified the Hexatron as a Mobile Rocket Platform and changed its description to match.
  * Gave Hexatron team colors.
  * Gave Hexatron a reload animation.
  * Enabled Sorian AI to build Hexatron.

  ### 2016-09-11

  * Fixed the broken Hexatron Sorian AI file, which was breaking Sorian AI.

  ### 2016-09-28

  * Changed the buff definitions file so it doesn't error all the time with the Darkness debuff while not on FAF anymore.
  * Removed some old no-longer relevant categories from the Stargate.

  ### 2016-10-14

  * Crate Drop: Added a graphical notification popup on hat pickups.

  ### 2016-10-15

  * Gave the Scarab a proper Hat bone.
  * Crate Drop: Added graphical notification popups for the pickups:
    * Nothing
    * Generic bad thing
    * Generic good thing
    * Clone
    * Dude
    * Evil clone
    * Evil dude
    * Engineer
    * Engineering
    * Energy (Not used)
    * Health
    * Mass
    * Veterancy
    * Speed
    * Intel
    * Weapon

  ### 2016-10-16

  * Crate Drop: Hats now vary in size up to 15%.
  * Crate Drop: Added a fedora. M'lady.
  * Crate Drop: Added a black derby.

  ### 2016-10-19

  * Crate Drop: Allowed multiple crates per level, based on map size. (2-6 crates, 5-81 km)
  * Crate Drop: An explosion roll no longer crashes a crate if the unit dies and has no death animation.
  * Crate Drop: A unit can no longer get a free extra roll if they don't have a hat bone when given a bonus hat (This couldn't happen before).
  * Crate Drop: Units who roll a jackpot now get a free bonus hat.
  * Crate Drop: Crates now re-appears 1-(20-60, based on map size) seconds after being collected, instead of immediately.
  * Crate Drop: Added a French pith helmet.
  * Crate Drop: Added a Vietnamese pith helmet.
  * Crate Drop: Added a Brodie helmet.

  ### 2016-10-24

  * Added hat bones to:
    * Aeon:
      * Light Gunship
      * Light Torpedo Bomber
      * Tactical Bomber
      * Heavy Air Transport
      * Decoy Plane
      * Defense Engineers
      * Armored Assault Tank

  ### 2016-10-26

  * Crate Drop: Added an icosahedron based alternative crate.
  * Crate Drop: Added a truncated tetrahedron based alternative crate.
  * Added a basic version of the Alchemist Aeon T3 Mobile AA.

  ### 2016-10-27

  * Added a custom beam, stats, and strings for the Alchemist.
  * Updated the relativistic path trawler to also update beam blueprints.

  ### 2016-10-28

  * Crystal Hill: UI no longer crashes if its managed to go to overtime without realizing because people have teamed up with unlocked teams. Game still behaves wierd in that case though.
  * Gave the Patch Class a unique texture with yellow black engineer bits, and a hat bone. There is currently no way for it to actually get a hat.
  * Gave the Alchemist a better mesh.
  * Renamed the Alchemist to the Armillary.

  ### 2016-10-29

  * Mostly finished the Armillary's model and texture.

  ### 2016-10-30

  * Finished the Armillary.

  ### 2016-11-01

  * Crystal Hill: Now treats allies as enemy with unlocked teams.
  * Crystal Hill: Now only counts selectable units when counting units.
  * Crystal Hill: Now only selectable, targetable, non-wall, non-satellite units can capture the crystal.

  ### 2016-11-02

  * Fixed the attach point on the slink.
  * Added a hat point to the slink.
  * Increased the pitch of the weapon of the slink, so it always fires upwards.

  ### 2016-11-04

  * Crystal Hill: Removed movement statistics from the crystal. (Unlike health or some others that are useful for mod compatibility.)
  * Crystal Hill: Added a 30 second notification.
  * Crystal Hill: Added German string for 30 seconds remaining acquired from the blue hued avian.
  * German strings, and flagrant insults. Provided by AlmostBlueBlueDuck.
    20:49 - AlmostBlueBlueDuck: GO FUCK YOUR MOUTH
    20:49 - AlmostBlueBlueDuck: i will make me food
    20:50 - ? Balthazar: bitch what am I paying you for
    * Ain't he a darlin'
  * Gave the Megalith the ability to build the Hexatron.
  * Added descriptions to the Megalith eggs.
  * Gave the new Megalith eggs icons.
  * Fixed the layer seabed amphibious eggs are built on.

  ### 2016-11-05

  * Separated out a section of the Ai support, in an attempt to narrow down one of the crashes.

  ### 2016-11-11

  * Crate Drop: The jackpot free hat is now a crown, which can't drop randomly.
  * Crate Drop: Increased the odds of a mass jackpot to 1 in 10.
  * Added hat bones to:
    * UEF
      * T1 Gunship
      * T1 Torpedo bomber
      * T3 Torpedo bomber

  ### 2016-11-19

  * Increased the lifebar offset on the Patch Class.
  * Added the Fixxie Class; a T2 Patch Class.
  * Extended the build lists of the field engineering ships to:
    * Naval buildings
    * Anti-missile buildings (T2 max)
    * Anti-navy buildings
    * Anti-air buildings
    * Shield buildings
    * And mines

  ### 2016-11-22

  * Finished most of the graphics for the Fixxie Class.

  ### 2016-11-27

  * Fixed land and air factories being able to build the T2 field engineer boat.
  * Fixed the nuke mines.

  ### 2016-12-08

  * theonewhonevergivesa: Updated Russian language translation.
  * Added the Seraphim T2 wall's name to the string tables for translation.
  * Added the Megalith egg MRL to the translation tables.
  * Added the Iyadesu's storage drone description to the translation tables.
  * Fixed the string assignment for the T2 wall long description on Russian and German.
  * Listed the Aeon shielded mass extractors "Shield Dome" ability.
  * Crate Drop: Only selectable units on the 'Land' layer can collect the crate.
    * Aircraft must land to collect it.
    * Dummy units, satellites, and drones can no longer collect it.
  * Remerged AI files, because Saxxon testing indicates it doesn't help.

  ### 2016-12-09

  * Increased the health of Outy from 215 to 220.
  * Reduced the energy cost and build time of T1 field engineers from 300 to 265.
  * Reduced the energy cost of T3 field engineers from 4000 to 3625.

  ### 2016-12-12

  * Adjusted the balance of Field Boats.
    * They now have calculated stats rather than stats taken from what their base model is.
      * T3 UEF:
        * Health now 6525 from 7200
        * Energy cost now 7100 from 15000
        * Mass cost 2275 from 2250
        * Build time now 4750 from 10000
      * T2 UEF:
        * Health now 3025 from 2120
        * Energy cost now 1950 from 2600
        * Mass cost now 750 from 260
        * Build time now 1975 from 1300
  * Added the UEF T1 Field Engineering Boat.
  * Experimental Icons Overhaul: Potentially fixed a bug related to checking non-existent strings.

  ### 2016-12-13

  * Experimental Icons Overhaul: Fixed an issue related to doing string operations on non-strings.
  * Updated the description of the Panopticon.
  * Added string entries for the Aeon Experimental Air Factory, for the future, and disabled it.
  * Added string entries for the unfinished and unadded Cybran Sniperbot.

  ### 2016-12-14

  * Fixed the death animations of the T1 field engie boat.
  * Fixed the death animations of the T2 field engie boat.
  * Recreated the icons for the UEF field engie boats so they all match.
  * Created icons for meta-units, such as the crate drop pings, and for temp units, such as the Aeon Experimental Aircraft Factory.
  * Removed the tread-marks from the Iyadesu.
  * Updated the icon to match the current Iyadesu model.
  * Created strategic icons for T2 and T1 engineer boats.
  * Gave the UEG ADG considerably better texture.
  * Fixed the tarmac size for the ADG.
  * Added more detail to the texture of the Ivan.
  * Inverted the normals of the UEF T1&3 field engineers.

  ### 2016-12-15

  * Added final few missing non-English translations. Google translate wooo.


## 2015-09-05|0.7

* Fixed the third arm and thread accumulation of the Darkness.
* Fixed the first arm on the distance model of the Darkness.
* Changed the Darkness to use the default buffs system for applying its debuffs. This has the following effects:
  * Effect is no longer affected by distance.
  * It no longer has to specifically tracks units. Meaning it no longer crashes crash when one of them dies before it does, and uses less system resources.
  * Its now multiple stacking buffs with a duration, rather than defined specifically each time.
  * Units leaving the area will now eventually lose the effect.
* Fixed a bug in the vanilla buff definitions that references RADAR radius instead of OMNI radius when calculating the base size of omni buffs.
  * Unfortunately this causes log warnings every time the a unit with a omni buff has its buffs change. But that is to do with how bad the vanilla code is.
* Darkness now stops firing pulses when it doesn't have power. To some degree.

  ### 2015-09-06

  * Changed the UV, texture, and model for the Absolution lod1, so it looks more like, and increased the distances at which it appears and dissapears.

  ### 2015-09-07

  * The observation satellite no longer falls to the ground if it dies.
  * The observation satellite station no longer goes through the satellite re-spawn motions when its trying to die.

  ### 2015-09-11

  * The observation satellite now has a different model than the original Novax satellite. Admittedly a derivative model, but different nonetheless, that most importantly non longer has a phat lazor on it.
  * Added a hat attach bone for the observation satellite.
  * Crates: Changed the vision buff to use actual buffs, rather than an attached vis entity.
  * Crates: Changed the health buff to use actual buffs, rather than just multiplying the units health. They now stack with other buffs like upgrades and veterancy rather than being replaced by them. Buff is now x1.5 rather than x2.
  * Crates: Clones now get a copy of the original units buff table, and then have their current health set to that of the original.
  * Crates: Kills drop now only gives kills to units with defined veterancy levels, and gives an amount of kills at random from the units veterancy levels table.
  * Crates: Added a radar buff. Only activates if the unit has radar. Buff is 25%.
  * Crates: Added weapon buff. Adds 10% to damage and aoe, and 25% to max range. Only applies to units with damage dealing weapons that aren't death weapons.
  * Crates: Added movement speed buff. Value is 20%. Only applies if the unit isn't movement type 'RULEUMT_None'.
  * Crates: Added build rate buff. Buff is x2. Only applies to units with a build speed.
  * Crates: Added 'Jackpot' variations of each buff, which are an order of magnitude more powerful, and have a 1% chance of replacing the original.

  ### 2015-09-12

  * Crates: Removed the damage radius buff from the crate weapon buff. Because the function to set damage radius doesn't exist. Its another bugged buff.
  * Crates: Fixed the weapons check on the weapons buff.
  * Crates: Changed the free mass drop to check available storage. Rerolls if less than 5K remaining storage. It now gives 10% of remaining storage worth of mass, or 5000 mass, which ever is bigger. With a 1% chance of outright filling your storage.
  * Crates: Added floating text box messages to drops. They use default language strings so I don't have to get translations done. Also means some are a bit odd.
  * Paragon game: More intelligent placement of units after the paragon:
    * It now tries to spawns the shields near where it actually spawned the paragon, rather than where it tried to spawn the paragon.
  * Crates: No longer freezes the game if it can't find a safe place to warp to. Warps to the same place instead. Which can have hilarious consequences.

  ### 2015-09-20

  * Added a basic version of the Cybran T3 mobile stealth field gen. Lacks unique model and icon.
  * Added a basic version of the Panopticon: UEF Experimental Sensor Array.
  * Fixed a critical issue with the Darkness where it ignores units that you don't know about.
  * Added a radar stealth field to the darkness. This is mostly to show the area that is protected from eaves dropping from the Panopticon.
  * Darkness now removes Panopticon vis entities from units entering its stealth field area on pulse. Units in that area not recieving them in the first place is handled by the Panopticon.

  ### 2015-09-21

  * Added a temp icon for the Panopticon.
  * Added some AI names for the Panopticon. (Although the AI wont build it yet.)
  * Added a brief note in the Panopticon description pertaining to its interaction with the Darkness.

  ### 2015-09-26

  * Ivan drop pod units now die on contact with a shield.

  ### 2015-09-27

  * Added Top Gun call-signs to the list of things the AI will call Centurions.

  ### 2015-10-02

  * The Panopticon can now see all enemy units, except for command units, counterintel, walls, and mines.

  ### 2015-10-03

  * The Panopticon can now get vis entities on counterintel units, but not units currently cloaked anymore.
  * Fixed a script issue with AI controlled Slinks.

  ### 2015-10-04

  * Panopticon changes:
    * Gave radar and omni.
    * Added an upkeep cost.
    * Added a disable feature.
    * Cleaned up some internal garbage collection.

  ### 2015-10-12

  * Added build sounds to the UEF T3 engineering power generator, mass fab, and mass extractor.
  * Added the UEF T3 Repair & Assist Boat.
  * Fixed an issue where a unit already being watched by a Panopticon couldn't also be watched by a third players Panopticon.

  ### 2015-10-13

  * Fixed an issue where a unit that had been seen by a Panopticon, and had its bug removed by a Darkness, could not be seen again by the same Panopticon.
  * Repair boat now automatically repairs nearby damaged units while idle.
  * Reclassified the Patch Class as a Field Engineering Ship.
  * Added a strategic icon and icon for the Patch Class.

  ### 2015-10-14

  * Fix for land and air factories being able to build naval engineers.

  ### 2015-10-15

  * Reduced the costs of the Scathis Mk2 to build by the sum of 4 T2 power plants and 1 T1 power plant. This is what it takes to increase its RoF to greater than that of the original.
  * Gave the UEF T2 wall a unique model & removed its ability to make turrets.
  * Fixed the localization for the T2 walls' descriptions.

  ### 2015-10-16

  * Created the cost variance mod.
  * Partially reworked the file structure.
  * Changed the unit code of the Aeon and Cybran T2 walls, from 5201 to 5210.

  ### 2015-10-17

  * Paragon Game: Added the factional Paragons to the AI buildable lists.
  * Cost Varience: Fixed an issue that was causing some slow units to have 0 speed.
  * Crate Drop: Fixed the issue of some people not being able to pick up the crates because another arbitrary random person couldn't see them picking it up.
  * Added adjacency bonuses for the Panopticon.

  ### 2015-10-25

  * Added the Waterlag UEF small leg entity to the UEF T3 wall when it builds something.
  * Paragon Game: Added an Aeon Engineering Station. Currently has no icon and has a borrowed model.

  ### 2015-10-31

  * Fixed the Ivan being able to build the naval engie.

  ### 2015-11-01

  * TeaD: Added a super basic version of a new game mode mod: Tower defense.

  ### 2015-11-07

  * Added a FAF check to the Darkness so that it uses the real omni buff while on FAF, since I had it fixed there. Possibly only the beta version so far.
  * Fixed the Seraphim strat defense particle effects.
  * TeaD: Made functional. Still very content-less though.

  ### 2015-11-08

  * TeaD: Fixed the AI team check, which caused issues if the only Human wasn't on a team.
  * TeaD: Created a proper start unit for UEF.
  * TeaD: Added a pathfinder unit. It runs fast, leaves tread-marks that stay for 10 minutes, and doesn't damage the crystal.
  * TeaD: Creeps now give their mass on death, and no longer leave a corpse.
  * TeaD: Moved the crystals nearer to the center.
  * TeaD: Added a backup if the crystal fails to spawn.

  ### 2015-11-13

  * TeaD: Creeps now have an anti-blocking script, that removes nearby walls if they are in the same position they were 10 seconds ago.
  * TeaD: All factions now start with the UEF TeaD Engineer, while we wait for the others to exist.
  * TeaD: Some map specific creep gate start distances set.
  * TeaD: New wave and units. Lasts about 10 minutes from start to finish now.

  ### 2015-11-14

  * TeaD: Adjusted the rewards balance for creep rewards.
  * TeaD: Increased the speed and reduced the size and health of the Bike.
  * TeaD: Slowed the Shield down so its the same speed as the other units, and increased its shield size.
  * TeaD: Pathfinder is now a residual energy signature.
  * TeaD: Added a Shield Marine.
  * TeaD: Added more waves.
  * TeaD: Added a Cloaked creep.

  ### 2015-11-15

  * TeaD: Removed mass points.
  * TeaD: Added conflict between TeaD and MetalWorld.
  * TeaD: Fixed an issue with the re-issue of move orders for stuck creeps.
  * TeaD: Added an air scout, and air scout wave.
  * TeaD: Added a light point defense.
  * TeaD: Added a light radar tower, to detect the cloaked creeps with.
  * TeaD: The wave messages are now printed to the bottom of the screen.
    * Some of the warning messages are lies, and wont be true until the content they refer to exists.
  * TeaD: Approx game duration ~15 minutes.

  ### 2015-11-16

  * TeaD: Spaced some waves out better.
  * TeaD: Buffed the T1 Air turret. It can now kill the scouts. Although it looks silly.
  * TeaD: Added proper wave messages. It gives a 20-30 second warning on flier waves. Although not cloaked waves.
  * TeaD: Game length estimate: ~18 minutes.

  ### 2015-11-20

  * TeaD: Crystal is now a teacup, with health represented by tea.
    * TeaD: It has a steam effect while it is full.
  * TeaD: Creep gates will no longer start waves if the target player is dead.
  * TeaD: Leaked Non-damage-test boss waves now cause 5 damage.
  * TeaD: Added the first damage test boss.
  * TeaD: Changed the sounds of the pathfinder.
  * TeaD: Fixed the turn radius of the pathfinder.
  * TeaD: Added some bad map handling.

  ### 2015-11-21

  * TeaD: Added the second damage test boss.
  * TeaD: Added the first real boss.
  * TeaD: The gate can no longer take damage.

  ### 2015-11-22

  * TeaD: Added no-rush handling.
  * TeaD: Fixed the shield boss strategic icon.
  * TeaD: Added a warning for cloaked waves.

  ### 2015-11-23

  * TeaD: Doily.

  ### 2015-11-25

  * Fixed a potential, but unlikely, interaction with the Panopticon and the Darkness, whereby a Darkness just outside of the Panopticons radius would be totally ignored, and have its nearby units spied upon.

  ### 2015-11-28

  * Gave the Operative a new model and an icon.
  * TeaD: Added icons for the creeps.
  * TeaD: Changed the light point defense, and gave it an icon.
  * TeaD: Reduced the mass rewards for later level creeps.
  * Added an economy watch mode for the Panopticon.
  * Made the description of the Panopticon more explicit in its abilities and restrictions.
  * Added Seraphim T2 walls.

  ### 2015-11-29

  * Added the Aeon T3 shield wall.
    * Requires a rewrite of the cardinal wall script that I still haven't done.
  * Fixed the Aeon T2 wall icon.
  * Inverted the Aeon defense engineer normal map.

  ### 2015-12-01

  * Partially rewrote the cardinal wall script.

  ### 2015-12-03

  * Finished rewrite of the cardinal wall script, and applied the new script to all walls.
    * Gates still use old script.
  * Fixed the icon for the Cybran T2 wall.

  ### 2015-12-04

  * Updated the gates with the new cardinal wall script, and updated the script to work better with them.

  ### 2015-12-05

  * Added the Seraphim T2 mobile shield generator.
  * Increased the shield health of the UEF T3 shield generator from 8000 to 8800.
  * Added an unfinished Aeon T3 mobile shield generator.

  ### 2015-12-06

  * Additional texture work for the Ivan.

  ### 2015-12-12

  * Additional texture work for the Ivan.

  ### 2015-12-30

  * Paragon Game: Created new model for the Aeon Engineering station.

## 2015-04-06|0.6.1

* Added some additional AI names for the Absolution.
* Added the Aeon T3 torpedo launcher.
* Increased the max range of the UEF T3 Torpedo Launcher.
* Lowered the range of each of the anti-armor point defenses by 5. (150 to 145)

  ### 2015-05-09

  * Paragon Game: More intelligent placement of paragon:
    * Paragon now spawns 20 to 60 distance away from you (based on map size).
    * Paragon now cares more about where you are in the map for deciding position:
      * If you are within 40 to 60 distance of the center (same sliding scale as the map size one) it spawns between you and the center.
      * If you are within the 20 to 60 +10 distance of the edge of the map it now spawns the paragon towards the center of the map.
      * Otherwise it spawns the paragon the other side of you from the center of the map.

  ### 2015-05-10

  * Added a minimum depth for the Aeon T3 torpedo launcher, to prevent the turrets from being underground and doing nothing.
  * Allowed the wreckage of the Aeon T3 torpedo launcher to appear on water.

  ### 2015-05-11

  * Paragon Game: Fixed a crippling bug that would sometimes cause the script to crash and not spawn some players in.

  ### 2015-05-16

  * Partially redone UEF drop-pod artillery.

  ### 2015-05-17

  * Finished the recoding of the UEF drop-pod artillery: now also buildable again.
  * Did some more work on the model for the UEF drop-pod artillery.
  * The Cyrban Punisher can now leave a wreckage.

  ### 2015-05-22

  * Drop pod artillery no longer auto targets.
  * Reduced camera shake caused by drop-pod artillery firing.
  * The Gantry now has a selection area a reasonable size, rather than nearly twice its size.

  ### 2015-05-23

  * Prop-pod artillery now issues itself a stop when it finishes firing, so it can now successfully be given build orders again after it finishes firing without manually telling it to stop.

  ### 2015-05-24

  * Added the new improved Mentlegens Reef map to BrewLAN. (Its a 7v1 Gentlemans Reef)
  * Gantry Hax 2: Merged numbers from git fork.
  * Removed the log spam from the Suthanus.

  ### 2015-05-27

  * Paragon Game: FIXED! FOR REALS THIS TIME!
  * Improved the appearance of the Drop-pod artillery.
    * Corrected the smoothing.
    * Finished the UV mapping and texture outline of its base.

  ### 2015-05-29

  * UEF Ivan: Experimental Drop-Pod Artillery changes:
    * Finished the UV mapping and a basic texture for the Ivan Drop-pod Artillery.
    * Reduced the cost and build time of the Ivan by 25%.
    * Energy drain increased from 5600 a shot to 10000 a shot.
    * Drain time reduced from just under a second and a half to half a second.
    * Improved the movement of the decorative drop-pods.

  ### 2015-05-30

  * Some more work on the texture of the Ivan.
  * Removed some log spam.

  ### 2015-05-31

  * The Ivan now loads a drop-pod into its barrel if the current build is cancelled.
  * Added the Cybran T2 wall to the language tables. (Fuck knows how long that's been missing)
  * Added a temporary version of the UEF T2 wall. (Uses the T3 model)

  ### 2015-06-01

  * Ivan now has the option to rebuilt what launched after its finished firing.

  ### 2015-06-03

  You see Ivan, when fire repeating script, many robit will make attack.
  * Added scripted button for repeat firing for the Ivan.
  * Drop-podded units now spawn facing a random direction, instead of straight down.

  ### 2015-06-05

  * The Ivan will now re-give itself the orders it loses when the auto-target location is updated.

  ### 2015-06-07

  * Experimental Icons: Category GATE experimentals no longer show up with transport icons.
  * Additional texture work for Ivan.

  ### 2015-06-10

  * Additional texture work for Ivan.
  * Created a distance model for Ivan.

  ### 2015-06-13

  * Ivan now has an LCD display of the ammo count.
  * Fixed an issue with having actual repeat orders on with the scripted repeat orders.
  * Additional texture work on the Ivan.

  ### 2015-06-14

  * Cybran field engineer can now build the ED5 instead of the ED4. ED5 costs 50% more to build this way.
  * More texture for Ivan.

  ### 2015-06-15

  * Halved the cost and energy storage or the Stargate.

  ### 2015-06-19

  * Moar ivan texture.
  * Changed the LOD1 UV mapping on the UEF T1 Air staging, so it makes more sense.
  * Doubled the Guardian LOD distance cutoffs.
  * Fixed the LOD1 model of the LSD Pulse.
  * Fixed the smoothing groups for the model of the UEF T2 mass storage.
  * Spread out the blinking lights of the UEF T2 mass storage.
  * Replaced the LOD1 textures of the UEF T2 mass storage.
  * Replaced the LOD1 model of the UEF T2 mass storage.
  * Fixed the smoothing groups for the model of the UEF T2 energy storage.
  * Replaced the LOD1 textures of the UEF T2 energy storage.
  * Doubled the LOD distance cutoffs for the UEF T2 storages.

  ### 2015-06-20

  * Replaced the LOD1 for the Harpoon.
  * Gave the Aster a proper LOD1 model, and doubled the distance cutoffs for it.
  * Doubled the LOD1 distance cutoff for the Archimedes.
  * Fixed the duplication bug with the Ivan auto fire.
  * Made the Bessemer Reactor look slightly better.
  * Waterlag: Added 'floatation' legs to Cybran and UEF units that have added water functionality.

  ### 2015-06-21

  * Waterlag: Added additional leg types for Cybran.

  ### 2015-06-22

  * Updated Russian translation by theonewhonevergivesa.
  * Fixed LOC link for Little Bertha.

  ### 2015-06-24

  * localization fixes.
  * Fixed the health bar of the Cybran T1 Air Staging.

  ### 2015-06-26

  * RU 4 real. Russian language update.
  * Fixed the LOD1 mesh of the Cybran T1 Air Staging.
  * Adjusted the balance of the directly build ED5 again; buffed slightly.
  * Field tech support commanders can no longer build both the ED4 & ED5.
  * Added a build description for the ED5.

  ### 2015-06-27

  * Megalith can now egg up some Salem.
  * The Megalith flak egg is now considered T3.

  ### 2015-06-28

  * RU strings for Megalith Salem egg.
  * Improved the texturing for the Centurion LOD1.

  ### 2015-06-29

  * Waterlag: Now lowers the collision model of effected units so they are easier to torpedo.
  * Lowered the collision model of the Gantry so it can be show by torpedoes better.

  ### 2015-07-03

  * New Sub-mod: For specific features while running both BrewLAN and BlackOps: Lucky Dip:
    * Anywhere that BlackOps and BrewLAN make similar units, it restricts one of them at random.
  * Waterlag: Removed part of the collision model change that was effecting engineers weirdly.
  * Removed the Seraphim Battleship from the no nukes restriction.
  * Had the Seraphim Battleship disable its nuke launcher if nukes are restricted.

  ### 2015-07-04

  * Novax now rebuilds the Satellite if it dies.
  * Updated the build mode shortcuts for everything but field engineer buildings.

  ### 2015-07-08

  * Fixed the build-ability of the field engineers on FAF.
  * Improved other FAF related compatibility.

  ### 2015-07-11

  * New sub-mod with crates.

  ### 2015-07-12

  * Crates: Now with more effects.
  * Changed the Centurion behavior.
  * Changed the Scathis script, for less errors and better compatibility.
  * Fixed the name of the Centurion distance normals.

  ### 2015-07-13

  * Crates: Now with more effects. Including HATS!

  ### 2015-07-15

  * Jaisse: French localization update, and loc fixes.
  * More crate effects
  * Waterlag: Reduced the collision offset so land units can shoot the UEF T1 radar again.
  * BrewUI slight pass-through future proofing.

  ### 2015-07-18

  * Crates: Flash effect for crate.
  * Crates: New icon.
  * Crates: Reduced the chances of higher tech level units coming from the crate, and gated the maximum to one level above the unit picking it up.
  * Crates: New HAT!
  * Crates: Hats now stack!
  * Crates: A second new hat!
  * Crates: No longer able to receive vision buff with fog of war disabled.

  ### 2015-07-19

  * Crates: Created a lobby option for hats only.
  * Gave the Absolution an attachpoint. Totally not just so it can have a hat.
  * Crates: Structures now get larger hats than regular units. (Only affects 1 known building that has a recognised hat bone: Orbos)

  ### 2015-07-24

  * Shield walls now instead pass their damage to the shield if it is enabled.

  ### 2015-07-25

  * Crates: New hat!

  ### 2015-07-26

  * Crates: Slight scripting change for exception handling.
  * Added the UEF Artillery Defense Grid.

  ### 2015-07-27

  * Minor aesthetic change to the ADG. It now does lizard eyes. I can't for the life of me work out what type of lizard it reminds me of.

  ### 2015-07-29

  * Made the ADGs 'eyes' stop moving more often.
  * Airborne bombers of the same type on the same team can no longer damage each other.
    * This most specifically deals with the fact that a group of bombers attacking an Iron Curtain will almost certainly all kill eachother with their own bombs impacting the shield, but also affects experimental bombers hurting each other all the time when in groups.

  ### 2015-08-01

  * Overhauled the previous Iron Curtain bomber self damage fix.
    * Rather than doing a load of self and instigator checks on damage to make sure this only effects bombers of the same type on the same team that are also in the air it now does the following:
    * The damage type of each weapon with the variable NeedToComputeBombDrop that has the DamageType 'Normal' now has the damage type 'NormalBomb'. This includes all bombers' and fighter/bombers' bombs except corsair which doesn't bomb strictly speaking. This is computed during launch.
    * When taking the damage the following checks are made:
      * Am I a bomber?
      * Am I in the air?
      * Is the damage type NormalBomb.
    * If the answer to all those is yes it takes 5% damage instead.
      * This can still lead to a clumped group of 30 UEF T1 bombers damaging the bombers at the back of the group to half health
        * This is preferable to killing the whole group, whilst also giving some feedback on the bombers flying through the fire.

  ### 2015-08-05

  * Centurion changes:
    * Speed reduced from 15 to 9. (Still faster than the Soul Ripper, which is 8 I think)
    * The main flak cannon can no longer fire at ground targets.
    * Fixed the forever broken, but always existent, rear AA laser.
    * Added an additional light Gatling cannon to the underside of the tail for air-to-ground attacks. DPS ~320.
    * It can now wear a hat.
  * Paragon game: Fixed an issue where the script would crash after failing to give someone a Paragon or shield due to map issues. The player will still be Paragon or shieldless, but the game will log a warning and carry on with life.

  ### 2015-08-07

  * Paragon Game: If the script couldn't spawn a unit it will now try again a little bit closer to the players starting location. (Except for people in the center of the map.)
    * If ANY player doesn't have the unit after these checks, it will try a third time (or second time in middle people cases) to spawn, but this time right on their starting location.
      * If the Paragon fails to this point, the shields will also be spawned this way.
      * Players who have STILL been failed by the spawn script, will have the failure announced on their behalf. So people know the game is ruined and that you should all try a different map.

## 2015-01-02|0.6

* (Mostly) Finished the Seraphim Quantum Gateway.
* Added nuke mines and mobile nuke defenses to the restricted nuke units.
* Removed the console-only UEF T3 Artillery Shield from the bubbles restrictions list, which was causing it to break.

  ### 2015-01-04

  * Added BrewLAN units to FAF unit restrictions list. Specifically:
    * The heavy wall sections, armored wall sections, shield wall sections, and wall gates added to the "No Walls" restriction.
    * The Seraphim engie stations, and UEF T3 engineering resource buildings added to the "No Engineering Stations" restriction.
    * Scathis MK 2 and Suthanus added to the "No Super-Artillery" restriction.
    * UEF observation Satellite uplink, and Seraphim optics tracking facility to the "No Eye of Rhianne and Soothsayer" restriction.
  * Added the special tech 3 fabrication units to the "No Mass Fabrication" restriction.
  * Added the Aeon Shielded resource buildings to the "No Shields" restriction.
  * For Paragon Game added the three additional paragons to the "No Paragon" restriction.
  * Fixed the crash without Sorian AI.
  * Fixed the Suthanus. It couldn't fire more than half its range.
  * Upgrading to the advanced T3 resource buildings now costs half.
  * Paragon Game: Fixed the shaders for the Seraphim and Cybran Paragons.
  * Fixed the texture shader for the Cybran T2 mine, Cybran T2, & T3 walls and gate.
  * Reclassified the non-Seraphim anti-armor point defenses as indirect fire. The Seraphim AAPD fires too directly.
  * Stargate iris now cares about the energy costs of the units as well.
    * An ACU can now survive with slightly less than a third health left.
  * Sorian AI will now only specifically target a Paragon with its pancake script if its over 66% done.
  * The Suthanus now has a fluctuating accuracy modifier, and gets more accurate the longer it has been firing on a target.

  ### 2015-01-05

  * Added a transport attach bone to the Scarab.
  * Improved the aesthetics of the Stargate, and its effects.

  ### 2015-01-07

  * Resbot now references the original unit ID properly.

  ### 2015-01-10

  * Fixed a bug in the Stargate script preventing dialing back of a gate that just dialed in.
  * 'Close Link' button now disappears on a gate with an incoming wormhole.
  * Iris shield now has sound effects for enabling and disabling. (Unlike everything else for the stargate.)

  ### 2015-01-14

  * Additional rezbot scripting. It now costs during reclaim and outputs a full health unit. Kinda. Numbers are off. Wont go right. Stress. Going to go shoot things now.

  ### 2015-01-16

  * Paragon Game: Now does a civilian check, so they no longer break team calculations.
  * Crystal Hill: Now does a proper civilian check, so a real player (human or ai) called 'civilian' for some reason can now get the first capture.

  ### 2015-01-19

  * Made the additional build cats script marginally more efficient when dealing with units that have lost their ability to build from other mods.
  * Added the Cybran T1 Light Torpedo Bomber. The last of the currently planned T1 units now exists.
  * Altered the menu sort priority of the Jester, so it matches that of the Wailer, and appears between the torpedo bomber and transport.

  ### 2015-01-21

  * The Seraphim Optics Tracking Facility now targets the closest unit to the center of the chosen location, instead of the first indexed unit, and now charges for new targets based on the distance between them.

  ### 2015-01-23

  * Seraphim Optics Tracking Facility changes and fixes:
    * Increased the range at which the Seraphim optics tracker gets a discount on range
    * Fixed the discount so it is what is charged, instead of an additional cost.
    * Fixed the no power auto on/off function.

  ### 2015-01-30

  * Added the UEF T3 Mobile Shield Generator.

  ### 2015-01-31

  * Crystal Hill: Added a tarmac texture to the crystal.
  * Paragon Game: Fixed a crash related to players with spawns near the far north of the map.

  ### 2015-02-15

  * UEF Kennel changes:
    * Tech 3 version now costs double, but is directly buildable.
    * The tech 2 version gets a 50% discount on upgrading to it, so its functionally the same that way.
    * Building it directly results in a net profit of 50 mass and 250 energy compared to upgrading to it.
  * Cybran Hive changes:
    * Third level of it is now tech 3, costs 4 times as much, and is directly buildable.
    * The second level gets a 75% discount on building it.
    * Building it directly results in a net profit of 20 mass, and a loss of 700 energy compared to upgrading to.

  ### 2015-02-16

  * Gantry Hax 1: Added an upper limit to the build speed of the AIx Gantries.
  * Fixed the triple notification bug on the 10 minute marker in paragon game.

  ### 2015-02-18

  * Crystal Hill: Added overtime; you now only win when there are no enemies, there hasn't been for 10 seconds, and the time is 0 or below.

  ### 2015-02-20

  * Crystal Hill: Added custom lobby options for defining the Crystal times. (requires the lobby enhancement mod)

  ### 2015-02-21

  * Crystal Hill: Refined the lobby options, and added full complete tooltips and language switch support. Currently only in English.
  * Gantry now builds custodians instead of regular engineers during its build.

  ### 2015-02-23

  * Crystal Hill: Fixed a bug causing 10 seconds of overtime if no enemy ever came near the crystal to cause a real defined overtime end.
  * Crystal Hill: MightyBlueDuck: Added German translations of Crystal Hill lobby options.
  * Reverted the Gantry building Custodians instead of Engineers.
  * Added Ella and the Suthanus to the Sorain AI build lists. Re-added the Scathis Mk II to Sorian AI build lists.

  ### 2015-02-27

  * Created a new mesh for the Stargate. Based heavily off the SGU gate. Old mesh still used for distance model.

  ### 2015-03-01

  * Experimental Icons Overhaul: Did a slight overhaul of the detection for weapon based icons, and changed the priorities for others.
  * Experimental Icons Overhaul: Fixed the check for nuke based weapons, since they don't use the 'damage' attrib, the Yolona Oss was showing as direct-fire which is the default for things involved in the damage off checks.

## 2014-12-29|0.5.9

* Created a work around for the heavy walls losing their path blocking when a building on top of them dies or is removed.
  * All things build able on the wall that would cause the issue now have their footprints modified so they only take the center of the path blocking, which doesn't matter.
* Added some basic functions for the start of the Stargate dialing script.
* Added tooltips for the Stargate dialing function.

  ### 2014-12-30

  * Seraphim T4 Stargate can now warp things across the map to other gates.

## 2014-12-26|0.5.8.1

* Removed the attempted workaround for the bug related to walls losing their blocking when a 3x3 building is removed from on top of them. I'm not sure its fixable.

## 2014-12-21|0.5.8

* Fixed the bug in the category changes script created on ## 2014-12-17, which was causing it to re-add the categories after removing them.
* Moved the centurion pancake script into AIBehaviours.lua.
* Centurions now only pancake Paragons with shields, and will just attack them otherwise.
* All Centurions now have this behavior, not just Gantry built Centurions.
* Disabled the original Scathis again.

  ### 2014-12-23

  * The AI's Centurion pancake script now checks how many times they have failed against each Paragon.
    * They will only try to pancake a Paragon once per half of the level of completion of the Paragon, or if they have more in the squad than the total number that died trying.
  * The pancake script now also checks the maximum speed of the Centurion, and adjusts the ideal kill angle estimation appropriately.
    * For if I adjust the Centurion speed again, and if I apply the script to other experimental fliers.
  * Increased the air speed of the Centurion from 12 to 15. (Original 18)
  * Added a work around for removal of things on walls sometimes causing it to lose its path blocking if the removed thing had the same or larger footprint.

  ### 2014-12-24

  * Added the Aeon T1 Torpedo Bomber.

  ### 2014-12-25

  * Reduced the maximum stunned time for resurrected units to a minute.
  * Disabled the unscripted Seraphim Stargate experimental.
  * Changed the LOD fade-off of the Aeon T1 torp bomber.
  * Fixed texture references in the Seraphim T1 gunship and T3 torpedo bomber.

## 2014-11-30|0.5.7

* Separated the AIx Gantry hax into its own module.
* Lowered the crash damage and movement speed of the Centurion by a third each.
* Re-adjusted the AIx pancake code to accommodate the new Centurion speed.

  ### 2014-12-07

  * Fixed a minor error in the panic state script for UEF engineering resource buildings.

  ### 2014-12-08

  * Sorted some things related to the assignment of units in the build restrictions list. Specifically:
    * The Scathis MK 2 can't be built with no Game Enders, on its original code now.
      * It is also back to its old unit code for compatibility with other mods.
      * This also fixed the bug whereby with BrewLAN disabled the Scathis icon was still the Scathis Mk 2.
      * And a bug whereby the rebuild bonus wasn't working due to it referencing the current (and original) unit code.
    * The Cybran Shields, and tech 1 shields are no longer buildable with no Bubbles (Assuming you are running a version for which no-bubbles isn't bugged.)
    * Paragon Game: The Paragon is always buildable by the Paragon guy.

  ### 2014-12-10

  * Sorian AI now treats the Absolution as if it was a Fatboy.
  * Created the infrastructure to move all the Gantry AI scripts, and Centurion pancake scripts into the actual AI files.

  ### 2014-12-13

  * Added the Seraphim Experimental Rapid-Fire Artillery.

  ### 2014-12-14

  * Slight re-texture for the UEF T3 wall and gate sections.
  * Added the Seraphim Experimental Rapid-Fire Artillery to the game enders list.
  * Fixed a particle effect on the Seraphim T1 Gunship.
  * Added a Seraphim T1 Light Torpedo Bomber.
  * Changed the descriptions of the Iyadesu to match what it currently does.
  * Corrected a typo in the von mayor rector description.

  ### 2014-12-15

  * Minor improvement to the code that deals with the relative costs of aircraft.
  * BrewUI now returns the original code if BrewLAN isn't active. Meaning you can leave it on when BrewLAN is off without breaking things.

  ### 2014-12-17

  * Script for handling sweeping changes of categories is now slightly more efficient.
  * Crystal Hill now removes civilian buildings from the direct center of the map, and spawns the crystal in the exact position of the first of those buildings, if there were any.
    * However the script no longer cares if anything else is blocking the location, or if the ground is flat.
    * This is better for maps where uneven terrain would make the crystal appear nearer one player.
    * The crystal sometimes has its underside visible.
  * MetalWorld now cheat-spawns the correct factional power plant for AI's.
  * Added credit headers to various scripts.
  * Made the Paragon Game initializations script more compatible.
  * Made the Crystal Hill initializations script more compatible.
  * Paragon Game and Crystal Hill can now be played together.

  ### 2014-12-18

  * Lowered the selection priority of the Iyadesu.
  * Units resurrected by the Iyadesu are now stunned for the ideal amount of time it would take to repair it.
  * Crystal Hill now strips bracketed text from player names on the notification messages, most relevent for AIs.
  * AI's now pay some attention to the crystal on Crystal Hill, and send units there, sometimes even leaving the units there.

## 2014-11-23|0.5.6

* Created a new icon for the field tech enhancement.

  ### 2014-11-24

  * Re-enabled the Iyadesu as a RezBot.

  ### 2014-11-26

  * New icon for the rez/reclaim ability.
  * Rezzing now causes the resurrected thing to become stunned for 10 seconds.
  * The Iyadesu now has only mass storage instead of mass storage and energy storage, and its shield now only costs 50 energy per second.

  ### 2014-11-28

  * Fixed the rezbot duplication bug.
  * Changed some of the rezcode variables to be better named.
  * Fixed the orientation issue of the rezed units.

  ### 2014-11-29

  * Fixed a typo in 3 of the tech 1 shield generator descriptions.
  * Fixed a typo in the anti-armor point defense descriptions.
  * Fixed a typo in the Novax description.

## 2014-11-17|0.5.5

* Increased the AI chance of building a Gantry.
* Changed the AI Gantry build Centurion pancake behavior.

  ### 2014-11-18

  * Fixed the Gantry build pancake Centurion name threads issue.

  ### 2014-11-19

  * Fixed the Gantry-built pancake-Centurion name threads re-issue. For reals this time.
  * Paragon Adjacency buffs change.
    * This change includes a work around for an issue with things requiring maintenance energy breaking next to the paragon.

  ### 2014-11-21

  * Changed the Paragon buffs again.
  * Fixed an issue with some hooked scripts hard linking back to the originals.
  * Added an enhancement to the SACUs to enable field engineer buildings for them.

  ### 2014-11-22

  * Center of the Gantry no longer blocks pathing.

## 2014-11-16|0.5.4

* Changed the texture of the texture of the Centurion.
* Fixed a typo of the pancake Centurion.

## 2014-10-26|0.5.3

* Fixed an error with the wall script.
* Changed the Gantry code to be more inclusive with what it selects to be buildable.
  * Side effect: The Gantry can now build T3 Sonar.
* Added a restriction for the Atlantis on AI controlled Gantries.
* AI now names its Gantries.
* AI now names its pancake Centurions differently.

  ### 2014-10-31

  * The AI Gantry experimental picker now starts at with a random experimental instead of the first on its list (it still cycles linearly from there).
  * Field engineers can now build air staging platforms.

  ### 2014-11-08

  * Added a super basic version of the Seraphim totally-not-a-stargate.
  * Added air staging to the build lists of field engineers.
  * Increased the chances of the AI building the Gantry.
  * Extended the build list of the Gantry.
  * Added additional AI Gantry name options.

## 2014-10-19|0.5.2

* Added strings to the table for the soon to exist seraphim experimentals.

  ### 2014-10-20

  * Changed the AI behavior with a Gantry.
    * It will now have it build 5 engineers.
    * It will then build a Centurion.
    * It will then repeat the two preceding steps before infinite building Centurions.

  ### 2014-10-23

  * Fixed an issue with beams on the walls not removing properly when a section dies.

  ### 2014-10-24

  * Changed the AI use of the Gantry. Involves hax. Lots of hax.

  ### 2014-10-25

  * Created a proper function for the Gantry choosing which experimental to build while AI controlled.
    * It now cycles through all air experimentals detected by the launch script, and builds one, then does the same for land experimentals, and then sequentially cycles through all of them in that pattern.

## 2014-10-15|0.5.1

* Fixed some issues in the French and Russian string tables.
* Fixed a typo in the long descriptions of tech 1 gunships.

  ### 2014-10-17

  * Fixed the remaining issues with the Russian string tables.
  * Fixed the string reference for the description of the engineering mass extractor.
  * Fixed the string reference for the long description of the tech 1 mines.
  * Fixed the conflict with Extreme Wars. (Caused by BrewLAN assuming the Fatboy could build.)
  * Changed the way the armored walls pick their turrets. Its now based on footprint, not size cat.
  * Fixed the conflict with Total Veterency. (Caused by TotalVeterency assuming all units have health.)
  * Allowed the Absolution to move backwards.

## 2014-10-05|0.5

* Re-enabled torpedo bombers to land in/on water, and modified their target layer caps table to allow targeting while in/on the water.
* Fixed the Gantry not stopping its resource drain on pause.
* Aster: UEF Mobile Anti-Nuke changes:
  * Increased the mass cost and health by 40% (not counting cost of starting missiles).
  * Set the starting storage/max storage to 3/6 (from 1/1).
  * Decreased the cost and damage of its missiles by 3 times.
  * Increased its build rate to 10.

  ### 2014-10-06

  * Fixed the maintenance cost not auto-activating on the UEF E-MEX.
  * Increased the animation speed of the Aster.
  * Added the pause function to all units that can upgrade.
  * Added the stop function to all units that can upgrade.
  * Removed the icons for the old removed naval shields.
  * Finally fixed the ANSI/UTF-8 encoding error on the French localization files.
  * Fixed the localization errors for the string 'Field Engineer' on 6 of the field engineers.
  * Updated the strings for the German localization. Pending actual translation.

  ### 2014-10-08

  * Updated German translation provided by Simon Jenner (106.Bluebird).

  ### 2014-10-09

  * New French translation provided by asdrubaelvect29.
  * AI related changes to the Gantry.

  ### 2014-10-10

  * Slightly improved AI handling for Gantry; they no longer have the air/other ui build restrictions.

  ### 2014-10-11

  * Finished the Scarab.
  * Fixed the script of the Aeon shielded fab.
  * Increased the size of the Hedgehog.
  * Created icons for all units missing icons.
  * Created a Russian translation with GOOGLE.

  ### 2014-10-12

  * Moved the upgrade stop button function to the unit script, so that it only appears when it needs to.
  * Gantry now picks buildable experimentals based on their footprint width to be buildable.
  * Made the Gantry to be able to build other races experimentals if you control a T3 engineer (or anything that has the categories 'engineer' and 'tech3') of that race next to it.
  * Fixed an FX error with the Aeon T1 Gunship.

## 2014-09-28|0.4.F

* Finished the Omni Disrupter.
* Set the Slink to not have its cloak active on creation.
* Removed my AA damage change for the Broadsword and Wailer.
* Created the UEF T3 Gate section.

  ### 2014-09-29

  * Fixed the bug with the Sparky mine build cat, which had accidentally gotten overwritten by the counterintel cat.
  * Unified spellings of 'defense' to match the American spellings of 'Defense' already found throughout the game. Even if it feels wrong.
  * Set all land mines to link back to the same script, instead of being almost exact copies of said script.
  * Allowed all units to walk over land mines.
  * Fixed the normals link for the UEF T1 Field Engineer.
  * Gave the UEF T1 mine a unique appearance, fixed, and finished it.
  * Allowed all non-Iron Curtain shields to be built on water.
  * Removed the last traces of the old naval only shields.
  * Fixed the error in the script for the Night Skimmer, and made it be closed on creation.
  * Gave the Aeon T1 air staging its large node. Like the others have always had.
  * Finished the Aeon T3 Shielded Mass Extractor.

  ### 2014-09-30

  * Sorian AI will now build most new BrewLAN units, including the Centurion, Archimedes, Field Engineers, Mobile Strat defenses, and others. (Also the Gantry, but they don't use it well.)
  * Allowed AI to cheat with field engineer exclusive units, and be able to build them with regular engineers, allowing them to build the alternate resource buildings and anti-armor point defenses.
  * Removed the Aeon and UEF T1 shield references to the non-existent naval shields.
  * Fixed the normals reference of the Orbos.
  * Fixed the particle effects of the Aeon decoy.

  ### 2014-10-01

  * Added the Seraphim T1 & T3 mines.
  * Removed the radar and sonar from T1 mines and replaced them with omni; they are supposed to be pressure sensitive and wouldn't detonate to jammer signals.
  * Created a new model for the Orbos.
  * Enabled flatten skirt for the Orbos (also enables tarmac).
  * Created a new model for the Aeon Field Engineers.
  * Fixed the transport class of the Cybran T3 engineer.

  ### 2014-10-02

  * Brightened the distance lights of the Aeon Field engineers.
  * Added the Aeon T1 mine.
  * Fixed the shader types of several mines.
  * Improved the AI assignment in overlapping types.
  * Disabled AI building T1 shields until I can make them upgrade them.
  * Set the Slink to auto activate its Cloak if controlled by an AI.
  * Set the Slink to disable its Cloak on fire.

  ### 2014-10-03

  * Slink now decloaks to fire, and recloaks afterwards.
    * Added sound effects and particle effects for some audio and visual feedback on its cloak status.

  ### 2014-10-04

  * Added a clause for the cardinal wall script to check multiple conflicts.
  * Added the Aeon T2 Wall.
  * Added a build restriction so walls can't build Hydrocarbon plants. (This only effected a total Meyhem unit to my knowledge.)
  * Transferred cardinal wall and gates scripts into the BrewLAN default units lua doc.
  * Added a check to the wall script for creating beams, to check both bone ends are legit.
  * Created a custom model for the Aeon Shielded power gen.
  * Added the Cybran T1 mine.
  * Added the Cybran T3 Cloakable Extractor.

## 2014-09-22|0.4.E

* Changed the gate sections to be a separate building to the wall sections instead of an upgrade of the afforementioned.
  * As much as I preferred the lack of UI clutter it being an upgrade came with, it had three unfortunate side effects:
    * It occasionally broke adjacency script for them.
    * You couldn't have them in templates.
    * It made the gate sections be repaired virtually instantly by anything. (They both still repair to fast anyway.)
* Altered the costs of the T3 walls.
* Increased the animation speed of the gates.
* Increased the max slope that T2 & T3 walls can be built on.
* Increased the depth of the wall models so they don't leave gaps when on uneven land.
* Created a distance model for the Cybran T3 gate.
* Removed the distance model reference for the Cybran T2 wall. Its simple enough to not matter.
* Added the UEF T3 Armored Wall Section.

  ### 2014-09-23

  * Added an icon and description to the UEF T3 wall.

  ### 2014-09-24

  * Did a complete blitz of the blueprints.lua. (Over 100 lines shorter, with the same+ function.)
  * Made the Ravager buildable by the armored walls.
  * Set the Ravager to be Size4 instead of Size12.
  * Created a base unit for the Cybran Experimental Omni Disrupting Facility. No script yet.

  ### 2014-09-27

  * Made the Omni Disrupter almost fully functional.

## 2014-09-14|0.4.D

* Added Harpoon: UEF T3 torpedo launcher.

  ### 2014-09-15

  * Created a new model for the Cybran T2 wall.

  ### 2014-09-17

  * Created a texture for the Cybran T2 wall's new texture.
  * Added a laser fence effect to the Cynran T2 wall.
  * Added decals to the second layer version of the Cybran T3 wall.

  ### 2014-09-18

  * Added a seraphim quantum optics variant.
    * Currently not very variant-y. That is a word now.
  * Fixed the size category for the Aeon Quantum Optics. It was set to size 4, so you could make it free with T1 power plants, but if you did it broke it.

  ### 2014-09-19

  * Changes to the Seraphim quantum optics variant:
    * Reclassified as a 'Optics Tracking Facility'.
    * Renamed and given unique text strings.
    * Changed functionality to target radar blips/units and spy on them.
    * Can no longer target open space.
  * Fixed the selection sizes of the Cybran walls.
  * Added Cybran heavy gate sections.

  ### 2014-09-21

  * Fixed the construction button on-click changes so it now cares about things other than building more, and removing things on the questack.
  * Set the armored wall to upgrade into the armored gate.
  * Had the armored wall destroy whatever was on-top of it when the upgrade finishes.
  * Set the gate sections to pass their orders to adjacent gate sections.
  * Created a model for the Cybran armored gate sections.

## 2014-09-08|0.4.C

* Updated factions.lua
* Created BrewUI.
  * A separate UI mod for handling all the Field Engineers, separate because its not coded well for compatibility. (Yet)

  ### 2014-09-10

  * Made the Gantry not trigger the idle factories list.

  ### 2014-09-11

  * Made the cybran armored wall not trigger the idle factories list.

  ### 2014-09-12

  * Added a destroy turret button to the heavy walls. Just in case.
  * Changed the build list for the Cybran T3 wall to have a different wall.
    * This different wall has a smaller base and cant build.
  * Fixed the distance mesh for the Iron Curtain, that has been miss-linked since the B-S unit code change.
  * Changed the T2 adjacency buffs from T2 storage with size 12 and size 20 buildings, to account for the gaps they will always leave. Although there are no size 20 buildings that care anyway.
  * Changed the Cybran T2 wall to be larger, and use the cardinal directions code. Currently uses the stripped down T3 mesh.

## 2014-08-31|0.4.B

* Lowered the rate of fire bonus given by the Paragon from -1 to -.2. P90 Mavor, while hilarious, is not on.

  ### 2014-09-02

  * Added a death animation script to the Gantry. Complete with random exploding arms.
  * Improved the LOD1 mesh of the Gantry, so the arms move at a distance, and the floatation legs also appear at a distance.

  ### 2014-09-03

  * The Hades now has an overheat effect: A small explosion dealing 500 damage, usually only to itself, a small fire, and some smoke that lasts most of the 16 cooldown time.
  * Hades now deals damage when it dies, equal to its power drain, or calculated power drain if its not firing, at a proportional radius of up to 3.

  ### 2014-09-04

  * Minor performance improvements for the Gantry whacky wailing inflatable arms flailing script.
  * Minor change in Gantry flailing arm speeds.
  * Basic script for building things on top of the armored walls.

  ### 2014-09-05

  * Fixed the script errors and the 'I dropped it' bug with the armored wall buildings.
  * Mostly sorted out the build lists for the armored walls. (It can build torpedo launchers still.)
  * Allowed the Fatboy to build the Custodian.
  * Fixed an issue with the Seraphim shield walls getting shot.

  ### 2014-09-06

  * Removed torpedo launchers from the heavy wall build lists.

## 2014-08-31|0.4.A

* Changed the description of the Cybran armored wall.
* Modified the on-click function of a build-menu buttons to check if the unit clicked is buildable by the Gantry and one of the units selected is the Gantry.
  * This allows units to both be Gantry built and Engineer built, without any weirdness with fake units that become the real thing.
* Removed the fake Fatboy, Atlantis, and Centurion.
* Made the real Centurion buildable by engineers.
* Removed the part of the script that was making the Fatboy and Atlantis Gantry only. (Also effected experimentals from BlackOps and Total Mayhem)
* Fixed the lod1 normal map link for the Gantry.
* Set the population cap usage of the Novax Satellite to 0. Center itself still takes a slot.
  * This prevents it from not spawning when at the population limit, and leaving useless centers.
* Fixed a minor error in the Centurion script, relating to it attempting to set the speed of its rotors before they have been set up as.
* Added additional compatibility scripts for the Gantry building units with other mods enabled.

## 2014-08-24|0.4.9

* Added the Aeon T3 Shielded Power Gen and Fabricator, neither has a unique model yet.

  ### 2014-08-25

  * Changes to the Aeon and UEF T1 Shields:
    * Footprint increased to 6x6:
      * Coverage area proportionally increased for same effective coverage.
    * Temporarily removed aquatic abilities pending new implementation of naval shields.
    * Allowed to upgrade into their respective T2 shield.
  * Cost increases of the Armored Point defenses:
    * Energy cost from 13500 to 29700.
    * Mass cost from 2250 to 3000.
    * Build time from 2250 to 2700.
    * Energy per shot from 0 to:
      * Aeon: 2500.
      * UEF: 5000.
      * Cybran: 1500.
      * Seraphim: 2250.
  * Added the attack reticle to the Seraphim Anti-Armor, and also removed its water vision.
  * Disabled Torpedo Bombers from landing in the water again.

  ### 2014-08-26

  * Changes to the Novax Observation Satellite:
    * Intel changes:
      * Radar added with range 80.
      * Vision reduced from 72 to 65.
      * Sonar added with range 50.
      * Omni reduced from 50 to 35.
      * Underwater vision added at 20.
      * Added personal stealth.
    * Selection priority reduced to 4; after engineers but before buildings.
    * Reduced impact damage to 10.
    * Maintenance per second set to 2500.
    * Vision reduces to similar levels as the old Satellite when not powered.
    * Fixed a bug preventing the Uplink Center from dying when the Satellite dies.
  * Allowed the Generic T3 resource generators to upgrade into the existing advanced resource buildings (6 units total).
  * Allowed the Cybran T2 Stealth Field Generator to upgrade into the Cloakable Stealth Field Generator.
  * Cleared up a lot of redundant code in the blueprints.lua file and the unit.bp mods file.
  * Did a work around fix for the Scathis MkII not being disabled when game enders are off.
    * Changed my modded version to have the original code and replace it entirely. Will cause problems with other mods that alter the Scathis.
  * Created a ghetto work around for the Atlantis getting stuck in the Gantry. Very ghetto fix.

  ### 2014-08-27

  * Created a script class for the UEF engineering resource generators, so there is less copied code.
    * Script now checks how far away the instigator is, and does nothing if its too far away, then checks the instigator layer instead of its categories when deciding what to build.
      * Too far away is considered over x3 its visual range.
      * If the units layer is water it alternates between trying to build a torpedo or point defence, in case it can't reach the water for a torpedo.
  * The Engineering Power Generator now aims with all its arms, instead of just the first.
  * Fixed a long standing bug with the Gantry being able to have its costs reduced, through adjacency, to 0 of any one resource.
  * Increased the physical size of the T1 UEF Shield so it matches the size of the T2, and doesn't look odd when upgrading to it.
  * Applied a change to the Engineering resource building script by MrDeagle, which reduces total lines of code.

  ### 2014-08-28

  * Added Cybran Tech 3 Armored Wall Section.

  ### 2014-08-29

  * Fixed the script of the Cybran Armored Wall, and otherwise finished it.
  * Finished the Seraphim T3 Shield Wall.
  * Made the Seraphim shield walls double-clickable.
  * Fixed the cost of the UEF Engineering Mass Fabricator. (It was 10x cheaper than it should have been.)

  ### 2014-08-30

  * Added the Seraphim Armored Power Generator, Fabricator, and Extractor, allowed there T3 others to upgrade into them.
  * Added adjacency buffs to the Paragon.
  * Increased the cost to fire of the Orbos to 1500 from 500.
  * corrected the distance model of the Centurion, so it doesn't look like the old version.
  * Added a basic Aeon T3 Shielded Mass Extractor.
  * Sorted an issue with some units not being able to queue upgrade all the way up from the bottom.
  * Fixed the normals linking on the UEF T3 Field engineer.

## 2014-08-17|0.4.8

* Fixed the Cybran T3 Cloakable Fabricator, gave it a custom model, and added it to the string tables.
* Added Field Engineer capability to build counterintelligence buildings.
* Removed the basic UEF Cloakable fusion.
* Added Cybran T3 Cloakable Stealth Field Generator.
* Added the appropriate T1 storage to each T3 engineering resource buildings' buildable list.

  ### 2014-08-18

  * Changed the energy drain of T3 Point defenses:
    * Aeon Orbos to 500 per shot from 400.
    * Seraphim Othuushala to 100 per shot from 10.
    * Partial setup of a script for the Cybran Hades to have its energy drain per second increase by 10 for every half second its active and decrease by 30 for every half second its inactive. (It doesn't subtract correcrly, and currently breaks the economy.)

  ### 2014-08-20

  * Re-created the script for the Hades cumulatively increasing and decreasing its firing upkeep cost, so it now works.

  ### 2014-08-22

  * Updated the descriptions of the Hades and Orbos.
  * Created the UEF Tech 3 Engineering Power Generator.
  * Fixed a long standing bug with the Seraphim Shield Wall test unit, which was preventing it from loading.

  ### 2014-08-23

  * Experiments with giving the Aeon Decoy Plane the category 'SPECIALHIGHPRI' so it gets the shit shot out of it.
  * Changed the Engineering Power Generator script to also check if the instigator was a submarine or dead, for making a torpedo, or nothing respectively.
  * Gave the Engineering Power Generator a siren when it is attacked.
  * Added the UEF T3 Engineering Mass Fabricator

## 2014-08-08|0.4.7

* Added a basic Cybran cloakable fusion.
* Removed the Iyadesu again.

  ### 2014-08-15

  * Cybran Tech 3 Cloakable Power Generator changes.
    * Created a unique model for it.
    * Gave it a name.
    * Changed its balancing.
    * Added particle effects to its cloak.

  ### 2014-08-16

  * Added a basic UEF Cloakable Power Gen.
  * Added a basic Cybran Cloakable Fab.

## 2014-06-08|0.4.6

* Workaround for the bug that prevents things from properly assisting a builder that has 0 build rate.
  * Set the mobile anti-nukes to have a build rate of 1 so they are still completely ineffectual on their own but can be assisted.
* Added the Seraphim T3 Mobile Strat defense.
* Fixed the collision box of the Aeon T3 Heavy Point defense.

  ### 2014-06-28

  * Removed the footprint size from the Gantry built Centurion. It was preventing other things being built infront or behind the Gantry.

  ### 2014-08-03

  * Reduced the build time of mobile anti nuke missiles, so they take less engineering power than the units that get one for free.
  * Added Nihiloid: Aeon Tech 3 Anti-Armor Point defense.

## 2014-01-06|0.4.5

* Corrected problem with fake Centurion not referencing the model of the original properly.
* Added icon for fake Centurion.
* Linked flavor text for the fake Centurion.

  ### 2014-01-18

  * Added the Guardian; A UEF Static Gauss Cannon. Still needs some work. Not in string tables yet.

  ### 2014-01-25

  * Moved the Guardian to be buildable only by the currently non existent T3 field engineer.
  * Gave the Guardian a description and added it to the US string tables.
  * Fixed the Guardian crashing the game when it tries to fire.
  * Added A T3 Field engineer to build the Guardian.
  * Made the UEF Nuke mine only buildable by the T3 field engineer.
  * Increased the tarmac size, footprint size, and physics model size of the Guardian.
  * Reclassified the Guardian as a Anti-Armor Point Defense.

  ### 2014-01-26

  * Added a Cybran T3 Field Engineer. Called House.
  * Made the Cybran Nuke Mine only buildable by House.
  * Added a Cybran T1 Field Engineer. Called Outy.
  * Increased the size and distance of the life bar for the Custodian.
  * Increased the damage and range of the Custodian, slightly.

  ### 2014-01-26

  * Fixed the Guardian not being able to fire directly north.
  * Added a Seraphim T3 Torpedo Bomber.

  ### 2014-02-08

  * Lowered the health of the Cybran T3 field engineer by 35.
  * Increased the health of the Aeon T3 defense engineer by 5.
  * Added a line of Seraphim fiend engineers. (T1, T2, & T3)
    * The Seraphim now have a way of building their mine.

  ### 2014-02-09

  * Added a Seraphim T3 Anti-Armor Point defense.
  * Fixed the BlackOps fake weapon crash from the fake Centurion.

  ### 2014-02-17

  * Corrected the Night Skimmer not using default language string tables.
  * Added Aeon T1 & T3 field engineers.
  * Moved the Aeon Nuke mine to be T3 buildable only.
  * Buffed the Seraphim T3 field engineer to have the same build speed as the regular T3 engineer for seraphim.

  ### 2014-02-18

  * Changed the Gantry scripts to move all BlackOps and Total Mayhem units that fit to be buildable by it.
  * Added a script to change the costs of the BrewLAN T3 torp bombers, gunships, and transports based on the version of FA used.
  * Added the UEF T1 fiend engineer.

  ### 2014-02-19

  * Added an icon for the UEF T1 field engineer, and temporary icons for the temporary Aeon T1 & T3 field engineers.
  * Added the Cybran: Punisher: Tech 3 Anti-Armor Point defense.
  * Reduced the damage radius and health of the Seraphim T3 AArmorPD.
  * Increased the health of the UEF AArmorPD.

  ### 2014-02-20

  * Moved the decal tarmac textures out of the gamedata folder into the mods folder.
  * Changed the health bar size and positions of the AArmorPDs.

  ### 2014-02-21

  * Added a LOD1 mesh for the Punisher.

  ### 2014-02-28

  * Re-enabled the Iyadesu, with a total overhaul as an experimental field engineer.

  ### 2014-03-02

  * Increased the tarmac of the T2 and T3 UEF shield generators.

  ### 2014-03-07

  * Added the Hedgehog: Cybran T3 Mobile strat defense. Showcasing my new balance plan for the unit: Build cost includes its only missile, and it is unable to make more unassisted.
  * Adjusted the balance of Aster to match that of the Hedgehog. Specifically:
    * Energy cost from 78750 to 391500.
    * Mass cost from 5625 to 5850.
    * Build time unchanged. (Technically it went from 5* the time of the static to an arbitrary 22500, which turned out to be the same.)
    * Build rate of missile from 810 to 0.
    * Maximum storage from 3 to 1.
    * Initial storage from 0 to 1.
    * Build time of missile from 259200 to 25920.

  ### 2014-03-10

  * Slightly increased the energy cost and slightly decreased the mass cost and build time of the mobile anti nuke launchers.
  * Changed the description of the mobile ANLs slightly.

  ### 2014-03-15

  * Added Scarab: Aeon Tech 3 Mobile Strategic Missile Defense.
    * Not fully functioning yet; still lacks animation and bone setups. But it looks nice.
  * Listed the ability 'Strategic Missile Defense' for Scarab, Aster, and Hedgehog.

## 2013-08-17|0.4.4

* Changed the implementation for the Galactic Colossus health increase so it doesn't conflict with other mods' GC health changes.
* Fixed the energy drain of the Seraphim and Aeon T3 point defenses.
* Added the Cybran T3 Cloaked Mobile Missile Launcher.

  ### 2013-08-18

  * Fixed the Cybran cloaked missile launcher and improved its texture.

  ### 2013-08-25

  * Reduced the rate of fire of the Absolution.
  * Added stealth and jamming to the Slink.

  ### 2013-11-13

  * Re-added the torpedo bomber ability to land on water, with a workaround preventing torpedos from targeting them.

  ### 2013-11-17

  * Prevented the Solaris from not crash landing on death.
  * Increased the Absolution rate of fire back to its original.
  * Increased the costs of the Absolution slightly.

  ### 2013-12-01

  * Started creating a new model for the Centurion.

  ### 2013-12-08

  * Centurion things.
  * Model now properly implemented, with a ghetto texture.
  * No working weapons yet.

  ### 2013-12-16

  * More Centurion things.

  ### 2013-12-19

  * More Centurion things.

  ### 2013-12-20

  * More work on the Centurion.
  * Removed the long since removed Doomsday Machine from the string tables.

  ### 2014-01-05

  * More Centurion things.
  * Added an engineer built Centurion.

## 2013-06-01|0.4.2

* The end of 5 months of silence.

  ### 2013-06-02

  * Assigned build mode key bindings for constructing from the Gantry.
  * Added build mode key bindings for constructing all factory build units:
    * Archimedes (UEF T3 Satellite uplink)
    * Moldovite (Aeon T3 Armored assault tank)
    * Butler (Aeon T2 defense engineer)
    * Wilson (Cybran T2 Field engineer)
    * Ilshatha (Seraphim T3 Assault bot)
    * Albatros (UEF T3 Torpedo bomber)
    * Zenith (Cybran T3 Torpedo bomber)
    * The nonexistent Seraphim T3 torpedo bomber
    * Solaris (Aeon T3 Transport)
    * Night Skimmer (Cybran T3 Transport)
    * Vishuum (Seraphim T3 Transport)
    * Vulthuum (seraphim T3 Gunship)
    * Beguiler (Aeon T3 Decoy plane)
    * Respirer (Aeon T1 Gunship)
    * Pigeon (UEF T1 Gunship)
    * Vulesel (Seraphim T1 Gunship)
    * Seagull (UEF T1 Torpedo bomber)
    * Impaler (Aeon T2 Bomber)
  * Changed build mode keys for Othuum.
  * Added build mode key bindings for upgrading the following:
    * Aspis (T1 shield)
    * LSD - Pulse (T1 shield)
    * Atha-istle (T1 shield)
    * Iya (Seraphim engineering stations)
  * Added build mode key bindings for building the following:
    * All T2 storage.

  ### 2013-06-08

  * Doubled the rotation speed of the inner circle of the Solaris.

  ### 2013-06-16

  * Doubled the adjacency buff for T2 energy storages.

  ### 2013-08-03

  * Applied the French language files update by Marc Tassetti.

  ### 2013-08-04

  * Changed the textures of the UEF T1 Air Staging.
  * Adjusted the texture mapping of the UEF T1 Air Staging.

  ### 2013-08-14

  * Added the Cybran T1 Air Staging platform.

  ### 2013-08-15

  * Identified and fixed the incompatibility with BlackOps Unleashed 5.
    * The problem was the fake Fatboy I created, to be able to move the real Fatboy into the Gantry, had a fake AA weapon with no targeting restrictions (because it could never fire it) and BlackOps had a script that tried to give all AA weapons a restriction so they couldn't shoot their nuke atellite, which failed when it found a weapon with no restrictions.

## 2012-11-04|0.4.1

* Lowered the turning speed of the Archimedes.
* Gave the Archimedes a pair of targeting lasers to telegraph where its firing, and where its firing from.
* Lowered the build time of the Novax Center to 1000 from 2900, to be more inline with the Soothsayer and Eye of whats-her-face.
* Fixed the Zenith and Night Skimmer auto enabling stealth on create.
  * Not entirely sure my original code didn't work though, so meh.

  ### 2012-11-07

  * Added Orbos, the Aeon T3 Heavy Point defense.
  * AM-12 Anti-Armor: UEF Tech 2 Proximity Mine changes:
    * Increased damage from 1200 to 4500.
    * Lowered the mass cost from 300 to 100.
    * Lowered the build time from 150, to 50. (5 seconds)

  ### 2012-11-09

  * Added the Orbos to the string tables.
  * AM-12 Anti-Armor changes:
    * Fixed it not firing.
    * Changed the explosion effects to look more UEF.

  ### 2012-11-10

  * AM-12 Anti-Armor changes:
    * Changed the mesh to be more round.
    * Made more of the mesh visible above ground (For on slopes).
    * Added a submerging animation for while on water.
    * Fixed its build icon background to display it as amphibious.
  * Fixed the slightly out of align build skirt of the pseudo Fatboy.
  * Fixed the targeting beams of the Archimedes not being able to pass through allied shields.
  * Added a LOD1 mesh for the Archimedes.
  * Reclassified the Novax Center as an 'Observation Satellite Uplink'
  * Added the seraphim proximity mine. Even though there isn't a Seraphim field engineer yet.

  ### 2012-11-11

  * Jesus Christ its been a year since Skyrim came out.
  * Started the long slow process of changing the unit codes from B~~ to S~~.
  * Added the Cybran T2 Energy Storage.
  * Increased the explosion damage of T2 Energy Storages.
  * Made the AC-500 less useless (Gave it some usable guns) and re-added it to the build menus.
  * Created a lod1 mesh for the Solaris.

  ### 2012-11-12

  * Fixed the Solaris only being able to fire its AA in one direction.
    * This wasn't actually that noticeable because it used to turn without changing where it was flying, but it meant it could only really shoot things on one side of it.
  * Added the Cybran T2 Nuclear Mine.
  * Added a manual detonate button for all the land mines.
  * Added the Cybran T2 Proximity Mine.
  * Lowered the radar/sonar range of the proxy mines to 1 less than the explosion range.
  * Added 'Bulkhead' a T2 Cybran wall section. Buildable by field engineer.

  ### 2012-11-13

  * Condensed and rewrote parts of blueprints.lua.

  ### 2012-11-14

  * Changed the on killed explosion of the nuke mine to the damage category death-nuke from normal.
    * Gives ACUs and structures a massive resistance to it.
  * Changed the Scathis Mk2's armor class to structure, from experimental.
    * It provides more relevant resistances.

  ### 2012-11-17

  * Fixed the shader and build animation of the Seraphim T2 proxy mine.
  * Fixed an error in the unit statuses doc caused by the SVN being a retard, and updated it.
  * Added the UEF Nuke Mine.
  * Increased the health of proxy mines by 5 so they can just about survive the death explosions of SCUs and nuke mines.
  * Made most of the cannons on the Centurion functional.

  ### 2012-11-18

  * Fixed the massive bug which made Seraphim, Aeon, and Cybran T1 Land factories be able to build every engineer-capable unit for that faction. Including the Megalith, Iyadesu, and SCUs.
  * Added the Aeon Experimental Assault Tank.

  ### 2012-11-20

  * Changed the unit codes of proximity mines to s~b2221 from s~b2220.
  * Changed other mine stuff around.

  ### 2012-11-23

  * Aeon Experimental Assault Tank changes:
    * Created a new mesh.
    * Increased rate of fire once every 6 seconds from 10.

  ### 2012-11-24

  * Aeon Experimental Assault Tank changes:
    * Improved texture.
    * Tactical Missile Defense added.
    * Fixed footprint size and some particle effects.
  * Changed nuke mines to list as T3, but sort downwards so it stays where it is on the menus.
    * This way it gets disabled in T2 only games.
  * Made a prototype version of the UEF T1 Pressure Mine.
  * Renamed the UEF Nuke mine to AM-36 Trinity, from AM-36 Fatman.

  ### 2012-11-25

  * Corrected a typo in the Novax center description.

  ### 2012-11-26

  * Improved texture of the Aeon T4 Tank.

  ### 2012-11-27

  * Aeon Experimental Assault Tank changes:
    * Improved the texture.
    * Aligned some of the texture mapping.
    * Added the Volatile warning to the abilities list.

  ### 2012-12-01

  * Changed the Gantry roll off stats.
  * Aeon Experimental Assault Tank changes:
    * Made texture look complete.
    * Created opening animation.
    * Removed its mass & energy storage ability.

  ### 2012-12-02

  * Aeon Experimental Assault Tank changes:
    * Fixed the selection area.
    * Updated the icon to the new model.

  ### 2012-12-(3-4)

  <Section data missing>

  ### 2012-12-05

  * Aeon T3 Point defense changes:
    * Changed its appearance.
    * Decreased its range slightly.
    * Gave it the ability to target low altitude aircraft (gunships and transports)
    * Gave it an idle animation.
  * Added a section of test script that moves the Total Mayhem mod unit Doomsday into the Gantry.

  ### 2012-12-07

  * Adjusted the tracks of the Wilson.
  * Corrected the selection overlay for the Little Bertha.
  * Fixed the pitch animation of the Little Bertha.
  * Aligned the selection overlay for the Poker.
  * Tightened the build effect overlay of the Poker.
  * Aligned the selection overlay of the Charis.

  ### 2012-12-08

  * Added the Seraphim T3 Sonar.
    * Allowed the Seraphim T2 Sonar to upgrade into it.
  * Fixed the blank icons on the idle engineers tab heading for Aeon and Cybran T2 when the field engineers are the only idle engineer.
    * They still lack entries on the actual list.
  * Changed the build sorting of the Gantry to Construction.
  * Changed the build sorting of the Paragon to Economy.
  * Changed the build sorting of the Iron Curtain to defense.
  * Added the Seraphim T2 energy storage.
  * Changed the unit codes of all T2 energy and mass storages to S- prefix from b- prefix.
  * Added the Aeon T2 energy storage.
  * Enabled Sorian AI to build and rename the Absolution.
  * Re-added all the old Sorian names I removed around rev71.

  ### 2012-12-09

  * Gantry changes:
    * Changed unit code to new prefix.
    * Allowed it to build engineers while in naval & air modes.
    * Gave it more underwater furniture (Legs, arms, pipes, ect.)
    * Gave it a better texture, and team colored areas.

  ### 2012-12-10

  * Fixed the dust emitters and partially inverted normal map for the Moldovite.
  * Added a water ripple idle effect for the Absolution.
  * Added a custom tarmac for the Gantry, one that is actually large enough for it.

  ### 2012-12-10

  * Changed the following unit code prefixes to prevent direct BlackOps unit conflicts:
    * Cybran T3 Point defense.
    * Seraphim T3 Point defense.
    * Seraphim T1 Air Staging.
    * Seraphim T4 Engineer (the one that's disabled anyway).
      * The units no longer conflict, but the mod scripts do.
  * Removed the Doomsday Machine completely. Ain't no one want that shit.
  * Increased the firing tolerance on the Archimedes to prevent it from occasionally not firing.

  ### 2012-12-15

  * Added scaled explosions to the T2 energy storages. Successfully this time.
    * With no power in storage they do next to nothing. Big boom when full.

  ### 2012-12-16

  * Gantry changes:
    * Added blinking lights.
    * Fixed the targeting bones so things shoot it right.
  * Changed the unit code prefixes of the UEF and Aeon T1 air staging, and fixed the script errors in them.
  * Removed the reference to a non-existent bone on the Seagull.
  * Removed the reference to a non-existent bone on the Aeon decoy plane.
  * Fixed the tread marks on the Aster.

  ### 2012-12-17

  * Changed the unit code prefixes of ALL remaining units, fixing a number of errors along the way.
  * Removed the horribly broken Cybran sniper bot.

  ### 2012-12-19

  * Added the Aeon Proximity and Nuclear mines.
  * Fixed the sound files for the UEF Nuclear mine.
  * Fixed the Seraphim T1 shield not properly upgrading.
  * Added the Seraphim T2 engineering station line.

  ### 2012-12-23

  * Added localization data for the Seraphim engineering stations.

  ### 2012-12-29

  * Fixed the highest upgrade of Seraphim engy station being able to build itself.

  ### 2013-01-02

  * Experimented with classifying the Absolution as an aircraft engine side so it floats around better.

  ### 2013-01-03

  * Started work on the UEF Experimental Drop-Pod Artillery.
    * Currently uses the model of the Mavor, and only fires Mech Marines.

## 2011-03-19|0.4.0

* Added the UEF Mobile Satellite Uplink at about this date. (Changelog note added ## 2012-09-16)

  ### 2011-03-20

  * Added the UEF Mobile Strategic defense at about this date. (Changelog note added ## 2012-09-16)

  ### 2012-09-16

  * Added a strategic icon for T3 antimissile vehicle.
  * Added a strategic icon for T1 Anti naval fighter aircraft.
  * Modified the mesh and textures of the Aeon T2 Bomber to finish the appearance of its rear end.

  ### 2012-09-18

  * Added the UEF T1 torpedo bomber.

  ### 2012-09-20

  * Made all torpedo bombers able to land on water. Funny story; it was the 'TRANSPORTATION' category all along.

  ### 2012-09-21

  * Added the UEF T1 Air staging platform.

  ### 2012-09-22

  * Finished the UEF T1 Air staging platform.
  * Allowed the Aeon T2 shield to upgrade into the T3.
  * Updated 'Unit Statuses.txt' somewhat.
  * Added localization string for the Aeon T4 Artillery description.
  * Updated entries in German string table. Translations still pending.
  * Added French localization; the names and nicknames are probably fine(ish) but the description text is probably pigeon French.

  ### 2012-09-25

  * Fixed the Abyssal Persecutors occasional walk animation speed bugs.
  * Flailed around blindly with the UEF T2 energy storage.

  ### 2012-09-30

  * Minor changes to the UEF T1 shield gen for allowing it to upgrade.
  * Disabled the UEF T1 shield from upgrading on land.
  * Added the UEF T3 Naval shield, only available as an upgrade from the UEF T1 light shield (which is aquatic).
  * Added some ghetto German and French string tables for the UEF T3 Naval shield.

  ### 2012-10-01

  * Increased the max health of the Scathis, to 17500 from 8750.
  * Shield generator changes:
    * Fixed the adjacency bonuses of the T1 Aeon & UEF shields, and the UEF T3 Naval shield.
    * Corrected the abilities list of the Iron Curtain.
    * Cybran shield balancing:
      * Bumped the ED2 down to T1 and removed it from T2 build lists.
      * Added the ED3 to T2 build lists.
      * Increased the max health of the Iron Curtain to 6950 from 4250.
        * It now takes 3 hits from any T3 bomber directly to destroy it, instead of 1-2 (race dependent).
      * Removed the unlisted radar and sonar from the Iron Curtain.
    * T1 UEF Shield gen balancing:
      * Increased the build rate (for upgrading) from 7.5 to 10.
      * Increased the power outage regen time to 5 sec from 3.
      * Increased the damage outage regen time to 10 sec from 7.25.
      * Increased regen rate to 110 from 80.
      * Increased shield size to 14 from 13.
    * Aeon T1 shield balancing:
      * Increased regen to 120 from 69.
      * Increased recharge time to 10 from 8.
      * Increased shield strength to 6700 from 5500.
      * Increased size to 11 from 10.
      * Lowered build costs to 240m 2400e 240t from identical to the T2's.

  ### 2012-10-02

  * Part two of shield generator changes:
    * Seraphim T1 shield balancing.
      * Increased health to 250 from 200.
      * Increased shield strength to 8000 from 6500.
      * Increased shield size to 17 from 16.
      * Increased regen rate to 139 from 75.
      * Increased recharge time to 12 from 10.
      * Increased mass/energy/build time to 400/4000/400 from 350/3500/350.
    * Cybran Iron Curtain changes.
      * Halved mass/energy/time/maintenance costs to 1200/200000e/8000/2500eps.
      * Halved the regen assist mult and energy drain regen values back to their original 60 and 5, like all other shields.
      * Lowered shield rebuild time to 1:30 from 3:40.

  ### 2012-10-06

  * More random flailing at the T2 Energy storage scaled explosions. Srsly, fuck them.
  * Partially completed a new model for the Aeon T3 Transport. It came out bigger than expected.
  * Rebalanced stats of the Aeon T3 Transport to accommodate for its new size.

  ### 2012-10-13

  * Fixed the Hades' cannon not rotating while firing.
  * Fixed the Hades' inverted normals.
  * Allowed Cerberus to upgrade into Hades, then disallowed it. That shit was crazy OP.

  ### 2012-10-14

  * Gave the Aeon T3 Transport shield active animations and effects, although the particles are out of align, the shutter doors don't open yet, and it still has no weapons.

  ### 2012-10-16

  * Gave the Aeon T3 Transport weapons (AA only), fixed the particle effects, and made the shutters hide on built.
  * Fixed the Aeon T3 Transport's rings and ball not starting up again on shield reset.

  ### 2012-10-17

  * Increased the build time of the Aeon T3 Transport.
  * Gave the Aeon T3 Transport a pretty death.

  ### 2012-10-19

  * Reclassified the Abyssal Persecutor as 'Experimental Battleship' instead of 'Experimental Dreadnaught'.
  * Fixed, and gave a slightly more unique appearance to, the Seraphim T3 Point defense.
  * Gave the damage test unit a mesh. Because that's important enough for the changelog.
  * Cleaned up some un-needed files.

  ### 2012-10-20

  * Fixed the death animation link for the Seraphim T3 Point defense.
  * Corrected the Solaris' name on the French and German string tables.
  * Added build descriptions for the Seraphim T3 Point defense.
    * German description is the same as the Hades.
    * French description is probably terrible French.
  * Updated Unit Statuses.txt.
  * Moved the code that hides the Scathis and Novax Center to Blueprints.Lua.
  * Hid the UEF T4 PD from the build menus.
  * Changed the Cybran and UEF T3 Gunship AA damage values to double their original values. (That's 12 and 6 damage per shot :O)
  * Removed all the extra spaces from the French LOC, and capitalized some letters.
  * Moved the code that gives Sparky the extra build cat to Blueprints.lua.
  * Added the Aeon T2 defense Engineer.
  * Added the Aeon T3 Naval shield, which can only be acquired by upgrading the T1 on water.
  * Fixed the energy cost of the UEF T3 Naval shield, which was missing a digit.
  * Removed the rebuild bonuses from the UEF T3 Naval shield. You cant build it directly.
  * Added the UEF Experimental Factory.
  * Temporarily disabled the UEF T4 Factory from building aircraft.
  * Temporarily disabled the UEF T4 Factory from building experimental naval units.
    * The Atlantis gets stuck attached to it for some reason.
  * Failed attempt at making the T4 factory accept experimental units properly.

  ### 2012-10-21

  * Added headers to the language string tables with cheesy ascii art.
  * Minor change to the Sorian ai units table. It needs a proper update still.
  * Removed the Restorer changes for breaking FAF balancing.
  * Moved 1k health from the Harbingers shields to its health.
  * UEF Experimental Factory changes:
    * Halved build time.
      * It is now quicker to build than the Fatboy, instead of longer.
    * Increased build rate from 180 to 240.
      * Its now faster than the Fatboy instead of the same speed.
    * Gave it the name 'Gantry'.
    * Increased the selection width.

  ### 2012-10-22

  * Fixed a number of errors in the foreign string tables.
  * Added the Aeon T3 naval shield, T2 defense engineer and the Gantry to the string tables.
  * UEF Gantry changes:
    * Gave build animations.
    * Fixed unit rolloff.
    * Made Air units buildable again.
    * Created a toggle button for between building land/sea and air.
      * Gave the toggle button custom tooltips.
        * Added tooltips to the localization string tables.
      * Gave the button a custom appearance.

  ### 2012-10-23

  * Moved the Fatboy to be buildable only by the Gantry, for technical reasons.
  * Added a fake Fatboy for engineers to build.
    * It has all the stats important during building of the real Fatboy.
    * When it finishes building it gets replaced by the real one.
      * I'll do the same for the Atlantis when I make a script to make it automatically dive, or otherwise not get stuck.

  ### 2012-10-24

  * Fixed the engineer built Fatboy regaining all its health on completion.
  * Disabled torpedo bombers ability to land on water.
    * While landed on water they wont retaliate automatically against submarines.
  * Added rebuild bonus for the Gantry on the corpse of another.
  * Removed the scripts I made that 'made the Cybran bomber and fighter auto activate stealth'.
    * They weren't; they were just activating the maintenance consumption.
    * Also FAF already does what I was after with that.
  * Added tooltips for the decoy planes ability to change their speed.
  * Made a start on the script to change the speed of the Aeon Decoy plane.

  ### 2012-10-30

  * Fixed the string tables for the decoy plane tooltips.
  * Removed the Aster (UEF mobile anti-nuke) from build menus.
    * It fires missiles it doesn't have, and goes into negative numbers. Forever.
  * Changes Archimedes to be listed as indirect fire.
  * Changed stats of the Archimedes to be similar to the Seraphim sniper bot on slow.
  * Gave the Beguiler (Aeon Decoy Plane) a mesh and icon.
  * Removed the other two uncompleted decoy planes from the build menus.
  * Increased the energy cost of the BrewLAN T3 air units to match that of the others.
  * Fixed the Aeon T3 defense engineer being buildable by all aeon factories.
  * Removed the Archimedes, AC-500 Centurion, and Abbysal Persecutor from build menus.
    * All unfinished.
  * Fixed the Gantry to be able to build Sparky. For reals this time.

  ### 2012-10-31

  * Changed the icon of the Pigeon. Still not happy with it; its at the wrong angle.
  * Archimedes changes:
    * Fixed the strategic icon.
      * It now actually has the same as the mobile artillery.
    * Added a (lazy) custom mesh for the Archimedes.
    * Set it to do a little under 5K damage per shot.
    * Set its rate of fire to once every 30 seconds.
    * Gave it an icon.
    * Re-added it to the build menus.
  * Re-arranged the build icon sort priorities for T3 land units.

  ### 2012-11-02

  * Lowered the damage of the Aeon T2 bomber from 1925 to 1125.

## 2010-05-29|0.3.1a

* Added the UEF Albatross; T3 Torpedo Bomber.

  ### 2010-06-03

  * Added the Cybran Experimental shield thing.
  * Added generic icons for experimentals that still lack final meshes.

  ### 2010-06-20

  * Created the LOD1 mesh, fixed the normals, buffs and icon for the UEF T2 Energy Storage.
    * 8 T2 E-stores around a T3 power gen now double the power gens capacity.
  * Fixed the normals for the UEF T2 Mass Storage.

  ### 2010-06-22

  * Gave the UEF T2 Energy Storage a name. A name which is totally not a Powerthirst reference.
  * Cybran T4 Shield changes:
    * Gave it a temporary semi-custom mesh and icon.
    * Renamed it to the Iron Curtain, from Erectile Dysfunction 6.
    * Fixed the life bar and selection size and position.
    * Added rebuild bonus for remaking.
    * Updated the script for the new mesh.
    * Added the unit to the string tables for localization.
  * Updated icons in the SCD file.

  ### 2010-06-24

  * Iron Curtain changes:
    * Created a LOD1 mesh
    * Increased the length of time it takes to reactivate
    * Reduced its regen rate.
    * Made an attempt to fix the smoothing groups of the mesh, which failed.
  * Moved the AINames strings from sorianlangs.lua to the individual units.
  * Updated the version name in the mod_info.lua.
  * Improved Sorian AI support.
  * Fixed the LOC string link which was making the Night Skimmer appear as being called 'Heavy Air Transport'.

  ### 2010-06-25

  * Changed the mesh and normal map for the Iron Curtain for better in-game smoothing.
  * Changed the normal map of the Zenith for better smoothing.

  ### 2010-06-28

  * Updated the required UID for the Icon Support mod; they had made it to version 5 without me noticing.

  ### 2010-07-19

  * Increased the rate of fire of the Scathis, resulting in a lower rate of fire without power plant bonus.

  ### 2010-07-27

  * Simon Jenner (106.Bluebird) corrected the German string tables.

  ### 2010-07-28

  * Re-added the Iron Curtain to the German string tables.
  * Fixed and changed the mesh, icon, textures, script and blueprint of the Cybran T2 Field Engineer.

  ### 2010-08-05

  * Added strategic icons for counter intel aircraft.
  * Added Vanguard, the UEF T3 Decoy plane.
  * Removed the Wilson from the aircraft factory build lists.
  * Changed the build sorting for the Solace, Albatross and Zenith.
  * Added the Albatross and the uncreated seraphim equivalent to the string tables.
  * Changed the normal map of the Cybran Field engy.

  ### 2010-08-12

  * Added a temp texture and icon for the Albatross.

  ### 2010-08-13

  * Partially textured the Albatross properly.
  * Fixed the AA guns of the Albatross.
  * Fixed the script of the Seraphim T3 transport which was causing its weapons, and probably other things, to not work.
  * Changed the UV map of the Albatross.

  ### 2010-08-23

  * Further texture changes for the Albatross.
  * Removed unnecessary categories from the Vanguard.
  * Created the category PRODUCTBREWLAN, for external referencing.
  * Changed the threat level of the Decoy planes to be 1000x that of Spy planes.
  * Altered the balance of the Aeon Restorer again.

  ### 2010-09-08

  * Fixed the counter-intel fighter strategic icons, which had horrible artifacts on some states.
  * Fixed the Wilson not appearing in any build menus after the last 'fix' which I never checked properly after changing.
  * Fixed the Cybran T1 land factory being able to build the Megalith somehow after the last fix which never got individually uploaded.

  ### 2010-09-09

  * Slightly reduced the damage of the Restorers AA to accommodate for the fact that it has A-G weapons aw well as AA.
  * Changed the particle effects from the Pigeons main weapon.
  * Started creating and implementing the Aeon T2 Bomber.

  ### 2010-09-10

  * Did more work on the mesh, texture, and stats of the Aeon T2 Tactical Bomber, now called the Impaler, and added it to the string tables.

## 2010-05-27|0.3 beta

* Hid unfinished units for public beta release.

## 2010-02-16|0.2.9.1a

* Beta removals skipped out.
* Fixed the icon background of the UEF and Aeon T1 Shield gens, changed to 'amph'.

  ### 2010-02-17

  * Added adjacency buff table data for T2 energy storages.
  * Changed the buff value of the UEF T2 Energy storage to T2 from T1.
  * Removed the Iyadesu from the build lists; pending proper balancing. Yes, it is that broken.

  ### 2010-02-18

  * Properly hooked the changes to the Cybran ASF and Strat bomber.
  * Updated mod_info.lua to show the correct version.
  * Fixed the off center position of the Scathis MK II's cannon.
  * Changed the mesh, texture, firing pattern, and emitters of the Moldivite.
  * Removed the unused custom emitters for the UEF T1 Shield Gen.

  ### 2010-02-19

  * Finised the Aeon T3 Assault Tank.

  ### 2010-02-20

  * Re-rebalancing of the Restorer.

  ### 2010-02-21

  * Category table compatibility fixes for modded units.
    Effected units:
    * Aeon Quantum Optics Facility
    * Mavor
    * Paragon
    * Salvation
    * ED1, ED2, ED4 and ED5

  ### 2010-02-26

  * Added an early alpha of the T3 Seraphim point defense.
  * Added a damage test unit, spawn only.
  * Removed an unwanted line from the Aspis' blueprint.

  ### 2010-02-27

  * Icon file changes and moves.
  * SCD update for the SVN; SVN has been behind on that since the last beta.

  ### 2010-03-01

  * Preparation for translation.

  ### 2010-03-04

  * Re-textured the Moldovite.
  * Added additional nodes to the Moldovite's mesh.

  ### 2010-03-05

  * Localization data preparation.
  * Fixed a bug which was giving T1 energy storage the T2 buffs.

  ### 2010-03-09

  * Added the Seraphim T1 Gunship.
  * Fixed build cats of the Seraphim T3 PD.

  ### 2010-03-18

  * Added a lod1 mesh for the Moldovite.

  ### 2010-04-01

  * Added the 'AC-500 Centurion', UEF Experimental Gunship. Early alpha state; using a converted slightly modified mesh from the Creation Matrix Total Annihilation unit Core flying fortress: Centurion. Final version will use a new mesh.

  ### 2010-04-07

  * Gave the alpha-mesh of the Centurion a 'proper' texture so it doesn't look like complete arse.

  ### 2010-04-17

  * Changed the Centurions' scripts again.

  ### 2010-05-27

  * Finished the loc strings table, I think, now I just need to find someone to translate for me.
  * Fixed the Cirrus' name after the last update.
  * Added German compatibility.

## 2010-02-14|0.2.9b

* Static download changes:
  * Removed svn client data.
  * Removed the following unfinished units:
      * Iyadesu Seraphim Experimental Engineer.
      * Digger Cybran T3 Sniper Bot.
      * Doomsday Machine UEF Experimental Point Defense.
      * Unnamed UEF T2 Energy storage.
  * Changed the icon back to its default blue color.

## 2010-01-01|0.2.8 SVN

* Named the UEF T2 Mass Storage 'CJ-00F4T-2'.

  ### 2010-01-25

  * Added an alpha version of the Seraphim Experimental Engineer 'Iyadesu'.

  ### 2010-02-09

  * Added 'Hades' as an alpha unit; Cybran T3 Point Defense.

  ### 2010-02-11

  * Gave the Hades a temporary custom mesh, a build description and an icon.
  * Removed unchanged and unneeded files from the Hades folder.

## 2009-11-30|0.2.8 SVN

* Fixed the smoothing groups and replaced the icon of the UEF T2 Mass storage.
* Created a proper LOD1 mesh for the UEF Mass storage.
* Doubled the adjacency bonus for T2 mass storages; an effective improvement from T1 storages on only T2 fabs and extractors.
* Updated unit descriptions of T2 mass storages to align with the above.
* Created a custom tarmac for the UEF T2 mass storage, T3 missile defense and shield gens.
* Corrected the size of the UEF T3 heavy shield gens tarmac.
* Nerfed the T2 mass storages bonus on smaller buildings.
* Modified version number, icon, and notes for this version (SVN).

  ### 2009-12-12

  * Various changes to the Restorer:
    * Description changed to Heavy Gunship, from AA Gunship.
    * Strategic icon changed to direct fire gunship.
    * Health reduced to 5950, from 7200.
    * Cost and build time increased to E35000, M1680 and T8400 from E20000, M1200 and T4800.
    * Air to ground DPS increased to an approx. DPS of 300, from 160.
    * AA weaponry damage reduced to an approx. DPS of 30, from 130.
  * Increased the AA damage of the Broadsword 10 fold (to an approx. DPS of 30).
  * Increased the AA damage of the Wailer by approx. 66% (to an approx. DPS of 30).

  ### 2009-12-13

  * Rebalanced the Restorers weapons, its an AA Gunship again but not the same as before.
    * Air to ground DPS has been halved compared to the original
    * AA DPS has been increased to 250, giving it an overall DPS of 330, a number shared with all gunships.
  * Updated the unit statuses document.

  ### 2009-12-14

  * Changed the build description for T2 storages.
  * Mostly created the UEF T2 energy storage, the normals, smoothing groups and icon came out wrong. Adjacency bonus still needs doing.

## 2009-11-17|0.2.7a

* Fixed the spec map on the LOD1 mesh of the UEF proximity mine.

  ### 2009-11-19

  * Changed the script, blueprint and unit description of the UEF proximity mine.
  * Modified the unit description of the Seraphim T3 Gunship.

  ### 2009-11-21

  * Added the UEF mine icon to the SCD file.

## 2009-11-16|0.2.6a

* Removed unwanted poly's on the mesh of the Zenith.
* Finished the Zenith's texture, replaced its build icon, and increased its selection size.
* Re-added the additional build cat for the Field engie's unique build items.
* Partially fixed the UEF proximity mine. It doesn't die properly. Detonation status unknown.

## 2009-11-14|0.2.5a

* Created subfolders for the various things in the root folder.
* Created a proper LOD1 mesh for the Zenith.
* Further modified the mesh of the Zenith and finished most of the texture.
* Added the 'Ilshatha', Seraphim Heavy Asssault Bot.
* Increased the stats of the Seraphim siege tank to armored assault bot/tank levels.
* Changed the buildsort of walls, the Brick and siege tank.

  ### 2009-11-15

  * Changed the mesh of the Zenith again and finished texturing all but the body of the Zenith.

## 2009-11-11|0.2.4a

* Modified the mesh of the Zenith and textured the parts of it.
* Added a button to turn off the Zenith's stealth.

  ### 2009-11-12

  * Reduced the cost, build time and stats of the Harbinger Mark IV (division by 1.7 recurring) to coincide with the titan and the loyalist.

  ### 2009-11-13

  * Added proper Sorian AI unit support for the following:
    * T4 Cyrban & Aeon Arty
    * T3 Cybran & Aeon Transport
    * T3 Seraphim Transport & Gunship
    * T3 Cybran Torp bomber
    * T3 Aeon Tank
    * T1 Artillery installations
    * T1 Gunships

## 2009-11-09|0.2.3a

* Corrected several instances of '2008' in the dates in the change log. I'm living the past apparently.
* Added custom strategic icons for the landmines I attempted to add a while back.
* Cut down large amounts of unnecessary files for Seraphim unit textures/models.

  ### 2009-11-10

  * Cut down on the majority of the rest of the unnecessary files for unit textures/models. Halved the total size of the mod.
  * Added 'Zenith', Cybran T3 Torp bomber.

## 2009-11-04|0.2.2a

* Added the Seraphim T1 Air Staging.
* Fixed the Seraphim T3 Siege Tanks physics, previously it didn't bank on slopes.
* Fixed various issues with the Moldovite.

  ### 2009-11-05

  * Compatibility fix regarding the changes to the Salvation.
  * Changed the menu sort of all experimental buildings.
  * Replaced the Scathis.

  ### 2009-11-06

  * Compatibility fix regarding the changes to the Novax Centre.
  * Fixed the custom tarmacs issue.
  * Changed the Cybran T2 Mass Storage and Strat defense to use one of the new tarmacs.
  * Attempted to add Sorian AI capabilities.

## 2009-10-26|0.2.1a

* Reversed beta changes.
* Added the Aeon T3 Heavy Air Transport, 'Cirrus', and Assault Tank, 'Moldovite', as placeholders.

  ### 2009-09-27

  * Added the Aeon T1 Air Staging Facility, 'Pedestal'.
  * Added unit descriptions for the Cirrus, Moldovite, and Pedestal.

## 2009-10-03|0.2b

* Commented out build locations on unfinished units for public beta release.
  They can still be accessed for whatever reason in-game via the spawn menu.

## 2009-10-02|0.1.9a

* Made the Aeon Quantum Optics Facility drag buildable and reduced the footprint.
* Fixed the build menu location of the Cybran T3 Transport.
* Gave minute omni range to all T1 land scouts (range of 2) as an unlisted ability.
* Added 'Aspis', Aeon T1 Shield Generator.
* Unified the Wall Section build icon priorities to that of the Cybran Wall.
* Fixed the unitdescription.lua file hooking.
* Added build descriptions for all custom units and all modified units.
* Raised the vertical offset of the seraphim T1 Shields.
* Added a place holder Aeon T3 Air Transport.
* Raised the max health of Galactic Colossus by 1.
* Changed the UEF T1 Shields footprint plan.
* Started work on the Cybran Sniperbot.

## 2009-10-01|0.1.8a

* Fixed the UEF T1 Gunship; Engines now rotate, transport hooks T1 only.
* Fixed, finished, and rebalanced all factions T1 Light Artillery.
* Fixed the icon reference for the mod, broke on file rename.
* Changed back to a fixed filename, for the sake of not having to update URL's between versions.
* Created the Night Skimmer, Cybran T3 Heavy Air Transport.
* Halved the Omni range of the T3 Observation Satellite, formerly T4 Defense Satellite.
* Made Cybran T3 Aircraft auto stealth from creation.
* Created the Seraphim T1 Shield and made it upgradable.
* Fixed the glow position on the UEF T1 Shield.

## 2009-09-28|0.1.7a

* Changed name listings; removed 'balance' and added version from/to the name.
* Fixed the script for the UEF T2 Mass store for correct fill anims.
* Made an attempt at fixing the Emitter location on the UEF T1 Shield Gen; sort of worked.

## 2009-09-25|0.1.6a

* Added the UEF and Aeon T2 Mass Storages.
* Accidentally listed it as 0.1.3a instead of 0.1.6a in mod_info.

## 2009-09-19|0.1.5a

* Bilmon created the Seraphim and Cybran T1 Artillery, using the T2 meshes.
* Started translating Seraphim for the sake of naming conventions.

  ### 2009-09-20

  * Created a custom mesh and icon for the Cybran T1 Artillery.
  * Changed back the file structure changed in prior release.

  ### 2009-09-21

  * Added the Cybran T2 mass storage.

  ### 2009-09-23

  * Added the Seraphim T2 mass storage.

## 2009-09-04|0.1.4a

* Bilmon started contributing to the mod.
* Bilmon changed the pokers stats to be more inline with the other T1 units.
* Bilmon added the Charis Aeon Tech 1 Artillery using the Aeon T2 artillery mesh as a placeholder.
* Changed the modded FA units to a single modded .bp file.
* Added an icon and a custom mesh for the Charis.

  ### 2009-09-06

  * Re-added the files for the Salvation and the Defense Satellite; mods weren't working right.
  * Renamed the T3 Seraphim Gunship to the Vulthuum from Vulthuulth, thuum appearing to mean 'big' on other units.

  ### 2009-09-09

  * Attempted to add 'Wilson', the Cybran T2 Combat Engineer, using a modified Engineer mesh. Didn't appear in-game.

  ### 2009-09-14

  * Finally finished the mesh for the UEF Experimental Point Defense, 'Doomsday Machine', and got it mostly functioning in game.

  ### 2009-09-15

  * Started texturing the Doomsday Machine.

  ### 2009-09-16

  * Corrected the spelling of 'Experimental' on the Salvation and the still unfinished Doomsday Machine.

  ### 2009-09-17

  * Added the 'Vishuum', Seraphim T3 Heavy Air Transport.

  ### 2009-09-18

  * Failed at getting any new units to work.

  ### 2009-09-19

  * Changed the file structure of the mod.

## 2009-09-01|0.1.3a

* Changed the Pigeons unit code from BUA0105 to BEA0105 for correct categorization on the spawn menu.
* Fixed the firing and aiming for the Respirer.
* Added the Poker UEF Tech 1 Artillery.

  ### 2009-09-02

  * Fixed the firing script for the Poker
  * Added the LSD - Pulse, Aquatic Tech 1 Light Shield Generator for the UEF.
  * Modified the Novax Center to be a Tech 3 Observation Satellite Station and reduced its cost by around 10 times.
  * Replaced the Pigeons mesh from after I accidentally exported over it.
  * Made the Aeon Rapid Fire Artillery an experimental unit, only menu position effected.
  * Renamed the mod to the BrewLAN Balance Mod to accommodate for it now extending out of Tech 1.
  * Created the Vulthuulth, Tech 3 Seraphim Heavy Gunship

  ### 2009-09-03

  * Properly texture mapped the Vulthuulth, created custom textures and build icon, fixed AA gun.
  * Replaced mod icon.

## 2009-08-29|0.1.2a

* Created a custom mesh and texture for the Pidgeon.

  ### 2009-08-30

  * Renamed the Pidgeon to the Pigeon.

  ### 2009-08-31

  * Accidentally exported over the custom mesh for the Pigeon while creating one for the respirer.
  * Created a custom mesh for the Respirer.
  * Broke weapon systems of the Respirer whilst attempting to split the cannons.

## 2009-08-27|0.1.1a

* Created Changelog.
* Fixed the Pidgeons size, weapon animations and damage.
* Gave the Pidgeon its own icon, instead of sharing the T2 Gunship icon.
* Added the Respirer, Aeon Tech 1 Light Gunship to the game, a retextured resized Specter.

## 2009-08-26|0.1a

* Added the Pidgeon, UEF Tech 1 Light Gunship to the game.
