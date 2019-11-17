--pb文件管理类，负责加载pb文件，解析，加密
--外部只提供给网络模块调用！！！

require "Framework/Config/NetMsg"
local pb = require 'pb'       --Lua虚拟机启动时，XLua进行注册
local protoc = require 'protoc'      --Lua虚拟机启动时，XLua进行注册

local function gen_msg_map()
    print("Init gen_msg_map")
    MSG_TYPE = {}
    for msg_name, msg_type in pairs(NetMsg) do
        MSG_TYPE[msg_type] = msg_name
    end
end

local function init()
    --解析所有pb文件
    local pb_message = LuaManager.GetPBString("Framework/Config/Net_Msg.pb")
    protoc:load(pb_message)
    gen_msg_map()
end

--根据协议id，解析bye[]到table
local function get_msg_table(msgType,bytes)
    local msg_pb_name = MSG_TYPE[msgType]
    if(msg_pb_name == nil) then
        LogWarning(string.format("msg type: [%d] not exist"),msgType)
        return
    end
    return pb.decode(msg_pb_name,bytes)
end

--根据协议id，压缩table到byte[]
local function get_msg_bytes(msgType,table)
    local msg_pb_name = MSG_TYPE[msgType]
    if(msg_pb_name == nil) then
        LogWarning(string.format("msg type: [%d] not exist",msgType)  )
        return
    end
    return pb.encode(msg_pb_name,table)
end

return{
    init = init,
    get_msg_table = get_msg_table,
    get_msg_bytes = get_msg_bytes,
}