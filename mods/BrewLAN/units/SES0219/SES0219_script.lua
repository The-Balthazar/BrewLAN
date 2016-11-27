#****************************************************************************
#**
#**  File     :  /cdimage/units/UES0103/UES0103_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Frigate Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TSeaUnit = import('/lua/terranunits.lua').TSeaUnit
local TAALinkedRailgun = import('/lua/terranweapons.lua').TAALinkedRailgun
local Entity = import('/lua/sim/Entity.lua').Entity

SES0219 = Class(TSeaUnit) {

    Weapons = {
        AAGun = Class(TAALinkedRailgun) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        TSeaUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateRotator(self, 'Spinner01', 'y', nil, 360, 0, 180))
        self.Trash:Add(CreateRotator(self, 'Spinner02', 'y', nil, 90, 0, 180))
        self.Trash:Add(CreateRotator(self, 'Spinner03', 'y', nil, -180, 0, -180))
        self.RadarEnt = Entity {}
        self.Trash:Add(self.RadarEnt)
        self.RadarEnt:InitIntel(self:GetArmy(), 'Radar', self:GetBlueprint().Intel.RadarRadius or 75)
        self.RadarEnt:EnableIntel('Radar')
        self.RadarEnt:InitIntel(self:GetArmy(), 'Sonar', self:GetBlueprint().Intel.SonarRadius or 75)
        self.RadarEnt:EnableIntel('Sonar')
        self.RadarEnt:AttachBoneTo(-1, self, 0)    
        self:SetupBuildBones()
        self:ForkThread(self.AssistThread)
    end,

    CreateBuildEffects = function( self, unitBeingBuilt, order )
        WaitSeconds( 0.1 )
        for k, v in self:GetBlueprint().General.BuildBones.BuildEffectBones do
            self.BuildEffectsBag:Add( CreateAttachedEmitter( self, v, self:GetArmy(), '/effects/emitters/flashing_blue_glow_01_emit.bp' ) )         
            self.BuildEffectsBag:Add( self:ForkThread( import('/lua/EffectUtilities.lua').CreateDefaultBuildBeams, unitBeingBuilt, {v}, self.BuildEffectsBag ) )
        end
    end,

    AssistThread = function(self)
        while true do
            if self:IsIdleState() then
                --Insert some kind of table sort for most damaged here
                for i, v in self:GetAIBrain():GetUnitsAroundPoint(categories.ALLUNITS, self:GetPosition(), 30, 'Ally' ) do
                    if v:GetHealthPercent() != 1 then
                        IssueRepair({self}, v)
                    end
                end
            end   
            WaitTicks(30)
        end
    end,
}

TypeClass = SES0219