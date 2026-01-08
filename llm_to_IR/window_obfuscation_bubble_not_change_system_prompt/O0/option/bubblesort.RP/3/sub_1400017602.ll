; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@aVirtualprotect = external global i8
@aVirtualqueryFa = external global i8
@aAddressPHasNoI = external global i8

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare i64 @VirtualQuery(i8*, i8*, i64)
declare i32 @VirtualProtect(i8*, i64, i32, i32*)
declare i32 @GetLastError()
declare void @sub_140001700(i8*, i32)

define void @sub_140001760(i8* %rcx) {
entry:
  %Buffer = alloca [48 x i8], align 8
  %buf.i8 = bitcast [48 x i8]* %Buffer to i8*
  %count0 = load i32, i32* @dword_1400070A4, align 4
  %cmp.le = icmp sle i32 %count0, 0
  br i1 %cmp.le, label %init_case, label %scan_loop_init

scan_loop_init:
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %scan0 = getelementptr i8, i8* %base0, i64 24
  br label %scan_loop

scan_loop:
  %idx = phi i32 [ 0, %scan_loop_init ], [ %idx.next, %scan_step ]
  %scan.cur = phi i8* [ %scan0, %scan_loop_init ], [ %scan.next, %scan_step ]
  %entry.addr.ptr = bitcast i8* %scan.cur to i8**
  %entry.addr = load i8*, i8** %entry.addr.ptr, align 8
  %param.i64 = ptrtoint i8* %rcx to i64
  %entry.addr.i64 = ptrtoint i8* %entry.addr to i64
  %is.below = icmp ult i64 %param.i64, %entry.addr.i64
  br i1 %is.below, label %scan_step, label %check_range

check_range:
  %p.hdr.loc = getelementptr i8, i8* %scan.cur, i64 8
  %p.hdr.ptr = bitcast i8* %p.hdr.loc to i8**
  %p.hdr = load i8*, i8** %p.hdr.ptr, align 8
  %len.ptr8 = getelementptr i8, i8* %p.hdr, i64 8
  %len32.ptr = bitcast i8* %len.ptr8 to i32*
  %len32 = load i32, i32* %len32.ptr, align 4
  %len64 = zext i32 %len32 to i64
  %end.i64 = add i64 %entry.addr.i64, %len64
  %inrange = icmp ult i64 %param.i64, %end.i64
  br i1 %inrange, label %ret_early, label %scan_step

scan_step:
  %idx.next = add i32 %idx, 1
  %scan.next = getelementptr i8, i8* %scan.cur, i64 40
  %cmp.jnz = icmp ne i32 %idx.next, %count0
  br i1 %cmp.jnz, label %scan_loop, label %create_from_scan

create_from_scan:
  br label %create_new

init_case:
  br label %create_new

create_new:
  %index = phi i32 [ 0, %init_case ], [ %count0, %create_from_scan ]
  %rdi = call i8* @sub_140002250(i8* %rcx)
  %is.null = icmp eq i8* %rdi, null
  br i1 %is.null, label %err_no_image, label %after_alloc

after_alloc:
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %idx64 = sext i32 %index to i64
  %offset.bytes = mul i64 %idx64, 40
  %entry.ptr = getelementptr i8, i8* %base1, i64 %offset.bytes
  %off32loc = getelementptr i8, i8* %entry.ptr, i64 32
  %off32ptr = bitcast i8* %off32loc to i8**
  store i8* %rdi, i8** %off32ptr, align 8
  %entry.i32ptr = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %entry.i32ptr, align 4
  %ret390 = call i8* @sub_140002390()
  %rdi.off.c = getelementptr i8, i8* %rdi, i64 12
  %rdi.off.c.i32 = bitcast i8* %rdi.off.c to i32*
  %edx.val = load i32, i32* %rdi.off.c.i32, align 4
  %edx64 = zext i32 %edx.val to i64
  %query.addr = getelementptr i8, i8* %ret390, i64 %edx64
  %entry.off.18 = getelementptr i8, i8* %entry.ptr, i64 24
  %entry.off.18.ptr = bitcast i8* %entry.off.18 to i8**
  store i8* %query.addr, i8** %entry.off.18.ptr, align 8
  %call.vq = call i64 @VirtualQuery(i8* %query.addr, i8* %buf.i8, i64 48)
  %vq.zero = icmp eq i64 %call.vq, 0
  br i1 %vq.zero, label %virtquery_fail, label %post_vq

post_vq:
  %buf.off.24 = getelementptr i8, i8* %buf.i8, i64 36
  %prot.ptr = bitcast i8* %buf.off.24 to i32*
  %eax.prot = load i32, i32* %prot.ptr, align 4
  %sub4 = sub i32 %eax.prot, 4
  %and1 = and i32 %sub4, 4294967291
  %cond1 = icmp eq i32 %and1, 0
  br i1 %cond1, label %inc_and_ret, label %check_mask2

check_mask2:
  %sub64 = sub i32 %eax.prot, 64
  %and2 = and i32 %sub64, 4294967231
  %cond2 = icmp eq i32 %and2, 0
  br i1 %cond2, label %inc_and_ret, label %do_protect

do_protect:
  %cmp2 = icmp eq i32 %eax.prot, 2
  %newprot = select i1 %cmp2, i32 4, i32 64
  %baseaddr.ptr = bitcast i8* %buf.i8 to i8**
  %baseaddr = load i8*, i8** %baseaddr.ptr, align 8
  %buf.off.18 = getelementptr i8, i8* %buf.i8, i64 24
  %regionsize.ptr = bitcast i8* %buf.off.18 to i64*
  %regionsize = load i64, i64* %regionsize.ptr, align 8
  %entry.off.8 = getelementptr i8, i8* %entry.ptr, i64 8
  %entry.off.8.ptr = bitcast i8* %entry.off.8 to i8**
  store i8* %baseaddr, i8** %entry.off.8.ptr, align 8
  %entry.off.10 = getelementptr i8, i8* %entry.ptr, i64 16
  %entry.off.10.ptr = bitcast i8* %entry.off.10 to i64*
  store i64 %regionsize, i64* %entry.off.10.ptr, align 8
  %oldprot.ptr = bitcast i8* %entry.ptr to i32*
  %vp.res = call i32 @VirtualProtect(i8* %baseaddr, i64 %regionsize, i32 %newprot, i32* %oldprot.ptr)
  %vp.ok = icmp ne i32 %vp.res, 0
  br i1 %vp.ok, label %inc_and_ret, label %vp_fail

vp_fail:
  %gle = call i32 @GetLastError()
  call void @sub_140001700(i8* @aVirtualprotect, i32 %gle)
  br label %init_case

virtquery_fail:
  %rdi.off.8 = getelementptr i8, i8* %rdi, i64 8
  %rdi.off.8.i32 = bitcast i8* %rdi.off.8 to i32*
  %bytes = load i32, i32* %rdi.off.8.i32, align 4
  %addr.in = load i8*, i8** %entry.off.18.ptr, align 8
  call void bitcast (void (i8*, i32)* @sub_140001700 to void (i8*, i32, i8*)*)(i8* @aVirtualqueryFa, i32 %bytes, i8* %addr.in)
  br label %err_no_image

err_no_image:
  call void bitcast (void (i8*, i32)* @sub_140001700 to void (i8*, i8*)*)(i8* @aAddressPHasNoI, i8* %rcx)
  br label %ret_noinc

inc_and_ret:
  %oldc = load i32, i32* @dword_1400070A4, align 4
  %newc = add i32 %oldc, 1
  store i32 %newc, i32* @dword_1400070A4, align 4
  br label %ret_early

ret_noinc:
  ret void

ret_early:
  ret void
}