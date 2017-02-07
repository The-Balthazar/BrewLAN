--UEF
local BrewLANIconsDir = import( '/lua/game.lua' ).BrewLANPath() .. '/textures/ui/common/icons/units/'

Factions[1].IdleEngTextures.T1F = BrewLANIconsDir .. 'sel0119_icon.dds'
--Factions[1].IdleEngTextures.T2F = '/icons/units/xel0209_icon.dds'
Factions[1].IdleEngTextures.T3F = BrewLANIconsDir .. 'sel0319_icon.dds'
Factions[1].BrewLAN = true -- referenced by BrewUI to check if it should do anything.
Factions[1].IdleGantryTextures = {
	'seb0401_icon.dds',
}
Factions[1].IdleFactoryTextures.GANTRY = {
	BrewLANIconsDir .. 'seb0401_icon.dds',
}
Factions[1].IdleEngTextures.FIELD = {
	BrewLANIconsDir .. 'sel0119_icon.dds',
	BrewLANIconsDir .. 'xel0209_icon.dds',
	BrewLANIconsDir .. 'sel0319_icon.dds',
}
Factions[1].IdleEngTextures.LAND = {
	BrewLANIconsDir .. 'uel0105_icon.dds',
	BrewLANIconsDir .. 'uel0208_icon.dds',
	BrewLANIconsDir .. 'uel0309_icon.dds',
}



--Aeon



Factions[2].IdleEngTextures.T1F = BrewLANIconsDir .. 'sal0119_icon.dds'
Factions[2].IdleEngTextures.T2F = BrewLANIconsDir .. 'sal0209_icon.dds'
Factions[2].IdleEngTextures.T3F = BrewLANIconsDir .. 'sal0319_icon.dds'

Factions[2].IdleEngTextures.FIELD = {
	BrewLANIconsDir .. 'sal0119_icon.dds',
	BrewLANIconsDir .. 'sal0209_icon.dds',
	BrewLANIconsDir .. 'sal0319_icon.dds',
}
Factions[2].IdleEngTextures.LAND = {
	BrewLANIconsDir .. 'ual0105_icon.dds',
	BrewLANIconsDir .. 'ual0208_icon.dds',
	BrewLANIconsDir .. 'ual0309_icon.dds',
}


--Cybran



Factions[3].IdleEngTextures.T1F = BrewLANIconsDir .. 'srl0119_icon.dds'
Factions[3].IdleEngTextures.T2F = BrewLANIconsDir .. 'srl0209_icon.dds'
Factions[3].IdleEngTextures.T3F = BrewLANIconsDir .. 'srl0319_icon.dds'

Factions[3].IdleEngTextures.FIELD = {
	BrewLANIconsDir .. 'srl0119_icon.dds',
	BrewLANIconsDir .. 'srl0209_icon.dds',
	BrewLANIconsDir .. 'srl0319_icon.dds',
}
Factions[3].IdleEngTextures.LAND = {
	BrewLANIconsDir .. 'url0105_icon.dds',
	BrewLANIconsDir .. 'url0208_icon.dds',
	BrewLANIconsDir .. 'url0309_icon.dds',
}


--Seraphim



Factions[4].IdleEngTextures.T1F = BrewLANIconsDir .. 'ssl0119_icon.dds'
Factions[4].IdleEngTextures.T2F = BrewLANIconsDir .. 'ssl0219_icon.dds'
Factions[4].IdleEngTextures.T3F = BrewLANIconsDir .. 'ssl0319_icon.dds'

Factions[4].IdleEngTextures.FIELD = {
	BrewLANIconsDir .. 'ssl0119_icon.dds',
	BrewLANIconsDir .. 'ssl0219_icon.dds',
	BrewLANIconsDir .. 'ssl0319_icon.dds',
}
Factions[4].IdleEngTextures.LAND = {
	BrewLANIconsDir .. 'xsl0105_icon.dds',
	BrewLANIconsDir .. 'xsl0208_icon.dds',
	BrewLANIconsDir .. 'xsl0309_icon.dds',
}
