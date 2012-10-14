#****************************************************************************
#**
#**  Author(s):  Sean Wheeldon
#**
#**  Summary  :  Aeon T3 Transport Script
#**
#****************************************************************************

local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')
local aWeapons = import('/lua/aeonweapons.lua')
local AAASonicPulseBatteryWeapon = aWeapons.AAASonicPulseBatteryWeapon

BAA0306 = Class(AAirUnit) {

    ShieldEffects = {
        '/effects/emitters/aeon_shield_generator_t2_01_emit.bp',
#        '/effects/emitters/aeon_shield_generator_t2_02_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_03_emit.bp',
        '/effects/emitters/aeon_shield_generator_t3_04_emit.bp',
    },

    AirDestructionEffectBones = { 'Outer1', 'Outer002', 'Outer003', 'Outer004', 'Outer005', 'Outer006',
				  'Outer007', 'Outer008', 'Outer009', 'Outer010', 'Outer011', 'Outer012',
				  'Torus001', 'Torus002', 'Torus003', 'Torus004', 'Torus005', 'Torus006',
				  'Torus007', 'Torus008', 'Torus009', 'Torus010', 'Torus011', 'Torus012',
                                  'Sphere', 'Shutter1', 'Shutter2', 'Shutter3', 'Shutter4', 'Shutter5', 'Shutter6',
				  'Disk1', 'Disk2', },

    Weapons = {
        SonicPulseBattery1 = Class(AAASonicPulseBatteryWeapon) {},
        SonicPulseBattery2 = Class(AAASonicPulseBatteryWeapon) {},
        SonicPulseBattery3 = Class(AAASonicPulseBatteryWeapon) {},
        SonicPulseBattery4 = Class(AAASonicPulseBatteryWeapon) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
	self.ShieldEffectsBag = {}
    end,

    OnShieldEnabled = function(self)
        AAirUnit.OnShieldEnabled(self)
        if not self.OrbManip1 then
            self.OrbManip1 = CreateRotator(self, 'Sphere', 'x', nil, 0, 45, -45)
            self.Trash:Add(self.OrbManip1)
        end
        self.OrbManip1:SetTargetSpeed(-45)
        if not self.OrbManip2 then
            self.OrbManip2 = CreateRotator(self, 'Sphere', 'z', nil, 0, 45, 45)
            self.Trash:Add(self.OrbManip2)
        end
        self.OrbManip2:SetTargetSpeed(45)

        if not self.DiskManip1 then
            self.DiskManip1 = CreateRotator(self, 'Disk1', 'x', nil, 0, 45, 45)
            self.Trash:Add(self.DiskManip1)
        end
        self.DiskManip1:SetTargetSpeed(45)

        if not self.DiskManip2 then
            self.DiskManip2 = CreateRotator(self, 'Disk2', 'y', nil, 0, 45, 45)
            self.Trash:Add(self.DiskManip2)
        end
        self.DiskManip2:SetTargetSpeed(45)

        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
	    self.ShieldEffectsBag = {}
	end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):ScaleEmitter(0.46) )
        end
    end,

    OnShieldDisabled = function(self)
        AAirUnit.OnShieldDisabled(self)
        if self.OrbManip1 then
            self.OrbManip1:SetSpinDown(true)
            self.OrbManip1:SetTargetSpeed(0)
        end
        if self.OrbManip2 then
            self.OrbManip2:SetSpinDown(true)
            self.OrbManip2:SetTargetSpeed(0)
        end
        if self.DiskManip1 then
            self.DiskManip1:SetSpinDown(true)
            self.DiskManip1:SetTargetSpeed(0)
        end
        if self.DiskManip2 then
            self.DiskManip2:SetSpinDown(true)
            self.DiskManip2:SetTargetSpeed(0)
        end
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
	    self.ShieldEffectsBag = {}
	end
    end,

    # When one of our attached units gets killed, detach it
    OnAttachedKilled = function(self, attached)
        attached:DetachFrom()
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        AAirUnit.OnKilled(self, instigator, type, overkillRatio)
        if self.OrbManip1 then
            self.OrbManip1:Destroy()
            self.OrbManip1 = nil
        end
        if self.OrbManip2 then
            self.OrbManip2:Destroy()
            self.OrbManip2 = nil
        end
        if self.DiskManip1 then
            self.DiskManip1:Destroy()
            self.DiskManip1 = nil
        end
        if self.DiskManip2 then
            self.DiskManip2:Destroy()
            self.DiskManip2 = nil
        end
        self:TransportDetachAllUnits(true)
    end,

    # Override air destruction effects so we can do something custom here
    CreateUnitAirDestructionEffects = function( self, scale )
        self:ForkThread(self.AirDestructionEffectsThread, self )
    end,

    AirDestructionEffectsThread = function( self )
        local numExplosions = math.floor( table.getn( self.AirDestructionEffectBones ) * 0.5 )
        for i = 0, numExplosions do
            explosion.CreateDefaultHitExplosionAtBone( self, self.AirDestructionEffectBones[util.GetRandomInt( 1, numExplosions )], 0.5 )
            WaitSeconds( util.GetRandomFloat( 0.2, 0.9 ))
        end
    end,
}

TypeClass = BAA0306