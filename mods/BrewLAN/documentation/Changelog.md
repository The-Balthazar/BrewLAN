# BrewLAN changelog

All changes by Sean Wheeldon (Balthazar) unless otherwise stated.

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
