--------------------------------------------------------------------------------
--  Summary:  Field engineer boat
--------------------------------------------------------------------------------
local CSeaUnit = import('/lua/cybranunits.lua').CSeaUnit
--------------------------------------------------------------------------------
local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath()
local AssistThread = import(BrewLANPath .. '/lua/fieldengineers.lua').AssistThread
local EffectUtil = import('/lua/EffectUtilities.lua')
--------------------------------------------------------------------------------
SRS0119 = Class(CSeaUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        CSeaUnit.OnStopBeingBuilt(self,builder,layer)
        self:ForkThread(AssistThread)
    end,

    CreateBuildEffects = function( self, unitBeingBuilt, order )
        local buildbots = EffectUtil.SpawnBuildBots( self, unitBeingBuilt, table.getn(self:GetBlueprint().General.BuildBones.BuildEffectBones), self.BuildEffectsBag )
        EffectUtil.CreateCybranEngineerBuildEffects( self, self:GetBlueprint().General.BuildBones.BuildEffectBones, buildbots, self.BuildEffectsBag )
    end,
}

TypeClass = SRS0119
