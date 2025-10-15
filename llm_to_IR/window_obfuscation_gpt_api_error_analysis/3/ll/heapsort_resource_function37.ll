; ModuleID = 'wrapper'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque

declare i64* @sub_140002A10()

declare i32 @__stdio_common_vfprintf(i64, %struct._iobuf*, i8*, i8*, i8*)

define dso_local i32 @sub_140002920(%struct._iobuf* %stream, i8* %format, i8* %arglist) {
entry:
  %opts_ptr = call i64* @sub_140002A10()
  %opts = load i64, i64* %opts_ptr, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %opts, %struct._iobuf* %stream, i8* %format, i8* null, i8* %arglist)
  ret i32 %call
}