--------------------------------------------------------------------------------
-- YOU SEE IVAN, WHEN GUN FIRE SMALLER GUN
--------------------------------------------------------------------------------
local TStructureUnit = import('/lua/terranunits.lua').TLandFactoryUnit
local TIFArtilleryWeapon = import('/lua/terranweapons.lua').TIFArtilleryWeapon
local Buff = import(import( '/lua/game.lua' ).BrewLANPath .. '/lua/legacy/VersionCheck.lua').Buff

if __blueprints.seb2404.Economy.BuilderDiscountMult
and __blueprints.seb2404.Economy.BuilderDiscountMult ~= 1
and not Buffs['IvanHealthBuff'] then
    BuffBlueprint {
        Name = 'IvanHealthBuff',
        DisplayName = 'IvanHealthBuff',
        BuffType = 'IvanHealthBuff',
        Stacks = 'ALWAYS',
        Duration = -1,
        Affects = {
            MaxHealth = {Add = 0, Mult = __blueprints.seb2404.Economy.BuilderDiscountMult},
        },
    }
end
--local DummyStorage = {}--This is populated whenever any player builds an Ivan for the first time.
--I didn't want to deal with issues regarding players dying, although I also never tested shared storage for that same reason.

SEB2404 = Class(TStructureUnit) {

    Weapons = {
        MainGun = Class(TIFArtilleryWeapon) {
            FxMuzzleFlashScale = 3,

            RackSalvoFireReadyState = State(TIFArtilleryWeapon.RackSalvoFireReadyState) {
                Main = function(self)
                    self.WeaponCanFire = false
                    self.unit:SetBusy(false)
                    while not self.unit.AmmoList[1] do
                        coroutine.yield(5)
                    end
                    --A wait for would be better here
                    self.unit:SetBusy(true)
                    --self.WeaponCanFire = true
                    TIFArtilleryWeapon.RackSalvoFireReadyState.Main(self)
                end,
            },

            CreateProjectileAtMuzzle = function(self, muzzle)
                local proj = TIFArtilleryWeapon.CreateProjectileAtMuzzle(self, muzzle)
                local data = false
                local Cargo = self.unit.AmmoList
                if Cargo[1] then
                    local num = table.getn(Cargo)
                    data = Cargo[num]
                    table.remove(self.unit.AmmoList,num)
                end
                self.unit:HideBone('DropPod', true)
                if proj and not proj:BeenDestroyed() then
                    data:DetachFrom(true)
                    if data:ShieldIsOn() and not data:GetBlueprint().Defense.Shield.PersonalShield then
                        data:DisableShield()
                        data:DisableDefaultToggleCaps()
                    end

                    data:AttachBoneTo(0, proj, 1)
                    proj:PassData(data)
                end
                self.unit:AmmoStackThread()
            end,
        },
    },

    OnCreate = function(self)
        TStructureUnit.OnCreate(self)
        self:HideBone('DropPod', true)
        self.DropPod0Slider = CreateSlider(self, 'DropPod', 0, 0, 55, 100)
        --self:RemoveCommandCap('RULEUCC_Transport')
    end,

    OnPaused = function(self)
        TStructureUnit.OnPaused(self)
        --When factory is paused take some action
        self:StopUnitAmbientSound( 'ConstructLoop' )
    end,

    OnUnpaused = function(self)
        TStructureUnit.OnUnpaused(self)
        if self.UnitBeingBuilt then
            self:PlayUnitAmbientSound( 'ConstructLoop' )
        end
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        local army = self:GetArmy()
        --if not DummyStorage[army] then
        --    DummyStorage[army] = CreateUnitHPR('seb2404_storage', army, -1, -1, -1, 0, 0, 0)
        --end
        self.AmmoList = {}
        TStructureUnit.OnStopBeingBuilt(self, builder, layer)
        --CreateSlider(unit, bone, [goal_x, goal_y, goal_z, [speed,
        CreateSlider(self, 'AmmoExtender', 0, 0, 110, 100)
        ChangeState(self, self.IdleState)
    end,

    OnFailedToBuild = function(self)
        TStructureUnit.OnFailedToBuild(self)
        self:AmmoStackThread()
        ChangeState(self, self.IdleState)
    end,

    BuildAttachBone = 'DropPod',

    IdleState = State {
        Main = function(self)
            self:DetachAll(self.BuildAttachBone)
            self:SetBusy(false)
        end,

        OnStartBuild = function(self, unitBuilding, order)
            TStructureUnit.OnStartBuild(self, unitBuilding, order)
            self.UnitBeingBuilt = unitBuilding
            --self:ChangeBlinkingLights('Yellow')
            ChangeState(self, self.BuildingState)
        end,
    },

    BuildingState = State {
        Main = function(self)
            self:SetBusy(true)
            self.DropPod0Slider:SetGoal(0,0,50)

            if Buffs['IvanHealthBuff'] then
                Buff.ApplyBuff(self.UnitBeingBuilt, 'IvanHealthBuff')
            end
            self.UnitBeingBuilt:AttachBoneTo(0, self, self.BuildAttachBone)
            --self:DetachAll('DropPod')
            self.UnitBeingBuilt:HideBone(0, true)
        end,

        OnStopBuild = function(self, unitBeingBuilt, order )
            TStructureUnit.OnStopBuild(self, unitBeingBuilt, order )
            --ChangeState(self, self.FinishedBuildingState)
            self:ForkThread(self.FinishBuildThread, unitBeingBuilt, order )
        end,
    },

    FinishBuildThread = function(self, unitBeingBuilt, order )
        --This thread triggers twice for whatever reason
        --unitBeingBuilt:DetachFrom(true)
        if self.UnitBeingBuilt then
            self.UnitBeingBuilt = nil
            --self:SetBusy(true)
            if self:TransportHasAvailableStorage() then
                self:DetachAll(self.BuildAttachBone)
                --coroutine.yield(1) -- this is needed if it's being added to storage
                table.insert(self.AmmoList, unitBeingBuilt)
                unitBeingBuilt:AttachBoneTo(0, self, 'DropPod001')
                unitBeingBuilt:OnAddToStorage(self)
                unitBeingBuilt:DisableIntel('Vision')
                --self:AddUnitToStorage(unitBeingBuilt)
                --DummyStorage[self:GetArmy()]:AddUnitToStorage(unitBeingBuilt)
            else
                local worldPos = self:CalculateWorldPositionFromRelative({0, 0, -20})
                IssueMoveOffFactory({unitBeingBuilt}, worldPos)
                unitBeingBuilt:ShowBone(0,true)
            end
        end
        self:SetBusy(false)
        self:AmmoStackThread()
        self:RequestRefreshUI()
        ChangeState(self, self.IdleState)
    end,

    OnTransportDetach = function(self, attachBone, unit)
        TStructureUnit.OnTransportDetach(self, attachBone, unit)
        local x, y, z = unit:GetPositionXYZ()
        self:ForkThread(function()
            coroutine.yield(1)
            if unit then
                Warp(unit, {x, y, z})
            end
        end)
        unit:OnRemoveFromStorage(self)
        unit:EnableIntel('Vision')
        table.removeByValue(self.AmmoList, unit)
        self:AmmoStackThread()
    end,

    AmmoStackThread = function(self)
        local ammocount = table.getn(self.AmmoList)
        if not self.AmmoStackGoals then
            self.AmmoStackGoals = {
                ["DropPod001"] = 55,
                ["DropPod002"] = 110,
                ["DropPod003"] = 165,
            }
            self.AmmoSliders = {}
            for k, v in self.AmmoStackGoals do
                self.AmmoSliders[k] = CreateSlider(self, k, 0, 0, v, 100)
            end
        end
        for k, v in self.AmmoSliders do
            v:SetGoal(0,0,self.AmmoStackGoals[k] - math.min(ammocount, 4) * 55)
        end
        if ammocount > 0 then
            self:ShowBone('DropPod', true)
            self.DropPod0Slider:SetGoal(0,0,0)
        elseif ammocount == 0 then
            self.DropPod0Slider:SetGoal(0,0,50)
        end
        self:LCDUpdate(ammocount)
    end,

    LCDUpdate = function(self, ammocount)
          ---7---
        --       --
        --2      --4
        --       --
          ---6---
        --       --
        --1      --3
        --       --
          ---5---
        if not self.LCD then
            self.LCD = {
                [1] = {
                    {[1] = "LCD001", [2] = true,},
                    {[1] = "LCD002", [2] = true,},
                    {[1] = "LCD003", [2] = true,},
                    {[1] = "LCD004", [2] = true,},
                    {[1] = "LCD005", [2] = true,},
                    {[1] = "LCD006", [2] = true,},
                    {[1] = "LCD007", [2] = true,},
                },
                [2] = {
                    {[1] = "LCD008", [2] = true,},
                    {[1] = "LCD009", [2] = true,},
                    {[1] = "LCD010", [2] = true,},
                    {[1] = "LCD011", [2] = true,},
                    {[1] = "LCD012", [2] = true,},
                    {[1] = "LCD013", [2] = true,},
                    {[1] = "LCD014", [2] = true,},
                },
                [3] = {
                    {[1] = "LCD015", [2] = true,},
                    {[1] = "LCD016", [2] = true,},
                    {[1] = "LCD017", [2] = true,},
                    {[1] = "LCD018", [2] = true,},
                    {[1] = "LCD019", [2] = true,},
                    {[1] = "LCD020", [2] = true,},
                    {[1] = "LCD021", [2] = true,},
                },
            }
            for k, v in self.LCD do
                for i, s in v do
                    s[3] = CreateSlider(self, s[1], 0, 0, 0, 100)
                end
            end
        end
        ammocount = math.min(999,ammocount)
        local units = ammocount - (math.floor(ammocount/10)*10)
        local tens = (math.floor(ammocount/10)) - (math.floor(ammocount/100)*10)
        local huns = (math.floor(ammocount/100)) - (math.floor(ammocount/1000)*100)
        self:LCDnumber(units, 3)
        self:LCDnumber(tens, 2)
        self:LCDnumber(huns, 1)
    end,

    LCDnumber = function(self, num, mag)
        local deees = {
          [1] = {0, 2, 6, 8,},
          [2] = {0, 4, 5, 6, 8, 9,},
          [3] = {0, 1, 3, 4, 5, 6, 7, 8, 9,},
          [4] = {0, 1, 2, 3, 4, 7, 8, 9},
          [5] = {0, 2, 3, 5, 6, 8, 9,},
          [6] = {2, 3, 4, 5, 6, 8, 9,},
          [7] = {0, 2, 3, 5, 6, 7, 8, 9,},
        }
        for k, v in deees do
            for i, s in v do
                if num == s then
                    self.LCD[mag][k][2] = true
                    break
                else
                    self.LCD[mag][k][2] = false
                end
            end
        end

        --self:tprint(self.LCD)
        for k, v in self.LCD do
            for i, s in v do
                if s[2] then
                    s[3]:SetGoal(0,0,0)
                else
                    s[3]:SetGoal(0,0,-1)
                end
            end
        end
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        local pos = self:GetPosition()
        if self.AmmoList[1] then
            for k, v in self.AmmoList do
                v:DetachFrom(true)
                Warp(v, {pos[1] + math.random(-2,2), pos[2], pos[3] + math.random(-2,2)})
                local health = math.min(math.max((math.random(-300,100)/100)+(v:GetHealth()/4500),0),1) * math.min(math.random(0,120)/100,1)
                if health == 0 then
                    v:Kill()
                else
                    v:SetHealth(self,v:GetHealth()*health)
                    v:SetCanTakeDamage(true)
                    v:SetReclaimable(true)
                    v:SetCapturable(true)
                    v:MarkWeaponsOnTransport(v, false)
                end
                self.AmmoList[k] = nil
            end
        end
        TStructureUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    OnDestroy = function(self)
        if self.AmmoList[1] then
            for k, v in self.AmmoList do
                v:Destroy()
            end
        end
        TStructureUnit.OnDestroy(self)
    end,
}

TypeClass = SEB2404
