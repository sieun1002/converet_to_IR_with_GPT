; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_140004450 = external global i8*
@__imp_Sleep = external global void (i32)*
@off_140004460 = external global i8*
@dword_140007004 = internal global i32 0
@off_1400043D0 = external global i8*
@qword_140007010 = internal global i8* null
@dword_140007020 = internal global i32 0
@qword_140007018 = internal global i8* null
@dword_140007008 = internal global i32 0
@off_140004440 = external global i8*
@off_140004410 = external global i8*
@off_140004420 = external global i8*
@off_140004430 = external global i8*
@off_1400043A0 = external global i8*
@off_140004400 = external global i8*
@off_1400044D0 = external global i8*
@off_1400044B0 = external global i8*
@off_140004380 = external global i8*
@off_1400043E0 = external global i8*
@Last = external global i8*
@First = external global i8*
@off_140004500 = external global i8*
@off_1400044C0 = external global i8*
@off_140004470 = external global i8*
@off_140004480 = external global i8*

declare i8* @SetUnhandledExceptionFilter(i8*)
declare i8* @_set_invalid_parameter_handler(i8*)
declare i32 @_set_app_type(i32)
declare i32* @__p__fmode()
declare i32* @__p__commode()
declare i32 @sub_1400018B0()
declare void @sub_140002010(i8*)
declare i32 @_initterm_e(i8*, i8*)
declare i32 @sub_140002A00(i32*, i8**, i8**, i32, i8*)
declare i8* @malloc(i64)
declare i64 @strlen(i8*)
declare i8* @memcpy(i8*, i8*, i64)
declare i32 @sub_1400029D0(i32)
declare void @_cexit()
declare void @_initterm(i8*, i8*)
declare void @sub_140001890()
declare i32 @_configthreadlocale(i32)
declare i8* @sub_1400029C0()
declare void @sub_14000171D(i32, i8*, i8*)
declare void @exit(i32)
declare void @sub_140001C40()
declare void @sub_140002480()

declare i32 @TopLevelExceptionFilter(i8*)
declare void @Handler(i16*, i16*, i16*, i32, i64)
declare void @sub_140001970()

