; ModuleID = 'sub_1400029C0.ll'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque

declare dso_local i64* @sub_140002A10()
declare dso_local i32 @__stdio_common_vfprintf(i64, %struct._iobuf*, i8*, i8*, i8*)

declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local i32 @sub_1400029C0(%struct._iobuf* %stream, i8* %format, ...) local_unnamed_addr {
entry:
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %ap.val = load i8*, i8** %ap, align 8
  %opt.ptr = call dso_local i64* @sub_140002A10()
  %options = load i64, i64* %opt.ptr, align 8
  %call = call dso_local i32 @__stdio_common_vfprintf(i64 %options, %struct._iobuf* %stream, i8* %format, i8* null, i8* %ap.val)
  call void @llvm.va_end(i8* %ap.cast)
  ret i32 %call
}