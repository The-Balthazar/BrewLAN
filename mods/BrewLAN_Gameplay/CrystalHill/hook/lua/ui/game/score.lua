--------------------------------------------------------------------------------
--  Summary:  Crystal count down and notifications
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
local Old_OnBeat = _OnBeat
local Crystal = {}
function _OnBeat()
    Old_OnBeat()
    if Sync.Crystal.EndTimeMins then
        Crystal = Sync.Crystal
        import('/lua/ui/game/announcement.lua').CreateAnnouncement(string.gsub(Crystal.PlayerName, " %(.*", "") .. LOC("<LOC crystal_0001> controls the crystal."), controls.time)
    end    
    if Sync.CrystalEndTimeOvertimeMins then
        Crystal.Overtime = Sync.CrystalEndTimeOvertimeMins
    end
    if Crystal.EndTimeMins then
        local remaining = (Crystal.EndTimeMins * 60) - GetGameTimeSeconds()
        if remaining > 0 then   
            controls.time:SetText(LOCF('%02d:%02d:%02d', math.floor(remaining / 3600), math.floor(remaining/60), math.mod(remaining, 60)))
        elseif not Crystal.Victory and remaining <= 0 then    
            local overtimeTotal = GetGameTimeSeconds() - (Crystal.EndTimeMins * 60)
            local overtimeLeft
            if Crystal.Overtime then
                overtimeLeft = math.max(0, (Crystal.Overtime * 60) - GetGameTimeSeconds() )
            else
                overtimeLeft = 0            
            end             
            controls.time:SetText("-" .. LOCF('%02d:%02d:%02d', math.floor(overtimeTotal / 3600), math.floor(overtimeTotal/60), math.mod(overtimeTotal, 60)) .. " (" .. math.ceil(overtimeLeft) .. ")")
        end
        if remaining < 10 * 60 and remaining > 9.9*60 and not Crystal.Ten then
            import('/lua/ui/game/announcement.lua').CreateAnnouncement(LOC("<LOC crystal_0005>10 minutes remaining."), controls.time)
            Crystal.Ten = true
        end
        if remaining > 2.5 * 60 and remaining < 2.51 * 60 and not Crystal.Two then
            import('/lua/ui/game/announcement.lua').CreateAnnouncement(LOC("<LOC crystal_0006>2:30 minutes remain."), controls.time)
            Crystal.Two = true
        end
        if remaining > 0.5 * 60 and remaining < 0.51 * 60 and not Crystal.Half then
            import('/lua/ui/game/announcement.lua').CreateAnnouncement(LOC("<LOC crystal_0008>30 seconds remain."), controls.time)
            Crystal.Half = true
        end
    end   
    if Sync.Crystal.Victory == 1 then
        import('/lua/ui/game/announcement.lua').CreateAnnouncement(string.gsub(Sync.Crystal.PlayerName, " (.*", "") .. LOC("<LOC crystal_0002> and friends win with the crystal."), controls.time)
        Crystal.Victory = true
    elseif Sync.Crystal.Victory == 2 then
        import('/lua/ui/game/announcement.lua').CreateAnnouncement(string.gsub(Sync.Crystal.PlayerName, " (.*", "") .. LOC("<LOC crystal_0003> and friend win with the crystal."), controls.time)
        Crystal.Victory = true
    elseif Sync.Crystal.Victory == 3 then
        import('/lua/ui/game/announcement.lua').CreateAnnouncement(string.gsub(Sync.Crystal.PlayerName, " (.*", "") .. LOC("<LOC crystal_0004> has won with the crystal."), controls.time)
        Crystal.Victory = true
    end
end
end
