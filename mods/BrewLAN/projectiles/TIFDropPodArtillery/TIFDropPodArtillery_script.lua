local TArtilleryAntiMatterProjectile = import('/lua/terranprojectiles.lua').TArtilleryAntiMatterProjectile02
local utilities = import('/lua/utilities.lua')
local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath()
local GetTerrainAngles = import(BrewLANPath .. '/lua/TerrainUtils.lua').GetTerrainSlopeAnglesDegrees
TIFDropPodArtillery = Class(TArtilleryAntiMatterProjectile) {

    FxLandHitScale = 0.2,
    FxUnitHitScale = 0.2,
    FxSplatScale = 1,

    OnCreate = function(self, inWater)
        TArtilleryAntiMatterProjectile.OnCreate(self, inWater)
    end,

    OnImpact = function(self, TargetType, TargetEntity)
        TArtilleryAntiMatterProjectile.OnImpact(self, TargetType, TargetEntity)
        self:DropUnit(TargetType)
        LOG(TargetType)
    end,

    DropUnit = function(self, TargetType)
        local pos = self:GetPosition()
        if self.Data then
            self:DetachAll(1, true)
            Warp(self.Data,pos)-- This fixes a bunch of fucky stuff
            --Can't just call OnRemoveFromStorage on the unit 'cause this isn't a carrier, and we can't rely on the artillery to be alive to pass that as the second arg.
            self.Data:ShowBone(0,true)
            self.Data:SetCanTakeDamage(true)
            self.Data:SetReclaimable(true)
            self.Data:SetCapturable(true)
            self.Data:MarkWeaponsOnTransport(self.Data, false)
            self.Data:EnableIntel('Vision')

            local DropBP = self.Data:GetBlueprint()
            local DropLayer = self.Data:GetCurrentLayer()
            LOG(DropLayer)
            if TargetType == "Shield" then
                --Resets personal shields as an added downside
                if self.Data:ShieldIsOn() then
                    self.Data:DisableShield()
                end
                self.Data.FallenFromPod(self.Data, pos[2])
            elseif not
            (
                -- If we are on land                           and they say land                                             or the bitwise string is odd
                DropLayer == "Land" and (DropBP.Physics.BuildOnLayerCaps == "Land" or math.mod(tonumber(DropBP.Physics.BuildOnLayerCaps), 2) == 1)
                or --or if we are not on land              and the unit doesn't say land                                then it will survive anywhere else since the other options are all "in or on the water"
                DropLayer ~= "Land" and DropBP.Physics.BuildOnLayerCaps ~= "Land"
            )
            then
                self.Data:Kill()
            end
            if not self.Data.Dead then
                self.Data:EnableShield()
                self.Data:EnableDefaultToggleCaps()
            end
        else
            --we were never told what the thing was
            LOG("YOU GET NOTHING. GOOD DAY")
        end
        --LOG(GetTerrainType(pos[1],pos[3]) )
        CreateLightParticle(self, -1, self:GetArmy(), 10, 3, 'flare_lens_add_03', 'ramp_white_07' )
        if TargetType == 'Terrain' then
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
        end
        self.Data = nil
        self:Kill()
    end,
}

TypeClass = TIFDropPodArtillery
