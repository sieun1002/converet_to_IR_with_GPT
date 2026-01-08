; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare void @"loc_14000276D+3"()
declare void @"loc_140002755+3"(i32)
declare i32* @sub_140002740()
declare i8** @sub_140002748()
declare i8** @sub_140002800()
declare void @sub_1400027E0(i32)

define i32 @sub_1400026A0(i32* %arg0, i8** %arg1, i8** %arg2, i32 %arg3, i32* %arg4) {
entry:
  call void @"loc_14000276D+3"()
  %cmp = icmp ult i32 %arg3, 1
  %ec = select i1 %cmp, i32 1, i32 2
  call void @"loc_140002755+3"(i32 %ec)
  %p0 = call i32* @sub_140002740()
  %v0 = load i32, i32* %p0, align 4
  store i32 %v0, i32* %arg0, align 4
  %p1 = call i8** @sub_140002748()
  %v1 = load i8*, i8** %p1, align 8
  store i8* %v1, i8** %arg1, align 8
  %p2 = call i8** @sub_140002800()
  %v2 = load i8*, i8** %p2, align 8
  store i8* %v2, i8** %arg2, align 8
  %v3 = load i32, i32* %arg4, align 4
  call void @sub_1400027E0(i32 %v3)
  ret i32 0
}