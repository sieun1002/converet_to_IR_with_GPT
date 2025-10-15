; ModuleID: 'sub_140002AA0_module'
source_filename = "sub_140002AA0_module"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

declare i64* @sub_140002AF0()
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local i32 @sub_140002AA0(i8* %stream, i8* %format, ...) {
entry:
  %va_list.addr = alloca i8*, align 8
  %va_list.addr.cast = bitcast i8** %va_list.addr to i8*
  call void @llvm.va_start(i8* %va_list.addr.cast)
  %ap = load i8*, i8** %va_list.addr, align 8
  %optptr = call i64* @sub_140002AF0()
  %opt = load i64, i64* %optptr, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %opt, i8* %stream, i8* %format, i8* null, i8* %ap)
  call void @llvm.va_end(i8* %va_list.addr.cast)
  ret i32 %call
}