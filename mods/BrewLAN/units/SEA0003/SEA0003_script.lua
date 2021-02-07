local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath
local OffsetBoneToTerrain = import(BrewLANPath .. '/lua/TerrainUtils.lua').OffsetBoneToTerrain

SEA0003 = Class(TAirUnit) {
    DestroyNoFallRandomChance = 0,

    HideBones = { 'Shell01', 'Shell02', 'Shell03', 'Shell04' },

    OnStopBeingBuilt = function(self, ...)
        TAirUnit.OnStopBeingBuilt(self, unpack(arg) )
        --Less fuel for smaller maps. Max fuel only on 81k.
        self:SetFuelRatio(math.max(ScenarioInfo.size[1], ScenarioInfo.size[2]) / 4096)
    end,

    PreLaunchSetup = function(self, parent)
        self:SetScriptBit('RULEUTC_JammingToggle', true)
        self:RemoveToggleCap('RULEUTC_JammingToggle')
    end,

    Setup = function(self, parent)
        ChangeState( self, self.OpenState )
    end,

    OpenState = State() {
        Main = function(self)
            self.OpenAnim = CreateAnimator(self)
            self.OpenAnim:PlayAnim( '/units/XEA0002/xea0002_aopen01.sca' )
            self.Trash:Add( self.OpenAnim )
            WaitFor( self.OpenAnim )
            for k, v in self.HideBones do
                self:HideBone( v, true )
            end
            self.OpenAnim:PlayAnim( '/units/XEA0002/xea0002_aopen02.sca' )
            WaitFor( self.OpenAnim )
            --self:CreateVisEntity()
            self:AddToggleCap('RULEUTC_JammingToggle')
            self:SetScriptBit('RULEUTC_JammingToggle', false)
        end,
    },

    StartUnguidedOrbitalDecay = function(self)
        if not self.UnguidedOrbitalDecay then
            self.UnguidedOrbitalDecay = self:ForkThread(
                function()
                    local pos = self:GetPosition()
                    while not self.Dead do
                        self:OnDamage(self, 1, pos, 'Decay')
                        WaitTicks(1)
                    end
                end
            )
        end
    end,

    StopUnguidedOrbitalDecay = function(self)
        if self.UnguidedOrbitalDecay then
            KillThread(self.UnguidedOrbitalDecay)
            self.UnguidedOrbitalDecay = nil
        end
    end,

    OnIntelEnabled = function(self)
        TAirUnit.OnIntelEnabled(self)
        if not self.Hologram then
            self.Hologram = {}
            local pos = self:GetPosition()
            for i = 1, 3 do
                self.Hologram[i] = CreateUnitHPR('sea0004', self:GetArmy(), pos[1] + Random(-10, 10), pos[2], pos[3] + Random(-10, 10), 0, 0, 0)
                IssueGuard({self.Hologram[i]}, self)
            end
        end
    end,

    OnIntelDisabled = function(self)
        TAirUnit.OnIntelDisabled(self)
        if self.Hologram then
            for i, v in self.Hologram do
                v:Destroy()
            end
            self.Hologram = nil
        end
    end,

    OnRunOutOfFuel = function(self)
        TAirUnit.OnRunOutOfFuel(self)
        self:SetSpeedMult(self:GetBlueprint().Physics.NoFuelSpeedMult)
        self:SetAccMult(1)
        self:SetTurnMult(1)
    end,
}

TypeClass = SEA0003
