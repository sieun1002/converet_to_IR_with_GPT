; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%MBI = type { i8*, i8*, i32, i32, i64, i32, i32, i32 }

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare i64 @sub_14001FAD3(i8*, i8*, i32)
declare void @sub_140001AD0(i8*, ...)
declare i32 @loc_14000EEBA(i8*, i64, i32, i8*, ...)
declare i32 @qword_140008260()

define void @sub_140001B30(i8* %arg) local_unnamed_addr {
entry:
  %count0 = load i32, i32* @dword_1400070A4, align 4
  %gt0 = icmp sgt i32 %count0, 0
  br i1 %gt0, label %loop.prep, label %noentries

loop.prep:
  %basearr.pre = load i8*, i8** @qword_1400070A8, align 8
  %scanptr0 = getelementptr i8, i8* %basearr.pre, i64 24
  br label %loop

loop:
  %i = phi i32 [ 0, %loop.prep ], [ %i.next, %loop.next ]
  %scanptr = phi i8* [ %scanptr0, %loop.prep ], [ %scanptr.next, %loop.next ]
  %scanptr.pp = bitcast i8* %scanptr to i8**
  %regionbase = load i8*, i8** %scanptr.pp, align 8
  %arg.int = ptrtoint i8* %arg to i64
  %rbase.int = ptrtoint i8* %regionbase to i64
  %cmp.low = icmp ult i64 %arg.int, %rbase.int
  br i1 %cmp.low, label %loop.next, label %afterlower

afterlower:
  %p8 = getelementptr i8, i8* %scanptr, i64 8
  %p8.pp = bitcast i8* %p8 to i8**
  %ptr2 = load i8*, i8** %p8.pp, align 8
  %ptr2p8 = getelementptr i8, i8* %ptr2, i64 8
  %size32p = bitcast i8* %ptr2p8 to i32*
  %size32 = load i32, i32* %size32p, align 4
  %size64 = zext i32 %size32 to i64
  %end.int = add i64 %rbase.int, %size64
  %inrange = icmp ult i64 %arg.int, %end.int
  br i1 %inrange, label %ret.early, label %loop.next

loop.next:
  %i.next = add i32 %i, 1
  %scanptr.next = getelementptr i8, i8* %scanptr, i64 40
  %cont = icmp ne i32 %i.next, %count0
  br i1 %cont, label %loop, label %noentries.cont

ret.early:
  ret void

noentries:
  br label %setup

noentries.cont:
  br label %setup

setup:
  %idx = phi i32 [ 0, %noentries ], [ %count0, %noentries.cont ]
  %desc = call i8* @sub_140002610(i8* %arg)
  %isnull = icmp eq i8* %desc, null
  br i1 %isnull, label %print_no_image, label %have_desc

have_desc:
  %basearr = load i8*, i8** @qword_1400070A8, align 8
  %idx.z = zext i32 %idx to i64
  %mul5 = mul i64 %idx.z, 5
  %off = shl i64 %mul5, 3
  %ent = getelementptr i8, i8* %basearr, i64 %off
  %ent_p20 = getelementptr i8, i8* %ent, i64 32
  %ent_p20.pp = bitcast i8* %ent_p20 to i8**
  store i8* %desc, i8** %ent_p20.pp, align 8
  %ent_i32 = bitcast i8* %ent to i32*
  store i32 0, i32* %ent_i32, align 4
  %base2 = call i8* @sub_140002750()
  %desc_pC = getelementptr i8, i8* %desc, i64 12
  %desc_pC_i32 = bitcast i8* %desc_pC to i32*
  %offval = load i32, i32* %desc_pC_i32, align 4
  %off64 = zext i32 %offval to i64
  %addr = getelementptr i8, i8* %base2, i64 %off64
  %ent_p18 = getelementptr i8, i8* %ent, i64 24
  %ent_p18.pp = bitcast i8* %ent_p18 to i8**
  store i8* %addr, i8** %ent_p18.pp, align 8
  %mbi = alloca %MBI, align 8
  %mbi.buf = bitcast %MBI* %mbi to i8*
  %vq = call i64 @sub_14001FAD3(i8* %addr, i8* %mbi.buf, i32 48)
  %vq.ok = icmp ne i64 %vq, 0
  br i1 %vq.ok, label %after_vq, label %vq_failed

after_vq:
  %protect.p = getelementptr inbounds %MBI, %MBI* %mbi, i32 0, i32 6
  %protect = load i32, i32* %protect.p, align 4
  %sub4 = sub i32 %protect, 4
  %and1 = and i32 %sub4, -5
  %iszero1 = icmp eq i32 %and1, 0
  br i1 %iszero1, label %inc_and_ret, label %check64

check64:
  %sub64 = sub i32 %protect, 64
  %and2 = and i32 %sub64, -65
  %iszero2 = icmp eq i32 %and2, 0
  br i1 %iszero2, label %inc_and_ret, label %do_vprotect

inc_and_ret:
  %c.old = load i32, i32* @dword_1400070A4, align 4
  %c.new = add i32 %c.old, 1
  store i32 %c.new, i32* @dword_1400070A4, align 4
  ret void

do_vprotect:
  %is2 = icmp eq i32 %protect, 2
  %newProt = select i1 %is2, i32 4, i32 64
  %baseaddr.p = getelementptr inbounds %MBI, %MBI* %mbi, i32 0, i32 0
  %baseaddr = load i8*, i8** %baseaddr.p, align 8
  %regionsize.p = getelementptr inbounds %MBI, %MBI* %mbi, i32 0, i32 4
  %regionsize = load i64, i64* %regionsize.p, align 8
  %ent_p8 = getelementptr i8, i8* %ent, i64 8
  %ent_p8.pp = bitcast i8* %ent_p8 to i8**
  store i8* %baseaddr, i8** %ent_p8.pp, align 8
  %ent_p10 = getelementptr i8, i8* %ent, i64 16
  %ent_p10.p64 = bitcast i8* %ent_p10 to i64*
  store i64 %regionsize, i64* %ent_p10.p64, align 8
  %vp.ok = call i32 (i8*, i64, i32, i8*, ...) @loc_14000EEBA(i8* %baseaddr, i64 %regionsize, i32 %newProt, i8* %ent, i8* %baseaddr)
  %vp.succ = icmp ne i32 %vp.ok, 0
  br i1 %vp.succ, label %inc_and_ret, label %vprotect_failed

vprotect_failed:
  %err = call i32 @qword_140008260()
  %fmt1.ptr = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt1.ptr, i32 %err)
  ret void

vq_failed:
  %basearr2 = load i8*, i8** @qword_1400070A8, align 8
  %ent2 = getelementptr i8, i8* %basearr2, i64 %off
  %ent2_p18 = getelementptr i8, i8* %ent2, i64 24
  %ent2_p18.pp = bitcast i8* %ent2_p18 to i8**
  %addr.logged = load i8*, i8** %ent2_p18.pp, align 8
  %desc_p8 = getelementptr i8, i8* %desc, i64 8
  %desc_p8_i32 = bitcast i8* %desc_p8 to i32*
  %bytes = load i32, i32* %desc_p8_i32, align 4
  %fmt2.ptr = getelementptr inbounds [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt2.ptr, i32 %bytes, i8* %addr.logged)
  br label %print_no_image

print_no_image:
  %fmt3.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt3.ptr, i8* %arg)
  ret void
}