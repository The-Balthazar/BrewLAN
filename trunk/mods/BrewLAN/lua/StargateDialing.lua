--------------------------------------------------------------------------------
-- Summary  :  Stargate Dailing Script
--------------------------------------------------------------------------------    
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

# TODO: make sure each new instance is using a previous metatable
function StargateDialing(SuperClass)
    return Class(SuperClass) {
        OnCreate = function(self)
            SuperClass.OnCreate(self)
            self.DialingData = {}
            self.DialingData.DisableCounter = 0
            self.DialingData.IntelButton = true
        end,

        OnStopBeingBuilt = function(self,builder,layer)
            self.Sync.Abilities = self:GetBlueprint().Abilities
            self:SetMaintenanceConsumptionInactive()
            SuperClass.OnStopBeingBuilt(self,builder,layer)
        end,

        OnKilled = function(self, instigator, type, overkillRatio)
            SuperClass.OnKilled(self, instigator, type, overkillRatio)
            self:SetMaintenanceConsumptionInactive()
        end,
        
        DisableRemoteViewingButtons = function(self)
            self.Sync.Abilities = self:GetBlueprint().Abilities
            self.Sync.Abilities.TargetLocation.Active = false
            self:RemoveToggleCap('RULEUTC_IntelToggle')
        end,
        
        EnableRemoteViewingButtons = function(self)
            self.Sync.Abilities = self:GetBlueprint().Abilities
            self.Sync.Abilities.TargetLocation.Active = true
            self:AddToggleCap('RULEUTC_IntelToggle')
        end,
 
        OnTargetLocation = function(self, location)
            --Initial energy drain here - we drain resources instantly when an eye is relocated (including initial move)
            local aiBrain = self:GetAIBrain()
            local bp = self:GetBlueprint()
            local have = aiBrain:GetEconomyStored('ENERGY')
            local need = bp.Economy.DialingCostBase
            if not ( have > need ) then
                return
            end
            
            --Drain economy here
        
             
            self.DialingData.TargetGate = aiBrain:GetUnitsAroundPoint(categories.GATE, location, 10)
            if self.DialingData.TargetGate[1] != self then
                if self.DialingData.Beam then self.DialingData.Beam:Destroy() end
                self.DialingData.Beam = AttachBeamEntityToEntity(self, 'Center', self.DialingData.TargetGate[1], 'Center', self:GetArmy(), '/effects/emitters/microwave_laser_beam_02_emit.bp')
                LOG("THIS ISN'T ME")  
                aiBrain:TakeResource( 'ENERGY', bp.Economy.DialingCostBase )
                if not self.DialingData.ActiveWormhole then
                    self.DialingData.ActiveWormhole = self:ForkThread(
                        function()
                            while true do
                                local units = aiBrain:GetUnitsAroundPoint(categories.MOBILE - categories.AIR, self:GetPosition(), 4)
                                for i, v in units do
                                    Warp(v, self.DialingData.TargetGate[1]:GetPosition())
                                end
                                WaitTicks(3)
                            end
                        end
                    )
                end
            else
                LOG("THIS IS ME")
            end
        end,

        DisableResourceMonitor = function(self)
            WaitSeconds(0.5)
            local fraction = self:GetResourceConsumed()
            while fraction == 1 do
                WaitSeconds(0.5)
                fraction = self:GetResourceConsumed()
            end
            --if self.RemoteViewingData.IntelButton then
            --    self.RemoteViewingData.DisableCounter = self.RemoteViewingData.DisableCounter + 1
            --    self.RemoteViewingData.ResourceThread = self:ForkThread(self.EnableResourceMonitor)
            --    self:DisableVisibleEntity()
            --end
        end,

        EnableResourceMonitor = function(self)
            --local recharge = self:GetBlueprint().Intel.ReactivateTime or 10
            --WaitSeconds(recharge)
            --self.RemoteViewingData.DisableCounter = self.RemoteViewingData.DisableCounter - 1
            --self:CreateVisibleEntity()
        end,
    }    
end