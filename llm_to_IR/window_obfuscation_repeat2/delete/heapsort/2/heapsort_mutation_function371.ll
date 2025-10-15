source_filename = "module.ll"
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque

declare dso_local i32 @__stdio_common_vfprintf(i64, %struct._iobuf*, i8*, i8*, i8*)
declare dso_local i64* @sub_140002A10()
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local i32 @sub_1400029C0(%struct._iobuf* %stream, i8* %format, ...) {
entry:
  %va_list.addr = alloca i8*, align 8
  %va_cast = bitcast i8** %va_list.addr to i8*
  call void @llvm.va_start(i8* %va_cast)
  %p = call dso_local i64* @sub_140002A10()
  %opt = load i64, i64* %p, align 8
  %va_cur = load i8*, i8** %va_list.addr, align 8
  %res = call dso_local i32 @__stdio_common_vfprintf(i64 %opt, %struct._iobuf* %stream, i8* %format, i8* null, i8* %va_cur)
  call void @llvm.va_end(i8* %va_cast)
  ret i32 %res
}