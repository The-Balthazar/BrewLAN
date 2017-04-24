--------------------------------------------------------------------------------
--  Summary:  Field engineer boat
--------------------------------------------------------------------------------
local TSeaUnit = import('/lua/terranunits.lua').TSeaUnit
--------------------------------------------------------------------------------
local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath()
local AssistThread = import(BrewLANPath .. '/lua/fieldengineers.lua').AssistThread
--------------------------------------------------------------------------------
SES0119 = Class(TSeaUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        TSeaUnit.OnStopBeingBuilt(self,builder,layer)
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
}

TypeClass = SES0119
