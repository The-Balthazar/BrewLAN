#****************************************************************************
#**
#**  File     :  /mods/BrewLAN/units/BEA0401/BEA0401_script.lua
#**
#**  Summary  :  UEF Experimental Gunship script
#**
#**  Copyright © 2010 BrewLAN
#****************************************************************************

local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local TIFSmallYieldNuclearBombWeapon = WeaponsFile.TIFSmallYieldNuclearBombWeapon
local TAirToAirLinkedRailgun = WeaponsFile.TAirToAirLinkedRailgun
local TSAMLauncher = WeaponsFile.TSAMLauncher
local TDFHeavyPlasmaCannonWeapon = WeaponsFile.TDFHeavyPlasmaCannonWeapon
local TDFGaussCannonWeapon = WeaponsFile.TDFGaussCannonWeapon

local EffectUtil = import('/lua/EffectUtilities.lua')
local CreateUEFBuildSliceBeams = EffectUtil.CreateUEFBuildSliceBeams

SEA0401 = Class(TAirUnit) {
    BeamExhaustCruise = '/effects/emitters/missile_exhaust_fire_beam_03_emit.bp',

    EngineRotateBones = {'Engine_Body001', 'Engine_Body002',},

    Weapons = {
        GaussTurret01 = Class(TDFHeavyPlasmaCannonWeapon) {},
        GaussTurret02 = Class(TDFHeavyPlasmaCannonWeapon) {},
        GaussTurret03 = Class(TDFHeavyPlasmaCannonWeapon) {},
        GaussTurret04 = Class(TDFHeavyPlasmaCannonWeapon) {},
        GaussTurret05 = Class(TDFHeavyPlasmaCannonWeapon) {},
        GaussTurret06 = Class(TDFHeavyPlasmaCannonWeapon) {},
        FrontTurret01 = Class(TDFGaussCannonWeapon) {},
        FrontTurret02 = Class(TDFGaussCannonWeapon) {},
        LinkedRailGun1 = Class(TAirToAirLinkedRailgun) {},
        LinkedRailGun2 = Class(TAirToAirLinkedRailgun) {},
        MissileRack01 = Class(TSAMLauncher) {},
    },
    DestructionPartsChassisToss = {'SEA0401',},
    DestroyNoFallRandomChance = 1.1,

    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
        self.EngineManipulators = {}

        # create the engine thrust manipulators
        for key, value in self.EngineRotateBones do
            table.insert(self.EngineManipulators, CreateThrustController(self, "thruster", value))
        end

        # set up the thursting arcs for the engines
        for key,value in self.EngineManipulators do
            #                          XMAX, XMIN, YMAX,YMIN, ZMAX,ZMIN, TURNMULT, TURNSPEED
            value:SetThrustingParam( -0.0, 0.0, -0.25, 0.25, -0.1, 0.1, 1.0,      0.25 )
        end
        
        for k, v in self.EngineManipulators do
            self.Trash:Add(v)
        end

        self.Rotator1 = CreateRotator(self, 'Engine_Propeller001', 'y', nil, 1000, 100, 1000)
        self.Rotator2 = CreateRotator(self, 'Engine_Propeller002', 'y', nil, 1000, 100, 1000)
        self.Rotator3 = CreateRotator(self, 'Engine_Propeller003', 'y', nil, -1000, -100, -1000)
        self.Rotator4 = CreateRotator(self, 'Engine_Propeller004', 'y', nil, -1000, -100, -1000)
        self.Trash:Add(self.Rotator1)
        self.Trash:Add(self.Rotator2)
        self.Trash:Add(self.Rotator3)
        self.Trash:Add(self.Rotator4)

        self.LandingAnimManip = CreateAnimator(self)
        self.LandingAnimManip:SetPrecedence(0)
        self.Trash:Add(self.LandingAnimManip)
        self.LandingAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationLand):SetRate(1)
        self:ForkThread(self.ExpandThread)

    end,

    OnLayerChange = function(self, new, old)
        TAirUnit.OnLayerChange(self, new, old)
        if new == 'Land' then
            self.Rotator1:SetTargetSpeed(0)
            self.Rotator2:SetTargetSpeed(0)
            self.Rotator3:SetTargetSpeed(0)
            self.Rotator4:SetTargetSpeed(0)
        elseif new == 'Air' then
            self.Rotator1:SetTargetSpeed(1000)
            self.Rotator2:SetTargetSpeed(1000)
            self.Rotator3:SetTargetSpeed(-1000)
            self.Rotator4:SetTargetSpeed(-1000)   
        end
    end,

    OnMotionVertEventChange = function(self, new, old)
        TAirUnit.OnMotionVertEventChange(self, new, old)

        if (new == 'Down') then
            self.LandingAnimManip:SetRate(-1)
        elseif (new == 'Up') then
            self.LandingAnimManip:SetRate(1)
        end
    end,
}

TypeClass = SEA0401
