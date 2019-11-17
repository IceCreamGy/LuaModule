local NetworkManager_ByCS = CS.AppFacade.instance:GetNetworkManager()

--连接服务器， address(string) port(int)
local function  NetworkManager_ConnectServer(address,port)
    NetworkManager_ByCS:ConnectServer(address,port)
end
--发送协议，msgtype（int） bytes(byte[])
local function NetworkManager_SendNetMsg(msgType,bytes)
    NetworkManager_ByCS:SendNetMsg(msgType,bytes)
end

return {
    ConnectServer = NetworkManager_ConnectServer,
    SendNetMsg = NetworkManager_SendNetMsg,
}