; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@dword_140007004 = global i32 0
@dword_140007008 = global i32 1
@qword_140007010 = global i8* null
@qword_140007018 = global i8** null
@dword_140007020 = global i32 0

@g_lock = global i64 0
@off_140004450 = global i64* @g_lock

@g_state = global i32 0
@off_140004460 = global i32* @g_state

@g_prev_filter = global i8* null
@off_140004440 = global i8** @g_prev_filter

@g_flag1 = global i32 0
@g_flag2 = global i32 0
@g_flag3 = global i32 0
@off_140004410 = global i32* @g_flag1
@off_140004420 = global i32* @g_flag2
@off_140004430 = global i32* @g_flag3

@g_is_gui = global i32 0
@off_140004400 = global i32* @g_is_gui

@g_flag380 = global i32 0
@off_140004380 = global i32* @g_flag380

@g_threadlocale_flag = global i32 0
@off_1400043E0 = global i32* @g_threadlocale_flag

@First = global i8** null
@Last = global i8** null

@g_first_init = global i8* null
@g_last_init = global i8* null
@off_140004470 = global i8** @g_first_init
@off_140004480 = global i8** @g_last_init

@g_unknown500 = global i32 0
@off_140004500 = global i32* @g_unknown500

@g_unknown4C0 = global i32 0
@off_1400044C0 = global i32* @g_unknown4C0

@g_init_fmode = global i32 0
@off_1400044D0 = global i32* @g_init_fmode

@g_init_commode = global i32 0
@off_1400044B0 = global i32* @g_init_commode

@g_cb = global i8* null
@off_1400043D0 = global i8** @g_cb

@g_arg_storage = global i8* null

declare dllimport void @Sleep(i32)
declare dllimport i8* @SetUnhandledExceptionFilter(i8*)
declare dllimport i32* @__p__fmode()
declare dllimport i32* @__p__commode()
declare dllimport i32 @_set_app_type(i32)
declare dllimport i32 @_initterm_e(i8**, i8**)
declare dllimport void @_initterm(i8**, i8**)
declare dllimport i32 @_configthreadlocale(i32)
declare dllimport void @_cexit()
declare dllimport void @exit(i32)
declare dllimport i8* @_set_invalid_parameter_handler(i8*)
declare dllimport i8* @malloc(i64)
declare dllimport i8* @memcpy(i8*, i8*, i64)
declare dllimport i64 @strlen(i8*)
declare dllimport i32 @GetCurrentThreadId()

