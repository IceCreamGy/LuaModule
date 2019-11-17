CS_LuaManager = CS.AppFacade.instance:GetLuaManager()

local LuaManager={}
function LuaManager.GetPBString (fileName)
    return CS_LuaManager:GetPBString(fileName)
end

return LuaManager