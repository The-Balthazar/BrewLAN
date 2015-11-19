--------------------------------------------------------------------------------
--  Summary:  Crystal count down and notifications
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
local Old_OnBeat = _OnBeat
local Message = 0
function _OnBeat()
    Old_OnBeat()
    if Sync.TeaDMessage and Sync.TeaDMessage[2] > Message then
        import('/lua/ui/game/announcement.lua').CreateAnnouncement(LOC(Sync.TeaDMessage[1]), controls.time)
        Message = Sync.TeaDMessage[2]
    end
end
end
