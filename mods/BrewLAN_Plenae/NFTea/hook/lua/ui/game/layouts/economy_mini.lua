do
    local oldLayout = SetLayout
    function SetLayout()
        oldLayout()

        -- Make the Eco GUI have three rows
        local GUI = import('/lua/ui/game/economy.lua').GUI
        GUI.bg.panel:SetTexture(UIUtil.UIFile('/mods/brewlan_plenae/nftea/textures/ui/uef/game/resource-panel/resources_panel_bmp.dds'))
        GUI.bg.Height:Set(GUI.bg.panel.Height)
        GUI.bg.Width:Set(GUI.bg.panel.Width)

        -- Place our row
        local group = GUI.crypto
        group.hideTarget.Top:Set(group.Top)
        group.hideTarget.Bottom:Set(group.Bottom)
        group.hideTarget.Left:Set(function() return group.last.Right() + 10 end)
        group.hideTarget.Right:Set(group.Right)
        group.Height:Set(25)
        group.Width:Set(296)
        LayoutHelpers.Below(group, GUI.energy, 5)
    end
end
