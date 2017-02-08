do
local OldCreateIdleTab = CreateIdleTab
local OldCreateIdleEngineerList = CreateIdleEngineerList

function CreateIdleTab(unitData, id, expandFunc, ...)
    if Factions[1].BrewLAN then -- If this exists assume BrewLAN is active.
        local bg = Bitmap(controls.avatarGroup, UIUtil.SkinnableFile('/game/avatar/avatar-s-e-f_bmp.dds'))
        bg.id = id
        bg.tooltipKey = 'mfd_idle_'..id

        bg.allunits = unitData
        bg.units = unitData

        bg.icon = Bitmap(bg)
        LayoutHelpers.AtLeftTopIn(bg.icon, bg, 7, 8)
        bg.icon:SetSolidColor('00000000')
        bg.icon.Height:Set(34)
        bg.icon.Width:Set(34)
        bg.icon:DisableHitTest()

        bg.count = UIUtil.CreateText(bg.icon, '', 18, UIUtil.bodyFont)
        bg.count:DisableHitTest()
        bg.count:SetDropShadow(true)
        LayoutHelpers.AtBottomIn(bg.count, bg.icon)
        LayoutHelpers.AtRightIn(bg.count, bg.icon)

        bg.expandCheck = Checkbox(bg,
            UIUtil.SkinnableFile('/game/avatar-arrow_btn/tab-open_btn_up.dds'),
            UIUtil.SkinnableFile('/game/avatar-arrow_btn/tab-close_btn_up.dds'),
            UIUtil.SkinnableFile('/game/avatar-arrow_btn/tab-open_btn_over.dds'),
            UIUtil.SkinnableFile('/game/avatar-arrow_btn/tab-close_btn_over.dds'),
            UIUtil.SkinnableFile('/game/avatar-arrow_btn/tab-open_btn_dis.dds'),
            UIUtil.SkinnableFile('/game/avatar-arrow_btn/tab-close_btn_dis.dds'))
        bg.expandCheck.Right:Set(function() return bg.Left() + 4 end)
        LayoutHelpers.AtVerticalCenterIn(bg.expandCheck, bg)
        bg.expandCheck.OnCheck = function(self, checked)
            if checked then
                if expandedCheck and expandedCheck != bg.id and GetCheck(expandedCheck) then
                    GetCheck(expandedCheck):SetCheck(false)
                end
                expandedCheck = bg.id
                self.expandList = expandFunc(self, bg.units)
            else
                expandedCheck = false
                if self.expandList then
                    self.expandList:Destroy()
                    self.expandList = nil
                end
            end
        end
        bg.curIndex = 1
        bg.HandleEvent = ClickFunc
        bg.Update = function(self, units)
            self.allunits = units
            self.units = {}
            if self.id == 'engineer' then
                local sortedUnits = {}
                sortedUnits[7] = EntityCategoryFilterDown(categories.SUBCOMMANDER, self.allunits)
                sortedUnits[6] = EntityCategoryFilterDown(categories.TECH3 * categories.FIELDENGINEER, self.allunits)
                sortedUnits[5] = EntityCategoryFilterDown(categories.TECH3 - categories.FIELDENGINEER - categories.SUBCOMMANDER, self.allunits)
                sortedUnits[4] = EntityCategoryFilterDown(categories.TECH2 * categories.FIELDENGINEER, self.allunits)
                sortedUnits[3] = EntityCategoryFilterDown(categories.TECH2 - categories.FIELDENGINEER, self.allunits)
                sortedUnits[2] = EntityCategoryFilterDown(categories.TECH1 * categories.FIELDENGINEER, self.allunits)
                sortedUnits[1] = EntityCategoryFilterDown(categories.TECH1 - categories.FIELDENGINEER, self.allunits)

                local keyToIcon = {'T1','T1F','T2','T2F','T3','T3F','SCU'}

                local i = table.getn(sortedUnits)
                local needIcon = true
                while i > 0 do
                    if table.getn(sortedUnits[i]) > 0 then
                        if needIcon then
                            if string.lower(string.sub(Factions[currentFaction].IdleEngTextures[keyToIcon[i]],1,7)) == '/icons/' then
                                self.icon:SetTexture('/textures/ui/common'..Factions[currentFaction].IdleEngTextures[keyToIcon[i]])
                            else
                                self.icon:SetTexture(Factions[currentFaction].IdleEngTextures[keyToIcon[i]])
                            end
                            needIcon = false
                        end
                        for _, unit in sortedUnits[i] do
                            table.insert(self.units, unit)
                        end
                    end
                    i = i - 1
                end
            elseif self.id == 'factory' then
                local categoryTable = {'LAND','AIR','NAVAL'}
                local sortedFactories = {}
                for i, cat in categoryTable do
                    sortedFactories[i] = {}
                    sortedFactories[i][1] = EntityCategoryFilterDown(categories.TECH1 * categories[cat], self.allunits)
                    sortedFactories[i][2] = EntityCategoryFilterDown(categories.TECH2 * categories[cat], self.allunits)
                    sortedFactories[i][3] = EntityCategoryFilterDown(categories.TECH3 * categories[cat], self.allunits)
                end

                local i = 3
                local needIcon = true
                while i > 0 do
                    for curCat = 1, 3 do
                        if table.getn(sortedFactories[curCat][i]) > 0 then
                            if needIcon then
                                if
                                  string.lower(string.sub(Factions[currentFaction].IdleFactoryTextures[categoryTable[curCat]][i],1,7)) == '/icons/'
                                and
                                  DiskGetFileInfo('/textures/ui/common'..Factions[currentFaction].IdleFactoryTextures[categoryTable[curCat]][i])
                                then
                                    self.icon:SetTexture('/textures/ui/common'..Factions[currentFaction].IdleFactoryTextures[categoryTable[curCat]][i])
                                elseif DiskGetFileInfo(Factions[currentFaction].IdleFactoryTextures[categoryTable[curCat]][i]) then
                                    self.icon:SetTexture(Factions[currentFaction].IdleFactoryTextures[categoryTable[curCat]][i])
                                else
                                    self.icon:SetTexture(UIUtil.UIFile('/icons/units/default_icon.dds'))
                                end
                                needIcon = false
                            end
                            for _, unit in sortedFactories[curCat][i] do
                                table.insert(self.units, unit)
                            end
                        end
                    end
                    i = i - 1
                end
            end
            self.count:SetText(table.getsize(self.allunits))

            if self.expandCheck.expandList then
                self.expandCheck.expandList:Update(self.allunits)
            end
        end

        return bg
    else
        return OldCreateIdleTab(unitData, id, expandFunc, unpack(arg) )
    end
