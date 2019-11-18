
message UserRegister{
    required string name  = 1;
    required string password  = 2;
}

message UserInfo{
	required string name  = 1;
	required int64 age = 2;
	required string phone = 3;
	required string password = 4;
}