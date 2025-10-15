; ModuleID = 'sub_1400029C0.ll'
source_filename = "sub_1400029C0.c"
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque

declare i32 @__stdio_common_vfprintf(i64, %struct._iobuf*, i8*, i8*, i8*)
declare i64* @sub_140002A10()
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local i32 @sub_1400029C0(%struct._iobuf* %stream, i8* %format, ...) {
entry:
  %ap.addr = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap.addr to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %ap.val = load i8*, i8** %ap.addr, align 8
  %opt.ptr = call i64* @sub_140002A10()
  %opt = load i64, i64* %opt.ptr, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %opt, %struct._iobuf* %stream, i8* %format, i8* null, i8* %ap.val)
  call void @llvm.va_end(i8* %ap.cast)
  ret i32 %call
}