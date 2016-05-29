--------------------------------------------------------------------------------
-- Seraphim Optics Tracking Facility script.
-- Spererate from the units actual script for reasons.
--------------------------------------------------------------------------------
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

function RemoteViewing(SuperClass)
    return Class(SuperClass) {
        OnCreate = function(self)
            SuperClass.OnCreate(self)
            self.RemoteViewingData = {}
            self.RemoteViewingData.RemoteViewingFunctions = {}
            self.RemoteViewingData.DisableCounter = 0
            self.RemoteViewingData.IntelButton = true
        end,

        OnStopBeingBuilt = function(self,builder,layer)
            self.Sync.Abilities = self:GetBlueprint().Abilities
            self:SetMaintenanceConsumptionInactive()
            SuperClass.OnStopBeingBuilt(self,builder,layer)
        end,

        OnKilled = function(self, instigator, type, overkillRatio)
            SuperClass.OnKilled(self, instigator, type, overkillRatio)
            if self.RemoteViewingData.Satellite then
                self.RemoteViewingData.Satellite:DisableIntel('Vision')
                self.RemoteViewingData.Satellite:Destroy()
            end
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
            local targettable = aiBrain:GetUnitsAroundPoint(categories.SELECTABLE, location, 10)
            local targetunit = targettable[1]
            if table.getn(targettable) > 1 then
                local dist = 100
                for i, target in targettable do    
                    if IsUnit(target) then
                        local cdist = VDist2Sq(target:GetPosition()[1], target:GetPosition()[3], location[1], location[3])
                        --LOG(location[1] .. " " .. location[2] .. " " .. location[3])
                        --LOG(cdist)
                        if cdist < dist then
                            dist = cdist
                            targetunit = target
                        end
                    end
                end   
            end
            if targetunit and IsUnit(targetunit) then
                self:CreateVisibleEntity(location, targetunit)
            end
        end,
        
        CreateVisibleEntity = function(self, location, targetunit)
            local bp = self:GetBlueprint()
            local aiBrain = self:GetAIBrain()
            local have = aiBrain:GetEconomyStored('ENERGY')
            local need = bp.Economy.InitialRemoteViewingEnergyDrain      
            
            if not self.RemoteViewingData.Satellite then
                self:SetMaintenanceConsumptionInactive()
                if not location and not targetunit then
                    return
                end
            end
            
            if self.RemoteViewingData.DisableCounter == 0 and self.RemoteViewingData.IntelButton then
                --Create new visible area
                if location and targetunit then
                    if not self.RemoteViewingData.Satellite or self.RemoteViewingData.Satellite:BeenDestroyed() then  
                        if not ( have > need ) then
                            return
                        end 
                        aiBrain:TakeResource( 'ENERGY', need )
                        self:SetMaintenanceConsumptionActive()
                        local spec = {
                            X = location[1],
                            Z = location[3],
                            Radius = bp.Intel.RemoteViewingRadius,
                            LifeTime = -1,
                            Omni = false,
                            Radar = false,
                            Vision = true,
                            Army = self:GetAIBrain():GetArmyIndex(),
                        }
                        self.RemoteViewingData.Satellite = VizMarker(spec)   
                        self.RemoteViewingData.Satellite:AttachTo(targetunit, -1)
                        self.Trash:Add(self.RemoteViewingData.Satellite)
                    else
                        --Charge based on the distance moved
                        local oldpos = self.RemoteViewingData.Satellite:GetPosition()
                        local newpos = targetunit:GetPosition()
                        local distance = math.max(math.min(VDist2Sq(oldpos[1], oldpos[3], newpos[1], newpos[3]), 1000), 1)
                        --LOG("Distance: " .. distance)
                        need = need * (distance * 0.001)
                        --LOG("NEED: " .. need)
                        if not ( have > need ) then
                            return
                        end
                        aiBrain:TakeResource( 'ENERGY', need )      
                        self:SetMaintenanceConsumptionActive()
                        Warp( self.RemoteViewingData.Satellite, location )
                        self.RemoteViewingData.Satellite:DetachFrom()
                        self.RemoteViewingData.Satellite:AttachTo(targetunit, -1)
                        self.RemoteViewingData.Satellite:EnableIntel('Vision')
                    end
                elseif not location and not targetunit then  
                    self.RemoteViewingData.Satellite:EnableIntel('Vision')
                end 
                -- monitor resources
                if self.RemoteViewingData.ResourceThread then
                    self.RemoteViewingData.ResourceThread:Destroy()
                end
                self.RemoteViewingData.ResourceThread = self:ForkThread(self.DisableResourceMonitor)
            end
        end,

        DisableVisibleEntity = function(self)
            -- visible entity already off
            if self.RemoteViewingData.DisableCounter > 1 then return end
            -- disable vis entity and monitor resources
            if not self:IsDead() and self.RemoteViewingData.Satellite then
                self.RemoteViewingData.Satellite:DisableIntel('Vision')
            end
        end,

        OnIntelEnabled = function(self)
            -- Make sure the button is only calculated once rather than once per possible intel type
            if not self.RemoteViewingData.IntelButton then
                self.RemoteViewingData.IntelButton = true
                self.RemoteViewingData.DisableCounter = self.RemoteViewingData.DisableCounter - 1
                self:CreateVisibleEntity()
            end
            SuperClass.OnIntelEnabled(self)
        end,

        OnIntelDisabled = function(self)
            -- make sure button is only calculated once rather than once per possible intel type
            if self.RemoteViewingData.IntelButton then
                self.RemoteViewingData.IntelButton = false
                self.RemoteViewingData.DisableCounter = self.RemoteViewingData.DisableCounter + 1
                self:DisableVisibleEntity()
            end
            SuperClass.OnIntelDisabled(self)
        end,

        DisableResourceMonitor = function(self)
            WaitSeconds(0.5)
            local fraction = self:GetResourceConsumed()
            while fraction == 1 do
                WaitSeconds(0.5)
                fraction = self:GetResourceConsumed()
            end
            if self.RemoteViewingData.IntelButton then
                self.RemoteViewingData.DisableCounter = self.RemoteViewingData.DisableCounter + 1
                self.RemoteViewingData.ResourceThread = self:ForkThread(self.EnableResourceMonitor)
                self:DisableVisibleEntity()
            end
        end,

        EnableResourceMonitor = function(self)
            local recharge = self:GetBlueprint().Intel.ReactivateTime or 10
            WaitSeconds(recharge)
            self.RemoteViewingData.DisableCounter = self.RemoteViewingData.DisableCounter - 1
            self:CreateVisibleEntity()
        end,
    }    
end
