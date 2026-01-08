; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8
@qword_140008260 = external global i32 ()*, align 8

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00", align 1
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00", align 1
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare i64 @loc_1403D6CC2(i8*, i8*, i32)
declare i32 @sub_1400E9A25(i8*, i64, i32, i8*)
declare i32 @sub_140001700(i8*, ...)

define void @sub_140001760(i8* %rcx) {
entry:
  %buf = alloca [48 x i8], align 8
  %buf.ptr = bitcast [48 x i8]* %buf to i8*
  %cnt.load = load i32, i32* @dword_1400070A4, align 4
  %cnt.le.zero = icmp sle i32 %cnt.load, 0
  br i1 %cnt.le.zero, label %retry_idx0_pre, label %search_setup

search_setup:                                      ; preds = %entry
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %rax0 = getelementptr inbounds i8, i8* %base0, i64 24
  br label %search_loop

search_loop:                                       ; preds = %inc_block, %search_setup
  %r9.phi = phi i32 [ 0, %search_setup ], [ %r9.next, %inc_block ]
  %rax.cur = phi i8* [ %rax0, %search_setup ], [ %rax.next, %inc_block ]
  %rax.cur.pp = bitcast i8* %rax.cur to i8**
  %r8.load = load i8*, i8** %rax.cur.pp, align 8
  %param.int = ptrtoint i8* %rcx to i64
  %r8.int = ptrtoint i8* %r8.load to i64
  %cmp.below = icmp ult i64 %param.int, %r8.int
  br i1 %cmp.below, label %inc_block, label %range_check

range_check:                                       ; preds = %search_loop
  %rax.cur.plus8 = getelementptr inbounds i8, i8* %rax.cur, i64 8
  %rax.cur.plus8.pp = bitcast i8* %rax.cur.plus8 to i8**
  %rdxp = load i8*, i8** %rax.cur.plus8.pp, align 8
  %rdxp.plus8 = getelementptr inbounds i8, i8* %rdxp, i64 8
  %rdx.sz.ptr = bitcast i8* %rdxp.plus8 to i32*
  %sz32 = load i32, i32* %rdx.sz.ptr, align 4
  %sz64 = zext i32 %sz32 to i64
  %r8.end = getelementptr inbounds i8, i8* %r8.load, i64 %sz64
  %r8.end.int = ptrtoint i8* %r8.end to i64
  %cmp.inrange = icmp ult i64 %param.int, %r8.end.int
  br i1 %cmp.inrange, label %ret_block, label %inc_block

inc_block:                                         ; preds = %range_check, %search_loop
  %r9.next = add i32 %r9.phi, 1
  %rax.next = getelementptr inbounds i8, i8* %rax.cur, i64 40
  %cmp.cont = icmp ne i32 %r9.next, %cnt.load
  br i1 %cmp.cont, label %search_loop, label %call_sub

retry_idx0_pre:                                    ; preds = %entry, %vp_fail_printed
  br label %call_sub

call_sub:                                          ; preds = %retry_idx0_pre, %inc_block
  %idx = phi i32 [ 0, %retry_idx0_pre ], [ %cnt.load, %inc_block ]
  %rdi.call = call i8* @sub_140002250(i8* %rcx)
  %rdi.isnull = icmp eq i8* %rdi.call, null
  br i1 %rdi.isnull, label %print_no_image_section, label %add_entry

add_entry:                                         ; preds = %call_sub
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %idx64 = sext i32 %idx to i64
  %mul5 = mul i64 %idx64, 5
  %entry.off = shl i64 %mul5, 3
  %entry.ptr = getelementptr inbounds i8, i8* %base1, i64 %entry.off
  %entry.plus20 = getelementptr inbounds i8, i8* %entry.ptr, i64 32
  %entry.plus20.pp = bitcast i8* %entry.plus20 to i8**
  store i8* %rdi.call, i8** %entry.plus20.pp, align 8
  %entry.i32ptr = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %entry.i32ptr, align 4
  %rax.base = call i8* @sub_140002390()
  %rdi.plus12 = getelementptr inbounds i8, i8* %rdi.call, i64 12
  %rdi.plus12.p32 = bitcast i8* %rdi.plus12 to i32*
  %off32 = load i32, i32* %rdi.plus12.p32, align 4
  %off64 = zext i32 %off32 to i64
  %rcx.addr = getelementptr inbounds i8, i8* %rax.base, i64 %off64
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %entry.off.plus18 = add i64 %entry.off, 24
  %entry.plus18 = getelementptr inbounds i8, i8* %base2, i64 %entry.off.plus18
  %entry.plus18.pp = bitcast i8* %entry.plus18 to i8**
  store i8* %rcx.addr, i8** %entry.plus18.pp, align 8
  %vq = call i64 @loc_1403D6CC2(i8* %rcx.addr, i8* %buf.ptr, i32 48)
  %vq.iszero = icmp eq i64 %vq, 0
  br i1 %vq.iszero, label %vq_fail, label %post_vq

vq_fail:                                          ; preds = %add_entry
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %entry.plus18.2 = getelementptr inbounds i8, i8* %base3, i64 %entry.off.plus18
  %entry.plus18.2.pp = bitcast i8* %entry.plus18.2 to i8**
  %r8.arg = load i8*, i8** %entry.plus18.2.pp, align 8
  %rdi.plus8 = getelementptr inbounds i8, i8* %rdi.call, i64 8
  %rdi.plus8.p32 = bitcast i8* %rdi.plus8 to i32*
  %edx.arg = load i32, i32* %rdi.plus8.p32, align 4
  %fmt.vq = getelementptr inbounds [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  %call.print.vq = call i32 (i8*, ...) @sub_140001700(i8* %fmt.vq, i32 %edx.arg, i8* %r8.arg)
  %fmt.addr = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  %rbx.off.as.ptr = inttoptr i64 %entry.off to i8*
  %call.print.addr = call i32 (i8*, ...) @sub_140001700(i8* %fmt.addr, i8* %rbx.off.as.ptr)
  br label %ret_block

post_vq:                                          ; preds = %add_entry
  %buf.plus24 = getelementptr inbounds i8, i8* %buf.ptr, i64 36
  %buf.plus24.p32 = bitcast i8* %buf.plus24 to i32*
  %protect = load i32, i32* %buf.plus24.p32, align 4
  %prot.minus4 = sub i32 %protect, 4
  %mask1 = and i32 %prot.minus4, 4294967291
  %mask1.iszero = icmp eq i32 %mask1, 0
  br i1 %mask1.iszero, label %inc_and_ret, label %chk2

chk2:                                             ; preds = %post_vq
  %prot.minus64 = sub i32 %protect, 64
  %mask2 = and i32 %prot.minus64, 4294967231
  %mask2.nz = icmp ne i32 %mask2, 0
  br i1 %mask2.nz, label %vp_call, label %inc_and_ret

inc_and_ret:                                      ; preds = %chk2, %post_vq
  %oldcnt = load i32, i32* @dword_1400070A4, align 4
  %newcnt = add i32 %oldcnt, 1
  store i32 %newcnt, i32* @dword_1400070A4, align 4
  br label %ret_block

vp_call:                                          ; preds = %chk2
  %is.eq.2 = icmp eq i32 %protect, 2
  %r8.sel = select i1 %is.eq.2, i32 4, i32 64
  %buf.base.p = bitcast i8* %buf.ptr to i8**
  %lpAddress = load i8*, i8** %buf.base.p, align 8
  %buf.plus18 = getelementptr inbounds i8, i8* %buf.ptr, i64 24
  %buf.plus18.p64 = bitcast i8* %buf.plus18 to i64*
  %dwSize = load i64, i64* %buf.plus18.p64, align 8
  %base4 = load i8*, i8** @qword_1400070A8, align 8
  %entry.ptr.2 = getelementptr inbounds i8, i8* %base4, i64 %entry.off
  %entry.plus8 = getelementptr inbounds i8, i8* %entry.ptr.2, i64 8
  %entry.plus8.pp = bitcast i8* %entry.plus8 to i8**
  store i8* %lpAddress, i8** %entry.plus8.pp, align 8
  %entry.plus10 = getelementptr inbounds i8, i8* %entry.ptr.2, i64 16
  %entry.plus10.p64 = bitcast i8* %entry.plus10 to i64*
  store i64 %dwSize, i64* %entry.plus10.p64, align 8
  %vp.res = call i32 @sub_1400E9A25(i8* %lpAddress, i64 %dwSize, i32 %r8.sel, i8* %entry.ptr.2)
  %vp.ok = icmp ne i32 %vp.res, 0
  br i1 %vp.ok, label %inc_and_ret, label %vp_fail_print

vp_fail_print:                                    ; preds = %vp_call
  %fptr = load i32 ()*, i32 ()** @qword_140008260, align 8
  %err = call i32 %fptr()
  %fmt.vp = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  %call.print.vp = call i32 (i8*, ...) @sub_140001700(i8* %fmt.vp, i32 %err)
  br label %vp_fail_printed

vp_fail_printed:                                  ; preds = %vp_fail_print
  br label %retry_idx0_pre

print_no_image_section:                           ; preds = %call_sub
  %fmt.addr.only = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  %call.print.addr.only = call i32 (i8*, ...) @sub_140001700(i8* %fmt.addr.only, i8* %rcx)
  br label %ret_block

ret_block:                                        ; preds = %print_no_image_section, %vp_fail, %inc_and_ret, %range_check
  ret void
}