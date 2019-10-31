--Generated By protoc-gen-lua Do not Edit
local protobuf = require "Framework.Net.Protobuf.protobuf"
local _M = {}

_M.REQ_CREATE_USER = protobuf.Descriptor();
_M.REQ_CREATE_USER_NAME_FIELD = protobuf.FieldDescriptor();
_M.RSP_CREATE_USER = protobuf.Descriptor();
_M.RSP_CREATE_USER_RESULT_FIELD = protobuf.FieldDescriptor();
_M.RSP_CREATE_USER_NAME_FIELD = protobuf.FieldDescriptor();
_M.RSP_CREATE_USER_USE_ICON_FIELD = protobuf.FieldDescriptor();
_M.REQ_CHANGE_NAME = protobuf.Descriptor();
_M.REQ_CHANGE_NAME_NAME_FIELD = protobuf.FieldDescriptor();
_M.RSP_CHANGE_NAME = protobuf.Descriptor();
_M.RSP_CHANGE_NAME_RESULT_FIELD = protobuf.FieldDescriptor();
_M.RSP_CHANGE_NAME_NAME_FIELD = protobuf.FieldDescriptor();

_M.REQ_CREATE_USER_NAME_FIELD.name = "name"
_M.REQ_CREATE_USER_NAME_FIELD.full_name = ".user.req_create_user.name"
_M.REQ_CREATE_USER_NAME_FIELD.number = 2
_M.REQ_CREATE_USER_NAME_FIELD.index = 0
_M.REQ_CREATE_USER_NAME_FIELD.label = 1
_M.REQ_CREATE_USER_NAME_FIELD.has_default_value = true
_M.REQ_CREATE_USER_NAME_FIELD.default_value = ""
_M.REQ_CREATE_USER_NAME_FIELD.type = 9
_M.REQ_CREATE_USER_NAME_FIELD.cpp_type = 9

_M.REQ_CREATE_USER.name = "req_create_user"
_M.REQ_CREATE_USER.full_name = ".user.req_create_user"
_M.REQ_CREATE_USER.nested_types = {}
_M.REQ_CREATE_USER.enum_types = {}
_M.REQ_CREATE_USER.fields = {_M.REQ_CREATE_USER_NAME_FIELD}
_M.REQ_CREATE_USER.is_extendable = false
_M.REQ_CREATE_USER.extensions = {}
_M.RSP_CREATE_USER_RESULT_FIELD.name = "result"
_M.RSP_CREATE_USER_RESULT_FIELD.full_name = ".user.rsp_create_user.result"
_M.RSP_CREATE_USER_RESULT_FIELD.number = 1
_M.RSP_CREATE_USER_RESULT_FIELD.index = 0
_M.RSP_CREATE_USER_RESULT_FIELD.label = 1
_M.RSP_CREATE_USER_RESULT_FIELD.has_default_value = true
_M.RSP_CREATE_USER_RESULT_FIELD.default_value = 0
_M.RSP_CREATE_USER_RESULT_FIELD.type = 5
_M.RSP_CREATE_USER_RESULT_FIELD.cpp_type = 1

_M.RSP_CREATE_USER_NAME_FIELD.name = "name"
_M.RSP_CREATE_USER_NAME_FIELD.full_name = ".user.rsp_create_user.name"
_M.RSP_CREATE_USER_NAME_FIELD.number = 3
_M.RSP_CREATE_USER_NAME_FIELD.index = 1
_M.RSP_CREATE_USER_NAME_FIELD.label = 1
_M.RSP_CREATE_USER_NAME_FIELD.has_default_value = true
_M.RSP_CREATE_USER_NAME_FIELD.default_value = ""
_M.RSP_CREATE_USER_NAME_FIELD.type = 9
_M.RSP_CREATE_USER_NAME_FIELD.cpp_type = 9

_M.RSP_CREATE_USER_USE_ICON_FIELD.name = "use_icon"
_M.RSP_CREATE_USER_USE_ICON_FIELD.full_name = ".user.rsp_create_user.use_icon"
_M.RSP_CREATE_USER_USE_ICON_FIELD.number = 4
_M.RSP_CREATE_USER_USE_ICON_FIELD.index = 2
_M.RSP_CREATE_USER_USE_ICON_FIELD.label = 1
_M.RSP_CREATE_USER_USE_ICON_FIELD.has_default_value = true
_M.RSP_CREATE_USER_USE_ICON_FIELD.default_value = 0
_M.RSP_CREATE_USER_USE_ICON_FIELD.type = 5
_M.RSP_CREATE_USER_USE_ICON_FIELD.cpp_type = 1

