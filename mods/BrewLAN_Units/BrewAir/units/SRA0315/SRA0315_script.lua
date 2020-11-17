local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local MissileFlare = import('/lua/defaultunits.lua').BaseDirectionalAntiMissileFlare
local CybranWeapons = import('/lua/cybranweapons.lua')
local CDFParticleCannonWeapon = CybranWeapons.CDFParticleCannonWeapon
local CDFHeavyMicrowaveLaserGeneratorCom = CybranWeapons.CDFHeavyMicrowaveLaserGeneratorCom

SRA0315 = Class(CAirUnit, MissileFlare) {

    Weapons = {
        MainLaser = Class(CDFHeavyMicrowaveLaserGeneratorCom) {},
        SmallLaser = Class(CDFParticleCannonWeapon) {},
    },

    FlareBones = {'Spike_001', 'Spike_002', 'Spike_003', 'Spike_004', 'Spike_005', 'Spike_006'},

    OnCreate = function(self)
        CAirUnit.OnCreate(self)
        for i, v in self.FlareBones do
            self:HideBone(v, false)
        end
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
        self:CreateMissileDetector()
		self:DisableUnitIntel('Cloak')
        self:RequestRefreshUI()
    end,

    DeployFlares = function(self)
        local ranB = math.random(1,table.getn(self.FlareBones))
        MissileFlare.DeployFlares(self, self.FlareBones[ranB])
        self:ForkThread(function()
            self:ShowBone(self.FlareBones[ranB], false)
            coroutine.yield(5)
            self:HideBone(self.FlareBones[ranB], false)
        end)
    end,

    OnLayerChange = function(self, new, old)
        CAirUnit.OnLayerChange(self, new, old)
        if new == 'Land' then
            self:EnableUnitIntel('Cloak')
        else
		    self:DisableUnitIntel('Cloak')
        end
    end,
}
TypeClass = SRA0315
