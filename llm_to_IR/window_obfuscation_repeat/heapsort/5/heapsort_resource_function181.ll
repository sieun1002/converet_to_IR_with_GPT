; ModuleID = 'fixed_module'
source_filename = "fixed_module.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.MEMORY_BASIC_INFORMATION = type { i8*, i8*, i32, i32, i64, i32, i32, i32 }

@dword_1400070A4 = dso_local global i32 0, align 4
@qword_1400070A8 = dso_local global i8* null, align 8

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00", align 1
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00", align 1
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare dso_local i8* @sub_140002610(i8*)
declare dso_local i8* @sub_140002750()
declare dso_local i32 @sub_140001AD0(i8*, ...)

declare dllimport i64 @VirtualQuery(i8*, %struct.MEMORY_BASIC_INFORMATION*, i64)
declare dllimport i32 @VirtualProtect(i8*, i64, i32, i32*)
declare dllimport i32 @GetLastError()

define dso_local void @sub_140001B30(i8* %addr) {
entry:
  %n.cur = load i32, i32* @dword_1400070A4, align 4
  %has.entries = icmp sgt i32 %n.cur, 0
  br i1 %has.entries, label %after_scan, label %after_scan

after_scan:                                        ; preds = %entry, %entry
  %img.ptr = call i8* @sub_140002610(i8* %addr)
  %img.isnull = icmp eq i8* %img.ptr, null
  br i1 %img.isnull, label %noimg, label %hasimg

noimg:                                             ; preds = %after_scan
  %fmt.noimg = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  %call.noimg = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt.noimg, i8* %addr)
  ret void

hasimg:                                            ; preds = %after_scan
  %table.base = load i8*, i8** @qword_1400070A8, align 8
  %n64 = sext i32 %n.cur to i64
  %mul5 = mul i64 %n64, 5
  %off.bytes = shl i64 %mul5, 3
  %entry.ptr = getelementptr i8, i8* %table.base, i64 %off.bytes
  %entry.plus20 = getelementptr i8, i8* %entry.ptr, i64 32
  %entry.plus20.p = bitcast i8* %entry.plus20 to i8**
  store i8* %img.ptr, i8** %entry.plus20.p, align 8
  %entry.p32 = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %entry.p32, align 4

  %mod.base = call i8* @sub_140002750()
  %img.plusC = getelementptr i8, i8* %img.ptr, i64 12
  %img.plusC.p = bitcast i8* %img.plusC to i32*
  %img.edx = load i32, i32* %img.plusC.p, align 4
  %img.edx64 = sext i32 %img.edx to i64
  %region.addr = getelementptr i8, i8* %mod.base, i64 %img.edx64

  %entry.plus18 = getelementptr i8, i8* %entry.ptr, i64 24
  %entry.plus18.p = bitcast i8* %entry.plus18 to i8**
  store i8* %region.addr, i8** %entry.plus18.p, align 8

  %buf = alloca %struct.MEMORY_BASIC_INFORMATION, align 8
  %vq.ret = call i64 @VirtualQuery(i8* %region.addr, %struct.MEMORY_BASIC_INFORMATION* %buf, i64 48)
  %vq.ok = icmp ne i64 %vq.ret, 0
  br i1 %vq.ok, label %vq_ok, label %vq_fail

vq_fail:                                           ; preds = %hasimg
  %table.base2 = load i8*, i8** @qword_1400070A8, align 8
  %n64b = sext i32 %n.cur to i64
  %mul5b = mul i64 %n64b, 5
  %off.bytes.b = shl i64 %mul5b, 3
  %entry.ptr.b = getelementptr i8, i8* %table.base2, i64 %off.bytes.b
  %entry.plus18.b = getelementptr i8, i8* %entry.ptr.b, i64 24
  %entry.plus18.bp = bitcast i8* %entry.plus18.b to i8**
  %addr.stored = load i8*, i8** %entry.plus18.bp, align 8
  %img.plus8 = getelementptr i8, i8* %img.ptr, i64 8
  %img.plus8.p = bitcast i8* %img.plus8 to i32*
  %bytes.sz = load i32, i32* %img.plus8.p, align 4
  %fmt.vq = getelementptr inbounds [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  %call.vq = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt.vq, i32 %bytes.sz, i8* %addr.stored)
  ret void

vq_ok:                                             ; preds = %hasimg
  %prot.ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 6
  %prot.val = load i32, i32* %prot.ptr, align 4
  %t1 = sub i32 %prot.val, 4
  %t1m = and i32 %t1, -5
  %is.good1 = icmp eq i32 %t1m, 0
  br i1 %is.good1, label %good_prot, label %cont_check

cont_check:                                        ; preds = %vq_ok
  %t2 = sub i32 %prot.val, 64
  %t2m = and i32 %t2, -65
  %is.good2 = icmp eq i32 %t2m, 0
  br i1 %is.good2, label %good_prot, label %need_fix

good_prot:                                         ; preds = %cont_check, %vq_ok
  %cnt0 = load i32, i32* @dword_1400070A4, align 4
  %cnt1 = add i32 %cnt0, 1
  store i32 %cnt1, i32* @dword_1400070A4, align 4
  ret void

need_fix:                                          ; preds = %cont_check
  %is2 = icmp eq i32 %prot.val, 2
  %fl.sel = select i1 %is2, i32 4, i32 64

  %region.size.ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 4
  %region.size = load i64, i64* %region.size.ptr, align 8

  %entry.plus08 = getelementptr i8, i8* %entry.ptr, i64 8
  %entry.plus08.p = bitcast i8* %entry.plus08 to i8**
  store i8* %region.addr, i8** %entry.plus08.p, align 8
  %entry.plus10 = getelementptr i8, i8* %entry.ptr, i64 16
  %entry.plus10.p = bitcast i8* %entry.plus10 to i64*
  store i64 %region.size, i64* %entry.plus10.p, align 8

  %oldprot = alloca i32, align 4
  %vp.ok.i32 = call i32 @VirtualProtect(i8* %region.addr, i64 %region.size, i32 %fl.sel, i32* %oldprot)
  %vp.ok = icmp ne i32 %vp.ok.i32, 0
  br i1 %vp.ok, label %good_prot2, label %vp_fail

good_prot2:                                        ; preds = %need_fix
  %cnt2 = load i32, i32* @dword_1400070A4, align 4
  %cnt3 = add i32 %cnt2, 1
  store i32 %cnt3, i32* @dword_1400070A4, align 4
  ret void

vp_fail:                                           ; preds = %need_fix
  %gle = call i32 @GetLastError()
  %fmt.vp = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  %call.vp = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt.vp, i32 %gle)
  ret void
}