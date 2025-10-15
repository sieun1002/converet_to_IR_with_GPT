; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare void @Sleep(i32)
declare i8* @SetUnhandledExceptionFilter(i8*)
declare i8* @_set_invalid_parameter_handler(i8*)
declare i32 @_set_app_type(i32)
declare i32* @__p__fmode()
declare i32* @__p__commode()
declare i32 @_configthreadlocale(i32)
declare i32 @_initterm_e(i8**, i8**)
declare void @_initterm(i8**, i8**)
declare void @_cexit()
declare void @exit(i32) noreturn

declare void @sub_140001CA0()
declare void @sub_1400024E0()
declare i32 @sub_140001910()
declare void @sub_1400018F0()
declare void @sub_140002070(i8*)
declare i8* @sub_140002A20()
declare i32 @sub_140002A30(i32)
declare i32 @sub_14000171D(i32, i8*, i8*)
declare i32 @sub_140002A60(i32*, i8***, i8***, i32, i32*)

declare i8* @malloc(i64)
declare i8* @memcpy(i8*, i8*, i64)
declare i64 @strlen(i8*)

@off_140004450 = external global i8**          ; -> i8* (lock variable location)
@off_140004460 = external global i32*          ; -> i32* (state variable)
@dword_140007004 = external global i32
@off_1400043D0 = external global void (i32, i32, i32)**

@qword_140007010 = external global i8*
@dword_140007020 = external global i32
@qword_140007018 = external global i8**        ; base pointer to array of i8*

@dword_140007008 = external global i32

@TopLevelExceptionFilter = external global i8   ; function symbol, used as pointer
@off_140004440 = external global i8**          ; -> i8* to store previous filter
@Handler = external global i8                   ; invalid parameter handler symbol

@off_140004410 = external global i32*          ; -> i32*
@off_140004420 = external global i32*          ; -> i32*
@off_140004430 = external global i32*          ; -> i32*
@off_1400043A0 = external global i8*           ; -> i8* module base

@off_140004400 = external global i32*          ; -> i32* app type flag
@off_1400044D0 = external global i32*          ; -> i32* initial fmode
@off_1400044B0 = external global i32*          ; -> i32* initial commode

@off_140004380 = external global i32*          ; -> i32*
@off_1400043E0 = external global i32*          ; -> i32*

@Last = external global i8*                    ; arrays of init function pointers
@First = external global i8*

@off_140004500 = external global i32*          ; -> i32*
@off_1400044C0 = external global i32*          ; -> i32*

@off_140004480 = external global i8*           ; -> i8* (last for _initterm)
@off_140004470 = external global i8*           ; -> i8* (first for _initterm)

declare void @sub_1400019D0()

