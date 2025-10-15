; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002A20()
declare i32 @sub_14000171D(i32, i8**, i8*)
declare void @sub_140001CA0()
declare i32* @__p__fmode()
declare i32* @__p__commode()
declare i32 @sub_140001910()
declare void @sub_140002070(i8*)
declare i32 @_configthreadlocale(i32)
declare i32 @_initterm_e(i8**, i8**)
declare i32 @sub_140002A60(i32*, i8***, i8***, i32, i32*)
declare i8* @malloc(i64)
declare i64 @strlen(i8*)
declare i8* @memcpy(i8*, i8*, i64)
declare i32 @sub_140002A30(i32)
declare void @_cexit()
declare void @_initterm(i8**, i8**)
declare void @sub_1400018F0()
declare void @exit(i32)
declare void @_set_app_type(i32)
declare i8* @_set_invalid_parameter_handler(i8*)

declare i32 @TopLevelExceptionFilter(i8*)
declare void @Handler()
declare void @sub_1400019D0()

@off_140004450 = external global i8**            ; pointer to lock variable (i8*)
@__imp_Sleep = external global void (i32)*       ; import thunk for Sleep
@off_140004460 = external global i32**           ; pointer to init-state dword
@dword_140007004 = external global i32
@off_1400043D0 = external global i8**            ; pointer to function pointer
@qword_140007010 = external global i8*           ; pointer value
@dword_140007020 = external global i32
@qword_140007018 = external global i8**          ; pointer to array of i8*
@dword_140007008 = external global i32
@__imp_SetUnhandledExceptionFilter = external global i8* (i8*)*
@off_140004440 = external global i8**            ; pointer to storage for previous filter
@off_140004410 = external global i32**
@off_140004420 = external global i32**
@off_140004430 = external global i32**
@off_140004400 = external global i32**
@off_1400044D0 = external global i32**
@off_1400044B0 = external global i32**
@off_140004380 = external global i32**
@off_1400043E0 = external global i32**
@Last = external global i8**
@First = external global i8**
@off_140004500 = external global i32**
@off_1400044C0 = external global i32**
@off_140004480 = external global i8**
@off_140004470 = external global i8**

