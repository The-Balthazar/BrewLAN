--------------------------------------------------------------------------------
-- Centurion script
--------------------------------------------------------------------------------
local               TAirUnit = import('/lua/terranunits.lua').TAirUnit
local               TWeapons = import('/lua/terranweapons.lua')
--------------------------------------------------------------------------------
local TAAFlakArtilleryCannon = TWeapons.TAAFlakArtilleryCannon
local           TSAMLauncher = TWeapons.TSAMLauncher
local    TDFHiroPlasmaCannon = TWeapons.TDFHiroPlasmaCannon
local  TDFPlasmaCannonWeapon = TWeapons.TDFPlasmaCannonWeapon
--------------------------------------------------------------------------------
local             EffectUtil = import('/lua/EffectUtilities.lua')
local                Effects = import('/lua/effecttemplates.lua')
local  CreateBuildCubeThread = EffectUtil.CreateBuildCubeThread
--------------------------------------------------------------------------------
SEA0401 = Class(TAirUnit) {
    BeamExhaustCruise = import( '/lua/game.lua' ).BrewLANPath() .. '/effects/emitters/brewlan_missile_exhaust_fire_beam_01_emit.bp',
    DestroyNoFallRandomChance = 1.1,
    DestructionPartsChassisToss = {'SEA0401',},
    EngineRotateBones = {'Engine_Body001', 'Engine_Body002','Engine_Body003', 'Engine_Body004',},

    Weapons = {
        HeadAAGun = Class(TAAFlakArtilleryCannon) {},
        RearAAGun = Class(TAAFlakArtilleryCannon) {},
        SAM1 = Class(TSAMLauncher) {},
        SAM2 = Class(TSAMLauncher) {},
        RearASFBeam = Class(TDFHiroPlasmaCannon) {},
        GatlingCannon = Class(TDFPlasmaCannonWeapon)
        {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtil.CreateBoneEffects( self.unit, 'GGun_Barrel_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFPlasmaCannonWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'GGun_Barrel001', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TDFPlasmaCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtil.CreateBoneEffects( self.unit, 'GGun_Barrel_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFPlasmaCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
    },

    OnCreate = function(self)
        TAirUnit.OnCreate(self)
    end,

    StartBeingBuiltEffects = function(self, builder, layer)
        self:SetMesh(self:GetBlueprint().Display.BuildMeshBlueprint, true)
        self:HideBone(0, true)
        self.OnBeingBuiltEffectsBag:Add( self:ForkThread( CreateBuildCubeThread, builder, self.OnBeingBuiltEffectsBag ))
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
        self.EngineManipulators = {}
        -- create the engine thrust manipulators
        for key, value in self.EngineRotateBones do                                            --XMAX, XMIN,  YMAX, YMIN, ZMAX, ZMIN,TURNMULT, TURNSPEED
            local thruster = CreateThrustController(self, "thruster", value):SetThrustingParam( -0.05, 0.05, -0.25, 0.25, -0.1, 0.1, 1.0,      0.25 )
            self.Trash:Add(table.insert(self.EngineManipulators, thruster))
        end
        self.EnginePropBones = {
            {'Engine_Propeller001', 1000},
            {'Engine_Propeller002', 1000},
            {'Engine_Propeller003', -1000},
            {'Engine_Propeller004', -1000},
        }
        for i, v in self.EnginePropBones do
            self.EnginePropBones[i][3] = CreateRotator(self, v[1], 'y', nil, v[2], 250, v[2])
            self.Trash:Add(self.EnginePropBones[i][3])
        end

        self.LandingAnimManip = CreateAnimator(self):SetPrecedence(0):PlayAnim(self:GetBlueprint().Display.AnimationLand):SetRate(1)
        self.Trash:Add(self.LandingAnimManip)
    end,

    OnMotionVertEventChange = function(self, new, old)
        TAirUnit.OnMotionVertEventChange(self, new, old)
        if new == 'Down' then
            self.LandingAnimManip:SetRate(-1)
        elseif new == 'Up' then
            self.LandingAnimManip:SetRate(1)
        end
    end,

    OnLayerChange = function(self, new, old)
        TAirUnit.OnLayerChange(self, new, old)
        if self.EnginePropBones then
            if new == 'Land' then
                for i, v in self.EnginePropBones do
                    self.EnginePropBones[i][3]:SetTargetSpeed(0)
                end
            elseif new == 'Air' then
                for i, v in self.EnginePropBones do
                    self.EnginePropBones[i][3]:SetTargetSpeed(v[2])
                end
            end
        end
    end,
}

TypeClass = SEA0401
