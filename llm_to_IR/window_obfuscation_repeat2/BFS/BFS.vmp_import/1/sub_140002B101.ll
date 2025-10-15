; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque

@.str = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare %struct._iobuf* @__acrt_iob_func(i32)
declare i32 @sub_140002AA0(%struct._iobuf*, i8*, i32)
declare void @exit(i32)

define void @sub_140002B10(i32 %0) {
entry:
  %iob = call %struct._iobuf* @__acrt_iob_func(i32 2)
  %fmt = getelementptr inbounds [18 x i8], [18 x i8]* @.str, i64 0, i64 0
  %call = call i32 @sub_140002AA0(%struct._iobuf* %iob, i8* %fmt, i32 %0)
  call void @exit(i32 255)
  unreachable
}