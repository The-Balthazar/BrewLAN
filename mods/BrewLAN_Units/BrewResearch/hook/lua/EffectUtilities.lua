function IntelDishAnimationThread(self, bones)
    if not self then return end
    if type(bones) != 'table' then return end
    --[[
    Bones wants to look like this:
    bones = {
        {
            'Med_Dish_Stand_00',
            'Med_Dish_00',
            c = 1,
            bounds = {-180,180,-90,90,},
            speed = 6,
        },
    }
    ]]--
    for i, set in bones do
        if set.c then
            for j = 1, set.c do
                if set.cont then
                    if not self.CRotators then self.CRotators = {} end
                    table.insert(CreateRotator(self,set[1] .. j, 'z', nil, 30, 2, 30), self.CRotators)
                else
                    if not self.Rotators then self.Rotators = {} end
                    table.insert(
                        self.Rotators,
                        {
                            CreateRotator(self,set[1] .. j, 'z', math.random(set.bounds[1],set.bounds[2]), set.speed or 30, 2),
                            CreateRotator(self,set[2] .. j, 'x', math.random(set.bounds[3],set.bounds[4]), set.speed or 30, 2),
                            set.bounds,
                            set.speed or 30,
                        }
                    )
                end
            end
        else
            if not self.Rotators then self.Rotators = {} end
            table.insert(
                self.Rotators,
                {
                    CreateRotator(self,set[1], 'z', math.random(set.bounds[1],set.bounds[2]), set.speed or 30, 2),
                    CreateRotator(self,set[2], 'x', math.random(set.bounds[3],set.bounds[4]), set.speed or 30, 2),
                    set.bounds,
                    set.speed or 30,
                }
            )
            --CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
        end
    end
    while true do
        --LOG(self.Intel)
        if self.Intel then
            for i, v in self.Rotators do
                if math.random(1,40) < v[4] then
                    v[1]:SetGoal(math.random(v[3][1],v[3][2]))
                    v[2]:SetGoal(math.random(v[3][3],v[3][4]))
                    WaitTicks(math.random(1,3))
                end
            end
            WaitTicks(math.random(1,3))
        end
        WaitTicks(10)
    end
end
