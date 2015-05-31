--------------------------------------------------------------------------------
--  Summary:  The Gantry script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------

local TLandFactoryUnit = import('/lua/terranunits.lua').TLandFactoryUnit 
local explosion = import('/lua/defaultexplosions.lua')
local Utilities = import('/lua/utilities.lua')    
local Buff = import('/lua/sim/Buff.lua')   

SEB0401 = Class(TLandFactoryUnit) {     

--------------------------------------------------------------------------------
-- Function triggers
--------------------------------------------------------------------------------   

    OnCreate = function(self)
        TLandFactoryUnit.OnCreate(self) 
        self.BuildModeChange(self)
    end,
           
    OnStopBeingBuilt = function(self, builder, layer)
        TLandFactoryUnit.OnStopBeingBuilt(self, builder, layer)
        self.AIStartOrders(self)        
    end,
     
    OnLayerChange = function(self, new, old)
        TLandFactoryUnit.OnLayerChange(self, new, old)
        self.BuildModeChange(self)
    end,
    
    OnStartBuild = function(self, unitBeingBuilt, order)                    
        TLandFactoryUnit.OnStartBuild(self, unitBeingBuilt, order)   
        self.BuildModeChange(self)  
        self.AIxCheats(self)      
    end,      
           
    OnStopBuild = function(self, unitBeingBuilt)     
        TLandFactoryUnit.OnStopBuild(self, unitBeingBuilt)    
        self.AIControl(self, unitBeingBuilt)      
    end,      
        
--------------------------------------------------------------------------------
-- Button controls
--------------------------------------------------------------------------------  
          
    OnScriptBitSet = function(self, bit)
        TLandFactoryUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self.airmode = true
            self.BuildModeChange(self)
        end
    end,
    
    OnScriptBitClear = function(self, bit)
        TLandFactoryUnit.OnScriptBitClear(self, bit)
        if bit == 1 then	
            self.airmode = false    
            self.BuildModeChange(self)
        end
    end,
              
    OnPaused = function(self)
        TLandFactoryUnit.OnPaused(self)
        self:StopBuildFx(self:GetFocusUnit())
    end,

    OnUnpaused = function(self)
        TLandFactoryUnit.OnUnpaused(self)
        if self:IsUnitState('Building') then
            self:StartBuildFx(self:GetFocusUnit())
        end
    end,
      
--------------------------------------------------------------------------------
-- AI control
--------------------------------------------------------------------------------   
    
    AIStartOrders = function(self)    
        local aiBrain = self:GetAIBrain()
        self.Time = GetGameTimeSeconds()       
        if aiBrain.BrainType != 'Human' then     
            --self.engineers = {} 
            self.BuildModeChange(self)         
            aiBrain:BuildUnit(self, 'uel0309', 5)   
            aiBrain:BuildUnit(self, self.ChooseExpimental(self), 1)
            aiBrain:BuildUnit(self, 'uel0309', 5)       
            aiBrain:BuildUnit(self, self.ChooseExpimental(self), 1)
            local AINames = import('/lua/AI/sorianlang.lua').AINames
            if AINames.seb0401 then
                local num = Random(1, table.getn(AINames.seb0401))
                self:SetCustomName(AINames.seb0401[num])
            end
        end 
    end,
      
    AIControl = function(self, unitBeingBuilt)     
        local aiBrain = self:GetAIBrain()   
        if aiBrain.BrainType != 'Human' then   
            if unitBeingBuilt:GetUnitId() == 'uel0309' then
                --table.insert(self.engineers, unitBeingBuilt)
                self:ForkThread(
                    function()       
                        IssueClearCommands({unitBeingBuilt})
                        self.MookBuild(self, aiBrain, unitBeingBuilt, 'ueb4301')
                        for i = 1, 40 do     
                            if unitBeingBuilt:CanBuild('xeb0204') then
                                self.MookBuild(self, aiBrain, unitBeingBuilt, 'xeb0204')
                            else
                                self.MookBuild(self, aiBrain, unitBeingBuilt, 'xeb0104')
                            end
                        end   
                        IssueGuard({unitBeingBuilt}, self)
                    end
                )  
            end
            aiBrain:BuildUnit(self, self.ChooseExpimental(self), 1)
        end
    end,
    
    --The AI ignores this bit when it is important. Or rather, cancels the orders.
    MookBuild = function(self, aiBrain, mook, building)   
        local pos = self:GetPosition()  
        local bp = self:GetBlueprint()
        
        local x = bp.Physics.SkirtSizeX / 2 + (math.random(1,5)*2)
        local z = bp.Physics.SkirtSizeZ / 2 + (math.random(1,5)*2)
        local sign = -1 + 2 * math.random(0, 1)     
        local BuildGoalX = 0
        local BuildGoalZ = 0       
        if math.random(0, 1) > 0 then
            BuildGoalX = sign * x
            BuildGoalZ = math.random(math.ceil(-z/2),math.ceil(z/2))*2
        else
            BuildGoalX = math.random(math.ceil(-x/2),math.ceil(x/2))*2
            BuildGoalZ = sign * z
        end 
        aiBrain:BuildStructure(mook, building, {pos[1]+BuildGoalX, pos[3]+BuildGoalZ, 0})
    end,
    
    ChooseExpimental = function(self)  
        local bpAirExp = self:GetBlueprint().AI.Experimentals.Air
        local bpOtherExp = self:GetBlueprint().AI.Experimentals.Other
        if not self.ExpIndex then self.ExpIndex = {math.random(1, table.getn(bpAirExp)),math.random(1, table.getn(bpOtherExp)),} end
    
        if not self.togglebuild then
            for i=1,2 do
                for i, v in bpAirExp do
                    if self.ExpIndex[1] <= i then
                        --LOG('Current cycle = ', v[1])  
                        if not bpAirExp[i+1] then
                            self.ExpIndex[1] = 1
                        else
                            self.ExpIndex[1] = i + 1
                        end
                        if self:CanBuild(v[1]) then   
                            self.togglebuild = true
                            self.Lastbuilt = v[1]    
                            --LOG('Returning air chosen = ', v[1])  
                            return v[1]
                        end
                    end
                end
            end
            --only reaches here if it can't build any air experimentals   
            self.togglebuild = true
            --LOG('Gantry failed to find experimental fliers')
        end
        if self.togglebuild then          
            for i=1,2 do
                for i, v in bpOtherExp do
                    if self.ExpIndex[2] <= i then   
                        --LOG('Current cycle = ', v[1])  
                        if not bpOtherExp[i+1] then
                            self.ExpIndex[2] = 1
                        else
                            self.ExpIndex[2] = i + 1
                        end
                        if self:CanBuild(v[1]) then   
                            self.togglebuild = false
                            self.Lastbuilt = v[1]       
                            --LOG('Returning land chosen= ', v[1])  
                            return v[1]
                        end
                    end
                end
            end 
            --Only reaches this if it can't build any non-fliers
            self.togglebuild = false    
            --LOG('Gantry failed to find non-flying experimentals')  
        end
        --Attempts last successfull experimental, probably air at this point
        if self.Lastbuilt then       
            --LOG('Returning last built = ', self.Lastbuilt)  
            return self.Lastbuilt   
        --If nothing else works, flip a coin and build an ASF or a bomber
        elseif self:CanBuild('uea0303') and self:CanBuild('uea0304') then
            if math.random(1,2) == 1 then
                return 'uea0303'
            else
                return 'uea0304'
            end 
        --Are air and experimentals off?
        elseif self:CanBuild('XEL0305') then
            return 'XEL0305'
        --Is T3 off? Fuck it. Mech Marines.
        elseif self:CanBuild('UEL0106') then
            return 'UEL0106'
        end
    end,
    
--------------------------------------------------------------------------------
-- AI Cheats
--------------------------------------------------------------------------------   
                   
    AIxCheats = function(self)       
        local aiBrain = self:GetAIBrain()
        if aiBrain.BrainType != 'Human' then
            self:SetBuildRate( self:GetBlueprint().Economy.BuildRate * 2.5 )  
        end
    end,
    
--------------------------------------------------------------------------------
-- UI buildmode change function
-------------------------------------------------------------------------------- 
 
    BuildModeChange = function(self, mode)   
        self:RestoreBuildRestrictions()                                                               
        ------------------------------------------------------------------------
        -- The "Stolen tech" clause
        ------------------------------------------------------------------------     
        local aiBrain = self:GetAIBrain()        
        local engineers = aiBrain:GetUnitsAroundPoint(categories.ENGINEER, self:GetPosition(), 30, 'Ally' )
        local stolentech = {}
        stolentech.CYBRAN = false
        stolentech.AEON = false
        stolentech.SERAPHIM = false
        for k, v in engineers do
            if EntityCategoryContains(categories.TECH3, v) then
                for race, val in stolentech do
                    if EntityCategoryContains(ParseEntityCategory(race), v) then
                        stolentech[race] = true
                    end
                end
            end 
        end
        for race, val in stolentech do
            if not val then
                self:AddBuildRestriction(categories[race])
            end
        end                                                    
        ------------------------------------------------------------------------
        -- Human UI air/other switch
        ------------------------------------------------------------------------
        if aiBrain.BrainType == 'Human' then
            if self.airmode then
                self:AddBuildRestriction(categories.NAVAL)
                self:AddBuildRestriction(categories.MOBILESONAR)
                self:AddBuildRestriction(categories.LAND - categories.ENGINEER)
            else   
                if self:GetCurrentLayer() == 'Land' then
                    self:AddBuildRestriction(categories.NAVAL)    
                    self:AddBuildRestriction(categories.MOBILESONAR)
                elseif self:GetCurrentLayer() == 'Water' then
                    self:AddBuildRestriction(categories.LAND - categories.ENGINEER)
                end  
                self:AddBuildRestriction(categories.AIR)
            end
        ------------------------------------------------------------------------
        -- AI functional restrictions (allows easier AI control)
        ------------------------------------------------------------------------
        else
            if self:GetCurrentLayer() == 'Land' then
                self:AddBuildRestriction(categories.NAVAL) 
                self:AddBuildRestriction(categories.MOBILESONAR)
            elseif self:GetCurrentLayer() == 'Water' then
                self:AddBuildRestriction(categories.LAND - categories.ENGINEER)
                self:AddBuildRestriction(categories.ues0401)
            end  
        end 
        self:RequestRefreshUI()
    end,
    
--------------------------------------------------------------------------------
-- Animations
--------------------------------------------------------------------------------  

    StartBuildFx = function(self, unitBeingBuilt)
        if not unitBeingBuilt then
            unitBeingBuilt = self:GetFocusUnit()
        end
        --Start build process
        if not self.BuildAnimManip then
            self.BuildAnimManip = CreateAnimator(self)
            self.BuildAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationBuild, true):SetRate(0)
            self.Trash:Add(self.BuildAnimManip)
        end
        self.BuildAnimManip:SetRate(1)
    end,
    
    StopBuildFx = function(self)
        if self.BuildAnimManip then
            self.BuildAnimManip:SetRate(0)
        end
    end,
    
    
    DeathThread = function(self, overkillRatio, instigator) 
        for i = 1, 8 do
            local r = 1 - 2 * math.random(0,1)
            local a = 'ArmA_00' .. i
            local b = 'ArmB_00' .. i
            local c = 'ArmC_00' .. i
            local d = 'Nozzle_00' .. i
            self:ForkThread(self.Flailing, a, math.random(10,20), 'z', r)
            self:ForkThread(self.Flailing, b, math.random(25,45), 'x', r)
            self:ForkThread(self.Flailing, c, math.random(30,45), 'x', r)
            self:ForkThread(self.Flailing, d, math.random(35,45), 'x', r)
        end
        TLandFactoryUnit.DeathThread(self, overkillRatio, instigator)
    end,
    
    Flailing = function(self, bone, a, d, r)     
        local rotator = CreateRotator(self, bone, d) 
        self.Trash:Add(rotator)    
        rotator:SetGoal(a*r)
        local b = a*5
        local c = a*15
        rotator:SetSpeed(math.random(b,c)) 
        WaitFor(rotator)
        local m = 1
        local l = (a+a)*(r*-1)
        local i = (a+a)*r
        while true do 
            local f = math.random(b*m,c*m)          
            m = m + (math.random(1,2)/10)
            rotator:SetGoal(l)
            rotator:SetSpeed(f)
            WaitFor(rotator)   
            rotator:SetGoal(i)
            rotator:SetSpeed(f)
            if f > 1000 then
                self.effects = {
                    '/effects/emitters/terran_bomber_bomb_explosion_06_emit.bp',
                    '/effects/emitters/flash_05_emit.bp',
                    '/effects/emitters/destruction_explosion_fire_01_emit.bp',
                    '/effects/emitters/destruction_explosion_fire_plume_01_emit.bp',
                }
                for k, v in self.effects do  
                    CreateEmitterAtBone(self, bone, self:GetArmy(), v)
                end    
                self:Fling(bone, f) 
                f = 0
            end
            WaitFor(rotator)
        end
    end,
    
    Fling = function(self, bone)
        --[[
        local spinner = CreateRotator()
        self.detector = CreateCollisionDetector(self)
        self.Trash:Add(self.detector)
        self.detector:WatchBone(bone)
        self.detector:EnableTerrainCheck(true)
        self.detector:Enable()
        --]]      
        self:HideBone(bone, true)
    end, 
    --[[
    OnAnimTerrainCollision = function(self, bone,x,y,z)
        DamageArea(self, {x,y,z}, 1, 250, 'Default', true, false)
        explosion.CreateDefaultHitExplosionAtBone( self, bone, 1.0 )
        explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), {self:GetUnitSizes()})
    end,
    --]]
}

TypeClass = SEB0401