define void @sub_140001010() {
entry:
  %self.byte = alloca i8, align 1
  %eax.slot = alloca i32, align 4
  %var_5C = alloca i32, align 4
  %var_4C = alloca i32, align 4
  %r14flag = alloca i32, align 4
  store i32 0, i32* %r14flag, align 4

  %lock.ptr.ptr = load i8**, i8*** @off_140004450
  br label %lock_try

lock_try:
  %self.ptr = getelementptr i8, i8* %self.byte, i64 0
  %oldnew = cmpxchg i8** %lock.ptr.ptr, i8* null, i8* %self.ptr monotonic monotonic
  %old = extractvalue { i8*, i1 } %oldnew, 0
  %success = extractvalue { i8*, i1 } %oldnew, 1
  br i1 %success, label %lock_acquired, label %lock_failed

lock_failed:
  %is_reentrant = icmp eq i8* %old, %self.ptr
  br i1 %is_reentrant, label %reentrant, label %sleep_and_retry

sleep_and_retry:
  call void @Sleep(i32 1000)
  br label %lock_try

reentrant:
  store i32 1, i32* %r14flag, align 4
  br label %after_lock

lock_acquired:
  store i32 0, i32* %r14flag, align 4
  br label %after_lock

after_lock:
  %state.ptr.ptr = load i32*, i32** @off_140004460
  %state.val1 = load i32, i32* %state.ptr.ptr
  %is_one = icmp eq i32 %state.val1, 1
  br i1 %is_one, label %state_is_one, label %check_zero

state_is_one:
  %eax31 = call i32 @sub_140002A30(i32 31)
  store i32 %eax31, i32* %eax.slot, align 4
  br label %exit_with_eax

check_zero:
  %state.val2 = load i32, i32* %state.ptr.ptr
  %is_zero = icmp eq i32 %state.val2, 0
  br i1 %is_zero, label %do_init, label %set_flag_and_continue

set_flag_and_continue:
  store i32 1, i32* @dword_140007004, align 4
  br label %post_init_common

do_init:
  store i32 1, i32* %state.ptr.ptr, align 4
  call void @sub_140001CA0()
  %prev = call i8* @SetUnhandledExceptionFilter(i8* @TopLevelExceptionFilter)
  %prev.store.ptr = load i8**, i8*** @off_140004440
  store i8* %prev, i8** %prev.store.ptr, align 8
  %old.ip = call i8* @_set_invalid_parameter_handler(i8* @Handler)
  call void @sub_1400024E0()

  %p1p = load i32*, i32** @off_140004410
  store i32 1, i32* %p1p, align 4
  %p2p = load i32*, i32** @off_140004420
  store i32 1, i32* %p2p, align 4
  %p3p = load i32*, i32** @off_140004430
  store i32 1, i32* %p3p, align 4

  %ecxflag = alloca i32, align 4
  store i32 0, i32* %ecxflag, align 4
  %base.mod = load i8*, i8** @off_1400043A0
  %mz.ptr = bitcast i8* %base.mod to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %pe_check, label %pe_done

pe_check:
  %p3c = getelementptr i8, i8* %base.mod, i64 60
  %p3c.i32p = bitcast i8* %p3c to i32*
  %offNT = load i32, i32* %p3c.i32p, align 1
  %offNT64 = sext i32 %offNT to i64
  %nt = getelementptr i8, i8* %base.mod, i64 %offNT64
  %sig.p = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig.p, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %opt_magic, label %pe_done

opt_magic:
  %optmagic.p = getelementptr i8, i8* %nt, i64 24
  %optmagic.p16 = bitcast i8* %optmagic.p to i16*
  %optmagic = load i16, i16* %optmagic.p16, align 1
  %is_32 = icmp eq i16 %optmagic, 267
  %is_64 = icmp eq i16 %optmagic, 523
  br i1 %is_32, label %pe32_path, label %chk_64

chk_64:
  br i1 %is_64, label %pe64_path, label %pe_done

pe32_path:
  %p74 = getelementptr i8, i8* %nt, i64 116
  %p74.i32 = bitcast i8* %p74 to i32*
  %v74 = load i32, i32* %p74.i32, align 1
  %gtE_32 = icmp ugt i32 %v74, 14
  br i1 %gtE_32, label %pe32_read, label %pe_done

pe32_read:
  %pE8 = getelementptr i8, i8* %nt, i64 232
  %pE8.i32 = bitcast i8* %pE8 to i32*
  %vE8 = load i32, i32* %pE8.i32, align 1
  %nz32 = icmp ne i32 %vE8, 0
  %flag32 = zext i1 %nz32 to i32
  store i32 %flag32, i32* %ecxflag, align 4
  br label %pe_done

pe64_path:
  %p84 = getelementptr i8, i8* %nt, i64 132
  %p84.i32 = bitcast i8* %p84 to i32*
  %v84 = load i32, i32* %p84.i32, align 1
  %gtE_64 = icmp ugt i32 %v84, 14
  br i1 %gtE_64, label %pe64_read, label %pe_done

pe64_read:
  %pF8 = getelementptr i8, i8* %nt, i64 248
  %pF8.i32 = bitcast i8* %pF8 to i32*
  %vF8 = load i32, i32* %pF8.i32, align 1
  %nz64 = icmp ne i32 %vF8, 0
  %flag64 = zext i1 %nz64 to i32
  store i32 %flag64, i32* %ecxflag, align 4
  br label %pe_done

pe_done:
  %ecxfin = load i32, i32* %ecxflag, align 4
  store i32 %ecxfin, i32* @dword_140007008, align 4

  %apptype.ptr = load i32*, i32** @off_140004400
  %apptype.val = load i32, i32* %apptype.ptr, align 4
  %apptype.isnz = icmp ne i32 %apptype.val, 0
  br i1 %apptype.isnz, label %app_console, label %app_gui

app_gui:
  %r1 = call i32 @_set_app_type(i32 1)
  br label %post_init_common

app_console:
  %r2 = call i32 @_set_app_type(i32 2)
  br label %post_init_common

post_init_common:
  %pf = call i32* @__p__fmode()
  %fmode.srcp.p = load i32*, i32** @off_1400044D0
  %fmode.src = load i32, i32* %fmode.srcp.p, align 4
  store i32 %fmode.src, i32* %pf, align 4
  %pc = call i32* @__p__commode()
  %comm.srcp.p = load i32*, i32** @off_1400044B0
  %comm.src = load i32, i32* %comm.srcp.p, align 4
  store i32 %comm.src, i32* %pc, align 4

  %initres = call i32 @sub_140001910()
  %isneg = icmp slt i32 %initres, 0
  br i1 %isneg, label %call_sub_2A30_8_then_cexit, label %check_004380

check_004380:
  %p4380 = load i32*, i32** @off_140004380
  %v4380 = load i32, i32* %p4380, align 4
  %is1 = icmp eq i32 %v4380, 1
  br i1 %is1, label %call_2070, label %check_0043E0

call_2070:
  %fnaddr = bitcast void ()* @sub_1400019D0 to i8*
  call void @sub_140002070(i8* %fnaddr)
  br label %check_0043E0

check_0043E0:
  %p43E0 = load i32*, i32** @off_1400043E0
  %v43E0 = load i32, i32* %p43E0, align 4
  %is_m1 = icmp eq i32 %v43E0, -1
  br i1 %is_m1, label %config_thread_locale, label %call_initterm_e

config_thread_locale:
  %cfg = call i32 @_configthreadlocale(i32 -1)
  br label %call_initterm_e

call_initterm_e:
  %first.arr = load i8*, i8** @First
  %last.arr = load i8*, i8** @Last
  %first.ptr = bitcast i8* %first.arr to i8**
  %last.ptr = bitcast i8* %last.arr to i8**
  %einit = call i32 @_initterm_e(i8** %first.ptr, i8** %last.ptr)
  %einit.nz = icmp ne i32 %einit, 0
  br i1 %einit.nz, label %set_ff_and_return, label %call_sub_2A60

set_ff_and_return:
  br label %function_return

call_sub_2A60:
  %p4500 = load i32*, i32** @off_140004500
  %v4500 = load i32, i32* %p4500, align 4
  store i32 %v4500, i32* %var_4C, align 4

  %p44C0 = load i32*, i32** @off_1400044C0
  %v44C0 = load i32, i32* %p44C0, align 4

  %addr_qword_140007010 = bitcast i8** @qword_140007010 to i8***
  %res2A60 = call i32 @sub_140002A60(i32* @dword_140007020, i8*** @qword_140007018, i8*** %addr_qword_140007010, i32 %v44C0, i32* %var_4C)
  %isneg2 = icmp slt i32 %res2A60, 0
  br i1 %isneg2, label %call_sub_2A30_8_then_cexit, label %alloc_copy_argv

alloc_copy_argv:
  %count32 = load i32, i32* @dword_140007020, align 4
  %count64 = sext i32 %count32 to i64
  %countp1 = add i64 %count64, 1
  %size.bytes = shl i64 %countp1, 3
  %arrmem = call i8* @malloc(i64 %size.bytes)
  %arr.isnull = icmp eq i8* %arrmem, null
  br i1 %arr.isnull, label %call_sub_2A30_8_then_cexit, label %check_count

check_count:
  %le0 = icmp sle i32 %count32, 0
  %dst.list.base0 = bitcast i8* %arrmem to i8**
  br i1 %le0, label %put_null_terminator, label %prep_loop

prep_loop:
  %base.list.ptr = load i8**, i8*** @qword_140007018
  %dst.list = bitcast i8* %arrmem to i8**
  %i.start = add i64 0, 1
  br label %loop

loop:
  %i.ph = phi i64 [ %i.start, %prep_loop ], [ %i.next, %loop_body_end ]
  %src.elem.ptr = getelementptr i8*, i8** %base.list.ptr, i64 %i.ph
  %src.elem = load i8*, i8** %src.elem.ptr, align 8
  %len = call i64 @strlen(i8* %src.elem)
  %rdip1 = add i64 %len, 1
  %newbuf = call i8* @malloc(i64 %rdip1)
  %dst.slot.ptr = getelementptr i8*, i8** %dst.list, i64 %i.ph
  store i8* %newbuf, i8** %dst.slot.ptr, align 8
  %nb.notnull = icmp ne i8* %newbuf, null
  br i1 %nb.notnull, label %do_memcpy, label %loop_body_end

do_memcpy:
  %cpy = call i8* @memcpy(i8* %newbuf, i8* %src.elem, i64 %rdip1)
  br label %loop_body_end

loop_body_end:
  %cnt64 = sext i32 %count32 to i64
  %is_last = icmp eq i64 %cnt64, %i.ph
  br i1 %is_last, label %at_last, label %inc_and_continue

inc_and_continue:
  %i.next = add i64 %i.ph, 1
  br label %loop

at_last:
  %dst.list.end = bitcast i8* %arrmem to i8**
  %term.ptr = getelementptr i8*, i8** %dst.list.end, i64 %cnt64
  br label %put_null_terminator

put_null_terminator:
  %term.ptr.ph = phi i8** [ %term.ptr, %at_last ], [ %dst.list.base0, %check_count ]
  store i8* null, i8** %term.ptr.ph, align 8
  %dst.list.base = bitcast i8* %arrmem to i8**
  store i8** %dst.list.base, i8*** @qword_140007018
  %first2.arr = load i8*, i8** @off_140004470
  %last2.arr = load i8*, i8** @off_140004480
  %first2.ptr = bitcast i8* %first2.arr to i8**
  %last2.ptr = bitcast i8* %last2.arr to i8**
  call void @_initterm(i8** %first2.ptr, i8** %last2.ptr)
  call void @sub_1400018F0()
  store i32 2, i32* %state.ptr.ptr, align 4
  br label %after_init_complete

after_init_complete:
  %r14v = load i32, i32* %r14flag, align 4
  %r14zero = icmp eq i32 %r14v, 0
  br i1 %r14zero, label %release_lock_then_notify, label %notify_only

release_lock_then_notify:
  %lock_i64_ptr = bitcast i8** %lock.ptr.ptr to i64*
  %_ = atomicrmw xchg i64* %lock_i64_ptr, i64 0 monotonic
  br label %notify_only

notify_only:
  %cb.ptr.ptr = load void (i32, i32, i32)**, void (i32, i32, i32)*** @off_1400043D0
  %cb = load void (i32, i32, i32)*, void (i32, i32, i32)** %cb.ptr.ptr
  %cb.isnull = icmp eq void (i32, i32, i32)* %cb, null
  br i1 %cb.isnull, label %skip_cb, label %do_cb

do_cb:
  call void %cb(i32 0, i32 2, i32 0)
  br label %skip_cb

skip_cb:
  %blk = call i8* @sub_140002A20()
  %dstp = bitcast i8* %blk to i8**
  %val010 = load i8*, i8** @qword_140007010
  store i8* %val010, i8** %dstp, align 8
  %ecount = load i32, i32* @dword_140007020, align 4
  %argv.base.list = load i8**, i8*** @qword_140007018
  %argv.base.ptr = bitcast i8** %argv.base.list to i8*
  %argp010 = load i8*, i8** @qword_140007010
  %callres = call i32 @sub_14000171D(i32 %ecount, i8* %argv.base.ptr, i8* %argp010)
  store i32 %callres, i32* %eax.slot, align 4
  %flag008 = load i32, i32* @dword_140007008, align 4
  %flag008.zero = icmp eq i32 %flag008, 0
  br i1 %flag008.zero, label %exit_with_eax, label %check_early_cexit

check_early_cexit:
  %flag004 = load i32, i32* @dword_140007004, align 4
  %flag004.zero = icmp eq i32 %flag004, 0
  br i1 %flag004.zero, label %store_then_cexit, label %function_return

store_then_cexit:
  %eax.cur = load i32, i32* %eax.slot, align 4
  store i32 %eax.cur, i32* %var_5C, align 4
  call void @_cexit()
  br label %function_return

call_sub_2A30_8_then_cexit:
  %eax8 = call i32 @sub_140002A30(i32 8)
  store i32 %eax8, i32* %var_5C, align 4
  call void @_cexit()
  br label %function_return

exit_with_eax:
  %toexit = load i32, i32* %eax.slot, align 4
  call void @exit(i32 %toexit)
  unreachable

function_return:
  ret void
}