--+-----------------------------------------------------------------------------
--|
--|   Summary: Allows the Gantry and heavy walls to build units built like buildings usually.
--|   Author: Balthassar
--|
--+-----------------------------------------------------------------------------
local VersionIsSC = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/legacy/VersionCheck.lua').VersionIsSC()
do
    if not VersionIsSC then --If not original Steam SupCom
        local OldOnClickHandler = OnClickHandler
        function OnClickHandler(button, modifiers, ...)
            local item = button.Data
            local changeclick = false
            for i,v in sortedOptions.selection do
                if EntityCategoryContains(categories.GANTRY, v) or EntityCategoryContains(categories.HEAVYWALL, v) or EntityCategoryContains(categories.MEDIUMWALL, v) then
                    changeclick = true
                elseif EntityCategoryContains(categories.MOBILEBUILDERONLY, v) then
                    local blueprint = __blueprints[item.id]
                    local count = 1
                    local performUpgrade = false
                    local buildCmd = "build"
                    import('/lua/ui/game/commandmode.lua').StartCommandMode(buildCmd, {name=item.id})
                end
            end
            if changeclick then
                local blueprint = __blueprints[item.id]
                local count = 1
                local performUpgrade = false
                local buildCmd = "build"

                if modifiers.Ctrl or modifiers.Shift then
                    count = 5
                end
                if item.type == 'item' then
                    if modifiers.Left then
                        PlaySound(Sound({Cue = "UI_MFD_Click", Bank = "Interface"}))
                        ClearBuildTemplates()
                        if blueprint.General.UpgradesFrom == 'none' then
                            performUpgrade = false
                        else
                            for i,v in sortedOptions.selection do
                                if v then   --it's possible that your unit will have died by the time this gets to it
                                    local unitBp = v:GetBlueprint()
                                    if blueprint.General.UpgradesFrom == unitBp.BlueprintId then
                                        performUpgrade = true
                                    elseif blueprint.General.UpgradesFrom == unitBp.General.UpgradesTo then
                                        performUpgrade = true
                                    elseif blueprint.General.UpgradesFromBase != "none" then
                                        --try testing against the base
                                        if blueprint.General.UpgradesFromBase == unitBp.BlueprintId then
                                            performUpgrade = true
                                        elseif blueprint.General.UpgradesFromBase == unitBp.General.UpgradesFromBase then
                                            performUpgrade = true
                                        end
                                    end
                                end
                            end
                        end

                        if performUpgrade then
                            IssueBlueprintCommand("UNITCOMMAND_Upgrade", item.id, 1, false)
                        else
                            IssueBlueprintCommand("UNITCOMMAND_BuildFactory", item.id, count)
                        end
                    else
                        OldOnClickHandler(button, modifiers, unpack(arg))
                    end
                elseif item.type == 'queuestack' then
                    OldOnClickHandler(button, modifiers, unpack(arg))
                elseif item.type == 'unitstack' then
                    OldOnClickHandler(button, modifiers, unpack(arg))
                elseif item.type == 'attachedunit' then
                    OldOnClickHandler(button, modifiers, unpack(arg))
                elseif item.type == 'templates' then
                    OldOnClickHandler(button, modifiers, unpack(arg))
                elseif item.type == 'enhancement' then
                    OldOnClickHandler(button, modifiers, unpack(arg))
                end
            else
                OldOnClickHandler(button, modifiers, unpack(arg))
            end
        end
    elseif VersionIsSC then
        ------------------------------------------------------------------------------------------------------------------------------------------------
        -- LEGACY CRAP HO!                                                                                                                            --
        ------------------------------------------------------------------------------------------------------------------------------------------------
        --I was going to do the thing for original SC, but the UI code is absolute ass                                                                --
        --So I'm just going to shadow it instead and not bother working out the 'best-practice' way                                                   --
        ------------------------------------------------------------------------------------------------------------------------------------------------
        function CreateBuildableButton(parent, blueprintId, blueprint, unitList)                                                                      --
            local iconName, upIconName, downIconName, overIconName = GameCommon.GetCachedUnitIconFileNames(blueprint)                                 --
            local bg = Group(parent)                                                                                                                  --
            bg.Width:Set(GameCommon.iconBmpWidth)                                                                                                     --
            bg.Height:Set(GameCommon.iconBmpHeight)                                                                                                   --
            local button = Button(bg, upIconName, downIconName, overIconName, upIconName, 'UI_Opt_Mini_Button_Click', 'UI_Opt_Mini_Button_Over')      --
            button:UseAlphaHitTest(false)                                                                                                             --
            local selectedUnits = unitList                                                                                                            --
            button.Top:Set(bg.Top)                                                                                                                    --
            button.Left:Set(function() return bg.Left() + 1 end)                                                                                      --
            if layoutVar == 'minimal' then                                                                                                            --
                button.Height:Set(48)                                                                                                                 --
                button.Width:Set(48)                                                                                                                  --
            end                                                                                                                                       --
            button._blueprintId = blueprintId                                                                                                         --
            if newTechUnits and table.find(newTechUnits, blueprintId) then                                                                            --
                table.remove(newTechUnits, table.find(newTechUnits, blueprintId))                                                                     --
                button.NewInd = Bitmap(button, UIUtil.UIFile('/game/selection/selection_brackets_player_highlighted.dds'))                            --
                button.NewInd.Height:Set(80)                                                                                                          --
                button.NewInd.Width:Set(80)                                                                                                           --
                LayoutHelpers.AtCenterIn(button.NewInd, button)                                                                                       --
                button.NewInd:DisableHitTest()                                                                                                        --
                button.NewInd.Incrementing = false                                                                                                    --
                button.NewInd:SetNeedsFrameUpdate(true)                                                                                               --
                button.NewInd.OnFrame = function(self, delta)                                                                                         --
                    local newAlpha = self:GetAlpha() - delta / 5                                                                                      --
                    if newAlpha < 0 then                                                                                                              --
                        self:SetAlpha(0)                                                                                                              --
                        self:SetNeedsFrameUpdate(false)                                                                                               --
                        return                                                                                                                        --
                    else                                                                                                                              --
                        self:SetAlpha(newAlpha)                                                                                                       --
                    end                                                                                                                               --
                    if self.Incrementing then                                                                                                         --
                        local newheight = self.Height() + delta * 100                                                                                 --
                        if newheight > 80 then                                                                                                        --
                            self.Height:Set(80)                                                                                                       --
                            self.Width:Set(80)                                                                                                        --
                            self.Incrementing = false                                                                                                 --
                        else                                                                                                                          --
                            self.Height:Set(newheight)                                                                                                --
                            self.Width:Set(newheight)                                                                                                 --
                        end                                                                                                                           --
                    else                                                                                                                              --
                        local newheight = self.Height() - delta * 100                                                                                 --
                        if newheight < 50 then                                                                                                        --
                            self.Height:Set(50)                                                                                                       --
                            self.Width:Set(50)                                                                                                        --
                            self.Incrementing = true                                                                                                  --
                        else                                                                                                                          --
                            self.Height:Set(newheight)                                                                                                --
                            self.Width:Set(newheight)                                                                                                 --
                        end                                                                                                                           --
                    end                                                                                                                               --
                end                                                                                                                                   --
            end                                                                                                                                       --
            if (blueprint.StrategicIconName) then                                                                                                     --
                if DiskGetFileInfo(UIUtil.UIFile("/game/strategicicons/" .. string.lower(blueprint.StrategicIconName) .. "_rest.dds")) then           --
                    button.Strat = Bitmap(button, UIUtil.UIFile("/game/strategicicons/" .. string.lower(blueprint.StrategicIconName) .. "_rest.dds")) --
                    button.Strat:DisableHitTest()                                                                                                     --
                    LayoutHelpers.AtRightTopIn(button.Strat, button, 2, 2)                                                                            --
                end                                                                                                                                   --
            end                                                                                                                                       --
            button.Glow = Bitmap(button)                                                                                                              --
            button.Glow:SetTexture(UIUtil.UIFile('/game/units_bmp/glow.dds'))                                                                         --
            LayoutHelpers.FillParent(button.Glow, button)                                                                                             --
            button.Glow:SetAlpha(0)                                                                                                                   --
            button.Incrementing = true                                                                                                                --
            button.Glow.OnFrame = function(self, elapsedTime)                                                                                         --
                local curAlpha = self:GetAlpha()                                                                                                      --
                if self.Incrementing then                                                                                                             --
                    curAlpha = curAlpha + (elapsedTime * GLOW_SPEED)                                                                                  --
                    if curAlpha > UPPER_GLOW_THRESHHOLD then                                                                                          --
                        curAlpha = UPPER_GLOW_THRESHHOLD                                                                                              --
                        self.Incrementing = false                                                                                                     --
                    end                                                                                                                               --
                else                                                                                                                                  --
                    curAlpha = curAlpha - (elapsedTime * GLOW_SPEED)                                                                                  --
                    if curAlpha < LOWER_GLOW_THRESHHOLD then                                                                                          --
                        curAlpha = LOWER_GLOW_THRESHHOLD                                                                                              --
                        self.Incrementing = true                                                                                                      --
                    end                                                                                                                               --
                end                                                                                                                                   --
                self:SetAlpha(curAlpha)                                                                                                               --
            end                                                                                                                                       --
            local unitBuildKeys = import('/lua/ui/game/buildmode.lua').GetUnitKeys(selectedUnits[1]:GetBlueprint().BlueprintId, GetCurrentTechTab())  --
            if unitBuildKeys and unitBuildKeys[blueprint.BlueprintId] then                                                                            --
                button.KeyBG = Bitmap(button)                                                                                                         --
                button.KeyBG:SetSolidColor('AA000000')                                                                                                --
                button.KeyBG.Height:Set(function() return button.Height() / 2 end)                                                                    --
                button.KeyBG.Width:Set(function() return button.Width() / 2 end)                                                                      --
                button.KeyBG.Right:Set(button.Right)                                                                                                  --
                button.KeyBG.Bottom:Set(button.Bottom)                                                                                                --
                button.KeyBG.Depth:Set(function() return button.Glow.Depth() + 1 end)                                                                 --
                button.Key = UIUtil.CreateText(button.KeyBG, unitBuildKeys[blueprint.BlueprintId], 18, "Arial")                                       --
                LayoutHelpers.AtCenterIn(button.Key, button.KeyBG)                                                                                    --
                button.Key:SetColor('ffff9900')                                                                                                       --
                button.KeyBG:DisableHitTest(true)                                                                                                     --
                button.KeyBG:Hide()                                                                                                                   --
                button.KeyBG.OnHide = function(self)                                                                                                  --
                    if import('/lua/ui/game/buildmode.lua').IsInBuildMode() then                                                                      --
                        return false                                                                                                                  --
                    else                                                                                                                              --
                        return true                                                                                                                   --
                    end                                                                                                                               --
                end                                                                                                                                   --
            end                                                                                                                                       --
            button.OnClick = function(self, modifiers)                                                                                                --
                local blueprint = __blueprints[self._blueprintId]                                                                                     --
                local count = 1                                                                                                                       --
                local performUpgrade = false                                                                                                          --
                local buildCmd = "build"                                                                                                              --
                selectedwhatIfBuilder = whatIfBuilder                                                                                                 --
                selectedwhatIfBlueprintID = whatIfBlueprintID                                                                                         --
                if modifiers.Left then                                                                                                                --
                    if modifiers.Ctrl == true and modifiers.Shift == nil then                                                                         --
                        count = 5                                                                                                                     --
                    elseif modifiers.Shift == true and modifiers.Ctrl == nil then                                                                     --
                        count = 5                                                                                                                     --
                    elseif modifiers.Shift == true and modifiers.Ctrl == true then                                                                    --
                        count = 5                                                                                                                     --
                    end                                                                                                                               --
                    -- see if we are issuing an upgrade order                                                                                         --
                    if blueprint.General.UpgradesFrom == 'none' then                                                                                  --
                        performUpgrade = false                                                                                                        --
                    else                                                                                                                              --
                        for i,v in selectedUnits do                                                                                                   --
                            if v then   -- it's possible that your unit will have died by the time this gets to it                                    --
                                local unitBp = v:GetBlueprint()                                                                                       --
                                if blueprint.General.UpgradesFrom == unitBp.BlueprintId then                                                          --
                                    performUpgrade = true                                                                                             --
                                elseif blueprint.General.UpgradesFrom == unitBp.General.UpgradesTo then                                               --
                                    performUpgrade = true                                                                                             --
                                elseif blueprint.General.UpgradesFromBase != "none" then                                                              --
                                    -- try testing against the base                                                                                   --
                                    if blueprint.General.UpgradesFromBase == unitBp.BlueprintId then                                                  --
                                        performUpgrade = true                                                                                         --
                                    elseif blueprint.General.UpgradesFromBase == unitBp.General.UpgradesFromBase then                                 --
                                        performUpgrade = true                                                                                         --
                                    end                                                                                                               --
                                end                                                                                                                   --
                            end                                                                                                                       --
                        end                                                                                                                           --
                    end                                                                                                                               --
                    if performUpgrade then                                                                                                            --
                        -- if the item to build is an upgrade.. then issue the upgrade command                                                        --
                        local clear = false                                                                                                           --
                        IssueBlueprintCommand("UNITCOMMAND_Upgrade", self._blueprintId, 1, clear)                                                     --
                    else                                                                                                                              --
                        --------------------------------------------------------------------------------------------------------------------------------
                        -- IMPORTANT PART OF THE LEGACY CRAP                                                                                          --
                        --------------------------------------------------------------------------------------------------------------------------------
                        local OverrideBuild = false
                        for i, v in selectedUnits do
                            if
                              EntityCategoryContains(categories.GANTRY, v)
                            or
                              EntityCategoryContains(categories.HEAVYWALL, v)
                            or
                              EntityCategoryContains(categories.MEDIUMWALL, v)
                            then
                                OverrideBuild = true
                                break
                            elseif EntityCategoryContains(categories.MOBILEBUILDERONLY, v) then
                                OverrideBuild = 'Command'
                                break
                            end
                        end
                        if
                          not OverrideBuild
                          and
                          (blueprint.Physics.MotionType == 'RULEUMT_None' or EntityCategoryContains(categories.NEEDMOBILEBUILD, self._blueprintId))
                        or
                          OverrideBuild == 'Command'
                        then
        					       import('/lua/ui/game/commandmode.lua').StartCommandMode(buildCmd, {name=self._blueprintId})
                        else
                            IssueBlueprintCommand("UNITCOMMAND_BuildFactory", self._blueprintId, count)
                        end
                        --------------------------------------------------------------------------------------------------------------------------------
                        -- END OF IMPORTANT PART OF THE LEGACY CRAP                                                                                   --
                        --------------------------------------------------------------------------------------------------------------------------------
                    end                                                                                                                               --
                else                                                                                                                                  --
                    import('/lua/ui/game/queue.lua').RemovedLastQueuedUnit(self._blueprintId)                                                         --
                end                                                                                                                                   --
            end                                                                                                                                       --
            button.HandleEvent = function(self, event)                                                                                                --
                if event.Type == 'MouseEnter' then                                                                                                    --
                    self.Glow:SetNeedsFrameUpdate(true)                                                                                               --
                    self.Glow:SetAlpha(LOWER_GLOW_THRESHHOLD)                                                                                         --
                    local blueprint = __blueprints[self._blueprintId]                                                                                 --
                    local builder = unitList[1]                                                                                                       --
                    whatIfBuilder = builder                                                                                                           --
                    whatIfBlueprintID = self._blueprintId                                                                                             --
                    Tooltip.CreateMouseoverDisplay(self, blueprint.Description)                                                                       --
                    import('/lua/ui/game/unitviewDetail.lua').Show(blueprint, builder, self._blueprintId)                                             --
                end                                                                                                                                   --
                if event.Type == 'MouseExit' then                                                                                                     --
                    self.Glow:SetNeedsFrameUpdate(false)                                                                                              --
                    self.Glow:SetAlpha(0)                                                                                                             --
                    whatIfBuilder = nil                                                                                                               --
                    whatIfBlueprintID = nil                                                                                                           --
                    Tooltip.DestroyMouseoverDisplay()                                                                                                 --
                    import('/lua/ui/game/unitviewDetail.lua').Hide()                                                                                  --
                end                                                                                                                                   --
                Button.HandleEvent(self, event)                                                                                                       --
            end                                                                                                                                       --
            bg.button = button                                                                                                                        --
            return bg                                                                                                                                 --
        end                                                                                                                                           --
        ------------------------------------------------------------------------------------------------------------------------------------------------
        -- END OF LEGACY CRAP                                                                                                                         --
        ------------------------------------------------------------------------------------------------------------------------------------------------
    end
end
