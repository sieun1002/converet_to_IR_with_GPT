; target: Windows x64 MSVC, LLVM 14
target triple = "x86_64-pc-windows-msvc"

; External globals (pointers and data)
@off_140004450 = external global i8**               ; -> i8* (lock variable address)
@qword_140008280 = external global i8*              ; function pointer (e.g., Sleep)
@off_140004460 = external global i32*               ; -> i32 (state)
@dword_140007004 = external global i32
@off_1400043D0 = external global i8**               ; -> i8* (function pointer storage)
@qword_140007010 = external global i8*              ; pointer value
@qword_140007018 = external global i8**             ; pointer-to-array-of-pointers value
@dword_140007020 = external global i32
@dword_140007008 = external global i32
@off_140004410 = external global i32*
@off_140004420 = external global i32*
@off_140004430 = external global i32*
@off_1400043A0 = external global i8*                ; image base
@off_140004400 = external global i32*
@off_1400044D0 = external global i32*
@off_1400044B0 = external global i32*
@off_140004380 = external global i32*
@off_1400043E0 = external global i32*
@off_1400044A0 = external global i8*
@off_140004490 = external global i8*
@off_140004500 = external global i32*
@off_1400044C0 = external global i32*
@off_140004480 = external global i8*
@off_140004470 = external global i8*

; External functions (opaque)
declare i8* @__get_thread_unique()
declare void @sub_140001CA0()
declare void @sub_14001E978(i8*)
declare void @sub_140002B50()
declare void @sub_1400024E0()
declare i8* @sub_140002A20()
declare void @sub_14000171D(i32, i8**, i8*)
declare i32 @sub_140002A30(i32)
declare void @sub_140002B60(i32) noreturn
declare void @sub_140002B38(i32)
declare i32* @sub_140002AE0()
declare i32* @sub_140002AD8()
declare i32 @sub_140001910()
declare void @sub_140002070(i8*)
declare void @sub_140002B90(i32)
declare i32 @sub_140002B48(i8*, i8*)
declare i32 @sub_140002A60(i32*, i8***, i8**, i32, i32*)
declare i8* @sub_140002BB8(i64)
declare i64 @sub_140002AC0(i8*)
declare void @sub_140002B78(i8*, i8*, i64)
declare void @sub_140002B40(i8*, i8*)
declare i32 @sub_1400018F0()
declare void @sub_140002B10()
declare void @sub_1400019D0()
declare void @sub_140002080()

