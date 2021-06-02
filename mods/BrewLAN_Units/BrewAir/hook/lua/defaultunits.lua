--------------------------------------------------------------------------------
-- Scripts for directional anti-AA-missile flares for aircraft
--------------------------------------------------------------------------------
local AntiWeapons = import('/lua/defaultantiprojectile.lua')
local AAFlare = AntiWeapons.AAFlare
local MissileDetector = AntiWeapons.MissileDetector
--------------------------------------------------------------------------------
local MissileDetectorRadius = {}
--------------------------------------------------------------------------------
BaseDirectionalAntiMissileFlare = Class() {
    CreateMissileDetector = function(self)
        local bp = self.BpId and __blueprints[self.BpId] or self:GetBlueprint()
        local MDbp = bp.Defense.MissileDetector

        if not MissileDetectorRadius[bp.BlueprintId] and MDbp then
            LOG("Calculating missile detector radius for " .. bp.BlueprintId)
            MissileDetectorRadius[bp.BlueprintId] = math.sqrt(math.pow(VDist3(self:GetPosition(),self:GetPosition(MDbp.AttachBone)),2) + math.pow(bp.SizeSphere, 2))
        elseif not MissileDetectorRadius and not MDbp then
            MissileDetectorRadius[bp.BlueprintId] = 3
            WARN("Missile Detector data not set up correctly.")
        end

        self.Trash:Add(MissileDetector {
            Owner = self,
            Radius = MissileDetectorRadius[bp.BlueprintId],
            AttachBone = MDbp.AttachBone,
        })
    end,

    DeployFlares = function(self, bone)
        AAFlare {
            Owner = self,
            Radius = 3,
            AttachBone = bone or self.FlareBones[math.random(1,table.getn(self.FlareBones))] or 0,
        }
    end,
}
