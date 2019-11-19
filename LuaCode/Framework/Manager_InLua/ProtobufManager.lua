--pb文件管理类，负责加载pb文件，解析，加密
--外部只提供给网络模块调用！！！

local pb = require("pb")    --核心解析，当Lua虚拟机启动时，XLua进行注册
local protoc = require("Framework/Tools/protoc")    --protobuf LUA版本源码

local function gen_msg_map()
    MSG_TYPE = {}
    for msg_name, msg_ID in pairs(NetMsg) do
        MSG_TYPE[msg_ID] = msg_name
    end
end

local function Init()
    --解析所有pb文件
    local pb_message = LuaManager_InCS.GetPBString("Framework/Config/ProtobufDefine.pb")
    protoc:load(pb_message)
    gen_msg_map()
end

--根据协议id，解析bye[]到table
local function DeSerialize(msg_ID, bytes)
    local msg_pb_name = MSG_TYPE[msg_ID]
    if (msg_pb_name == nil) then
        LogWarning(string.format("msg type: [%d] not exist"), msg_ID)
        return
    end
    return pb.decode(msg_pb_name, bytes)
end

--根据协议id，压缩table到byte[]
local function Serialize(msg_ID, table)
    local protoName = MSG_TYPE[msg_ID]
    if (protoName == nil) then
        LogWarning(string.format("msg type: [%d] not exist", msg_ID))
        return
    end
    return pb.encode(protoName, table)
end

return {
    Init = Init,
    DeSerialize = DeSerialize,      --反序列化
    Serialize = Serialize,      --序列化
}