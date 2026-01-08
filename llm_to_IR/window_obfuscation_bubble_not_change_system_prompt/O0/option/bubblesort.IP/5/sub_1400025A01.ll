; ModuleID = 'sub_1400025A0.ll'
target triple = "x86_64-pc-windows-msvc"

declare i8* @loc_140002710(i32 noundef)
declare i8** @sub_140002650()
declare void @sub_140002728(i8* noundef, i8* noundef, i8* noundef, i64 noundef, i8* noundef)

define void @sub_1400025A0(i8* noundef %arg0, i8* noundef %arg1, i8* noundef %arg2, i8* noundef %arg3) {
entry:
  %arr = alloca [3 x i8*], align 8
  %arr.ptr = bitcast [3 x i8*]* %arr to i8**
  store i8* %arg1, i8** %arr.ptr, align 8
  %gep1 = getelementptr inbounds i8*, i8** %arr.ptr, i64 1
  store i8* %arg2, i8** %gep1, align 8
  %gep2 = getelementptr inbounds i8*, i8** %arr.ptr, i64 2
  store i8* %arg3, i8** %gep2, align 8
  %call1 = call i8* @loc_140002710(i32 noundef 1)
  %call2 = call i8** @sub_140002650()
  %rcx.val = load i8*, i8** %call2, align 8
  %va.ptr = bitcast i8** %arr.ptr to i8*
  call void @sub_140002728(i8* noundef %rcx.val, i8* noundef %call1, i8* noundef %arg0, i64 noundef 0, i8* noundef %va.ptr)
  ret void
}