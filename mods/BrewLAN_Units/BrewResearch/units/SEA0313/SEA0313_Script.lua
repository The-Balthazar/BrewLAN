--------------------------------------------------------------------------------
local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local MissileFlare = import('/lua/defaultunits.lua').BaseDirectionalAntiMissileFlare
--------------------------------------------------------------------------------
local TIFCruiseMissileLauncher = import('/lua/terranweapons.lua').TIFCruiseMissileLauncher
--------------------------------------------------------------------------------
local SCCollisionBeam = import('/lua/defaultcollisionbeams.lua').SCCollisionBeam
local DefaultBeamWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultBeamWeapon
local ePath = string.gsub(__blueprints.sea0313.Source, 'units/sea0313/sea0313_unit.bp', 'effects/emitters/tomcat_particle_cannon_')
--------------------------------------------------------------------------------
SEA0313 = Class(TAirUnit, MissileFlare) {
    Weapons = {
        ParticleCannon = Class(DefaultBeamWeapon) {
            BeamType = Class(SCCollisionBeam) {
                FxBeam         = {ePath .. 'beam_01_emit.bp', ePath .. 'beam_02_emit.bp'},
                FxBeamEndPoint = {ePath .. 'end_01_emit.bp',  ePath .. 'end_02_emit.bp'},
                FxBeamEndPointScale = 1,
            },
            FxMuzzleFlash = {ePath .. 'muzzle_01_emit.bp'},
        },
        Missile = Class(TIFCruiseMissileLauncher) {},
    },

    FlareBones = {'Flare'},

    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
        self.WingRotors = {
            CreateRotator(self, 'Wing_001', 'z'),
            CreateRotator(self, 'Wing_002', 'z'),
        }
        self:RotateSet(self.WingRotors, -42.5)
        self:SetMaintenanceConsumptionInactive()
        self:SetScriptBit('RULEUTC_StealthToggle', true)
        self:CreateMissileDetector()
		self:DisableUnitIntel('Cloak')
        self:RequestRefreshUI()
    end,

    RotateSet = function(self, rotors, angle)
        if not rotors then return false end
        for i, rotor in rotors do
            rotor:SetGoal(angle)
            rotor:SetSpeed(45)
        end
    end,

    OnMotionHorzEventChange = function(self, new, old)
        TAirUnit.OnMotionHorzEventChange(self, new, old)
        if new == 'TopSpeed' then
            self:RotateSet(self.WingRotors, 0)
        else
            self:RotateSet(self.WingRotors, -42.5)
        end
    end,

    OnLayerChange = function(self, new, old)
        TAirUnit.OnLayerChange(self, new, old)
        if new == 'Land' then
            self:EnableUnitIntel('Cloak')
        else
		    self:DisableUnitIntel('Cloak')
        end
    end,
}

TypeClass = SEA0313
