; ModuleID = 'sub_140001AD0_module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8
@qword_140008258 = external global i32 ()*, align 8

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00", align 1
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00", align 1
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_1400025B0(i8*)
declare i8* @sub_1400026F0()
declare i64 @sub_14030AB4D(i8*, i8*, i64)
declare void @sub_1403C03F0(i8*, i64, i32, i8*)
declare void @sub_140001A70(i8*, ...)

define void @sub_140001AD0(i8* %rcx.arg) local_unnamed_addr {
entry:
  %param = ptrtoint i8* %rcx.arg to i64
  %cnt.ld = load i32, i32* @dword_1400070A4, align 4
  %cnt.pos = icmp sgt i32 %cnt.ld, 0
  br i1 %cnt.pos, label %scan.init, label %c00.zero

scan.init:                                         ; preds = %entry
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %arr.start = getelementptr i8, i8* %base0, i64 24
  br label %scan.loop

scan.loop:                                          ; preds = %scan.iter, %scan.init
  %i.ph = phi i32 [ 0, %scan.init ], [ %i.next, %scan.iter ]
  %ptr.ph = phi i8* [ %arr.start, %scan.init ], [ %ptr.next, %scan.iter ]
  %entry.base.ptr = bitcast i8* %ptr.ph to i8**
  %r8.base.ld = load i8*, i8** %entry.base.ptr, align 8
  %r8.base.int = ptrtoint i8* %r8.base.ld to i64
  %cmp.lo = icmp ult i64 %param, %r8.base.int
  br i1 %cmp.lo, label %scan.iter, label %check.range

check.range:                                        ; preds = %scan.loop
  %rdx.ptr.ptr = getelementptr i8, i8* %ptr.ph, i64 8
  %rdx.ptr.cast = bitcast i8* %rdx.ptr.ptr to i8**
  %rdx.ptr = load i8*, i8** %rdx.ptr.cast, align 8
  %rdx.plus8 = getelementptr i8, i8* %rdx.ptr, i64 8
  %rdx.size.p = bitcast i8* %rdx.plus8 to i32*
  %size32 = load i32, i32* %rdx.size.p, align 4
  %size64 = zext i32 %size32 to i64
  %end.addr = add i64 %r8.base.int, %size64
  %in.range = icmp ult i64 %param, %end.addr
  br i1 %in.range, label %ret.success, label %scan.iter

scan.iter:                                          ; preds = %check.range, %scan.loop
  %i.next = add i32 %i.ph, 1
  %ptr.next = getelementptr i8, i8* %ptr.ph, i64 40
  %cnt.cur = load i32, i32* @dword_1400070A4, align 4
  %not.done = icmp ne i32 %i.next, %cnt.cur
  br i1 %not.done, label %scan.loop, label %b28.start

c00.zero:                                           ; preds = %entry
  br label %b28.start

b28.start:                                          ; preds = %scan.iter, %c00.zero
  %rsi.idx = phi i32 [ 0, %c00.zero ], [ %cnt.ld, %scan.iter ]
  %rdi.call = call i8* @sub_1400025B0(i8* %rcx.arg)
  %rdi.isnull = icmp eq i8* %rdi.call, null
  br i1 %rdi.isnull, label %c22.noimage, label %b3c.cont

b3c.cont:                                           ; preds = %b28.start
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %rsi.ext = sext i32 %rsi.idx to i64
  %mul5 = mul i64 %rsi.ext, 5
  %offset = shl i64 %mul5, 3
  %entry.ptr = getelementptr i8, i8* %base1, i64 %offset
  %entry.owner.p = getelementptr i8, i8* %entry.ptr, i64 32
  %entry.owner.pp = bitcast i8* %entry.owner.p to i8**
  store i8* %rdi.call, i8** %entry.owner.pp, align 8
  %entry.zero.p = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %entry.zero.p, align 4
  %buf.base = call i8* @sub_1400026F0()
  %rdi.plusC = getelementptr i8, i8* %rdi.call, i64 12
  %rdi.plusC.i32p = bitcast i8* %rdi.plusC to i32*
  %edx.val = load i32, i32* %rdi.plusC.i32p, align 4
  %edx.z = zext i32 %edx.val to i64
  %rcx.vq = getelementptr i8, i8* %buf.base, i64 %edx.z
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %entry.ptr2 = getelementptr i8, i8* %base2, i64 %offset
  %entry.q.p = getelementptr i8, i8* %entry.ptr2, i64 24
  %entry.q.pp = bitcast i8* %entry.q.p to i8**
  store i8* %rcx.vq, i8** %entry.q.pp, align 8
  %mbi = alloca { i8*, i8*, i32, i32, i64, i32, i32, i32, i32 }, align 8
  %mbi.cast = bitcast { i8*, i8*, i32, i32, i64, i32, i32, i32, i32 }* %mbi to i8*
  %call.vq = call i64 @sub_14030AB4D(i8* %rcx.vq, i8* %mbi.cast, i64 48)
  %ok.vq = icmp ne i64 %call.vq, 0
  br i1 %ok.vq, label %b8a.testprot, label %c07.vqfail

b8a.testprot:                                       ; preds = %b3c.cont
  %mbi.protect.p = getelementptr { i8*, i8*, i32, i32, i64, i32, i32, i32, i32 }, { i8*, i8*, i32, i32, i64, i32, i32, i32, i32 }* %mbi, i32 0, i32 6
  %prot.ld = load i32, i32* %mbi.protect.p, align 4
  %t1 = sub i32 %prot.ld, 4
  %t2 = and i32 %t1, -5
  %z1 = icmp eq i32 %t2, 0
  br i1 %z1, label %b9e.inccnt, label %b8a.cont

b8a.cont:                                           ; preds = %b8a.testprot
  %t3 = sub i32 %prot.ld, 64
  %t4 = and i32 %t3, -65
  %nz2 = icmp ne i32 %t4, 0
  br i1 %nz2, label %bb0.doVP, label %b9e.inccnt

bb0.doVP:                                           ; preds = %b8a.cont
  %cmp.a2 = icmp eq i32 %prot.ld, 2
  %r8d.sel = select i1 %cmp.a2, i32 4, i32 64
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %entry.ptr3 = getelementptr i8, i8* %base3, i64 %offset
  %mbi.baseaddr.p = getelementptr { i8*, i8*, i32, i32, i64, i32, i32, i32, i32 }, { i8*, i8*, i32, i32, i64, i32, i32, i32, i32 }* %mbi, i32 0, i32 0
  %baseaddr = load i8*, i8** %mbi.baseaddr.p, align 8
  %mbi.rs.p = getelementptr { i8*, i8*, i32, i32, i64, i32, i32, i32, i32 }, { i8*, i8*, i32, i32, i64, i32, i32, i32, i32 }* %mbi, i32 0, i32 4
  %regionsize = load i64, i64* %mbi.rs.p, align 8
  %entry.addr.p = getelementptr i8, i8* %entry.ptr3, i64 8
  %entry.addr.pp = bitcast i8* %entry.addr.p to i8**
  store i8* %baseaddr, i8** %entry.addr.pp, align 8
  %entry.sz.p = getelementptr i8, i8* %entry.ptr3, i64 16
  %entry.sz.pp = bitcast i8* %entry.sz.p to i64*
  store i64 %regionsize, i64* %entry.sz.pp, align 8
  call void @sub_1403C03F0(i8* %baseaddr, i64 %regionsize, i32 %r8d.sel, i8* %entry.ptr3)
  br label %b9e.inccnt

b9e.inccnt:                                         ; preds = %bb0.doVP, %b8a.cont, %b8a.testprot
  %cnt.old = load i32, i32* @dword_1400070A4, align 4
  %cnt.inc = add i32 %cnt.old, 1
  store i32 %cnt.inc, i32* @dword_1400070A4, align 4
  br label %ret.success

c07.vqfail:                                         ; preds = %b3c.cont
  %base4 = load i8*, i8** @qword_1400070A8, align 8
  %rdi.plus8 = getelementptr i8, i8* %rdi.call, i64 8
  %rdi.plus8.i32p = bitcast i8* %rdi.plus8 to i32*
  %bytes = load i32, i32* %rdi.plus8.i32p, align 4
  %entry.ptr4 = getelementptr i8, i8* %base4, i64 %offset
  %entry.q2.p = getelementptr i8, i8* %entry.ptr4, i64 24
  %entry.q2.pp = bitcast i8* %entry.q2.p to i8**
  %addr.at = load i8*, i8** %entry.q2.pp, align 8
  %fmt2.p = getelementptr [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001A70(i8* %fmt2.p, i32 %bytes, i8* %addr.at)
  br label %ret.success

c22.noimage:                                        ; preds = %b28.start
  %fmt3.p = getelementptr [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001A70(i8* %fmt3.p, i8* %rcx.arg)
  br label %ret.success

ret.success:                                        ; preds = %c07.vqfail, %b9e.inccnt, %check.range
  ret void
}