define i32 @sub_140001010() {
entry:
  %ret = alloca i32, align 4
  %var_4C = alloca i32, align 4
  %var_78 = alloca i8*, align 8
  %var_5C = alloca i32, align 4
  store i32 0, i32* %ret, align 4
  %lock_ptr_addr = load i8*, i8** @off_140004450
  %lock_ptr = bitcast i8* %lock_ptr_addr to i8**
  %sleep_fp = load void (i32)*, void (i32)** @__imp_Sleep
  br label %lock_try

lock_try:
  %cmpxchg = cmpxchg i8** %lock_ptr, i8* null, i8* inttoptr (i64 1 to i8*) seq_cst seq_cst
  %oldval = extractvalue { i8*, i1 } %cmpxchg, 0
  %acq = extractvalue { i8*, i1 } %cmpxchg, 1
  br i1 %acq, label %locked, label %cmp_fail

cmp_fail:
  %is_reent = icmp eq i8* %oldval, inttoptr (i64 1 to i8*)
  br i1 %is_reent, label %reentrant, label %sleep_then_retry

sleep_then_retry:
  call void %sleep_fp(i32 1000)
  br label %lock_try

locked:
  br label %after_lock

reentrant:
  br label %after_lock

after_lock:
  %r14flag = phi i1 [ false, %locked ], [ true, %reentrant ]
  %rbp_addr_any = load i8*, i8** @off_140004460
  %rbp_ptr = bitcast i8* %rbp_addr_any to i32*
  %rbp_val = load i32, i32* %rbp_ptr
  %cmp_one = icmp eq i32 %rbp_val, 1
  br i1 %cmp_one, label %loc_13C8, label %check_zero

loc_13C8:
  %t31 = call i32 @sub_1400029D0(i32 31)
  call void @exit(i32 %t31)
  unreachable

check_zero:
  %is_zero = icmp eq i32 %rbp_val, 0
  br i1 %is_zero, label %loc_1110, label %after_init_mark

loc_1110:
  store i32 1, i32* %rbp_ptr
  call void @sub_140001C40()
  %filter_ptr = bitcast i32 (i8*)* @TopLevelExceptionFilter to i8*
  %old_filter = call i8* @SetUnhandledExceptionFilter(i8* %filter_ptr)
  %off_4440 = load i8*, i8** @off_140004440
  %store_prev_ptr = bitcast i8* %off_4440 to i8**
  store i8* %old_filter, i8** %store_prev_ptr
  %handler_ptr = bitcast void (i16*, i16*, i16*, i32, i64)* @Handler to i8*
  %old_inv = call i8* @_set_invalid_parameter_handler(i8* %handler_ptr)
  call void @sub_140002480()
  %p0410 = load i8*, i8** @off_140004410
  %p0410_i32 = bitcast i8* %p0410 to i32*
  store i32 1, i32* %p0410_i32
  %p0420 = load i8*, i8** @off_140004420
  %p0420_i32 = bitcast i8* %p0420 to i32*
  store i32 1, i32* %p0420_i32
  %p0430 = load i8*, i8** @off_140004430
  %p0430_i32 = bitcast i8* %p0430 to i32*
  store i32 1, i32* %p0430_i32
  br label %loc_11C0

loc_11C0:
  store i32 0, i32* @dword_140007008
  %p0400 = load i8*, i8** @off_140004400
  %p0400_i32 = bitcast i8* %p0400 to i32*
  %val400 = load i32, i32* %p0400_i32
  %is_gui = icmp ne i32 %val400, 0
  br i1 %is_gui, label %set_gui, label %set_cui

set_gui:
  %at2 = call i32 @_set_app_type(i32 2)
  br label %loc_11E3

set_cui:
  %at1 = call i32 @_set_app_type(i32 1)
  br label %loc_11E3

loc_11E3:
  %pfmode = call i32* @__p__fmode()
  %p04D0 = load i8*, i8** @off_1400044D0
  %p04D0_i32 = bitcast i8* %p04D0 to i32*
  %fmode_val = load i32, i32* %p04D0_i32
  store i32 %fmode_val, i32* %pfmode
  %pcommode = call i32* @__p__commode()
  %p04B0 = load i8*, i8** @off_1400044B0
  %p04B0_i32 = bitcast i8* %p04B0 to i32*
  %commode_val = load i32, i32* %p04B0_i32
  store i32 %commode_val, i32* %pcommode
  %init_a = call i32 @sub_1400018B0()
  %neg = icmp slt i32 %init_a, 0
  br i1 %neg, label %loc_1301, label %cont_after_initA

cont_after_initA:
  %p0380 = load i8*, i8** @off_140004380
  %p0380_i32 = bitcast i8* %p0380 to i32*
  %v380 = load i32, i32* %p0380_i32
  %is_one_380 = icmp eq i32 %v380, 1
  br i1 %is_one_380, label %loc_1399, label %after_1399

loc_1399:
  %fn970 = bitcast void ()* @sub_140001970 to i8*
  call void @sub_140002010(i8* %fn970)
  br label %after_1399

after_1399:
  %p03E0 = load i8*, i8** @off_1400043E0
  %p03E0_i32 = bitcast i8* %p03E0 to i32*
  %v3E0 = load i32, i32* %p03E0_i32
  %is_m1 = icmp eq i32 %v3E0, -1
  br i1 %is_m1, label %loc_138A, label %after_138A

loc_138A:
  %ctl = call i32 @_configthreadlocale(i32 -1)
  br label %after_138A

after_138A:
  %last_ptr = load i8*, i8** @Last
  %first_ptr = load i8*, i8** @First
  %einit = call i32 @_initterm_e(i8* %first_ptr, i8* %last_ptr)
  %e_nonzero = icmp ne i32 %einit, 0
  br i1 %e_nonzero, label %loc_1380, label %cont_init_phase2

loc_1380:
  store i32 255, i32* %ret
  br label %epilogue_return

cont_init_phase2:
  %p0500 = load i8*, i8** @off_140004500
  %p0500_i32 = bitcast i8* %p0500 to i32*
  %val0500 = load i32, i32* %p0500_i32
  store i32 %val0500, i32* %var_4C, align 4
  %p04C0 = load i8*, i8** @off_1400044C0
  %p04C0_i32 = bitcast i8* %p04C0 to i32*
  %r9val = load i32, i32* %p04C0_i32
  %var4C_as_ptr = bitcast i32* %var_4C to i8*
  store i8* %var4C_as_ptr, i8** %var_78, align 8
  %resA00 = call i32 @sub_140002A00(i32* @dword_140007020, i8** bitcast (i8** @qword_140007018 to i8**), i8** bitcast (i8** @qword_140007010 to i8**), i32 %r9val, i8* %var4C_as_ptr)
  %negA00 = icmp slt i32 %resA00, 0
  br i1 %negA00, label %loc_1301, label %alloc_array

alloc_array:
  %n = load i32, i32* @dword_140007020
  %n64 = sext i32 %n to i64
  %nplus1 = add i64 %n64, 1
  %size_bytes = shl i64 %nplus1, 3
  %arrmem = call i8* @malloc(i64 %size_bytes)
  %arrnull = icmp eq i8* %arrmem, null
  br i1 %arrnull, label %loc_1301, label %maybe_loop

maybe_loop:
  %n_nonpos = icmp sle i32 %n, 0
  br i1 %n_nonpos, label %store_null_end, label %loop_prep

loop_prep:
  %src_arr_raw = load i8*, i8** @qword_140007018
  %src_arr = bitcast i8* %src_arr_raw to i8**
  %i.init = phi i64 [ 0, %loop_prep ]
  br label %loop_body

loop_body:
  %i = phi i64 [ 0, %loop_prep ], [ %i.next, %copy_done ]
  %src_ptr_ptr = getelementptr inbounds i8*, i8** %src_arr, i64 %i
  %src_ptr = load i8*, i8** %src_ptr_ptr
  %len = call i64 @strlen(i8* %src_ptr)
  %size1 = add i64 %len, 1
  %dst = call i8* @malloc(i64 %size1)
  %dst_arr = bitcast i8* %arrmem to i8**
  %dst_slot = getelementptr inbounds i8*, i8** %dst_arr, i64 %i
  store i8* %dst, i8** %dst_slot
  %dst_isnull = icmp eq i8* %dst, null
  br i1 %dst_isnull, label %loc_1301, label %do_copy

do_copy:
  %cpy = call i8* @memcpy(i8* %dst, i8* %src_ptr, i64 %size1)
  br label %copy_done

copy_done:
  %i.next = add i64 %i, 1
  %n64_again = sext i32 %n to i64
  %done = icmp eq i64 %i.next, %n64_again
  br i1 %done, label %store_null_end, label %loop_body

store_null_end:
  %dst_arr2 = bitcast i8* %arrmem to i8**
  %n64_2 = sext i32 %n to i64
  %end_slot = getelementptr inbounds i8*, i8** %dst_arr2, i64 %n64_2
  store i8* null, i8** %end_slot
  store i8* %arrmem, i8** @qword_140007018
  %first_it = load i8*, i8** @off_140004470
  %last_it = load i8*, i8** @off_140004480
  call void @_initterm(i8* %first_it, i8* %last_it)
  call void @sub_140001890()
  store i32 2, i32* %rbp_ptr
  br label %after_init_mark

loc_1301:
  %ecode8 = call i32 @sub_1400029D0(i32 8)
  store i32 %ecode8, i32* %ret, align 4
  store i32 %ecode8, i32* %var_5C, align 4
  call void @_cexit()
  %retv_1301 = load i32, i32* %var_5C, align 4
  store i32 %retv_1301, i32* %ret, align 4
  br label %epilogue_return

after_init_mark:
  store i32 1, i32* @dword_140007004
  br label %post_init

post_init:
  %r14_is_zero = icmp eq i1 %r14flag, false
  br i1 %r14_is_zero, label %release_lock, label %post_lock

release_lock:
  %xchg = atomicrmw xchg i8** %lock_ptr, i8* null seq_cst
  br label %post_lock

post_lock:
  %off3D0_ptr = load i8*, i8** @off_1400043D0
  %fp_slot = bitcast i8* %off3D0_ptr to i8**
  %fp_raw = load i8*, i8** %fp_slot
  %has_fp = icmp ne i8* %fp_raw, null
  br i1 %has_fp, label %call_fp, label %after_call_fp

call_fp:
  %fp_typed = bitcast i8* %fp_raw to void (i32, i32, i32)*
  call void %fp_typed(i32 0, i32 2, i32 0)
  br label %after_call_fp

after_call_fp:
  %slot_ptr = call i8* @sub_1400029C0()
  %slot_pp = bitcast i8* %slot_ptr to i8**
  %cur_qw1010 = load i8*, i8** @qword_140007010
  store i8* %cur_qw1010, i8** %slot_pp
  %cur_arr = load i8*, i8** @qword_140007018
  %n_now = load i32, i32* @dword_140007020
  call void @sub_14000171D(i32 %n_now, i8* %cur_arr, i8* %cur_qw1010)
  %ecx008 = load i32, i32* @dword_140007008
  %is_zero_008 = icmp eq i32 %ecx008, 0
  br i1 %is_zero_008, label %loc_13D2, label %check_7004

check_7004:
  %v7004 = load i32, i32* @dword_140007004
  %is_zero_7004 = icmp eq i32 %v7004, 0
  br i1 %is_zero_7004, label %loc_1310, label %epilogue_return

loc_1310:
  %curret = load i32, i32* %ret, align 4
  store i32 %curret, i32* %var_5C, align 4
  call void @_cexit()
  %curret2 = load i32, i32* %var_5C, align 4
  store i32 %curret2, i32* %ret, align 4
  br label %epilogue_return

loc_13D2:
  %rcode = load i32, i32* %ret, align 4
  call void @exit(i32 %rcode)
  unreachable

epilogue_return:
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}