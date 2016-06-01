#****************************************************************************
#**
#**  File     :  /cdimage/units/URB1105/URB1105_script.lua
#**  Author(s):  David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Energy Storage
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CEnergyStorageUnit= import('/lua/cybranunits.lua').CEnergyStorageUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')

SRB1205 = Class(CEnergyStorageUnit) {
    DestructionPartsChassisToss = {'URB1105'},

    OnStopBeingBuilt = function(self,builder,layer)
        CEnergyStorageUnit.OnStopBeingBuilt(self,builder,layer)
        self:ForkThread(self.AnimThread)
    end,

    AnimThread = function(self)
        # Play the "activate" sound
        local myBlueprint = self:GetBlueprint()
        if myBlueprint.Audio.Activate then
            self:PlaySound(myBlueprint.Audio.Activate)
        end

        local sliderManip = CreateStorageManip(self, 'Lift', 'ENERGY', 0, 0, 0, 0, .8, 0)
    end,

    Weapons = {
        DeathWeapon0 = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.ExplosionEffectsSml01,
        },
        DeathWeapon1 = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.ExplosionEffectsSml01,
        },
        DeathWeapon2 = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.ExplosionEffectsMed01,
        },
        DeathWeapon3 = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.ExplosionEffectsMed01,
        },
        DeathWeapon4 = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.ExplosionEffectsLrg01,
        },
        DeathWeapon5 = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.ExplosionEffectsLrg01,
        },
        DeathWeapon6 = Class(CMobileKamikazeBombWeapon) {      
   			FxDeath = EffectTemplate.ExplosionEffectsLrg02,
        },
    },

    OnKilled = function(self, instigator, type, overkillRatio)


                local bp = self:GetBlueprint()
                local aiBrain = GetArmyBrain(self:GetArmy())
                local curEnergy = aiBrain:GetEconomyStoredRatio('ENERGY')

                if self:IsBeingBuilt() then 
                else
                    if curEnergy < 0.2 then
                        self:GetWeaponByLabel('DeathWeapon0'):FireWeapon()
                        #LOG('Weapon0')
                    elseif curEnergy < 0.4 then
                        self:GetWeaponByLabel('DeathWeapon1'):FireWeapon()
                        #LOG('Weapon1')
                    elseif curEnergy < 0.6 then
                        self:GetWeaponByLabel('DeathWeapon2'):FireWeapon()
                        #LOG('Weapon2')
                    elseif curEnergy < 0.8 then
                        self:GetWeaponByLabel('DeathWeapon3'):FireWeapon()
                        #LOG('Weapon3')
                    elseif curEnergy < 0.9 then
                        self:GetWeaponByLabel('DeathWeapon4'):FireWeapon()
                        #LOG('Weapon4')
                    elseif curEnergy <= 1.0 then
                        self:GetWeaponByLabel('DeathWeapon5'):FireWeapon()
                        #LOG('Weapon5')
                    end
                end

        CEnergyStorageUnit.OnKilled(self)
    end,
}

TypeClass = SRB1205
