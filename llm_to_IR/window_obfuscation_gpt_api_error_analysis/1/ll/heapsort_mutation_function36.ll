; ModuleID = 'sub_140002960.ll'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct._iobuf = type opaque

declare %struct._iobuf* @__acrt_iob_func(i32 noundef)
declare i64* @sub_140002A10()
declare i32 @__stdio_common_vfprintf(i64 noundef, %struct._iobuf* noundef, i8* noundef, i8* noundef, i8* noundef)
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define i32 @sub_140002960(i8* noundef %format, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %stream = call %struct._iobuf* @__acrt_iob_func(i32 1)
  %opt.ptr = call i64* @sub_140002A10()
  %options = load i64, i64* %opt.ptr, align 8
  %ap.val = load i8*, i8** %ap, align 8
  %res = call i32 @__stdio_common_vfprintf(i64 %options, %struct._iobuf* %stream, i8* %format, i8* null, i8* %ap.val)
  call void @llvm.va_end(i8* %ap.cast)
  ret i32 %res
}