define i32 @sub_140001010() local_unnamed_addr {
entry:
  %thr = call i8* @__get_thread_unique()
  %lockpp.addr = load i8**, i8*** @off_140004450, align 8
  %sleep.fn.ptr = load i8*, i8** @qword_140008280, align 8
  br label %lock_try

lock_try:                                            ; attempt to acquire spin/reentrant lock
  %cmp = cmpxchg i8** %lockpp.addr, i8* null, i8* %thr seq_cst seq_cst
  %old = extractvalue { i8*, i1 } %cmp, 0
  %succ = extractvalue { i8*, i1 } %cmp, 1
  br i1 %succ, label %locked, label %lock_failed

lock_failed:
  %is_reentrant = icmp eq i8* %old, %thr
  br i1 %is_reentrant, label %reentrant_locked, label %sleep_wait

sleep_wait:
  %sleep.casted = bitcast i8* %sleep.fn.ptr to void (i32)*
  call void %sleep.casted(i32 1000)
  br label %lock_try

reentrant_locked:
  br label %post_lock

locked:
  br label %post_lock

post_lock:
  %r14d = phi i32 [ 1, %reentrant_locked ], [ 0, %locked ]
  %state.ptr = load i32*, i32** @off_140004460, align 8
  %state0 = load i32, i32* %state.ptr, align 4
  %is1 = icmp eq i32 %state0, 1
  br i1 %is1, label %state_is1, label %state_chk0

state_is1:
  %tA = call i32 @sub_140002A30(i32 31)
  call void @sub_140002B60(i32 %tA)
  unreachable

state_chk0:
  %state1 = load i32, i32* %state.ptr, align 4
  %is0 = icmp eq i32 %state1, 0
  br i1 %is0, label %init_phase, label %set_flag

set_flag:
  store i32 1, i32* @dword_140007004, align 4
  br label %after_init

init_phase:
  store i32 1, i32* %state.ptr, align 4
  call void @sub_140001CA0()
  %fp_2080 = bitcast void ()* @sub_140002080 to i8*
  call void @sub_14001E978(i8* %fp_2080)
  call void @sub_140002B50()
  call void @sub_1400024E0()
  %p410 = load i32*, i32** @off_140004410, align 8
  store i32 1, i32* %p410, align 4
  %p420 = load i32*, i32** @off_140004420, align 8
  store i32 1, i32* %p420, align 4
  %p430 = load i32*, i32** @off_140004430, align 8
  store i32 1, i32* %p430, align 4
  %imgbase = load i8*, i8** @off_1400043A0, align 8
  %mz.p = bitcast i8* %imgbase to i16*
  %mz = load i16, i16* %mz.p, align 2
  %mz.ok = icmp eq i16 %mz, 23117
  br i1 %mz.ok, label %check_pe_sig, label %flag_zero

check_pe_sig:
  %e_lfanew.p.i8 = getelementptr i8, i8* %imgbase, i64 60
  %e_lfanew.p = bitcast i8* %e_lfanew.p.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.p, align 4
  %e_lfanew64 = sext i32 %e_lfanew to i64
  %nthdr = getelementptr i8, i8* %imgbase, i64 %e_lfanew64
  %sig.p = bitcast i8* %nthdr to i32*
  %sigv = load i32, i32* %sig.p, align 4
  %pe.ok = icmp eq i32 %sigv, 17744
  br i1 %pe.ok, label %check_opt_magic, label %flag_zero

check_opt_magic:
  %magic.p.i8 = getelementptr i8, i8* %nthdr, i64 24
  %magic.p = bitcast i8* %magic.p.i8 to i16*
  %magic = load i16, i16* %magic.p, align 2
  %is.pe32 = icmp eq i16 %magic, 267
  br i1 %is.pe32, label %pe32_case, label %pe32plus_check

pe32_case:
  %soh32.p.i8 = getelementptr i8, i8* %nthdr, i64 116
  %soh32.p = bitcast i8* %soh32.p.i8 to i32*
  %soh32 = load i32, i32* %soh32.p, align 4
  %has.dir32 = icmp ugt i32 %soh32, 14
  br i1 %has.dir32, label %pe32_dir_read, label %flag_zero

pe32_dir_read:
  %dir32.p.i8 = getelementptr i8, i8* %nthdr, i64 232
  %dir32.p = bitcast i8* %dir32.p.i8 to i32*
  %dir32 = load i32, i32* %dir32.p, align 4
  %dir32.nz = icmp ne i32 %dir32, 0
  %ecx_pe32 = zext i1 %dir32.nz to i32
  br label %flag_store

pe32plus_check:
  %is.pe32plus = icmp eq i16 %magic, 523
  br i1 %is.pe32plus, label %pe32plus_hdr, label %flag_zero

pe32plus_hdr:
  %soh64.p.i8 = getelementptr i8, i8* %nthdr, i64 132
  %soh64.p = bitcast i8* %soh64.p.i8 to i32*
  %soh64 = load i32, i32* %soh64.p, align 4
  %has.dir64 = icmp ugt i32 %soh64, 14
  br i1 %has.dir64, label %pe32plus_dir_read, label %flag_zero

pe32plus_dir_read:
  %dir64.p.i8 = getelementptr i8, i8* %nthdr, i64 248
  %dir64.p = bitcast i8* %dir64.p.i8 to i32*
  %dir64 = load i32, i32* %dir64.p, align 4
  %dir64.nz = icmp ne i32 %dir64, 0
  %ecx_pe64 = zext i1 %dir64.nz to i32
  br label %flag_store

flag_zero:
  %ecx_zero = phi i32 [ 0, %check_pe_sig ], [ 0, %check_opt_magic ], [ 0, %pe32_case ], [ 0, %pe32plus_hdr ]
  br label %flag_store

flag_store:
  %ecx_sel = phi i32 [ %ecx_pe64, %pe32plus_dir_read ], [ %ecx_pe32, %pe32_dir_read ], [ %ecx_zero, %flag_zero ]
  store i32 %ecx_sel, i32* @dword_140007008, align 4
  %p400 = load i32*, i32** @off_140004400, align 8
  %v400 = load i32, i32* %p400, align 4
  %v400.nz = icmp ne i32 %v400, 0
  br i1 %v400.nz, label %call_B38_2, label %call_B38_1

call_B38_1:
  call void @sub_140002B38(i32 1)
  br label %after_B38

call_B38_2:
  call void @sub_140002B38(i32 2)
  br label %after_B38

after_B38:
  %dstA = call i32* @sub_140002AE0()
  %p4D0 = load i32*, i32** @off_1400044D0, align 8
  %v4D0 = load i32, i32* %p4D0, align 4
  store i32 %v4D0, i32* %dstA, align 4
  %dstB = call i32* @sub_140002AD8()
  %p4B0 = load i32*, i32** @off_1400044B0, align 8
  %v4B0 = load i32, i32* %p4B0, align 4
  store i32 %v4B0, i32* %dstB, align 4
  %rv_1910 = call i32 @sub_140001910()
  %rv_1910.neg = icmp slt i32 %rv_1910, 0
  br i1 %rv_1910.neg, label %error_exit, label %chk_4380

chk_4380:
  %p380 = load i32*, i32** @off_140004380, align 8
  %v380 = load i32, i32* %p380, align 4
  %v380.is1 = icmp eq i32 %v380, 1
  br i1 %v380.is1, label %call_2070, label %after_2070

call_2070:
  %pf_19D0 = bitcast void ()* @sub_1400019D0 to i8*
  call void @sub_140002070(i8* %pf_19D0)
  br label %after_2070

after_2070:
  %p3E0 = load i32*, i32** @off_1400043E0, align 8
  %v3E0 = load i32, i32* %p3E0, align 4
  %isMinus1 = icmp eq i32 %v3E0, -1
  br i1 %isMinus1, label %call_B90, label %after_B90

call_B90:
  call void @sub_140002B90(i32 -1)
  br label %after_B90

after_B90:
  %p4A0 = load i8*, i8** @off_1400044A0, align 8
  %p490 = load i8*, i8** @off_140004490, align 8
  %rB48 = call i32 @sub_140002B48(i8* %p490, i8* %p4A0)
  %rB48.nz = icmp ne i32 %rB48, 0
  br i1 %rB48.nz, label %ret_ff, label %call_A60

call_A60:
  %p500 = load i32*, i32** @off_140004500, align 8
  %v500 = load i32, i32* %p500, align 4
  %var4C = alloca i32, align 4
  store i32 %v500, i32* %var4C, align 4
  %pC0 = load i32*, i32** @off_1400044C0, align 8
  %vC0 = load i32, i32* %pC0, align 4
  %rA60 = call i32 @sub_140002A60(i32* @dword_140007020, i8*** @qword_140007018, i8** @qword_140007010, i32 %vC0, i32* %var4C)
  %rA60.neg = icmp slt i32 %rA60, 0
  br i1 %rA60.neg, label %error_exit, label %alloc_array

alloc_array:
  %cnt = load i32, i32* @dword_140007020, align 4
  %cnt64 = sext i32 %cnt to i64
  %cntp1 = add nsw i64 %cnt64, 1
  %bytes = shl i64 %cntp1, 3
  %arrmem = call i8* @sub_140002BB8(i64 %bytes)
  %r13 = bitcast i8* %arrmem to i8**
  %arr.null = icmp eq i8* %arrmem, null
  br i1 %arr.null, label %error_exit, label %maybe_loop

maybe_loop:
  %le0 = icmp sle i32 %cnt, 0
  br i1 %le0, label %after_copy, label %loop_prep

loop_prep:
  %srcarr = load i8**, i8*** @qword_140007018, align 8
  br label %loop_hdr

loop_hdr:
  %i = phi i32 [ 1, %loop_prep ], [ %i.next, %loop_latch ]
  %i64 = sext i32 %i to i64
  %idxm1 = add nsw i64 %i64, -1
  %src.ptr.p = getelementptr i8*, i8** %srcarr, i64 %idxm1
  %src.ptr = load i8*, i8** %src.ptr.p, align 8
  %len = call i64 @sub_140002AC0(i8* %src.ptr)
  %len1 = add i64 %len, 1
  %dst = call i8* @sub_140002BB8(i64 %len1)
  %dst.p = getelementptr i8*, i8** %r13, i64 %idxm1
  store i8* %dst, i8** %dst.p, align 8
  %dst.null = icmp eq i8* %dst, null
  br i1 %dst.null, label %error_exit, label %do_copy

do_copy:
  call void @sub_140002B78(i8* %dst, i8* %src.ptr, i64 %len1)
  %is_last = icmp eq i32 %i, %cnt
  br i1 %is_last, label %terminate_array, label %loop_latch

loop_latch:
  %i.next = add i32 %i, 1
  br label %loop_hdr

terminate_array:
  %cnt64b = sext i32 %cnt to i64
  %last.slot = getelementptr i8*, i8** %r13, i64 %cnt64b
  store i8* null, i8** %last.slot, align 8
  store i8** %r13, i8*** @qword_140007018, align 8
  %p470 = load i8*, i8** @off_140004470, align 8
  %p480 = load i8*, i8** @off_140004480, align 8
  call void @sub_140002B40(i8* %p470, i8* %p480)
  %t18F0 = call i32 @sub_1400018F0()
  store i32 2, i32* %state.ptr, align 4
  br label %after_init

after_copy:
  store i8* null, i8** %r13, align 8
  store i8** %r13, i8*** @qword_140007018, align 8
  %p470b = load i8*, i8** @off_140004470, align 8
  %p480b = load i8*, i8** @off_140004480, align 8
  call void @sub_140002B40(i8* %p470b, i8* %p480b)
  %t18F0b = call i32 @sub_1400018F0()
  store i32 2, i32* %state.ptr, align 4
  br label %after_init

after_init:
  %r14d.nz = icmp ne i32 %r14d, 0
  br i1 %r14d.nz, label %after_release, label %release

release:
  %lockpp.addr2 = load i8**, i8*** @off_140004450, align 8
  %oldrel = atomicrmw xchg i8** %lockpp.addr2, i8* null seq_cst
  br label %after_release

after_release:
  %fpbox = load i8**, i8*** @off_1400043D0, align 8
  %cb.ptr = load i8*, i8** %fpbox, align 8
  %cb.nz = icmp ne i8* %cb.ptr, null
  br i1 %cb.nz, label %call_cb, label %after_cb

call_cb:
  %cb.cast = bitcast i8* %cb.ptr to void (i64, i32, i64)*
  call void %cb.cast(i64 0, i32 2, i64 0)
  br label %after_cb

after_cb:
  %tmpbuf = call i8* @sub_140002A20()
  %tmpbuf.p = bitcast i8* %tmpbuf to i8**
  %v7010 = load i8*, i8** @qword_140007010, align 8
  store i8* %v7010, i8** %tmpbuf.p, align 8
  %v7020 = load i32, i32* @dword_140007020, align 4
  %v7018 = load i8**, i8*** @qword_140007018, align 8
  call void @sub_14000171D(i32 %v7020, i8** %v7018, i8* %v7010)
  %flag7008 = load i32, i32* @dword_140007008, align 4
  %flag7008.z = icmp eq i32 %flag7008, 0
  br i1 %flag7008.z, label %tail_noreturn, label %chk_7004

tail_noreturn:
  call void @sub_140002B60(i32 0)
  unreachable

chk_7004:
  %flag7004 = load i32, i32* @dword_140007004, align 4
  %flag7004.z = icmp eq i32 %flag7004, 0
  br i1 %flag7004.z, label %save_zero_and_ret, label %ret_zero

save_zero_and_ret:
  %zslot = alloca i32, align 4
  store i32 0, i32* %zslot, align 4
  call void @sub_140002B10()
  %zret = load i32, i32* %zslot, align 4
  ret i32 %zret

ret_zero:
  ret i32 0

ret_ff:
  ret i32 255

error_exit:
  %errv = call i32 @sub_140002A30(i32 8)
  %saveslot = alloca i32, align 4
  store i32 %errv, i32* %saveslot, align 4
  call void @sub_140002B10()
  %retv = load i32, i32* %saveslot, align 4
  ret i32 %retv
}