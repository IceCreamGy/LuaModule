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
