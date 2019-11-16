CS_LuaManager = CS.C_Framework.AppFacade.instance:GetLuaManager()

local function GetPBString (fileName)
    return CS_LuaManager:GetPBString(fileName)
end

LuaManager = {
    GetPBString = GetPBString,
}