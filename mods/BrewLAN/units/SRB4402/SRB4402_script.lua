#****************************************************************************
#**
#**  File     :  /cdimage/units/URB4203/URB4203_script.lua
#**  Author(s):  David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Radar Jammer Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CRadarJammerUnit = import('/lua/cybranunits.lua').CRadarJammerUnit  
local BareBonesWeapon = import('/lua/sim/defaultweapons.lua').BareBonesWeapon 
local Utilities = import('/lua/utilities.lua')

SRB4402 = Class(CRadarJammerUnit) {    
    Weapons = {
        PulseWeapon = Class(BareBonesWeapon) {
            OnFire = function(self)
                local aiBrain = self.unit:GetAIBrain()      
                local Mypos = self.unit:GetPosition()
                local Range = self.MaxRadius or 2000
                local LocalUnits = aiBrain:GetUnitsAroundPoint(categories.ALLUNITS, Mypos, Range) 
                local army = self.unit:GetArmy()
                self:PlaySound(self:GetBlueprint().Audio.Fire)
                for k, v in self.unit.Rotator do
                    self.unit.Rotator[k]:SetGoal(-50)
                    self.unit.Rotator[k]:SetSpeed(1900)
                    
                    ForkThread( function()
                                    WaitTicks(1)  
                                    for k, v in self.unit.Rotator do
                                        self.unit.Rotator[k]:SetGoal(0)
                                        self.unit.Rotator[k]:SetSpeed(25)
                                    end
                                end
                              )
                end
                CreateAttachedEmitter(self.unit, 0, army, '/effects/emitters/flash_01_emit.bp'):ScaleEmitter( 20 ):OffsetEmitter( 0, 4, 0 )
                local epathR = '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp'
                CreateAttachedEmitter(self.unit, 'XRC2201', army, epathR):OffsetEmitter( 0, 4, 0 )
                CreateAttachedEmitter(self.unit, 'XRC2201', army, epathR):ScaleEmitter( 3 ):OffsetEmitter( 0, 4, 0 )
                CreateAttachedEmitter(self.unit, 'XRC2201', army, epathR):ScaleEmitter( 6 ):OffsetEmitter( 0, 4, 0 )
                local epathQ = '/effects/emitters/cybran_qai_shutdown_ambient_'
                CreateAttachedEmitter(self.unit, 0, army, epathQ .. '01_emit.bp')
                CreateAttachedEmitter(self.unit, 0, army, epathQ .. '02_emit.bp')
                CreateAttachedEmitter(self.unit, 0, army, epathQ .. '03_emit.bp')
                CreateAttachedEmitter(self.unit, 0, army, epathQ .. '04_emit.bp')
                for k, v in LocalUnits do
                    if self.unit:GetEntityId() != v:GetEntityId()
                    and v:IsIntelEnabled('Omni') then
                    
                        --If this is the first time the target has been effected by any facility
                        if not v.Darkness.StartingRadius then
                            v.Darkness = {}
                            v.Darkness.StartingRadius = v:GetIntelRadius('Omni')
                            v.Darkness.Facilities = {}
                            v.Darkness.Facilities[self.unit:GetEntityId()] = true
                            self.unit.NerfedUnits[k] = v
                            
                            --LOG('First Instance: ' .. v:GetBlueprint().Description .. v:GetEntityId() .. ' Rad: ' .. v.Darkness.StartingRadius)
                            
                        --If this is the first time the target has been effected by just this facility    
                        elseif not v.Darkness.Facilities[self.unit:GetEntityId()] then
                            v.Darkness.Facilities[self.unit:GetEntityId()] = true
                            self.unit.NerfedUnits[k] = v
                            
                            --LOG('Second Instance: ' .. v:GetBlueprint().Description .. v:GetEntityId() .. ' Rad: ' .. v.Darkness.StartingRadius)
                        end
                        
                        --Check to see the target has upgraded and increased its radius, since first being effected    
                        if v:GetIntelRadius('Omni') > v.Darkness.StartingRadius then   
                            v.Darkness.StartingRadius = v:GetIntelRadius('Omni')
                            
                            --LOG('Upgrade Instance: ' .. v:GetBlueprint().Description .. v:GetEntityId() .. ' Rad: ' .. v.Darkness.StartingRadius)
                        end
                        
                        if v:GetIntelRadius('Omni') > 50 then
                            rate = 0.4 + Utilities.GetDistanceBetweenTwoEntities(v, self.unit)/(Range*2)
                            v:SetIntelRadius('Omni', math.max(v:GetIntelRadius('Omni')*rate, 50))
                            v:RequestRefreshUI()
                        end
                    end
                end  
            end,
        },
    },
        
    OnStopBeingBuilt = function(self,builder,layer)
        CRadarJammerUnit.OnStopBeingBuilt(self,builder,layer)
        if not self.Sliders then
            self.Rotator = {}
            self.Rotator.B01 = CreateRotator(self, ' B01', 'x')
            self.Rotator.B02 = CreateRotator(self, ' B02', 'x')
            self.Rotator.B02 = CreateRotator(self, ' B03', 'x')
            for k,v in self.Rotator do
                self.Trash:Add(self.Rotator[k])
            end
        end 
        if self.IntelEffects and not self.IntelFxOn then
            self.IntelEffectsBag = {}
            self.CreateTerrainTypeEffects( self, self.IntelEffects, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
            self.IntelFxOn = true
        end
        self.NerfedUnits = {}
        self.Intel = true
        self:ForkThread(self.FirePulse, self)
    end,
    
    OnIntelEnabled = function(self) 
        self.Intel = true 
        self:ForkThread(self.FirePulse, self)
        CRadarJammerUnit.OnIntelEnabled(self)
    end,

    OnIntelDisabled = function(self)
        self.Intel = false
        CRadarJammerUnit.OnIntelDisabled(self)
        self.ReturnOmni(self) 
        ForkThread( function()
                        WaitTicks(1)  
                        self.ReturnOmni(self) 
                    end
                  )
    end,
       
    OnKilled = function(self, instigator, type, overkillRatio)
        CRadarJammerUnit.OnKilled(self, instigator, type, overkillRatio)
        self.ReturnOmni(self)
        ForkThread( function()
                        WaitTicks(1)  
                        self.ReturnOmni(self) 
                    end
                  )
    end,
    
    FirePulse = function(self)
        while self.Intel do 
            WaitSeconds(2.5)
            if self.Intel then
                self:GetWeaponByLabel('PulseWeapon'):FireWeapon()
            end
            WaitSeconds(2.5)
        end
    end,
    
    ReturnOmni = function(self)
        if self.NerfedUnits then 
            for k, v in self.NerfedUnits do 
                --LOG('Return Instance: ' .. v:GetBlueprint().Description .. v:GetEntityId() .. ' Rad: ' .. v.Darkness.StartingRadius)
                
                v.Darkness.Facilities[self:GetEntityId()] = false
                for facility, active in v.Darkness.Facilities do
                    if active then
                        --fallback check, because primary can fail with multiple facilities disabled at the same time
                        if GetEntityById(facility).Intel then
                            return
                        end
                    end
                end  
                --LOG('Returning for: ' .. v:GetBlueprint().Description .. v:GetEntityId() .. ' Rad: ' .. v.Darkness.StartingRadius)
                if v:GetIntelRadius('Omni') < v.Darkness.StartingRadius then
                    v:SetIntelRadius('Omni', v.Darkness.StartingRadius)
                end 
            end
        --else
            --LOG('Nope, no return')
        end
    end,   
     
    IntelEffects = {
        {
            Bones = {
            	' B01',
            	' B02',
            	' B03',
            },
            Offset = {
              	0,
              	2,
              	0,
            },
            Type = 'Jammer01',
        },
    },
}
TypeClass = SRB4402