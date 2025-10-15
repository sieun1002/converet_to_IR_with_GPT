; ModuleID = 'sub_140001B30.ll'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8

@.str_vp = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00", align 1
@.str_vquery = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00", align 1
@.str_noimg = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare i64 @VirtualQuery(i8*, i8*, i64)
declare i32 @VirtualProtect(i8*, i64, i32, i32*)
declare i32 @GetLastError()
declare void @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %addr) {
entry:
  %count0 = load i32, i32* @dword_1400070A4, align 4
  %has_entries = icmp sgt i32 %count0, 0
  br i1 %has_entries, label %scan.prep, label %call_sub

scan.prep:
  %base.scan = load i8*, i8** @qword_1400070A8, align 8
  br label %scan

scan:
  %idx = phi i32 [ 0, %scan.prep ], [ %idx.next, %scan.cont ]
  %idx64 = sext i32 %idx to i64
  %stride = mul nsw i64 %idx64, 40
  %entries_base = getelementptr inbounds i8, i8* %base.scan, i64 24
  %cur = getelementptr inbounds i8, i8* %entries_base, i64 %stride
  %cur_start_pp = bitcast i8* %cur to i8**
  %start = load i8*, i8** %cur_start_pp, align 8
  %before = icmp ult i8* %addr, %start
  br i1 %before, label %scan.cont, label %range.check

range.check:
  %cur_plus8 = getelementptr inbounds i8, i8* %cur, i64 8
  %sptr_pp = bitcast i8* %cur_plus8 to i8**
  %sptr = load i8*, i8** %sptr_pp, align 8
  %sz_p = getelementptr inbounds i8, i8* %sptr, i64 8
  %sz_pi32 = bitcast i8* %sz_p to i32*
  %sz32 = load i32, i32* %sz_pi32, align 4
  %sz64 = zext i32 %sz32 to i64
  %endp = getelementptr inbounds i8, i8* %start, i64 %sz64
  %inrange = icmp ult i8* %addr, %endp
  br i1 %inrange, label %ret, label %scan.cont

scan.cont:
  %idx.next = add i32 %idx, 1
  %more = icmp ne i32 %idx.next, %count0
  br i1 %more, label %scan, label %call_sub

ret:
  ret void

call_sub:
  %img = call i8* @sub_140002610(i8* %addr)
  %img.isnull = icmp eq i8* %img, null
  br i1 %img.isnull, label %no_image, label %have_image

no_image:
  %fmt.noimg = getelementptr inbounds [32 x i8], [32 x i8]* @.str_noimg, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.noimg, i8* %addr)
  ret void

have_image:
  %base = load i8*, i8** @qword_1400070A8, align 8
  %count64 = sext i32 %count0 to i64
  %off.bytes = mul i64 %count64, 40
  %entry = getelementptr inbounds i8, i8* %base, i64 %off.bytes
  %entry_p20 = getelementptr inbounds i8, i8* %entry, i64 32
  %entry_p20_pp = bitcast i8* %entry_p20 to i8**
  store i8* %img, i8** %entry_p20_pp, align 8
  %entry_pi32 = bitcast i8* %entry to i32*
  store i32 0, i32* %entry_pi32, align 4
  %modbase = call i8* @sub_140002750()
  %img_plus_c = getelementptr inbounds i8, i8* %img, i64 12
  %img_plus_c_i32p = bitcast i8* %img_plus_c to i32*
  %len32 = load i32, i32* %img_plus_c_i32p, align 4
  %len64 = zext i32 %len32 to i64
  %qaddr = getelementptr inbounds i8, i8* %modbase, i64 %len64
  %entry_p18 = getelementptr inbounds i8, i8* %entry, i64 24
  %entry_p18_pp = bitcast i8* %entry_p18 to i8**
  store i8* %qaddr, i8** %entry_p18_pp, align 8
  %buf = alloca [48 x i8], align 8
  %buf0 = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  %vq = call i64 @VirtualQuery(i8* %qaddr, i8* %buf0, i64 48)
  %vq.zero = icmp eq i64 %vq, 0
  br i1 %vq.zero, label %vq.fail, label %vq.ok

vq.fail:
  %img_plus_8 = getelementptr inbounds i8, i8* %img, i64 8
  %img_plus_8_i32p = bitcast i8* %img_plus_8 to i32*
  %bytes32 = load i32, i32* %img_plus_8_i32p, align 4
  %fmt.vq = getelementptr inbounds [49 x i8], [49 x i8]* @.str_vquery, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.vq, i32 %bytes32, i8* %qaddr)
  ret void

vq.ok:
  %prot_p_i8 = getelementptr inbounds i8, i8* %buf0, i64 36
  %prot_p = bitcast i8* %prot_p_i8 to i32*
  %prot = load i32, i32* %prot_p, align 4
  %prot_m4 = sub i32 %prot, 4
  %t1 = and i32 %prot_m4, 4294967291
  %t1.iszero = icmp eq i32 %t1, 0
  br i1 %t1.iszero, label %inc.count, label %test2

test2:
  %prot_m40 = sub i32 %prot, 64
  %t2 = and i32 %prot_m40, 4294967231
  %t2.nzero = icmp ne i32 %t2, 0
  br i1 %t2.nzero, label %need.protect, label %inc.count

inc.count:
  %oldc = load i32, i32* @dword_1400070A4, align 4
  %newc = add i32 %oldc, 1
  store i32 %newc, i32* @dword_1400070A4, align 4
  ret void

need.protect:
  %is_ro = icmp eq i32 %prot, 2
  %baseaddr_pp = bitcast i8* %buf0 to i8**
  %baseaddr = load i8*, i8** %baseaddr_pp, align 8
  %rs_i8 = getelementptr inbounds i8, i8* %buf0, i64 24
  %rs_p = bitcast i8* %rs_i8 to i64*
  %rs = load i64, i64* %rs_p, align 8
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %off.bytes2 = mul i64 %count64, 40
  %entry2 = getelementptr inbounds i8, i8* %base2, i64 %off.bytes2
  %entry2_p8 = getelementptr inbounds i8, i8* %entry2, i64 8
  %entry2_p8_pp = bitcast i8* %entry2_p8 to i8**
  store i8* %baseaddr, i8** %entry2_p8_pp, align 8
  %entry2_p10 = getelementptr inbounds i8, i8* %entry2, i64 16
  %entry2_p10_p64 = bitcast i8* %entry2_p10 to i64*
  store i64 %rs, i64* %entry2_p10_p64, align 8
  %oldprot_p = bitcast i8* %entry2 to i32*
  %newprot = select i1 %is_ro, i32 4, i32 64
  %vp = call i32 @VirtualProtect(i8* %baseaddr, i64 %rs, i32 %newprot, i32* %oldprot_p)
  %vp.ok = icmp ne i32 %vp, 0
  br i1 %vp.ok, label %inc.count, label %vp.fail

vp.fail:
  %err = call i32 @GetLastError()
  %fmt.vp = getelementptr inbounds [39 x i8], [39 x i8]* @.str_vp, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.vp, i32 %err)
  ret void
}