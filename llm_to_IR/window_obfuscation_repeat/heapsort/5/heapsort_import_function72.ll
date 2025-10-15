; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070A4 = global i32 0, align 4
@qword_1400070A8 = global i8* null, align 8

@aVirtualprotect = private constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = private constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@aAddressPHasNoI = private constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare i64 @sub_14001FAD3(i8*, i8*, i32)
declare i32 @loc_14000EEBA(i8*, i8*, i32, i8*)
declare void @sub_140001AD0(i8*, ...)
declare i32 @GetLastError()

define void @sub_140001B30(i8* %p) {
entry:
  %count = load i32, i32* @dword_1400070A4, align 4
  %gt0 = icmp sgt i32 %count, 0
  br i1 %gt0, label %early_ret, label %noentries

early_ret:
  ret void

noentries:
  %secinfo = call i8* @sub_140002610(i8* %p)
  %isnull = icmp eq i8* %secinfo, null
  br i1 %isnull, label %noimage, label %haveimage

noimage:
  %fmt_noimg_ptr = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt_noimg_ptr, i8* %p)
  ret void

haveimage:
  %base = call i8* @sub_140002750()
  %edx_off = getelementptr i8, i8* %secinfo, i64 12
  %edx_off_i32 = bitcast i8* %edx_off to i32*
  %len32 = load i32, i32* %edx_off_i32, align 4
  %len64 = sext i32 %len32 to i64
  %rcxptr = getelementptr i8, i8* %base, i64 %len64
  %buf = alloca [48 x i8], align 16
  %bufptr = getelementptr [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  %vqret = call i64 @sub_14001FAD3(i8* %rcxptr, i8* %bufptr, i32 48)
  %vqok = icmp ne i64 %vqret, 0
  br i1 %vqok, label %aftervq, label %vqfail

vqfail:
  %szptr8 = getelementptr i8, i8* %secinfo, i64 8
  %sz32ptr = bitcast i8* %szptr8 to i32*
  %sz32 = load i32, i32* %sz32ptr, align 4
  %fmt_vq_ptr = getelementptr inbounds [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt_vq_ptr, i32 %sz32, i8* %rcxptr)
  ret void

aftervq:
  %protres = call i32 @loc_14000EEBA(i8* %p, i8* %rcxptr, i32 64, i8* null)
  %protok = icmp ne i32 %protres, 0
  br i1 %protok, label %inc_and_ret, label %vpfail

vpfail:
  %err = call i32 @GetLastError()
  %fmt_vp_ptr = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt_vp_ptr, i32 %err)
  ret void

inc_and_ret:
  %old = load i32, i32* @dword_1400070A4, align 4
  %inc = add i32 %old, 1
  store i32 %inc, i32* @dword_1400070A4, align 4
  ret void
}