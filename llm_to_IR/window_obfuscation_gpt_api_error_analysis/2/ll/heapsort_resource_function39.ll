; ModuleID = 'sub_1400029C0.ll'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque

declare i64* @sub_140002A10()
declare i32 @__stdio_common_vfprintf(i64, %struct._iobuf*, i8*, i8*, i8*)
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local i32 @sub_1400029C0(%struct._iobuf* %stream, i8* %format, ...) {
entry:
  %va = alloca i8*, align 8
  %opts_ptr = call i64* @sub_140002A10()
  %va.cast = bitcast i8** %va to i8*
  call void @llvm.va_start(i8* %va.cast)
  %opts = load i64, i64* %opts_ptr, align 8
  %ap = load i8*, i8** %va, align 8
  %ret = call i32 @__stdio_common_vfprintf(i64 %opts, %struct._iobuf* %stream, i8* %format, i8* null, i8* %ap)
  call void @llvm.va_end(i8* %va.cast)
  ret i32 %ret
}