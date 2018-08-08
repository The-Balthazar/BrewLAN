CreateDropPing = Class(Unit) {
    OnCreate = function(self)
        Unit.OnCreate(self)
        ChangeState(self, self.RevolvingState)
    end,

    RevolvingState = State {
        Main = function(self)
            self.Trash:Add(CreateRotator(self, 0, 'y', nil, 200, 200, 200) )
            self.Trash:Add(CreateSlider(self, 0, 0, 5, 0, 10, true) )
            WaitTicks(42)
            self:Destroy()
        end,
    },
}
