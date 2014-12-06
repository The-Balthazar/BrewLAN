do
local Old_OnBeat = _OnBeat
local Crystal = {}
function _OnBeat()
    Old_OnBeat()
    if Sync.Crystal.EndTimeMins then
        Crystal = Sync.Crystal
        import('/lua/ui/game/announcement.lua').CreateAnnouncement(Crystal.PlayerName .. LOC("<LOC crystal_0001> controls the crystal."), controls.time)
    end    
    if Crystal.EndTimeMins then
        local remaining = (Crystal.EndTimeMins * 60) - GetGameTimeSeconds()
        if remaining > 0 then   
            controls.time:SetText(LOCF('%02d:%02d:%02d', math.floor(remaining / 3600), math.floor(remaining/60), math.mod(remaining, 60)))
        end
    end   
    if Sync.Crystal.Victory == 1 then
        import('/lua/ui/game/announcement.lua').CreateAnnouncement(Sync.Crystal.PlayerName .. LOC("<LOC crystal_0002> and friends win with the crystal."), controls.time)
    elseif Sync.Crystal.Victory == 2 then
        import('/lua/ui/game/announcement.lua').CreateAnnouncement(Sync.Crystal.PlayerName .. LOC("<LOC crystal_0003> and friend win with the crystal."), controls.time)
    elseif Sync.Crystal.Victory == 3 then
        import('/lua/ui/game/announcement.lua').CreateAnnouncement(Sync.Crystal.PlayerName .. LOC("<LOC crystal_0004> has won with the crystal."), controls.time)
    end
end
end