--------------------------------------------------------------------------------
-- Summary  :  Stargate Dialing Script
-- Author   :  Balthazar
--------------------------------------------------------------------------------    
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

function StargateDialing(SuperClass)
    return Class(SuperClass) {
        OnCreate = function(self)
            SuperClass.OnCreate(self)
            self.DialingData = {}
            --self.DialingData.DisableCounter = 0
            self.DialingData.IntelButton = true
            self.DialingData.ActiveWormhole = false
            self.DialingData.IncomingWormhole = false  
            self.DialingData.Iris = false
            self:HideBone('Event_Horizon', true)  
        end,
            
        OnShieldEnabled = function(self)
            SuperClass.OnShieldEnabled(self)
            self.DialingData.Iris = true
        end,
       
        OnShieldDisabled = function(self)
            SuperClass.OnShieldDisabled(self)
            self.DialingData.Iris = false
        end,
        
        OnStopBeingBuilt = function(self,builder,layer)
            self.Sync.Abilities = self:GetBlueprint().Abilities
            self:SetMaintenanceConsumptionInactive()
            SuperClass.OnStopBeingBuilt(self,builder,layer)           
            self.DialingData.WormholeThread = self:ForkThread(
                function()
                    while true do
                        if self.DialingData.TargetGate
                        and self.DialingData.ActiveWormhole
                        and not self.DialingData.IncomingWormhole
                        and not self.DialingData.Iris
                        then
                            if not self.DialingData.TargetGate:IsDead() then
                                local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE - categories.AIR, self:GetPosition(), 4)
                                for i, v in units do
                                    Warp(v, self.DialingData.TargetGate:GetPosition())
                                    if self.DialingData.TargetGate.DialingData.Iris then
                                        local damage = (v:GetBlueprint().Economy.BuildCostMass + (v:GetBlueprint().Economy.BuildCostEnergy / 20) / 2 ) * v:GetHealthPercent()
                                        local irishealth = self.DialingData.TargetGate.MyShield:GetHealth()
                                        
                                        if irishealth > damage then
                                            v:Destroy()
                                        else
                                            v:SetHealth(v, v:GetHealth() * (1 - (irishealth / damage)))
                                        end
                                        self.DialingData.TargetGate:CreateIrisImpactEffect(self.DialingData.TargetGate)
                                        self.DialingData.TargetGate.MyShield:OnDamage(v,damage, {x=0,y=0,z=0}, 'normal')
                                        
                                    end
                                end
                            elseif self.DialingData.TargetGate:IsDead() then
                                self:WormholeFunctionToggle()
                            end
                            WaitTicks(3)
                        else
                            WaitTicks(12)
                        end
                    end
                end
            )
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
            local aiBrain = self:GetAIBrain()
            local bp = self:GetBlueprint()
            local have = aiBrain:GetEconomyStored('ENERGY')
            local need = bp.Economy.DialingCostBase
            if not ( have > need ) or self.DialingData.IncomingWormhole then
                return
            end
            local targetarea = aiBrain:GetUnitsAroundPoint(categories.STARGATE, location, 10)
            if targetarea[1] then      
                if targetarea[1] != self                                            --Check not trying to dial self
                and targetarea[1] != self.DialingData.TargetGate                    --Check not redialing the same gate
                and targetarea[1].DialingData.WormholeThread                        --Check the target is built and ready
                and not targetarea[1].DialingData.ActiveWormhole                    --Check the target isn't already dialing out
                and not targetarea[1].DialingData.IncomingWormhole                  --Check the target isn't already being dialed into
                then
                    if self.DialingData.TargetGate then
                        self:WormholeFunctionToggle()
                    end
                    self:WormholeFunctionToggle(targetarea[1], true)
                    aiBrain:TakeResource( 'ENERGY', bp.Economy.DialingCostBase )  
                    LOG("CHEVRON 7 LOCKED")
                else
                    LOG("CHEVRON 7 ... WONT ENGAGE")
                end
            end
        end,
        
        WormholeFunctionToggle = function(self, targetgate, wormhole)
            LOG("WORMJOLE:", wormhole)
            if not targetgate then
                targetgate = self.DialingData.TargetGate
            end
            if wormhole then
                self.DialingData.TargetGate = targetgate
                self:ShowBone('Event_Horizon', true)  
                self.DialingData.ActiveWormhole = true  
                self:DisableShield()    
                if not targetgate:IsDead() then
                    targetgate.DialingData.TargetGate = self
                    targetgate:ShowBone('Event_Horizon', true)  
                    targetgate.DialingData.ActiveWormhole = true
                    targetgate.DialingData.IncomingWormhole = true  
                    if self:GetArmy() == targetgate:GetArmy() then
                        targetgate:DisableShield()
                    elseif not IsAlly( self:GetArmy(), targetgate:GetArmy() ) then
                        targetgate:EnableShield()
                    end      
                end
            else
                self:HideBone('Event_Horizon', true)
                self.DialingData.ActiveWormhole = false     
                self.DialingData.TargetGate = nil
                if not targetgate:IsDead() then
                    targetgate:HideBone('Event_Horizon', true)
                    targetgate.DialingData.ActiveWormhole = false
                    targetgate.DialingData.IncomingWormhole = false     
                end  
            end
        end,
        
        CreateIrisImpactEffect = function(self)
            local army = self:GetArmy()
            for k, v in self.MyShield.ImpactEffects do
                CreateEmitterAtBone(self, 'Center', army, v ):ScaleEmitter(4)
            end
        end,
              
        OnScriptBitSet = function(self, bit)
            SuperClass.OnScriptBitSet(self, bit)
            if bit == 6 then
                if self.DialingData.TargetGate then
                    if not self.DialingData.IncomingWormhole or self.DialingData.TargetGate:IsDead() then
                        self:WormholeFunctionToggle()
                    end
                end
                self:SetScriptBit('RULEUTC_GenericToggle',false) 
            end
        end,
        
        OnKilled = function(self, instigator, type, overkillRatio)
            SuperClass.OnKilled(self, instigator, type, overkillRatio)  
            if self.DialingData.TargetGate then
                self:WormholeFunctionToggle()
            end
        end,
    }    
end