define i32 @sub_140001010() {
entry:
  %selfslot = alloca i8, align 1
  %ret_last = alloca i32, align 4
  store i32 0, i32* %ret_last, align 4
  %lockpp = load i8**, i8*** @off_140004450
  br label %lock_try

lock_try:
  %oldpair = cmpxchg i8**, i8** %lockpp, i8* null, i8* %selfslot monotonic monotonic
  %old = extractvalue { i8*, i1 } %oldpair, 0
  %succ = extractvalue { i8*, i1 } %oldpair, 1
  br i1 %succ, label %lock_acquired, label %lock_checkowner

lock_checkowner:
  %isSelf = icmp eq i8* %old, %selfslot
  br i1 %isSelf, label %reentrant_owner, label %sleep_wait

sleep_wait:
  %sleepfn = load void (i32)*, void (i32)** @__imp_Sleep
  call void %sleepfn(i32 1000)
  br label %lock_try

reentrant_owner:
  br label %after_lock

lock_acquired:
  br label %after_lock

after_lock:
  %statepp = load i32**, i32*** @off_140004460
  %statep = load i32*, i32** %statepp
  %statev = load i32, i32* %statep
  %is1 = icmp eq i32 %statev, 1
  br i1 %is1, label %state_eq1, label %state_check_zero

state_eq1:
  %call_a30_31 = call i32 @sub_140002A30(i32 31)
  call void @exit(i32 %call_a30_31)
  unreachable

state_check_zero:
  %is0 = icmp eq i32 %statev, 0
  br i1 %is0, label %init_path, label %state_other

state_other:
  store i32 1, i32* @dword_140007004
  br label %post_init_decision

init_path:
  store i32 1, i32* %statep
  call void @sub_140001CA0()
  %tlfptr = bitcast i32 (i8*)* @TopLevelExceptionFilter to i8*
  %setuef = load i8* (i8*)*, i8* (i8*)** @__imp_SetUnhandledExceptionFilter
  %prevf = call i8* %setuef(i8* %tlfptr)
  %prevslotpp = load i8**, i8*** @off_140004440
  store i8* %prevf, i8** %prevslotpp
  %iph = bitcast void ()* @Handler to i8*
  %oldiph = call i8* @_set_invalid_parameter_handler(i8* %iph)
  call void @sub_1400024E0()
  %p1pp = load i32**, i32*** @off_140004410
  %p1p = load i32*, i32** %p1pp
  store i32 1, i32* %p1p
  %p2pp = load i32**, i32*** @off_140004420
  %p2p = load i32*, i32** %p2pp
  store i32 1, i32* %p2p
  %p3pp = load i32**, i32*** @off_140004430
  %p3p = load i32*, i32** %p3pp
  store i32 1, i32* %p3p
  store i32 0, i32* @dword_140007008
  %apptypepp = load i32**, i32*** @off_140004400
  %apptypep = load i32*, i32** %apptypepp
  %apptypev = load i32, i32* %apptypep
  %apptype_nz = icmp ne i32 %apptypev, 0
  br i1 %apptype_nz, label %set_app_gui, label %set_app_cui

set_app_cui:
  call void @_set_app_type(i32 1)
  br label %set_modes

set_app_gui:
  call void @_set_app_type(i32 2)
  br label %set_modes

set_modes:
  %pfmode = call i32* @__p__fmode()
  %fmodepp = load i32**, i32*** @off_1400044D0
  %fmodep = load i32*, i32** %fmodepp
  %fmodev = load i32, i32* %fmodep
  store i32 %fmodev, i32* %pfmode
  %pcommode = call i32* @__p__commode()
  %commodepp = load i32**, i32*** @off_1400044B0
  %commodep = load i32*, i32** %commodepp
  %commodev = load i32, i32* %commodep
  store i32 %commodev, i32* %pcommode
  %call_1910 = call i32 @sub_140001910()
  %neg1910 = icmp slt i32 %call_1910, 0
  br i1 %neg1910, label %common_error, label %check_4380

check_4380:
  %p380pp = load i32**, i32*** @off_140004380
  %p380p = load i32*, i32** %p380pp
  %v380 = load i32, i32* %p380p
  %is1_380 = icmp eq i32 %v380, 1
  br i1 %is1_380, label %call_2070, label %after_2070

call_2070:
  %fptr_19d0 = bitcast void ()* @sub_1400019D0 to i8*
  call void @sub_140002070(i8* %fptr_19d0)
  br label %after_2070

after_2070:
  %p3E0pp = load i32**, i32*** @off_1400043E0
  %p3E0p = load i32*, i32** %p3E0pp
  %v3E0 = load i32, i32* %p3E0p
  %is_m1 = icmp eq i32 %v3E0, -1
  br i1 %is_m1, label %do_cfg_locale, label %after_cfg_locale

do_cfg_locale:
  %tmp_cfg = call i32 @_configthreadlocale(i32 -1)
  br label %after_cfg_locale

after_cfg_locale:
  %firstp = load i8**, i8*** @First
  %lastp = load i8**, i8*** @Last
  %einit = call i32 @_initterm_e(i8** %firstp, i8** %lastp)
  %einit_ok = icmp eq i32 %einit, 0
  br i1 %einit_ok, label %cont_after_einit, label %ret_ff

ret_ff:
  store i32 255, i32* %ret_last
  br label %return_epilogue

cont_after_einit:
  %v500pp = load i32**, i32*** @off_140004500
  %v500p = load i32*, i32** %v500pp
  %v500 = load i32, i32* %v500p
  %stk_var_4C = alloca i32, align 4
  store i32 %v500, i32* %stk_var_4C
  %v4C0pp = load i32**, i32*** @off_1400044C0
  %v4C0p = load i32*, i32** %v4C0pp
  %v4C0 = load i32, i32* %v4C0p
  %p_dword_7020 = bitcast i32* @dword_140007020 to i32*
  %p_qword_7018 = bitcast i8** @qword_140007018 to i8***
  %p_qword_7010 = bitcast i8* @qword_140007010 to i8***
  %call_2A60 = call i32 @sub_140002A60(i32* %p_dword_7020, i8*** %p_qword_7018, i8*** %p_qword_7010, i32 %v4C0, i32* %stk_var_4C)
  %neg2A60 = icmp slt i32 %call_2A60, 0
  br i1 %neg2A60, label %common_error, label %alloc_array

alloc_array:
  %argc = load i32, i32* @dword_140007020
  %argc64 = sext i32 %argc to i64
  %argc_p1 = add i64 %argc64, 1
  %szbytes = mul i64 %argc_p1, 8
  %arrmem = call i8* @malloc(i64 %szbytes)
  %arr_is_null = icmp eq i8* %arrmem, null
  br i1 %arr_is_null, label %common_error, label %maybe_loop

maybe_loop:
  %argc_pos = icmp sgt i32 %argc, 0
  br i1 %argc_pos, label %loop_prep, label %after_loop

loop_prep:
  %i = alloca i32, align 4
  store i32 0, i32* %i
  %srcbase = load i8**, i8*** @qword_140007018
  br label %loop

loop:
  %idx = load i32, i32* %i
  %idx64 = sext i32 %idx to i64
  %srcptr_gep = getelementptr inbounds i8*, i8** %srcbase, i64 %idx64
  %src = load i8*, i8** %srcptr_gep
  %len = call i64 @strlen(i8* %src)
  %len1 = add i64 %len, 1
  %dst = call i8* @malloc(i64 %len1)
  %arr_as_ptr = bitcast i8* %arrmem to i8**
  %dst_slot = getelementptr inbounds i8*, i8** %arr_as_ptr, i64 %idx64
  store i8* %dst, i8** %dst_slot
  %dst_null = icmp eq i8* %dst, null
  br i1 %dst_null, label %common_error, label %do_copy

do_copy:
  %copied = call i8* @memcpy(i8* %dst, i8* %src, i64 %len1)
  %idx1 = add i32 %idx, 1
  %done = icmp eq i32 %idx1, %argc
  br i1 %done, label %after_loop, label %cont_loop

cont_loop:
  store i32 %idx1, i32* %i
  br label %loop

after_loop:
  %arr_as_ptr2 = bitcast i8* %arrmem to i8**
  %argc64_b = sext i32 %argc to i64
  %term_slot = getelementptr inbounds i8*, i8** %arr_as_ptr2, i64 %argc64_b
  store i8* null, i8** %term_slot
  %lastpp = load i8**, i8*** @off_140004480
  %firstpp = load i8**, i8*** @off_140004470
  store i8** %arr_as_ptr2, i8*** @qword_140007018
  %firstp2 = load i8**, i8*** @off_140004470
  %lastp2 = load i8**, i8*** @off_140004480
  call void @_initterm(i8** %firstp2, i8** %lastp2)
  call void @sub_1400018F0()
  store i32 2, i32* %statep
  br label %post_init_decision

common_error:
  %err = call i32 @sub_140002A30(i32 8)
  %save_ec = alloca i32, align 4
  store i32 %err, i32* %save_ec
  call void @_cexit()
  %rv = load i32, i32* %save_ec
  ret i32 %rv

post_init_decision:
  ; if we reentered, do not release lock; otherwise release
  %reent_pred = icmp eq i1 false, false
  ; determine if we acquired lock in this function: check if current owner equals self to decide release
  ; Here we conservatively release if lock currently held by self
  %cur_owner = load i8*, i8** %lockpp
  %held_by_self = icmp eq i8* %cur_owner, %selfslot
  br i1 %held_by_self, label %release_lock, label %after_release

release_lock:
  atomicrmw xchg i8* %lockpp, i8* null monotonic
  br label %after_release

after_release:
  %fnpp = load i8**, i8*** @off_1400043D0
  %fnp = load i8*, i8** %fnpp
  %hasfn = icmp ne i8* %fnp, null
  br i1 %hasfn, label %call_maybe, label %after_maybe

call_maybe:
  %typedfn = bitcast i8* %fnp to void (i32, i32, i32)*
  call void %typedfn(i32 0, i32 2, i32 0)
  br label %after_maybe

after_maybe:
  %buf = call i8* @sub_140002A20()
  %bufp = bitcast i8* %buf to i8**
  %val7010 = load i8*, i8** bitcast (i8** @qword_140007010 to i8**)
  store i8* %val7010, i8** %bufp
  %argv = load i8**, i8*** @qword_140007018
  %argc2 = load i32, i32* @dword_140007020
  %env = load i8*, i8** bitcast (i8** @qword_140007010 to i8**)
  %retcall = call i32 @sub_14000171D(i32 %argc2, i8** %argv, i8* %env)
  store i32 %retcall, i32* %ret_last
  %flag = load i32, i32* @dword_140007008
  %flag_zero = icmp eq i32 %flag, 0
  br i1 %flag_zero, label %call_exit, label %check_flag_7004

call_exit:
  %retv = load i32, i32* %ret_last
  call void @exit(i32 %retv)
  unreachable

check_flag_7004:
  %f7004 = load i32, i32* @dword_140007004
  %f7004_zero = icmp eq i32 %f7004, 0
  br i1 %f7004_zero, label %do_cexit_path, label %return_epilogue

do_cexit_path:
  %ec = call i32 @sub_140002A30(i32 8)
  %save_ec2 = alloca i32, align 4
  store i32 %ec, i32* %save_ec2
  call void @_cexit()
  %rv2 = load i32, i32* %save_ec2
  ret i32 %rv2

return_epilogue:
  %r = load i32, i32* %ret_last
  ret i32 %r
}