define i32 @sub_140001010() {
entry:
  %tid32 = call i32 @GetCurrentThreadId()
  %tid64 = zext i32 %tid32 to i64
  br label %lock_loop

lock_loop:                                         ; preds = %sleep_then, %entry
  %lockptr.p = load i64*, i64** @off_140004450
  %cmp = cmpxchg i64* %lockptr.p, i64 0, i64 %tid64 monotonic monotonic
  %old = extractvalue { i64, i1 } %cmp, 0
  %succ = extractvalue { i64, i1 } %cmp, 1
  br i1 %succ, label %got_lock, label %lock_failed

lock_failed:                                       ; preds = %lock_loop
  %mine = icmp eq i64 %old, %tid64
  br i1 %mine, label %reentered, label %sleep_then

sleep_then:                                        ; preds = %lock_failed
  call void @Sleep(i32 1000)
  br label %lock_loop

reentered:                                         ; preds = %lock_failed
  br label %got_lock_with_reentrant

got_lock:                                          ; preds = %lock_loop
  br label %got_lock_with_reentrant

got_lock_with_reentrant:                           ; preds = %got_lock, %reentered
  %reent = phi i1 [ false, %got_lock ], [ true, %reentered ]
  %stptrptr = load i32*, i32** @off_140004460
  %state0 = load i32, i32* %stptrptr
  %is_one = icmp eq i32 %state0, 1
  br i1 %is_one, label %state_one, label %check_zero

state_one:                                         ; preds = %got_lock_with_reentrant
  %code31 = call i32 @sub_140002A30(i32 31)
  call void @exit(i32 %code31)
  unreachable

check_zero:                                        ; preds = %got_lock_with_reentrant
  %is_zero = icmp eq i32 %state0, 0
  br i1 %is_zero, label %do_init, label %post_init

do_init:                                           ; preds = %check_zero
  store i32 1, i32* %stptrptr
  call void @sub_140001CA0()
  %filter_ptr = bitcast i32 (i8*)* @TopLevelExceptionFilter to i8*
  %prevf = call i8* @SetUnhandledExceptionFilter(i8* %filter_ptr)
  %filter_slot_ptr = load i8**, i8*** @off_140004440
  store i8* %prevf, i8** %filter_slot_ptr
  %invph = bitcast void (i8*, i8*, i8*, i32, i64)* @Handler to i8*
  %prevh = call i8* @_set_invalid_parameter_handler(i8* %invph)
  call void @sub_1400024E0()
  %p410 = load i32*, i32** @off_140004410
  store i32 1, i32* %p410
  %p420 = load i32*, i32** @off_140004420
  store i32 1, i32* %p420
  %p430 = load i32*, i32** @off_140004430
  store i32 1, i32* %p430
  store i32 1, i32* @dword_140007008
  %p400 = load i32*, i32** @off_140004400
  %val400 = load i32, i32* %p400
  %is_gui = icmp ne i32 %val400, 0
  %apptype = select i1 %is_gui, i32 2, i32 1
  %tmpapp = call i32 @_set_app_type(i32 %apptype)
  %pfmode = call i32* @__p__fmode()
  %p4d0 = load i32*, i32** @off_1400044D0
  %initf = load i32, i32* %p4d0
  store i32 %initf, i32* %pfmode
  %pcommode = call i32* @__p__commode()
  %p4b0 = load i32*, i32** @off_1400044B0
  %initc = load i32, i32* %p4b0
  store i32 %initc, i32* %pcommode
  %initres = call i32 @sub_140001910()
  %neg = icmp slt i32 %initres, 0
  br i1 %neg, label %early_cleanup, label %check_4380

early_cleanup:                                     ; preds = %do_init
  %ecode = call i32 @sub_140002A30(i32 8)
  call void @_cexit()
  br i1 %reent, label %return_code, label %release_then_return_code

release_then_return_code:                          ; preds = %early_cleanup
  %lockptr2 = load i64*, i64** @off_140004450
  %oldx = atomicrmw xchg i64* %lockptr2, i64 0 monotonic
  br label %return_code

return_code:                                       ; preds = %release_then_return_code, %early_cleanup
  ret i32 %ecode

check_4380:                                        ; preds = %do_init
  %p4380 = load i32*, i32** @off_140004380
  %v4380 = load i32, i32* %p4380
  %is1 = icmp eq i32 %v4380, 1
  br i1 %is1, label %call_2070, label %after_2070

call_2070:                                         ; preds = %check_4380
  %fn = bitcast void ()* @sub_1400019D0 to i8*
  call void @sub_140002070(i8* %fn)
  br label %after_2070

after_2070:                                        ; preds = %call_2070, %check_4380
  %p43e0 = load i32*, i32** @off_1400043E0
  %v43e0 = load i32, i32* %p43e0
  %isneg1 = icmp eq i32 %v43e0, -1
  br i1 %isneg1, label %do_ctl, label %after_ctl

do_ctl:                                            ; preds = %after_2070
  %ct = call i32 @_configthreadlocale(i32 -1)
  br label %after_ctl

after_ctl:                                         ; preds = %do_ctl, %after_2070
  %first_e = load i8**, i8*** @First
  %last_e = load i8**, i8*** @Last
  %einit = call i32 @_initterm_e(i8** %first_e, i8** %last_e)
  %nonzero = icmp ne i32 %einit, 0
  br i1 %nonzero, label %exit_255, label %cont_args

exit_255:                                          ; preds = %after_ctl
  call void @exit(i32 255)
  unreachable

cont_args:                                         ; preds = %after_ctl
  %p500 = load i32*, i32** @off_140004500
  %val4c0ptr = load i32*, i32** @off_1400044C0
  %val4c0 = load i32, i32* %val4c0ptr
  %resA60 = call i32 @sub_140002A60(i32* @dword_140007020, i8*** @qword_140007018, i8** @qword_140007010, i32 %val4c0, i32* %p500)
  %neg2 = icmp slt i32 %resA60, 0
  br i1 %neg2, label %early_cleanup2, label %build_argv

early_cleanup2:                                    ; preds = %cont_args
  %ecode2 = call i32 @sub_140002A30(i32 8)
  call void @_cexit()
  br i1 %reent, label %return_code2, label %release_then_return_code2

release_then_return_code2:                         ; preds = %early_cleanup2
  %lockptr3 = load i64*, i64** @off_140004450
  %oldx2 = atomicrmw xchg i64* %lockptr3, i64 0 monotonic
  br label %return_code2

return_code2:                                      ; preds = %release_then_return_code2, %early_cleanup2
  ret i32 %ecode2

build_argv:                                        ; preds = %cont_args
  %argc = load i32, i32* @dword_140007020
  %argc64 = sext i32 %argc to i64
  %need = add i64 %argc64, 1
  %bytes = mul i64 %need, 8
  %arr = call i8* @malloc(i64 %bytes)
  %arrptr = bitcast i8* %arr to i8**
  %isnull = icmp eq i8* %arr, null
  br i1 %isnull, label %early_cleanup3, label %loop_prep

early_cleanup3:                                    ; preds = %build_argv
  %ecode3 = call i32 @sub_140002A30(i32 8)
  call void @_cexit()
  br i1 %reent, label %return_code3, label %release_then_return_code3

release_then_return_code3:                         ; preds = %early_cleanup3
  %lockptr4 = load i64*, i64** @off_140004450
  %oldx3 = atomicrmw xchg i64* %lockptr4, i64 0 monotonic
  br label %return_code3

return_code3:                                      ; preds = %release_then_return_code3, %early_cleanup3
  ret i32 %ecode3

loop_prep:                                         ; preds = %build_argv
  %srcarr = load i8**, i8*** @qword_140007018
  br label %loop

loop:                                              ; preds = %copy, %loop_prep
  %i = phi i32 [ 0, %loop_prep ], [ %i_next, %copy ]
  %cmpi = icmp slt i32 %i, %argc
  br i1 %cmpi, label %loop_body, label %loop_end

loop_body:                                         ; preds = %loop
  %i64 = sext i32 %i to i64
  %srcptrloc = getelementptr inbounds i8*, i8** %srcarr, i64 %i64
  %src = load i8*, i8** %srcptrloc
  %len = call i64 @strlen(i8* %src)
  %len1 = add i64 %len, 1
  %dstmem = call i8* @malloc(i64 %len1)
  %dstloc = getelementptr inbounds i8*, i8** %arrptr, i64 %i64
  store i8* %dstmem, i8** %dstloc
  %isnull2 = icmp eq i8* %dstmem, null
  br i1 %isnull2, label %loop_end, label %copy

copy:                                              ; preds = %loop_body
  %cpy = call i8* @memcpy(i8* %dstmem, i8* %src, i64 %len1)
  %i_next = add i32 %i, 1
  br label %loop

loop_end:                                          ; preds = %loop_body, %loop
  %argc64b = sext i32 %argc to i64
  %lastloc = getelementptr inbounds i8*, i8** %arrptr, i64 %argc64b
  store i8* null, i8** %lastloc
  store i8** %arrptr, i8*** @qword_140007018
  %first = load i8**, i8*** @off_140004470
  %last = load i8**, i8*** @off_140004480
  call void @_initterm(i8** %first, i8** %last)
  call void @sub_1400018F0()
  store i32 2, i32* %stptrptr
  br label %post_init

post_init:                                         ; preds = %loop_end, %check_zero
  br i1 %reent, label %after_release, label %release_lock

release_lock:                                      ; preds = %post_init
  %lockptr5 = load i64*, i64** @off_140004450
  %oldx5 = atomicrmw xchg i64* %lockptr5, i64 0 monotonic
  br label %after_release

after_release:                                     ; preds = %release_lock, %post_init
  %ppcb = load i8**, i8*** @off_1400043D0
  %cb = load i8*, i8** %ppcb
  %hascb = icmp ne i8* %cb, null
  br i1 %hascb, label %call_cb, label %after_cb

call_cb:                                           ; preds = %after_release
  %cbfn = bitcast i8* %cb to void (i32, i32, i32)*
  call void %cbfn(i32 0, i32 2, i32 0)
  br label %after_cb

after_cb:                                          ; preds = %call_cb, %after_release
  %dest = call i8** @sub_140002A20()
  %valq = load i8*, i8** @qword_140007010
  store i8* %valq, i8** %dest
  %argv = load i8**, i8*** @qword_140007018
  %argc2 = load i32, i32* @dword_140007020
  call void @sub_14000171D(i8** %dest, i8** %argv, i32 %argc2)
  %flag8 = load i32, i32* @dword_140007008
  %iszero8 = icmp eq i32 %flag8, 0
  br i1 %iszero8, label %exit_now, label %check_7004

exit_now:                                          ; preds = %after_cb
  call void @exit(i32 0)
  unreachable

check_7004:                                        ; preds = %after_cb
  %f7004 = load i32, i32* @dword_140007004
  %iszero7004 = icmp eq i32 %f7004, 0
  br i1 %iszero7004, label %do_cexit_return, label %ret0

do_cexit_return:                                   ; preds = %check_7004
  %code8 = call i32 @sub_140002A30(i32 8)
  call void @_cexit()
  ret i32 %code8

ret0:                                              ; preds = %check_7004
  ret i32 0
}

define i32 @sub_140002A30(i32 %x) {
entry:
  ret i32 %x
}

define i8** @sub_140002A20() {
entry:
  %p = getelementptr inbounds i8*, i8** @g_arg_storage, i32 0
  ret i8** %p
}

define void @sub_14000171D(i8** %dest, i8** %argv, i32 %argc) {
entry:
  ret void
}

define i32 @sub_140002A60(i32* %pargc, i8*** %pargv, i8** %parg0, i32 %flag, i32* %popt) {
entry:
  store i32 0, i32* %pargc
  store i8** null, i8*** %pargv
  ret i32 0
}

define i32 @sub_140001910() {
entry:
  ret i32 0
}

define void @sub_1400018F0() {
entry:
  ret void
}

define void @sub_140001CA0() {
entry:
  ret void
}

define void @sub_1400024E0() {
entry:
  ret void
}

define void @sub_140002070(i8* %fn) {
entry:
  ret void
}

define i32 @TopLevelExceptionFilter(i8* %p) {
entry:
  ret i32 0
}

define void @Handler(i8* %a, i8* %b, i8* %c, i32 %d, i64 %e) {
entry:
  ret void
}