#****************************************************************************
#**
#**  File     :  /data/units/XSL0401/XSL0401_script.lua
#**  Author(s):  Jessica St. Croix, Dru Staltman, Aaron Lundquist
#**
#**  Summary  :  Seraphim Experimental Assault Bot
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local SDFSinnuntheWeapon = import('/lua/seraphimweapons.lua').SDFSinnuntheWeapon
local utilities = import('/lua/utilities.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local explosion = import('/lua/defaultexplosions.lua')

SSB2311 = Class(SStructureUnit) {

    SpawnEffects = {
		'/effects/emitters/seraphim_othuy_spawn_01_emit.bp',
		'/effects/emitters/seraphim_othuy_spawn_02_emit.bp',
		'/effects/emitters/seraphim_othuy_spawn_03_emit.bp',
		'/effects/emitters/seraphim_othuy_spawn_04_emit.bp',
	},
	
    Weapons = {
        RightArm = Class(SDFSinnuntheWeapon)
        {
            PlayFxMuzzleChargeSequence = function(self, muzzle)
                #CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
                if not self.ClawTopRotator then 
                    self.ClawTopRotator = CreateRotator(self.unit, 'Top_Claw', 'x')
                    self.ClawBottomRotator = CreateRotator(self.unit, 'Bottom_Claw', 'x')
                    
                    self.unit.Trash:Add(self.ClawTopRotator)
                    self.unit.Trash:Add(self.ClawBottomRotator)
                end
                
                self.ClawTopRotator:SetGoal(-45):SetSpeed(10)
                self.ClawBottomRotator:SetGoal(45):SetSpeed(10)
                
                SDFSinnuntheWeapon.PlayFxMuzzleChargeSequence(self, muzzle)
                
                self:ForkThread(function()
                    WaitSeconds(self.unit:GetBlueprint().Weapon[1].MuzzleChargeDelay)
                    
                    self.ClawTopRotator:SetGoal(0):SetSpeed(50)
                    self.ClawBottomRotator:SetGoal(0):SetSpeed(50)
                end)
            end,
        },
    }, 
}
TypeClass = SSB2311
