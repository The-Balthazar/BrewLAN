local TStructureUnit = import('/lua/terranunits.lua').TAirFactoryUnit

SEB3303 = Class(TStructureUnit) {
    DeathThreadDestructionWaitTime = 0,

    OnStopBeingBuilt = function(self, ...)
        TStructureUnit.OnStopBeingBuilt(self, unpack(arg) )
        self.AnimManip = CreateAnimator(self)
        self.AnimManip:PlayAnim( '/units/XEB2402/XEB2402_aopen.sca' )
        self.Trash:Add(self.AnimManip)
        self:PlayUnitSound('MoveArms')
        self:Rebuild()
    end,

    Rebuild = function(self, pos)
        if pos then
			IssueClearFactoryCommands({self})
            IssueFactoryRallyPoint({self}, pos)
        end
        self:GetAIBrain():BuildUnit(self, 'sea0002', 1)
    end,

    FinishBuildThread = function(self, unitBeingBuilt, order )
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        local bp = self:GetBlueprint()
        local army = self:GetArmy()
        if unitBeingBuilt and not unitBeingBuilt:IsDead() then
            unitBeingBuilt:PreLaunchSetup(self)
            if not self.LightsOn then
                for i, v in {{0.06, -0.10, 1.90},{-0.06, -0.10, 1.90},{0.08, -0.5, 1.60},{-0.04, -0.5, 1.60}} do
                    self.Trash:Add(CreateAttachedEmitter(self, 'Tower_B04', army, '/effects/emitters/light_blue_blinking_01_emit.bp'):OffsetEmitter(v[1], v[2], v[3]))
                end
                for i = 1, 2 do
                    self.Trash:Add(CreateAttachedEmitter(self, 'ConstuctBeam0' .. i ,army, '/effects/emitters/light_red_rotator_01_emit.bp'):ScaleEmitter( 2.00 ))
                end
                self.LightsOn = true
                self.AnimManip:PlayAnim( '/units/XEB2402/XEB2402_aopen01.sca' )
            end
            for i, v in {0.7, -0.7} do
                self.Trash:Add(CreateAttachedEmitter(self,'Attachpoint01',army, '/effects/emitters/structure_steam_ambient_0' .. i .. '_emit.bp'):OffsetEmitter(v, -0.85, 0.35))
            end
            self.AnimManip:SetRate(1)
            self:PlayUnitSound('LaunchSat')
            WaitFor( self.AnimManip )
            self.Trash:Add(CreateAttachedEmitter(self,'XEB2402',army, '/effects/emitters/uef_orbital_death_laser_launch_01_emit.bp'):OffsetEmitter(0.00, 0.00, 1.00))
            self.Trash:Add(CreateAttachedEmitter(self,'XEB2402',army, '/effects/emitters/uef_orbital_death_laser_launch_02_emit.bp'):OffsetEmitter(0.00, 2.00, 1.00))

            unitBeingBuilt:DetachFrom()
            unitBeingBuilt:Setup()
        end
        self.AnimManip:SetRate(-1)
        self.AnimManip:SetPrecedence(0)
        WaitFor( self.AnimManip )
        ChangeState(self, self.RollingOffState)
    end,
}

TypeClass = SEB3303
