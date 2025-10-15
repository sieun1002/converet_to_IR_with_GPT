; ModuleID = 'fixed_module'
source_filename = "fixed_module.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@aVirtualprotect = internal constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = internal constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@aAddressPHasNoI = internal constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare i64 @sub_14001FAD3(i8*, i8*, i32)
declare i32 @loc_14000EEBA(i8*, i64, i32, i8*)
declare i32 @qword_140008260()
declare i32 @sub_140001AD0(i8*, ...)

define dso_local void @sub_140001B30(i8* %addr) {
entry:
  %count.load = load i32, i32* @dword_1400070A4, align 4
  %cmp.gt0 = icmp sgt i32 %count.load, 0
  br i1 %cmp.gt0, label %loop_prep, label %zero_count

loop_prep:
  %array.base0 = load i8*, i8** @qword_1400070A8, align 8
  %startptr0 = getelementptr i8, i8* %array.base0, i64 24
  br label %loop

loop:
  %i.phi = phi i32 [ 0, %loop_prep ], [ %i.next, %loop_continue ]
  %ptr.phi = phi i8* [ %startptr0, %loop_prep ], [ %ptr.next, %loop_continue ]
  %start.field.ptr = bitcast i8* %ptr.phi to i8**
  %start.load = load i8*, i8** %start.field.ptr, align 8
  %addr.i64 = ptrtoint i8* %addr to i64
  %start.i64 = ptrtoint i8* %start.load to i64
  %addr.below = icmp ult i64 %addr.i64, %start.i64
  br i1 %addr.below, label %loop_continue, label %check_end

check_end:
  %info.ptr.i8 = getelementptr i8, i8* %ptr.phi, i64 8
  %info.ptr = bitcast i8* %info.ptr.i8 to i8**
  %info.load = load i8*, i8** %info.ptr, align 8
  %size.ptr.i8 = getelementptr i8, i8* %info.load, i64 8
  %size.ptr = bitcast i8* %size.ptr.i8 to i32*
  %size.load = load i32, i32* %size.ptr, align 4
  %size.zext = zext i32 %size.load to i64
  %end.i64 = add i64 %start.i64, %size.zext
  %in.range = icmp ult i64 %addr.i64, %end.i64
  br i1 %in.range, label %ret_early, label %loop_continue

loop_continue:
  %i.next = add i32 %i.phi, 1
  %ptr.next = getelementptr i8, i8* %ptr.phi, i64 40
  %cmp.cont = icmp ne i32 %i.next, %count.load
  br i1 %cmp.cont, label %loop, label %B88

zero_count:
  br label %B88

ret_early:
  ret void

B88:
  %insert.idx = phi i32 [ 0, %zero_count ], [ %count.load, %loop_continue ]
  %call.sub_2610 = call i8* @sub_140002610(i8* %addr)
  %rdi.null = icmp eq i8* %call.sub_2610, null
  br i1 %rdi.null, label %C82, label %after_rdi

C82:
  %fmt.addr.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  %log.addr = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt.addr.ptr, i8* %addr)
  ret void

after_rdi:
  %array.base1 = load i8*, i8** @qword_1400070A8, align 8
  %insert.idx.sext = sext i32 %insert.idx to i64
  %entry.offset.bytes = mul nsw i64 %insert.idx.sext, 40
  %entry.ptr1 = getelementptr i8, i8* %array.base1, i64 %entry.offset.bytes
  %field20.ptr.i8 = getelementptr i8, i8* %entry.ptr1, i64 32
  %field20.ptr = bitcast i8* %field20.ptr.i8 to i8**
  store i8* %call.sub_2610, i8** %field20.ptr, align 8
  %field0.ptr = bitcast i8* %entry.ptr1 to i32*
  store i32 0, i32* %field0.ptr, align 4
  %call.sub_2750 = call i8* @sub_140002750()
  %rdi.offC.i8 = getelementptr i8, i8* %call.sub_2610, i64 12
  %rdi.offC.i32ptr = bitcast i8* %rdi.offC.i8 to i32*
  %offC.load = load i32, i32* %rdi.offC.i32ptr, align 4
  %offC.zext = zext i32 %offC.load to i64
  %rcx.addr = getelementptr i8, i8* %call.sub_2750, i64 %offC.zext
  %field18.ptr.i8 = getelementptr i8, i8* %entry.ptr1, i64 24
  %field18.ptr = bitcast i8* %field18.ptr.i8 to i8**
  store i8* %rcx.addr, i8** %field18.ptr, align 8
  %buf.alloca = alloca [48 x i8], align 16
  %buf.as.i8 = bitcast [48 x i8]* %buf.alloca to i8*
  %call.vq = call i64 @sub_14001FAD3(i8* %rcx.addr, i8* %buf.as.i8, i32 48)
  %vq.zero = icmp eq i64 %call.vq, 0
  br i1 %vq.zero, label %C67, label %after_vq

