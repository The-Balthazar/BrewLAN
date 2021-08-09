--------------------------------------------------------------------------------
-- Inputs:

-- Note the following files within referenced mods must be valid Lua
-- /mod_info.lua
-- /hook/lua/ui/help/tooltips.lua'
-- /hook/lua/ui/help/unitdescription.lua
-- /hook/loc/US/strings_db.lua

-- The output directory for the files, expected to be a clone of a Github wiki repo, but not asserted such
WikiRepoDir = "C:/BrewLAN.wiki"

-- The input list of mod directories to create pages for
-- It will recusively search for bp files with the following criteria:
--  - The blueprints must be somewhere within '/units'
--    - This is to reduce the amount of time it spends directory searching, which is the slowest part
--  - The blueprint filenames must end in '_unit.bp'
--  - The blueprint filenames must not begin with 'z' or 'Z'
--  - The blueprint files MUST be valid lua. That means not using # for comment.
ListOfModDirectories = {
    'C:/BrewLAN/mods/BrewLAN',
    'C:/BrewLAN/mods/BrewLAN_Units/BrewAir',
    'C:/BrewLAN/mods/BrewLAN_Units/BrewIntel',
    'C:/BrewLAN/mods/BrewLAN_Units/BrewMonsters',
    'C:/BrewLAN/mods/BrewLAN_Units/BrewResearch',
    'C:/BrewLAN/mods/BrewLAN_Units/BrewShields',
    'C:/BrewLAN/mods/BrewLAN_Units/BrewTeaParty',
    'C:/BrewLAN/mods/BrewLAN_Units/BrewTurrets',
}

-- The location of the hard-coded wiki icons
-- This is used at the start of src values in img tags so it can be a web domain
-- However, it does assume the images it expects are right in there with the names it expects
IconRepo = "/The-Balthazar/BrewLAN/wiki/icons/"
ImageRepo = "/The-Balthazar/BrewLAN/wiki/images/"
-- The location of the unit icons for inclusion in the wiki
-- The files are expected to be [unit blueprintID]_icon.png
-- This doesn't have to be a sub-directory of the icon repo
unitIconRepo = IconRepo.."units/"

--------------------------------------------------------------------------------
