local TArtilleryAntiMatterProjectile = import('/lua/terranprojectiles.lua').TArtilleryAntiMatterProjectile02
local utilities = import('/lua/utilities.lua')
local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath()
local GetTerrainAngles = import(BrewLANPath .. '/lua/TerrainUtils.lua').GetTerrainSlopeAnglesDegrees
TIFDropPodArtilleryMechMarine = Class(TArtilleryAntiMatterProjectile) {

    FxLandHitScale = 0.2,
    FxUnitHitScale = 0.2,
    FxSplatScale = 1,

    OnCreate = function(self, inWater)
        TArtilleryAntiMatterProjectile.OnCreate(self, inWater)
    end,

    OnImpact = function(self, TargetType, TargetEntity)
        if TargetType == 'Shield' then
            TArtilleryAntiMatterProjectile.OnImpact(self, TargetType, TargetEntity)
            if self.Data then
                DamageArea(self, self:GetPosition(), self.DamageData.DamageRadius, __blueprints[self.Data[1]].Economy.BuildCostMass * (self.Data[2] or 1) , 'Normal', self.DamageData.DamageFriendly)
            end
        else
            TArtilleryAntiMatterProjectile.OnImpact(self, TargetType, TargetEntity)
            self:DropUnit()
        end
    end,

    DropUnit = function(self)
        local pos = self:GetPosition()
        if self.Data then
            self:DetachAll(1, true)
            Warp(self.Data,pos)-- sometimes they get stuck in the air and this confuses them
            self.Data:ShowBone(0,true)
            local DropBP = self.Data:GetBlueprint()
            local DropLayer = self.Data:GetCurrentLayer()
            if not
            (
                -- If we are on land                           and they say land                                             or the bitwise string is odd
                DropLayer == "Land" and (DropBP.Physics.BuildOnLayerCaps == "Land" or math.mod(tonumber(DropBP.Physics.BuildOnLayerCaps), 2) == 1)
                or --or if we are not on land              and the unit doesn't say land                                then it will survive anywhere else since the other options are all "in or on the water"
                DropLayer ~= "Land" and DropBP.Physics.BuildOnLayerCaps ~= "Land"
            )
            then
                self.Data:Kill()
            end
        else
            --we were never told what the thing was
            LOG("YOU GET NOTHING. GOOD DAY")
        end
        --LOG(GetTerrainType(pos[1],pos[3]) )
        CreateLightParticle(self, -1, self:GetArmy(), 10, 3, 'flare_lens_add_03', 'ramp_white_07' )
        local Angles = GetTerrainAngles(pos, 3)
        local rotation = 0
        if Angles[1] == 0 and Angles[2] == 0 then
            rotation = math.random(1,360)
        end
        CreatePropHPR(
            BrewLANPath .. '/env/uef/props/UEF_Ivan_Droppod_Remains_prop.bp',
            pos[1], GetTerrainHeight(pos[1],pos[3]), pos[3],
            rotation, Angles[2], -Angles[1]
        )
        self.Data = nil
        self:Kill()
    end,
}

TypeClass = TIFDropPodArtilleryMechMarine
