local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit
PING = Class(CStructureUnit) {
    OnCreate = function(self, ...)
        self.Trash:Add(self:ForkThread(
            function()
                self.Trash:Add(CreateRotator(self, 0, 'y', nil, 200, 200, 200) )
                self.Trash:Add(CreateSlider(self, 0, 0, 5, 0, 10, true) )
                WaitSeconds(4)
                self:Destroy()
            end
        ) )
        CStructureUnit.OnCreate(self, unpack(arg))
    end,
}

TypeClass = PING