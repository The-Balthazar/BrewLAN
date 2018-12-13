local UnitOld = Unit

Unit = Class(UnitOld) {
    
    OnDamage = function(self, instigator, amount, vector, damageType, ...)
        if damageType == 'NormalAboveWater' and (self:GetCurrentLayer() == 'Sub' or self:GetCurrentLayer() == 'Seabed') then
            local bp = self:GetBlueprint()
            local myheight = bp.Physics.MeshExtentsY or bp.SizeY or 0
            local damagetotal = amount / math.max(math.abs(vector[2]) - myheight, 1)
            UnitOld.OnDamage(self, instigator, damagetotal, vector, damageType, unpack(arg))
        else
            UnitOld.OnDamage(self, instigator, amount, vector, damageType, unpack(arg))
        end
    end, 
}
