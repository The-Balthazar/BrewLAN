--------------------------------------------------------------------------------
--  Summary:  Field engineer ship
--------------------------------------------------------------------------------
local TSeaUnit = import('/lua/terranunits.lua').TSeaUnit
local WeaponFile = import('/lua/terranweapons.lua')
local TAALinkedRailgun = WeaponFile.TAALinkedRailgun
local TANTorpedoAngler = WeaponFile.TANTorpedoAngler
local TIFSmartCharge = WeaponFile.TIFSmartCharge
--------------------------------------------------------------------------------
local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath()
local AssistThread = import(BrewLANPath .. '/lua/fieldengineers.lua').AssistThread
--------------------------------------------------------------------------------
SES0319 = Class(TSeaUnit) {
    DestructionTicks = 200,
    Weapons = {
        FrontTurret02 = Class(TAALinkedRailgun) {},
        Torpedo01 = Class(TANTorpedoAngler) {},
        AntiTorpedo = Class(TIFSmartCharge) {},
    },

    RadarThread = function(self)
        local spinner = CreateRotator(self, 'Spinner02', 'x', nil, 0, 90, -90)
        self.Trash:Add(spinner)
        while true do
            WaitFor(spinner)
            spinner:SetTargetSpeed(90)
            WaitFor(spinner)
            spinner:SetTargetSpeed(-90)
        end
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        TSeaUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateRotator(self, 'Spinner01', 'y', nil, 180, 0, 180))
        self:ForkThread(self.RadarThread)
        self:HideBone( 'Back_Turret02', true )
        self:SetupBuildBones()
        self:ForkThread(AssistThread)
    end,

    CreateBuildEffects = function( self, unitBeingBuilt, order )
        WaitSeconds( 0.1 )
        for k, v in self:GetBlueprint().General.BuildBones.BuildEffectBones do
            self.BuildEffectsBag:Add( CreateAttachedEmitter( self, v, self:GetArmy(), '/effects/emitters/flashing_blue_glow_01_emit.bp' ) )
            self.BuildEffectsBag:Add( self:ForkThread( import('/lua/EffectUtilities.lua').CreateDefaultBuildBeams, unitBeingBuilt, {v}, self.BuildEffectsBag ) )
        end
    end,

    SetupBuildBones = function(self)
        TSeaUnit.SetupBuildBones(self)
        local bp = self:GetBlueprint()
        self.BuildArmManipulator = CreateBuilderArmController(self, bp.General.BuildBones.YawBone or 0 , bp.General.BuildBones.PitchBone or 0, bp.General.BuildBones.AimBone or 0)
        self.BuildArmManipulator2 = CreateBuilderArmController(self, bp.General.BuildBones2.YawBone or 0 , bp.General.BuildBones2.PitchBone or 0, bp.General.BuildBones2.AimBone or 0)
        self.BuildArmManipulator:SetAimingArc(-180, 180, 360, -90, 90, 360)
        self.BuildArmManipulator2:SetAimingArc(-180, 180, 360, -90, 90, 360)
        self.BuildArmManipulator:SetPrecedence(5)
        self.BuildArmManipulator2:SetPrecedence(5)
        self.Trash:Add(self.BuildArmManipulator)
        self.Trash:Add(self.BuildArmManipulator2)
    end,
}

TypeClass = SES0319
