local OldOnClickHandler = import('/lua/ui/game/construction.lua').OnClickHandler
                                                          
function OnClickHandler(button, modifiers)         
    local item = button.Data    
    if EntityCategoryContains(categories.BUILTBYGANTRY, item.id) and EntityCategoryContains(categories.GANTRY, sortedOptions.selection[1]) or EntityCategoryContains(categories.HEAVYWALL, sortedOptions.selection[1]) then 
        PlaySound(Sound({Cue = "UI_MFD_Click", Bank = "Interface"}))
        ClearBuildTemplates()
        local blueprint = __blueprints[item.id]
        local count = 1
        local performUpgrade = false
        local buildCmd = "build"   
        
        if modifiers.Ctrl or modifiers.Shift then
            count = 5
        end
        if item.type == 'queuestack' then
            local count = 1
            if modifiers.Shift or modifiers.Ctrl then
                count = 5
            end
            if modifiers.Left then
                IncreaseBuildCountInQueue(item.position, count)
            elseif modifiers.Right then
                DecreaseBuildCountInQueue(item.position, count)
            end
        else
        IssueBlueprintCommand("UNITCOMMAND_BuildFactory", item.id, count)
        end
    else
        OldOnClickHandler(button, modifiers)
    end
end