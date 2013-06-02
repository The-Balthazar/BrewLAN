#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2302/UEB2302_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Long Range Artillery Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local TIFArtilleryWeapon = import('/lua/terranweapons.lua').TIFArtilleryWeapon

SEB2404 = Class(TStructureUnit) {
    Weapons = {
        MainGun = Class(TIFArtilleryWeapon) {
            FxMuzzleFlashScale = 3,
            
            #IdleState = State(TIFArtilleryWeapon.IdleState) {
            #    OnGotTarget = function(self)
            #        TIFArtilleryWeapon.IdleState.OnGotTarget(self)
            #        if not self.ArtyAnim then
            #            self.ArtyAnim = CreateAnimator(self.unit)
            #            self.ArtyAnim:PlayAnim(self.unit:GetBlueprint().Display.AnimationOpen)
            #            self.unit.Trash:Add(self.ArtyAnim)
            #        end
            #    end,
            #},
        },
        MongooseGun = Class(TIFArtilleryWeapon) {
            FxMuzzleFlashScale = 3,
        },
        TitanGun = Class(TIFArtilleryWeapon) {
            FxMuzzleFlashScale = 3,
        },
        PercivalGun = Class(TIFArtilleryWeapon) {
            FxMuzzleFlashScale = 3,
        },
    },
    OnCreate = function(self)
        TStructureUnit.OnCreate(self)
        self:SetWeaponEnabledByLabel('MongooseGun', false)
        self:SetWeaponEnabledByLabel('TitanGun', false)
        self:SetWeaponEnabledByLabel('PercivalGun', false)
	self.FiringMode = 1
    end,

    OnScriptBitSet = function(self, bit)
        TStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
	    self.FiringMode = self.FiringMode + 1
            self.ToggleWeapons(self)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
	    self.FiringMode = self.FiringMode + 1
            self.ToggleWeapons(self)
        end
    end,

    ToggleWeapons = function(self)

        if self.FiringMode == 2 then
            self:SetWeaponEnabledByLabel('MongooseGun', true)
            self:SetWeaponEnabledByLabel('MainGun', false)
            #self:GetWeaponManipulatorByLabel('MongooseGun'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('MainGun'):GetHeadingPitch() )
            FloatingEntityText(self:GetEntityId(),'<LOC del0204_desc>')

        elseif self.FiringMode == 3 then
            self:SetWeaponEnabledByLabel('TitanGun', true)
            self:SetWeaponEnabledByLabel('MongooseGun', false)
            #self:GetWeaponManipulatorByLabel('TitanGun'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('MongooseGun'):GetHeadingPitch() )
            FloatingEntityText(self:GetEntityId(),'<LOC uel0303_desc>')

        elseif self.FiringMode == 4 then
            self:SetWeaponEnabledByLabel('PercivalGun', true)
            self:SetWeaponEnabledByLabel('TitanGun', false)
            #self:GetWeaponManipulatorByLabel('PercivalGun'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('TitanGun'):GetHeadingPitch() )
            FloatingEntityText(self:GetEntityId(),'<LOC xel0305_desc>')

        elseif self.FiringMode >= 5 then
	    self.FiringMode = 1
            self:SetWeaponEnabledByLabel('MainGun', true)
            self:SetWeaponEnabledByLabel('PercivalGun', false)
            #self:GetWeaponManipulatorByLabel('MainGun'):SetHeadingPitch( self:GetWeaponManipulatorByLabel('PercivalGun'):GetHeadingPitch() )
            FloatingEntityText(self:GetEntityId(),'<LOC uel0106_desc>')

        end
    end,

}

TypeClass = SEB2404