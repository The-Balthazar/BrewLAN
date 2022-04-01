Currency = {}
--States.cryptoValue = Prefs.GetFromCurrentProfile"cryptoValue" or 1

do
    local path = '/mods/brewlan_plenae/nftea/textures/ui/common/game/resources/'
    local CurrencyStyle = {
        { name='Brewcoin', colour='00bfff' },
        { name='Teatherium', colour='45af55' },
        { name='Sprouter', colour='bbea70' },
        { name='Dosh', colour='d8c70f' },
    }

    local oldCreateUI = CreateUI
    function CreateUI()
        oldCreateUI()
        local function CreateCryptoGroup()
            local group = Group(GUI.bg)

            for i, coindata in ipairs(CurrencyStyle) do
                local icon = coindata.name..'icon'
                local rate = coindata.name..'rate'

                group[icon] = Bitmap(group)
                group[rate] = UIUtil.CreateText(group, '0', 15, UIUtil.bodyFont)

                group[icon]:SetTexture(UIUtil.UIFile(path..coindata.name..'.dds'))
                group[icon].Width:Set(36)
                group[icon].Height:Set(36)

                if i==1 then
                    LayoutHelpers.AtLeftIn(group[icon], group, -4)
                else
                    LayoutHelpers.RightOf(group[icon], group[CurrencyStyle[i-1].name..'rate'], 3)
                end
                LayoutHelpers.AtVerticalCenterIn(group[icon], group)

                group[rate]:SetDropShadow(true)
                group[rate]:SetColor(coindata.colour)

                LayoutHelpers.RightOf(group[rate], group[icon], 3)
                LayoutHelpers.AtVerticalCenterIn(group[rate], group)

                group.last = group[rate]
            end

            group.hideTarget = Group(group)
            return group
        end
        GUI.crypto = CreateCryptoGroup()
    end

    local oldBeatFunction = _BeatFunction
    function _BeatFunction()
        oldBeatFunction()
        local army = GetFocusArmy()
        for i, coindata in ipairs(CurrencyStyle) do
            local val = Currency[coindata.name].BrainTotals[army] or 0
            if val > 999 and val < 100000 then
                val = string.format('%0.1fk', val/1000)
            elseif val > 99999 and val < 1000000 then
                val = string.format('%0.0fk', val/1000)
            elseif val > 999999 then
                val = string.format('%0.2fM', val/1000000)
            end
            GUI.crypto[coindata.name..'rate']:SetText(val)
        end
    end
end

print()
