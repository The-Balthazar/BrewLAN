local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local CAAMissileNaniteWeapon = import('/lua/cybranweapons.lua').CAAMissileNaniteWeapon
local CIFMissileCorsairWeapon = import('/lua/cybranweapons.lua').CIFMissileCorsairWeapon

SRA0402 = Class(CAirUnit) {
    Weapons = {
        AntiAirMissiles = Class(CAAMissileNaniteWeapon) {},
        GroundMissile = Class(CIFMissileCorsairWeapon) {

            IdleState = State (CIFMissileCorsairWeapon.IdleState) {
                Main = function(self)
                    CIFMissileCorsairWeapon.IdleState.Main(self)
                end,

                OnGotTarget = function(self)
                    self.unit:SetBreakOffTriggerMult(2.0)
                    self.unit:SetBreakOffDistanceMult(8.0)
                    self.unit:SetSpeedMult(0.67)
                    CIFMissileCorsairWeapon.IdleState.OnGotTarget(self)
                end,
            },

            OnGotTarget = function(self)
                self.unit:SetBreakOffTriggerMult(2.0)
                self.unit:SetBreakOffDistanceMult(8.0)
                self.unit:SetSpeedMult(0.67)
                CIFMissileCorsairWeapon.OnGotTarget(self)
            end,

            OnLostTarget = function(self)
                self.unit:SetBreakOffTriggerMult(1.0)
                self.unit:SetBreakOffDistanceMult(1.0)
                self.unit:SetSpeedMult(1.0)
                CIFMissileCorsairWeapon.OnLostTarget(self)
            end,
        },
    },

    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionInactive()
        self:SetScriptBit('RULEUTC_StealthToggle', true)
        self:RequestRefreshUI()
    end,
--[[

    SetParent = function(self, parent, podName)
        self.Parent = parent
        self.PodName = podName
        self:ForkThread(self.StayCloseThread)
        LOG("PodParent")
    end,

    StayCloseThread = function(self)
        LOG("stayclosethread")
        local myPos, pPos
        WaitTicks(3)
        self:RemoveBuildRestriction(categories[self.Parent.Pods[self.PodName].StorageID])
        self:RequestRefreshUI()
        while self do
            WaitSeconds(3)
            myPos = self:GetPosition()
            pPos = self.Parent:GetPosition()
            if not self.Parent:IsDead() and VDist2Sq(myPos[1], myPos[3], pPos[1], pPos[3]) > 900 then
                IssueClearCommands({self})
                IssueMove({self},pPos)
            end
        end
    end,


    OnKilled = function(self, instigator, type, overkillRatio)
        if self.Parent and not self.Parent:IsDead() then
            self.Parent:NotifyOfPodDeath(self.PodName)
            self.Parent = nil
        end
        CAirUnit.OnKilled(self, instigator, type, overkillRatio)
    end,]]
}

TypeClass = SRA0402
