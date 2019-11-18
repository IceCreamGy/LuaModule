--协议类型定义
local NetMsg = {
    --从服务器端来的
    S_LogOut = 101,
    S_LoginResult = 102,

    --客户端发送的
    UserRegister = 1000,
    UserLogin = 1001,
    UserInfo = 1002,
}

return NetMsg