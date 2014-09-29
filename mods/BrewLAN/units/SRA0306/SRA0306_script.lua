#****************************************************************************
#**
#**  Summary  :  Cybran T3 Air Transport Script
#**
#****************************************************************************

local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local EffectUtil = import('/lua/EffectUtilities.lua')
local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')
local Weapon = import('/lua/sim/Weapon.lua').Weapon
local cWeapons = import('/lua/cybranweapons.lua')
local CAAAutocannon = cWeapons.CAAAutocannon
local CEMPAutoCannon = cWeapons.CEMPAutoCannon
local CRadarJammerUnit = import('/lua/cybranunits.lua').CRadarJammerUnit

SRA0306 = Class(CAirUnit) {
    Weapons = {
        AAAutocannon = Class(CAAAutocannon) {},
        AAAutocannon2 = Class(CAAAutocannon) {},
        EMPCannon = Class(CEMPAutoCannon) {},
    },

    AirDestructionEffectBones = { 'Left_Exhaust', 'Right_Exhaust', 'Char04', 'Char03', 'Char02', 'Char01',
                                  'Front_Left_Leg03_B02', 'Front_Right_Leg03_B02', 'Front_Left_Leg01_B02', 'Front_Right_Leg01_B02',
                                  'Right_AttachPoint01', 'Right_AttachPoint02', 'Right_AttachPoint03', 'Right_AttachPoint04',
                                  'Left_AttachPoint01', 'Left_AttachPoint02', 'Left_AttachPoint03', 'Left_AttachPoint04', },

    BeamExhaustIdle = '/effects/emitters/missile_exhaust_fire_beam_05_emit.bp',
    BeamExhaustCruise = '/effects/emitters/missile_exhaust_fire_beam_04_emit.bp',
     
    IntelEffects = {
        {
            Bones = {
                'Char01',
            },
                Offset = {
                0,
                0.3,
                0,
            },
            Scale = 2,
            Type = 'Jammer01',
        },
    },
    
    OnCreate = function( self )
        CAirUnit.OnCreate(self)
        if not self.OpenAnim then
            self.OpenAnim = CreateAnimator(self)
            self.OpenAnim:PlayAnim(self:GetBlueprint().Display.AnimationOpen, false):SetRate(0)
            self.Trash:Add(self.OpenAnim)
        end
    end,

    OnStopBeingBuilt = function(self,builder,layer) 
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        self.AnimManip = CreateAnimator(self)
        self.Trash:Add(self.AnimManip)
        self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTakeOff, false):SetRate(1)
        if not self.OpenAnim then
            self.OpenAnim = CreateAnimator(self)
            self.Trash:Add(self.OpenAnim)
        end
        self.OpenAnim:PlayAnim(self:GetBlueprint().Display.AnimationOpen, false):SetRate(1)
        
        self:SetScriptBit('RULEUTC_StealthToggle', false)
        self:SetMaintenanceConsumptionActive()
        self:EnableUnitIntel('RadarStealthField')
        self:EnableUnitIntel('SonarStealthField')
        self.OnIntelEnabled(self)
        self:RequestRefreshUI()
    end,

    # When one of our attached units gets killed, detach it
    OnAttachedKilled = function(self, attached)
        attached:DetachFrom()
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        CAirUnit.OnKilled(self, instigator, type, overkillRatio)
        # TransportDetachAllUnits takes 1 bool parameter. If true, randomly destroys some of the transported
        # units, otherwise successfully detaches all.
        self:TransportDetachAllUnits(true)
    end,
    
    OnIntelEnabled = function(self)
        CAirUnit.OnIntelEnabled(self)
        if self.IntelEffects and not self.IntelFxOn then
            self.IntelEffectsBag = {}
            self.CreateTerrainTypeEffects( self, self.IntelEffects, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
            self.IntelFxOn = true
        end
    end,
    
    OnIntelDisabled = function(self)
        CAirUnit.OnIntelDisabled(self)
        EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
        self.IntelFxOn = false
    end,   
    OnMotionVertEventChange = function(self, new, old)
        #LOG( 'OnMotionVertEventChange, new = ', new, ', old = ', old )
        CAirUnit.OnMotionVertEventChange(self, new, old)
        #Aborting a landing
        if ((new == 'Top' or new == 'Up') and old == 'Down') then
            self.AnimManip:SetRate(-1)
        elseif (new == 'Down') then
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationLand, false):SetRate(1.5)
        elseif (new == 'Up') then
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTakeOff, false):SetRate(1)
        end
    end,

    # Override air destruction effects so we can do something custom here
    CreateUnitAirDestructionEffects = function( self, scale )
        self:ForkThread(self.AirDestructionEffectsThread, self )
    end,

    AirDestructionEffectsThread = function( self )
        local numExplosions = math.floor( table.getn( self.AirDestructionEffectBones ) * 0.5 )
        for i = 0, numExplosions do
            explosion.CreateDefaultHitExplosionAtBone( self, self.AirDestructionEffectBones[util.GetRandomInt( 1, numExplosions )], 0.5 )
            WaitSeconds( util.GetRandomFloat( 0.2, 0.9 ))
        end
    end,
}

TypeClass = SRA0306