end

function CreateIdleEngineerList(parent, units, ...)
    if Factions[1].BrewLAN then -- If this exists assume BrewLAN is active.
        local group = Group(parent)

        local bgTop = Bitmap(group, UIUtil.SkinnableFile('/game/avatar-engineers-panel/panel-eng_bmp_t.dds'))
        local bgBottom = Bitmap(group, UIUtil.SkinnableFile('/game/avatar-engineers-panel/panel-eng_bmp_b.dds'))
        local bgStretch = Bitmap(group, UIUtil.SkinnableFile('/game/avatar-engineers-panel/panel-eng_bmp_m.dds'))

        group.Width:Set(bgTop.Width)
        group.Height:Set(1)

        bgTop.Bottom:Set(group.Top)
        bgBottom.Top:Set(group.Bottom)
        bgStretch.Top:Set(group.Top)
        bgStretch.Bottom:Set(group.Bottom)

        LayoutHelpers.AtHorizontalCenterIn(bgTop, group)
        LayoutHelpers.AtHorizontalCenterIn(bgBottom, group)
        LayoutHelpers.AtHorizontalCenterIn(bgStretch, group)

        group.connector = Bitmap(group, UIUtil.SkinnableFile('/game/avatar-engineers-panel/bracket_bmp.dds'))
        group.connector.Right:Set(function() return parent.Left() + 8 end)
        LayoutHelpers.AtVerticalCenterIn(group.connector, parent)

        LayoutHelpers.LeftOf(group, parent, 10)
        group.Top:Set(function() return math.max(controls.avatarGroup.Top()+10, (parent.Top() + (parent.Height() / 2)) - (group.Height() / 2)) end)

        group:DisableHitTest(true)

        group.icons = {}

        group.Update = function(self, unitData)
            local function CreateUnitEntry(techLevel, userUnits, icontexture)
                local entry = Group(self)

                entry.icon = Bitmap(entry)
                if DiskGetFileInfo('/textures/ui/common'..icontexture) then
                    entry.icon:SetTexture('/textures/ui/common'..icontexture)
                elseif DiskGetFileInfo(icontexture) then
                    entry.icon:SetTexture(icontexture)
                else
                    entry.icon:SetTexture(UIUtil.UIFile('/icons/units/default_icon.dds'))
                end
                entry.icon.Height:Set(34)
                entry.icon.Width:Set(34)
                LayoutHelpers.AtRightIn(entry.icon, entry, 22)
                LayoutHelpers.AtVerticalCenterIn(entry.icon, entry)

                entry.iconBG = Bitmap(entry, UIUtil.SkinnableFile('/game/avatar-factory-panel/avatar-s-e-f_bmp.dds'))
                LayoutHelpers.AtCenterIn(entry.iconBG, entry.icon)
                entry.iconBG.Depth:Set(function() return entry.icon.Depth() - 1 end)

                entry.techIcon = Bitmap(entry, UIUtil.SkinnableFile('/game/avatar-engineers-panel/tech-'..techLevel..'_bmp.dds'))
                LayoutHelpers.AtLeftIn(entry.techIcon, entry)
                LayoutHelpers.AtVerticalCenterIn(entry.techIcon, entry.icon)

                entry.count = UIUtil.CreateText(entry, '', 20, UIUtil.bodyFont)
                entry.count:SetColor('ffffffff')
                entry.count:SetDropShadow(true)
                LayoutHelpers.AtRightIn(entry.count, entry.icon)
                LayoutHelpers.AtBottomIn(entry.count, entry.icon)

                entry.countBG = Bitmap(entry)
                entry.countBG:SetSolidColor('77000000')
                entry.countBG.Top:Set(function() return entry.count.Top() - 1 end)
                entry.countBG.Left:Set(function() return entry.count.Left() - 1 end)
                entry.countBG.Right:Set(function() return entry.count.Right() + 1 end)
                entry.countBG.Bottom:Set(function() return entry.count.Bottom() + 1 end)

                entry.countBG.Depth:Set(function() return entry.Depth() + 1 end)
                entry.count.Depth:Set(function() return entry.countBG.Depth() + 1 end)

                entry.Height:Set(function() return entry.iconBG.Height() end)
                entry.Width:Set(self.Width)

                entry.icon:DisableHitTest()
                entry.iconBG:DisableHitTest()
                entry.techIcon:DisableHitTest()
                entry.count:DisableHitTest()
                entry.countBG:DisableHitTest()

                entry.curIndex = 1
                entry.units = userUnits
                entry.HandleEvent = ClickFunc

                return entry
            end
            local engineers = {}

            engineers[7] = EntityCategoryFilterDown(categories.SUBCOMMANDER, unitData)
            engineers[6] = EntityCategoryFilterDown(categories.TECH3 * categories.FIELDENGINEER, unitData)
            engineers[5] = EntityCategoryFilterDown(categories.TECH3 - categories.FIELDENGINEER - categories.SUBCOMMANDER, unitData)
            engineers[4] = EntityCategoryFilterDown(categories.TECH2 * categories.FIELDENGINEER, unitData)
            engineers[3] = EntityCategoryFilterDown(categories.TECH2 - categories.FIELDENGINEER, unitData)
            engineers[2] = EntityCategoryFilterDown(categories.TECH1 * categories.FIELDENGINEER, unitData)
            engineers[1] = EntityCategoryFilterDown(categories.TECH1 - categories.FIELDENGINEER, unitData)

            local indexToIcon = {'1', '1', '2', '2', '3', '3', '3'}
            local keyToIcon = {'T1','T1F','T2','T2F','T3','T3F','SCU'}
            for index, units in engineers do
                local i = index
                if false then
                    continue
                end
                if not self.icons[i] then
                    self.icons[i] = CreateUnitEntry(indexToIcon[i], units, Factions[currentFaction].IdleEngTextures[keyToIcon[index]])
                    self.icons[i].priority = i
                end
                if table.getn(units) > 0 and not self.icons[i]:IsHidden() then
                    self.icons[i].units = units
                    self.icons[i].count:SetText(table.getn(units))
                    self.icons[i].count:Show()
                    self.icons[i].countBG:Show()
                    self.icons[i].icon:SetAlpha(1)
                else
                    self.icons[i].units = {}
                    self.icons[i].count:Hide()
                    self.icons[i].countBG:Hide()
                    self.icons[i].icon:SetAlpha(.2)
                end
            end
            local prevGroup = false
            local groupHeight = 0
            for index, engGroup in engineers do
                local i = index
                if not self.icons[i] then continue end
                if prevGroup then
                    LayoutHelpers.Above(self.icons[i], prevGroup)
                else
                    LayoutHelpers.AtLeftIn(self.icons[i], self, 7)
                    LayoutHelpers.AtBottomIn(self.icons[i], self, 2)
                end
                groupHeight = groupHeight + self.icons[i].Height()
                prevGroup = self.icons[i]
            end
            group.Height:Set(groupHeight)
        end

        group:Update(units)

        return group
    else
        return OldCreateIdleEngineerList(parent, units, unpack(arg))
    end
end

end
