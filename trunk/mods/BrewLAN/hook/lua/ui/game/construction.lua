--+-----------------------------------------------------------------------------
--�                                                                
--�   Summary: Allows the Gantry and heavy walls to build units built like buildings usually.
--�   Author: Balthassar
--�
--+-----------------------------------------------------------------------------
local OldOnClickHandler = OnClickHandler
                                                          
function OnClickHandler(button, modifiers)         
    local item = button.Data
    local changeclick = false
    for i,v in sortedOptions.selection do
        if EntityCategoryContains(categories.BUILTBYGANTRY, item.id) and EntityCategoryContains(categories.GANTRY, v) or EntityCategoryContains(categories.HEAVYWALL, v) then
            changeclick = true
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
                        if v then   # it's possible that your unit will have died by the time this gets to it
                            local unitBp = v:GetBlueprint()
                            if blueprint.General.UpgradesFrom == unitBp.BlueprintId then
                                performUpgrade = true
                            elseif blueprint.General.UpgradesFrom == unitBp.General.UpgradesTo then
                                performUpgrade = true
                            elseif blueprint.General.UpgradesFromBase != "none" then
                                # try testing against the base
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
                OldOnClickHandler(button, modifiers)
            end
        elseif item.type == 'queuestack' then
            OldOnClickHandler(button, modifiers) 
        elseif item.type == 'unitstack' then   
            OldOnClickHandler(button, modifiers)
        elseif item.type == 'attachedunit' then   
            OldOnClickHandler(button, modifiers)
        elseif item.type == 'templates' then
            OldOnClickHandler(button, modifiers)
        elseif item.type == 'enhancement' then 
            OldOnClickHandler(button, modifiers)
        end
    else
        OldOnClickHandler(button, modifiers)
    end
end