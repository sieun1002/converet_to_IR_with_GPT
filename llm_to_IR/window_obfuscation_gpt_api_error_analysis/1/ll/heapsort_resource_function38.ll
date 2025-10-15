; ModuleID = 'sub_140002960_module'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque

declare dso_local %struct._iobuf* @__acrt_iob_func(i32)
declare dso_local i32 @__stdio_common_vfprintf(i64, %struct._iobuf*, i8*, i8*, i8*)
declare dso_local i64* @sub_140002A10()

declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local i32 @sub_140002960(i8* %fmt, ...) local_unnamed_addr {
entry:
  %ap.addr = alloca i8*, align 8
  %iob = call %struct._iobuf* @__acrt_iob_func(i32 1)
  %opt.ptr = call i64* @sub_140002A10()
  %ap.cast = bitcast i8** %ap.addr to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %ap.val = load i8*, i8** %ap.addr, align 8
  %options = load i64, i64* %opt.ptr, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %options, %struct._iobuf* %iob, i8* %fmt, i8* null, i8* %ap.val)
  call void @llvm.va_end(i8* %ap.cast)
  ret i32 %call
}