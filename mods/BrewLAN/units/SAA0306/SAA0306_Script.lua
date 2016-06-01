#****************************************************************************
#**
#**  Author(s):  Sean Wheeldon
#**
#**  Summary  :  Aeon T3 Transport Script
#**
#****************************************************************************

local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local aWeapons = import('/lua/aeonweapons.lua')
local util = import('/lua/utilities.lua')
local AAATemporalFizzWeapon = aWeapons.AAATemporalFizzWeapon
local explosion = import('/lua/defaultexplosions.lua')

SAA0306 = Class(AAirUnit) {

    DestroyNoFallRandomChance = 1.1,

    ShieldEffects = {
		     '/effects/emitters/aeon_shield_generator_t3_03_emit.bp',
##	import( '/lua/game.lua' ).BrewLANPath() .. '/effects/emitters/aeon_shield_generator_mobile_air_01_emit.bp',	
    },

    AirDestructionEffectBones = { 'Outer1', 'Outer002', 'Outer003', 'Outer004', 'Outer005', 'Outer006',
				  'Outer007', 'Outer008', 'Outer009', 'Outer010', 'Outer011', 'Outer012',
				  'Torus001', 'Torus002', 'Torus003', 'Torus004', 'Torus005', 'Torus006',
				  'Torus007', 'Torus008', 'Torus009', 'Torus010', 'Torus011', 'Torus012',
                                  'Sphere', 'Shutter1', 'Shutter2', 'Shutter3', 'Shutter4', 'Shutter5', 'Shutter6',
				  'Disk1', 'Disk2', },

    Weapons = {
        AAFizz01 = Class(AAATemporalFizzWeapon) {},
        AAFizz02 = Class(AAATemporalFizzWeapon) {},
        AAFizz03 = Class(AAATemporalFizzWeapon) {},
        AAFizz04 = Class(AAATemporalFizzWeapon) {},
        AAFizz05 = Class(AAATemporalFizzWeapon) {},
        AAFizz06 = Class(AAATemporalFizzWeapon) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
	self.ShieldEffectsBag = {}
        self:HideBone('Shutter1', true)
        self:HideBone('Shutter2', true)
        self:HideBone('Shutter3', true)
        self:HideBone('Shutter4', true)
        self:HideBone('Shutter5', true)
        self:HideBone('Shutter6', true)
    end,

    OnShieldEnabled = function(self)
        AAirUnit.OnShieldEnabled(self)

            self.OrbManip1 = CreateRotator(self, 'Sphere', 'x', nil, 0, 45, -45)
            self.Trash:Add(self.OrbManip1)

        self.OrbManip1:SetTargetSpeed(-45)

            self.OrbManip2 = CreateRotator(self, 'Sphere', 'z', nil, 0, 45, 45)
            self.Trash:Add(self.OrbManip2)

        self.OrbManip2:SetTargetSpeed(45)

            self.DiskManip1 = CreateRotator(self, 'Disk1', 'x', nil, 0, 45, 45)
            self.Trash:Add(self.DiskManip1)

        self.DiskManip1:SetTargetSpeed(45)

            self.DiskManip2 = CreateRotator(self, 'Disk2', 'y', nil, 0, 90, 90)
            self.Trash:Add(self.DiskManip2)

        self.DiskManip2:SetTargetSpeed(90)

        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
	    self.ShieldEffectsBag = {}
	end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):ScaleEmitter(1):OffsetEmitter(0,-3,0) )
        end
    end,

    OnShieldDisabled = function(self)
        AAirUnit.OnShieldDisabled(self)

            self.OrbManip1:SetSpinDown(true)
            self.OrbManip1:SetTargetSpeed(0)


            self.OrbManip2:SetSpinDown(true)
            self.OrbManip2:SetTargetSpeed(0)


            self.DiskManip1:SetSpinDown(true)
            self.DiskManip1:SetTargetSpeed(0)


            self.DiskManip2:SetSpinDown(true)
            self.DiskManip2:SetTargetSpeed(0)

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

        self.detector = CreateCollisionDetector(self)
        self.Trash:Add(self.detector)
        self.detector:WatchBone('Attachpoint02')
        self.detector:WatchBone('Attachpoint008')
        self.detector:WatchBone('Attachpoint014')
        self.detector:WatchBone('Attachpoint020')
        self.detector:WatchBone('Attachpoint026')
        self.detector:WatchBone('Attachpoint032')
        self.detector:WatchBone('Attachpoint038')
        self.detector:WatchBone('Attachpoint044')
        self.detector:WatchBone('Attachpoint050')
        self.detector:WatchBone('Attachpoint056')
        self.detector:WatchBone('Attachpoint062')
        self.detector:WatchBone('Attachpoint068')
        self.detector:WatchBone('Attachpoint01')
        self.detector:WatchBone('Attachpoint012')
        self.detector:WatchBone('Attachpoint018')
        self.detector:WatchBone('Attachpoint024')
        self.detector:WatchBone('Attachpoint030')
        self.detector:WatchBone('Attachpoint036')
        self.detector:WatchBone('Attachpoint042')
        self.detector:WatchBone('Attachpoint058')
        self.detector:WatchBone('Attachpoint054')
        self.detector:WatchBone('Attachpoint060')
        self.detector:WatchBone('Attachpoint066')
        self.detector:WatchBone('Attachpoint072')
        self.detector:EnableTerrainCheck(true)
        self.detector:Enable()

        #self.OrbManip1:Destroy()
        #self.OrbManip1 = nil
        #self.OrbManip2:Destroy()
        #self.OrbManip2 = nil
        #self.DiskManip1:Destroy()
        #self.DiskManip1 = nil
        #self.DiskManip2:Destroy()
        #self.DiskManip2 = nil

        self:TransportDetachAllUnits(true)
    end,

    OnAnimTerrainCollision = function(self, bone,x,y,z)
        DamageArea(self, {x,y,z}, 5, 50, 'Default', true, false)
        explosion.CreateDefaultHitExplosionAtBone( self, bone, 1.0 )
        explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), {self:GetUnitSizes()})
    end,

    # Override air destruction effects so we can do something custom here
    #CreateUnitAirDestructionEffects = function( self, scale )
    #    self:ForkThread(self.AirDestructionEffectsThread, self )
    #end,

    #AirDestructionEffectsThread = function( self )
    #    local numExplosions = math.floor( table.getn( self.AirDestructionEffectBones ) * 0.5 )
    #    for i = 0, numExplosions do
    #        explosion.CreateDefaultHitExplosionAtBone( self, self.AirDestructionEffectBones[util.GetRandomInt( 1, numExplosions )], 0.5 )
    #        WaitSeconds( util.GetRandomFloat( 0.2, 0.9 ))
    #    end
    #end,
}

TypeClass = SAA0306
