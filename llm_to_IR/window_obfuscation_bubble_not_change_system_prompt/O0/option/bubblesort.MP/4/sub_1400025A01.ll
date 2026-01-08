; ModuleID = 'sub_1400025A0'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002710(i32 noundef)
declare i8** @sub_140002650()
declare void @sub_140002728(i8* noundef, i8* noundef, i8* noundef, i32 noundef, i8* noundef)

define void @sub_1400025A0(i8* noundef %arg1, i8* noundef %arg2, i8* noundef %arg3, i8* noundef %arg4) {
entry:
  %argsave = alloca [3 x i8*], align 8
  %p0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %argsave, i64 0, i64 0
  store i8* %arg2, i8** %p0, align 8
  %p1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %argsave, i64 0, i64 1
  store i8* %arg3, i8** %p1, align 8
  %p2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %argsave, i64 0, i64 2
  store i8* %arg4, i8** %p2, align 8
  %call1 = call i8* @sub_140002710(i32 1)
  %call2 = call i8** @sub_140002650()
  %rcx_load = load i8*, i8** %call2, align 8
  %p0_as_i8 = bitcast i8** %p0 to i8*
  call void @sub_140002728(i8* %rcx_load, i8* %call1, i8* %arg1, i32 0, i8* %p0_as_i8)
  ret void
}