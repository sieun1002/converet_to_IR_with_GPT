; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002710(i32 noundef)
declare i8** @sub_140002650()
declare void @sub_140002728(i8* noundef, i8* noundef, i8* noundef, i32 noundef, i8* noundef)

define void @sub_1400025A0(i8* %arg1, i8* %arg2, i8* %arg3, i8* %arg4) {
entry:
  %args.arr = alloca [3 x i8*], align 8
  %gep0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %args.arr, i64 0, i64 0
  store i8* %arg2, i8** %gep0, align 8
  %gep1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %args.arr, i64 0, i64 1
  store i8* %arg3, i8** %gep1, align 8
  %gep2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %args.arr, i64 0, i64 2
  store i8* %arg4, i8** %gep2, align 8
  %call.sub_2710 = call i8* @sub_140002710(i32 1)
  %call.sub_2650 = call i8** @sub_140002650()
  %load.rcx = load i8*, i8** %call.sub_2650, align 8
  %arr.ptr = bitcast [3 x i8*]* %args.arr to i8*
  call void @sub_140002728(i8* %load.rcx, i8* %call.sub_2710, i8* %arg1, i32 0, i8* %arr.ptr)
  ret void
}