C67:
  %size.ptr2.i8 = getelementptr i8, i8* %call.sub_2610, i64 8
  %size.ptr2 = bitcast i8* %size.ptr2.i8 to i32*
  %size.val2 = load i32, i32* %size.ptr2, align 4
  %fmt.vq.ptr = getelementptr inbounds [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  %log.vq = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt.vq.ptr, i32 %size.val2, i8* %rcx.addr)
  %fmt.addr.ptr2 = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  %log.addr2 = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt.addr.ptr2, i8* %addr)
  ret void

after_vq:
  %buf.base.i8 = bitcast [48 x i8]* %buf.alloca to i8*
  %off2C.i8 = getelementptr i8, i8* %buf.base.i8, i64 44
  %prot.ptr = bitcast i8* %off2C.i8 to i32*
  %eax.prot = load i32, i32* %prot.ptr, align 4
  %eax.minus4 = sub i32 %eax.prot, 4
  %mask1 = and i32 %eax.minus4, -5
  %is.zero1 = icmp eq i32 %mask1, 0
  br i1 %is.zero1, label %inc_and_ret, label %check2

check2:
  %eax.minus64 = sub i32 %eax.prot, 64
  %mask2 = and i32 %eax.minus64, -65
  %is.zero2 = icmp eq i32 %mask2, 0
  br i1 %is.zero2, label %inc_and_ret, label %C10

inc_and_ret:
  %old.count = load i32, i32* @dword_1400070A4, align 4
  %new.count = add i32 %old.count, 1
  store i32 %new.count, i32* @dword_1400070A4, align 4
  ret void

C10:
  %cmp.two = icmp eq i32 %eax.prot, 2
  %newprot.sel = select i1 %cmp.two, i32 4, i32 64
  %buf.baseaddr.ptr = bitcast [48 x i8]* %buf.alloca to i8*
  %baseaddr.ptr = bitcast i8* %buf.baseaddr.ptr to i8**
  %baseaddr.load = load i8*, i8** %baseaddr.ptr, align 8
  %region.sz.i8 = getelementptr i8, i8* %buf.baseaddr.ptr, i64 24
  %region.sz.ptr = bitcast i8* %region.sz.i8 to i64*
  %region.sz.load = load i64, i64* %region.sz.ptr, align 8
  %array.base2 = load i8*, i8** @qword_1400070A8, align 8
  %entry.ptr2 = getelementptr i8, i8* %array.base2, i64 %entry.offset.bytes
  %field8.ptr.i8 = getelementptr i8, i8* %entry.ptr2, i64 8
  %field8.ptr = bitcast i8* %field8.ptr.i8 to i8**
  store i8* %baseaddr.load, i8** %field8.ptr, align 8
  %field10.ptr.i8 = getelementptr i8, i8* %entry.ptr2, i64 16
  %field10.ptr = bitcast i8* %field10.ptr.i8 to i8**
  %region.as.ptr = inttoptr i64 %region.sz.load to i8*
  store i8* %region.as.ptr, i8** %field10.ptr, align 8
  %call.vp = call i32 @loc_14000EEBA(i8* %baseaddr.load, i64 %region.sz.load, i32 %newprot.sel, i8* %entry.ptr2)
  %vp.ok = icmp ne i32 %call.vp, 0
  br i1 %vp.ok, label %inc_and_ret, label %vp_fail

vp_fail:
  %err.code = call i32 @qword_140008260()
  %fmt.vp.ptr = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  %log.vp = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt.vp.ptr, i32 %err.code)
  ret void
}