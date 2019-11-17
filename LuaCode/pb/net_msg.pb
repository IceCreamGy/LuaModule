//required(必要)  optional（可选）  repeated（list）
//pb文件的定义，由服务器统一提供， 尽量使用optional（版本兼容）
//数据类型 double float int32 int64 uint32 uint64 sint32 sint64 fixed32 fixed64 sfixed32 sfixed64 bool string bytes

message User{
	required int32 id  = 1;
	repeated int32 status  = 2;
	required string pwdMd5  = 3;
	required string regTime  = 4;
	required UserInfo info = 5;
}

message UserInfo{
	required string name  = 1;
	required int64 diamond = 2;
	required int32 level = 3;
}
