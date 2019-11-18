--工具类

local function str_to_table(str)
    if str == nil or type(str) ~= "string" then
        return
    end
    return load("return "..str)()
end

local function serialize(obj)
    local lua = ""
    local t = type(obj)
    if t == "number" then
        lua = lua .. obj
    elseif t == "boolean" then
        lua = lua .. tostring(obj)
    elseif t == "string" then
        lua = lua .. string.format("%q", obj)
    elseif t == "table" then
        lua = lua .. "{\n"
    for k, v in pairs(obj) do
        lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
    end
    local metatable = getmetatable(obj)
        if metatable ~= nil and type(metatable.__index) == "table" then
        for k, v in pairs(metatable.__index) do
            lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
        end
    end
        lua = lua .. "}"
    elseif t == "nil" then
        return nil
    else
        error("can not serialize a " .. t .. " type.")
    end
    return lua
end



local function json_to_table(str)
    local rapidjson = require('rapidjson')
    local tb = rapidjson.decode(str)
    return tb
end

local function table_to_json(t)
    local rapidjson = require('rapidjson')
    local str = rapidjson.encode(t)
    return str
end

return {
    table_to_string = serialize,           --table转字符串
    string_to_table = str_to_table,            --字符串转table
    json_to_table = json_to_table,              --json字符串转table
    table_to_json = table_to_json,              --table转字符串
}