; ModuleID = 'sub_140001B30.ll'
target triple = "x86_64-pc-windows-msvc"

%Entry = type { i32, i32, i8*, i64, i8*, i8* } ; size 0x28: [0]=i32, [4]=i32 pad, [8]=ptr, [16]=i64, [24]=ptr, [32]=ptr
%MBI   = type { i8*, i8*, i32, i32, i64, i32, i32, i32, i32 } ; size 0x30 matching MEMORY_BASIC_INFORMATION layout

@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global %Entry*, align 8
@qword_140008260 = external global i32 ()*, align 8

@.str_vprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00", align 1
@.str_vquery   = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00", align 1
@.str_noimg    = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002610(i8* %addr)
declare i8* @sub_140002750()
declare i64 @sub_14001FAD3(i8* %addr, %MBI* %out, i64 %len)
declare i32 @loc_14000EEBA(i8* %base, i64 %size, i32 %newprot, %Entry* %entry)
declare void @sub_140001AD0(i8* %fmt, ...)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

define dso_local void @sub_140001B30(i8* %addr) {
entry:
  %count.ptr = getelementptr inbounds i32, i32* @dword_1400070A4, i64 0
  %count0 = load i32, i32* %count.ptr, align 4
  %has_entries = icmp sgt i32 %count0, 0
  br i1 %has_entries, label %loop.prep, label %noexisting

loop.prep:
  %arr0 = load %Entry*, %Entry** @qword_1400070A8, align 8
  br label %loop

loop:
  %i = phi i32 [ 0, %loop.prep ], [ %i.next, %loop.inc ]
  %entry.ptr = getelementptr inbounds %Entry, %Entry* %arr0, i32 %i
  %field4.ptr = getelementptr inbounds %Entry, %Entry* %entry.ptr, i32 0, i32 4
  %base.ptr = load i8*, i8** %field4.ptr, align 8
  %field5.ptr = getelementptr inbounds %Entry, %Entry* %entry.ptr, i32 0, i32 5
  %hdr.ptr = load i8*, i8** %field5.ptr, align 8
  %addr.int = ptrtoint i8* %addr to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %addr_ge_base = icmp uge i64 %addr.int, %base.int
  br i1 %addr_ge_base, label %check.size, label %loop.inc

check.size:
  %hdr.plus8 = getelementptr inbounds i8, i8* %hdr.ptr, i64 8
  %hdr.size32.p = bitcast i8* %hdr.plus8 to i32*
  %size32 = load i32, i32* %hdr.size32.p, align 4
  %size64 = zext i32 %size32 to i64
  %end.int = add i64 %base.int, %size64
  %in_range = icmp ult i64 %addr.int, %end.int
  br i1 %in_range, label %foundExisting, label %loop.inc

loop.inc:
  %i.next = add i32 %i, 1
  %cont = icmp slt i32 %i.next, %count0
  br i1 %cont, label %loop, label %noexisting

foundExisting:
  ret void

noexisting:
  %hdr.new = call i8* @sub_140002610(i8* %addr)
  %is.null = icmp eq i8* %hdr.new, null
  br i1 %is.null, label %noimage, label %haveSec

noimage:
  %fmt.noimg = getelementptr inbounds [32 x i8], [32 x i8]* @.str_noimg, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.noimg, i8* %addr)
  ret void

haveSec:
  %arr1 = load %Entry*, %Entry** @qword_1400070A8, align 8
  %count1 = load i32, i32* @dword_1400070A4, align 4
  %entry.new = getelementptr inbounds %Entry, %Entry* %arr1, i32 %count1
  %field5.new = getelementptr inbounds %Entry, %Entry* %entry.new, i32 0, i32 5
  store i8* %hdr.new, i8** %field5.new, align 8
  %field0.new = getelementptr inbounds %Entry, %Entry* %entry.new, i32 0, i32 0
  store i32 0, i32* %field0.new, align 4
  %modbase = call i8* @sub_140002750()
  %hdr.plusC = getelementptr inbounds i8, i8* %hdr.new, i64 12
  %hdr.off32.p = bitcast i8* %hdr.plusC to i32*
  %off32 = load i32, i32* %hdr.off32.p, align 4
  %off64 = zext i32 %off32 to i64
  %vq.addr = getelementptr inbounds i8, i8* %modbase, i64 %off64
  %field4.new = getelementptr inbounds %Entry, %Entry* %entry.new, i32 0, i32 4
  store i8* %vq.addr, i8** %field4.new, align 8
  %mbi = alloca %MBI, align 8
  %mbi.i8 = bitcast %MBI* %mbi to i8*
  call void @llvm.memset.p0i8.i64(i8* %mbi.i8, i8 0, i64 48, i1 false)
  %vq.ret = call i64 @sub_14001FAD3(i8* %vq.addr, %MBI* %mbi, i64 48)
  %vq.ok = icmp ne i64 %vq.ret, 0
  br i1 %vq.ok, label %vq_ok, label %vq_fail

vq_fail:
  %fmt.vq = getelementptr inbounds [49 x i8], [49 x i8]* @.str_vquery, i64 0, i64 0
  %hdr.plus8.b = getelementptr inbounds i8, i8* %hdr.new, i64 8
  %hdr.bytes.p = bitcast i8* %hdr.plus8.b to i32*
  %hdr.bytes = load i32, i32* %hdr.bytes.p, align 4
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.vq, i32 %hdr.bytes, i8* %vq.addr)
  ret void

vq_ok:
  %prot.p = getelementptr inbounds %MBI, %MBI* %mbi, i32 0, i32 6
  %prot = load i32, i32* %prot.p, align 4
  %is4 = icmp eq i32 %prot, 4
  %is8 = icmp eq i32 %prot, 8
  %is64 = icmp eq i32 %prot, 64
  %is128 = icmp eq i32 %prot, 128
  %rw.ok = or i1 %is4, %is8
  %xrw.ok = or i1 %is64, %is128
  %prot.ok = or i1 %rw.ok, %xrw.ok
  br i1 %prot.ok, label %inc_and_ret, label %need_vp

need_vp:
  %isRO = icmp eq i32 %prot, 2
  %newProt = select i1 %isRO, i32 4, i32 64
  %base.p = getelementptr inbounds %MBI, %MBI* %mbi, i32 0, i32 0
  %base = load i8*, i8** %base.p, align 8
  %size.p = getelementptr inbounds %MBI, %MBI* %mbi, i32 0, i32 4
  %size = load i64, i64* %size.p, align 8
  %field2.new = getelementptr inbounds %Entry, %Entry* %entry.new, i32 0, i32 2
  store i8* %base, i8** %field2.new, align 8
  %field3.new = getelementptr inbounds %Entry, %Entry* %entry.new, i32 0, i32 3
  store i64 %size, i64* %field3.new, align 8
  %vp.res = call i32 @loc_14000EEBA(i8* %base, i64 %size, i32 %newProt, %Entry* %entry.new)
  %vp.ok = icmp ne i32 %vp.res, 0
  br i1 %vp.ok, label %inc_and_ret, label %vp_fail

vp_fail:
  %getlast.p = load i32 ()*, i32 ()** @qword_140008260, align 8
  %err = call i32 %getlast.p()
  %fmt.vp = getelementptr inbounds [39 x i8], [39 x i8]* @.str_vprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.vp, i32 %err)
  ret void

inc_and_ret:
  %oldc = load i32, i32* @dword_1400070A4, align 4
  %newc = add i32 %oldc, 1
  store i32 %newc, i32* @dword_1400070A4, align 4
  ret void
}