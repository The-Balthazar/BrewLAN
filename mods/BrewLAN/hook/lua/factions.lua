do
    if not import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/legacy/VersionCheck.lua').VersionIsSC() then --If not original Steam SupCom
        local BrewLANIconsDir = import( '/lua/game.lua' ).BrewLANPath() .. '/textures/ui/common/icons/units/'
        --------------------------------------------------------------------------------
        -- UEF
        --------------------------------------------------------------------------------
        Factions[1].IdleEngTextures.T1F = BrewLANIconsDir .. 'sel0119_icon.dds'
        --Factions[1].IdleEngTextures.T2F = '/icons/units/xel0209_icon.dds'
        Factions[1].IdleEngTextures.T3F = BrewLANIconsDir .. 'sel0319_icon.dds'
        Factions[1].BrewLAN = true -- referenced by BrewUI to check if it should do anything.
        --------------------------------------------------------------------------------
        -- The following are here for the sake of future UI mods that use these.
        --------------------------------------------------------------------------------
        Factions[1].IdleGantryTextures = {BrewLANIconsDir .. 'seb0401_icon.dds',}
        Factions[1].IdleFactoryTextures.GANTRY = {BrewLANIconsDir .. 'seb0401_icon.dds',}
        Factions[1].IdleEngTextures.FIELD = {
            BrewLANIconsDir .. 'sel0119_icon.dds',
            '/icons/units/xel0209_icon.dds',
            BrewLANIconsDir .. 'sel0319_icon.dds',
        }
        Factions[1].IdleEngTextures.LAND = {
            '/icons/units/uel0105_icon.dds',
            '/icons/units/uel0208_icon.dds',
            '/icons/units/uel0309_icon.dds',
        }
        --------------------------------------------------------------------------------
        --Aeon
        --------------------------------------------------------------------------------
        Factions[2].IdleEngTextures.T1F = BrewLANIconsDir .. 'sal0119_icon.dds'
        Factions[2].IdleEngTextures.T2F = BrewLANIconsDir .. 'sal0209_icon.dds'
        Factions[2].IdleEngTextures.T3F = BrewLANIconsDir .. 'sal0319_icon.dds'
        --------------------------------------------------------------------------------
        -- The following are here for the sake of future UI mods that use these.
        --------------------------------------------------------------------------------
        Factions[2].IdleGantryTextures = {BrewLANIconsDir .. 'sab0401_icon.dds',}
        Factions[2].IdleFactoryTextures.GANTRY = {BrewLANIconsDir .. 'sab0401_icon.dds',}
        Factions[2].IdleEngTextures.FIELD = {
            BrewLANIconsDir .. 'sal0119_icon.dds',
            BrewLANIconsDir .. 'sal0209_icon.dds',
            BrewLANIconsDir .. 'sal0319_icon.dds',
        }
        Factions[2].IdleEngTextures.LAND = {
            '/icons/units/ual0105_icon.dds',
            '/icons/units/ual0208_icon.dds',
            '/icons/units/ual0309_icon.dds',
        }
        --------------------------------------------------------------------------------
        --Cybran
        --------------------------------------------------------------------------------
        Factions[3].IdleEngTextures.T1F = BrewLANIconsDir .. 'srl0119_icon.dds'
        Factions[3].IdleEngTextures.T2F = BrewLANIconsDir .. 'srl0209_icon.dds'
        Factions[3].IdleEngTextures.T3F = BrewLANIconsDir .. 'srl0319_icon.dds'
        --------------------------------------------------------------------------------
        -- The following are here for the sake of future UI mods that use these.
        --------------------------------------------------------------------------------
        Factions[3].IdleEngTextures.FIELD = {
            BrewLANIconsDir .. 'srl0119_icon.dds',
            BrewLANIconsDir .. 'srl0209_icon.dds',
            BrewLANIconsDir .. 'srl0319_icon.dds',
        }
        Factions[3].IdleEngTextures.LAND = {
            '/icons/units/url0105_icon.dds',
            '/icons/units/url0208_icon.dds',
            '/icons/units/url0309_icon.dds',
        }
        --------------------------------------------------------------------------------
        --Seraphim
        --------------------------------------------------------------------------------
        Factions[4].IdleEngTextures.T1F = BrewLANIconsDir .. 'ssl0119_icon.dds'
        Factions[4].IdleEngTextures.T2F = BrewLANIconsDir .. 'ssl0219_icon.dds'
        Factions[4].IdleEngTextures.T3F = BrewLANIconsDir .. 'ssl0319_icon.dds'
        --------------------------------------------------------------------------------
        -- The following are here for the sake of future UI mods that use these.
        --------------------------------------------------------------------------------
        Factions[4].IdleEngTextures.FIELD = {
            BrewLANIconsDir .. 'ssl0119_icon.dds',
            BrewLANIconsDir .. 'ssl0219_icon.dds',
            BrewLANIconsDir .. 'ssl0319_icon.dds',
        }
        Factions[4].IdleEngTextures.LAND = {
            '/icons/units/xsl0105_icon.dds',
            '/icons/units/xsl0208_icon.dds',
            '/icons/units/xsl0309_icon.dds',
        }
    end
end
