--------------------------------------------------------------------------------
-- Summary  :  Stargate Dialing Script
-- Author   :  Balthazar
--------------------------------------------------------------------------------   
local explosion = import('/lua/defaultexplosions.lua')

function StargateDialing(SuperClass)
    return Class(SuperClass) {
        
        ------------------------------------------------------------------------
        -- Main function callbacks
        ------------------------------------------------------------------------    
        
        OnShieldEnabled = function(self)
            SuperClass.OnShieldEnabled(self)
            self.DialingData.Iris = true
        end,
       
        OnShieldDisabled = function(self)
            SuperClass.OnShieldDisabled(self)
            self.DialingData.Iris = false
        end,

        OnKilled = function(self, instigator, type, overkillRatio)  
            self:CloseWormhole(true)
            SuperClass.OnKilled(self, instigator, type, overkillRatio)
        end,

        OnDestroy = function(self)  
            self:CloseWormhole(true)
            SuperClass.OnDestroy(self)
        end,
            
        OnScriptBitSet = function(self, bit)
            SuperClass.OnScriptBitSet(self, bit)
            if bit == 6 then  
                self:CloseWormhole()
                self:SetScriptBit('RULEUTC_GenericToggle',false) 
            end
        end,
        
        ------------------------------------------------------------------------
        -- Innitialisation
        ------------------------------------------------------------------------
        
        OnCreate = function(self)
            SuperClass.OnCreate(self)
            self.DialingData = {
                ActiveWormhole = false,
                IncomingWormhole = false,  
                Iris = false,
                TargetGate = nil,
                WormholeThread = nil,
                --DisableCounter = 0,
                DialingSequence = self:DialingSequence(self),
                DialingHome = math.mod(self:GetEntityId() or 1, 9),
                CurrentPosition = 9,
            }
        end,
        
        OnStopBeingBuilt = function(self,builder,layer)
            self.Sync.Abilities = self:GetBlueprint().Abilities
            self:RemoveToggleCap('RULEUTC_GenericToggle')
            SuperClass.OnStopBeingBuilt(self,builder,layer)           
            self.DialingData.WormholeThread = self:ForkThread(
                function()
                    while true do
                        if not self.DialingData.ActiveWormhole and self.DialingData.TargetGate and not self.DialingData.TargetGate.IncomingWormhole then
                            self:DialingAnimation(self.DialingData.TargetGate)
                            self:OpenWormhole(self.DialingData.TargetGate, true)
                        elseif self.DialingData.TargetGate
                        and self.DialingData.ActiveWormhole
                        and not self.DialingData.IncomingWormhole
                        and not self.DialingData.Iris
                        then
                            if not self.DialingData.TargetGate:IsDead() then
                                local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE - categories.AIR, self:GetPosition(), 4)
                                for i, v in units do
                                    Warp(v, self.DialingData.TargetGate:GetPosition())
                                    if self.DialingData.TargetGate.DialingData.Iris then
                                        self.DialingData.TargetGate:OnIrisImpact(v)
                                    end
                                end
                            elseif self.DialingData.TargetGate:IsDead() then
                                self:CloseWormhole(true)
                            end
                            WaitTicks(3)
                        else
                            WaitTicks(5)
                        end
                    end
                end
            )
        end,
        
        ------------------------------------------------------------------------
        -- Activation
        ------------------------------------------------------------------------
                  
        OnTargetLocation = function(self, location)
            local aiBrain = self:GetAIBrain()
            local bp = self:GetBlueprint()
            local have = aiBrain:GetEconomyStored('ENERGY')
            local need = bp.Economy.DialingCostBase
            if not ( have > need ) or self.DialingData.IncomingWormhole then
                return
            end
            local targetarea = aiBrain:GetUnitsAroundPoint(categories.STARGATE, location, 10)
            --if table.getn(targetarea) > 1 then
                --sort by distance here
                local targetgate = targetarea[1]
            --end
            
            if targetgate                                   --Check we have a target
            and targetgate != self                          --Check not trying to dial self
            and targetgate != self.DialingData.TargetGate   --Check not redialing the same gate
            and targetgate.DialingData.WormholeThread       --Check the target is built and ready
            and not targetgate.DialingData.ActiveWormhole   --Check the target isn't already dialing out
            and not targetgate.DialingData.IncomingWormhole --Check the target isn't already being dialed into
            and not targetgate.DialingData.OutgoingWormhole --Check the target isn't currently dialing out
            and not self.DialingData.IncomingWormhole       --Check we don't have incoming
            then
                if self.DialingData.OutgoingWormhole then
                    self:CloseWormhole(true)
                end
                targetgate.DialingData.IncomingWormhole = true
                self.DialingData.TargetGate = targetgate
                self.DialingData.OutgoingWormhole = true
                aiBrain:TakeResource( 'ENERGY', bp.Economy.DialingCostBase )  
                --LOG("CHEVRON 7 LOCKED")
            else
                --LOG("CHEVRON 7 ... WONT ENGAGE")
            end
        end,
        
        ------------------------------------------------------------------------
        -- Event Horizon functions
        ------------------------------------------------------------------------
        
        OpenWormhole = function(self, other, primary)
            --FloatingEntityText(self:GetEntityId(),tostring(primary) )
            if other and not other:IsDead() then
                if primary then 
                    other:OpenWormhole(self, not primary)
                    self:AddToggleCap('RULEUTC_GenericToggle')
                    self:SetScriptBit('RULEUTC_GenericToggle',false)
                    --Disable shield whilst dialing out. Can't leave else.
                    self:DisableShield()
                else
                    self:RemoveToggleCap('RULEUTC_GenericToggle')
                    if self:GetArmy() == other:GetArmy() then  
                        --Disables shield if being dialed by another owners gate.
                        self:DisableShield()
                    elseif not IsAlly( self:GetArmy(), other:GetArmy() ) then
                        --Enables shield if being dialed by an enemy gate. 
                        self:EnableShield()
                    end   
                end
                self.DialingData.TargetGate = other
                self.DialingData.ActiveWormhole = true
                self.DialingData.IncomingWormhole = not primary   
                self:EventHorizonToggle(true)
            end
        end,
        
        CloseWormhole = function(self, force)
            if not self.DialingData.IncomingWormhole or force then
                if self.DialingData.TargetGate and not self.DialingData.TargetGate:IsDead() then
                    local other = self.DialingData.TargetGate
                    self.DialingData.TargetGate.DialingData.TargetGate = nil
                    other:CloseWormhole(true)    
                end
                self:EventHorizonToggle(false)
                self:RemoveToggleCap('RULEUTC_GenericToggle')
                self.DialingData.ActiveWormhole = false
                self.DialingData.IncomingWormhole = false
                self.DialingData.OutgoingWormhole = false     
                self.DialingData.TargetGate = nil
                --self:DialingAnimationReset()
            end 
        end,

        OnIrisImpact = function(self, instigator)
            local army = self:GetArmy()
            local damage = (instigator:GetBlueprint().Economy.BuildCostMass + (instigator:GetBlueprint().Economy.BuildCostEnergy / 20) / 2 ) * instigator:GetHealthPercent()
            local irishealth = self.MyShield:GetHealth()
            if irishealth > damage then
                instigator:Destroy()
                self:AddKills(1)
                self:PlayUnitSound('ShieldImpact')
            else
                instigator:SetHealth(instigator, instigator:GetHealth() * (1 - (irishealth / damage)))
            end
            self.MyShield:OnDamage(instigator,damage, {x=0,y=0,z=0}, 'normal')
            for k, v in self.MyShield.ImpactEffects do
                CreateEmitterAtBone(self, 'Center', army, v ):ScaleEmitter(4)
            end
        end,
        
        ------------------------------------------------------------------------
        -- Animations and effects
        ------------------------------------------------------------------------
        
        DialingSequence = function(self, target)
            local targetPos = target:GetPosition()
            local Chevrons = {
                math.ceil((targetPos[1] * 9) / ScenarioInfo.size[1]),
                math.ceil((targetPos[3] * 9) / ScenarioInfo.size[2]),
                math.ceil(math.mod(targetPos[1] * 81, ScenarioInfo.size[1] * 9) / ScenarioInfo.size[1]),
                math.ceil(math.mod(targetPos[3] * 81, ScenarioInfo.size[2] * 9) / ScenarioInfo.size[2]),
            }
            return Chevrons
        end, 
        
        DialingAnimation = function(self, target, reset)            
            --------------------------------------------------------------------
            -- Error protection (Should never trigger)
            --------------------------------------------------------------------
            if not target then target = self end
            if not target.DialingData.DialingSequence then target.DialingData.DialingSequence = self:DialingSequence(target) end
            if not self.DialingData.DialingHome then self.DialingData.DialingHome = math.mod(self:GetEntityId() or 1, 9) end
            --------------------------------------------------------------------
            -- First time triggers
            --------------------------------------------------------------------
            if not self.DailingAnimation then self.DailingAnimation = CreateRotator(self, 'Ring', 'z') end
            if target != self and not target.DailingAnimation then target.DailingAnimation = CreateRotator(target, 'Ring', 'z') end
            --------------------------------------------------------------------
            -- Dial turn function
            --------------------------------------------------------------------
            local Dial = function(manipulator, values)
                local index = values[1]
                local Chevron = values[2]
                local prevChe = values[3]
                local sign = -1 + (2 * math.mod(index,2) )
                
                manipulator:SetAccel(40 )-- * Chevron)
                manipulator:SetTargetSpeed(100 * 5)-- * Chevron)
                manipulator:SetGoal(Chevron * 40)
                manipulator:SetSpeed(30 )-- * Chevron)
            end
            --------------------------------------------------------------------
            -- Load sequence
            --------------------------------------------------------------------
            local Chevrons = target.DialingData.DialingSequence
            table.insert(Chevrons, self.DialingData.DialingHome)
            --------------------------------------------------------------------
            -- Animation
            --------------------------------------------------------------------
            for i, chevron in Chevrons do
                Dial(self.DailingAnimation, {i, chevron, self.DialingData.CurrentPosition})
                self.DialingData.CurrentPosition = chevron
                if self != target then
                    Dial(target.DailingAnimation, {i, chevron, target.DialingData.CurrentPosition})
                    target.DialingData.CurrentPosition = chevron
                end       
                WaitFor(self.DailingAnimation)
                WaitFor(target.DailingAnimation)   
                WaitTicks(3)
            end
        end,        
        
        GateEffects = {
				'/effects/emitters/seraphim_ohwalli_strategic_flight_fxtrails_02_emit.bp', -- faint rings
				'/effects/emitters/seraphim_ohwalli_strategic_flight_fxtrails_03_emit.bp', -- distortion
        },
       
        GateEffectsBag = {},
        
        EventHorizonToggle = function(self, value)
            if value then 
                explosion.CreateDefaultHitExplosionAtBone( self, 'Center', 10.0 )
                for k, v in self.GateEffects do
                    table.insert(self.GateEffectsBag, CreateAttachedEmitter( self, 'Center', self:GetArmy(), v ):OffsetEmitter(0,3,0) )
                end 
                self.EventHorizon = import('/lua/sim/Entity.lua').Entity({Owner = self,})
                self.EventHorizon:AttachBoneTo( -1, self, 'Center' )
                self.EventHorizon:SetMesh( import( '/lua/game.lua' ).BrewLANPath() .. '/units/ssb5401/SSB5401_EventHorizon_mesh')
                self.EventHorizon:SetDrawScale(0.12)
                self.EventHorizon:SetVizToAllies('Intel')
                self.EventHorizon:SetVizToNeutrals('Intel')
                self.EventHorizon:SetVizToEnemies('Intel')     
                self.EventHorizonRotator = CreateRotator(self, 'Center', 'z', nil, math.random(-5, 5) )
                self.Trash:Add(self.EventHorizon)
            else  
                explosion.CreateDefaultHitExplosionAtBone( self, 'Center', 5.0 )
                for k, v in self.GateEffectsBag do
                    v:Destroy()
                end
                if self.EventHorizon then
                    self.EventHorizon:Destroy()
                end
            end
        end,                 
    }    
end