_M.RSP_CREATE_USER.name = "rsp_create_user"
_M.RSP_CREATE_USER.full_name = ".user.rsp_create_user"
_M.RSP_CREATE_USER.nested_types = {}
_M.RSP_CREATE_USER.enum_types = {}
_M.RSP_CREATE_USER.fields = {_M.RSP_CREATE_USER_RESULT_FIELD, _M.RSP_CREATE_USER_NAME_FIELD, _M.RSP_CREATE_USER_USE_ICON_FIELD}
_M.RSP_CREATE_USER.is_extendable = false
_M.RSP_CREATE_USER.extensions = {}
_M.REQ_CHANGE_NAME_NAME_FIELD.name = "name"
_M.REQ_CHANGE_NAME_NAME_FIELD.full_name = ".user.req_change_name.name"
_M.REQ_CHANGE_NAME_NAME_FIELD.number = 1
_M.REQ_CHANGE_NAME_NAME_FIELD.index = 0
_M.REQ_CHANGE_NAME_NAME_FIELD.label = 1
_M.REQ_CHANGE_NAME_NAME_FIELD.has_default_value = true
_M.REQ_CHANGE_NAME_NAME_FIELD.default_value = ""
_M.REQ_CHANGE_NAME_NAME_FIELD.type = 9
_M.REQ_CHANGE_NAME_NAME_FIELD.cpp_type = 9

_M.REQ_CHANGE_NAME.name = "req_change_name"
_M.REQ_CHANGE_NAME.full_name = ".user.req_change_name"
_M.REQ_CHANGE_NAME.nested_types = {}
_M.REQ_CHANGE_NAME.enum_types = {}
_M.REQ_CHANGE_NAME.fields = {_M.REQ_CHANGE_NAME_NAME_FIELD}
_M.REQ_CHANGE_NAME.is_extendable = false
_M.REQ_CHANGE_NAME.extensions = {}
_M.RSP_CHANGE_NAME_RESULT_FIELD.name = "result"
_M.RSP_CHANGE_NAME_RESULT_FIELD.full_name = ".user.rsp_change_name.result"
_M.RSP_CHANGE_NAME_RESULT_FIELD.number = 1
_M.RSP_CHANGE_NAME_RESULT_FIELD.index = 0
_M.RSP_CHANGE_NAME_RESULT_FIELD.label = 1
_M.RSP_CHANGE_NAME_RESULT_FIELD.has_default_value = true
_M.RSP_CHANGE_NAME_RESULT_FIELD.default_value = 0
_M.RSP_CHANGE_NAME_RESULT_FIELD.type = 5
_M.RSP_CHANGE_NAME_RESULT_FIELD.cpp_type = 1

_M.RSP_CHANGE_NAME_NAME_FIELD.name = "name"
_M.RSP_CHANGE_NAME_NAME_FIELD.full_name = ".user.rsp_change_name.name"
_M.RSP_CHANGE_NAME_NAME_FIELD.number = 2
_M.RSP_CHANGE_NAME_NAME_FIELD.index = 1
_M.RSP_CHANGE_NAME_NAME_FIELD.label = 1
_M.RSP_CHANGE_NAME_NAME_FIELD.has_default_value = true
_M.RSP_CHANGE_NAME_NAME_FIELD.default_value = ""
_M.RSP_CHANGE_NAME_NAME_FIELD.type = 9
_M.RSP_CHANGE_NAME_NAME_FIELD.cpp_type = 9

_M.RSP_CHANGE_NAME.name = "rsp_change_name"
_M.RSP_CHANGE_NAME.full_name = ".user.rsp_change_name"
_M.RSP_CHANGE_NAME.nested_types = {}
_M.RSP_CHANGE_NAME.enum_types = {}
_M.RSP_CHANGE_NAME.fields = {_M.RSP_CHANGE_NAME_RESULT_FIELD, _M.RSP_CHANGE_NAME_NAME_FIELD}
_M.RSP_CHANGE_NAME.is_extendable = false
_M.RSP_CHANGE_NAME.extensions = {}

_M.req_change_name = protobuf.Message(_M.REQ_CHANGE_NAME)
_M.req_create_user = protobuf.Message(_M.REQ_CREATE_USER)
_M.rsp_change_name = protobuf.Message(_M.RSP_CHANGE_NAME)
_M.rsp_create_user = protobuf.Message(_M.RSP_CREATE_USER)

return _M