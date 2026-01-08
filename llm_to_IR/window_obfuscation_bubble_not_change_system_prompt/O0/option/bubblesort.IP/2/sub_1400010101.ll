; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140002670(i32)
declare void @sub_1400018D0()
declare void @sub_14000ED64(i8*)
declare i8* @sub_140002660()
declare i32 @sub_140002880(i32, i64, i64)
declare void @sub_140002750()
declare void @sub_1400027A0(i32)
declare void @sub_140001CB0()

@off_140004470 = external global i64*
@qword_140008280 = external global void (i32)*
@off_140004480 = external global i32*
@dword_140007004 = external global i32
@off_1400043F0 = external global i8*
@qword_140007010 = external global i64
@dword_140007020 = external global i32
@qword_140007018 = external global i64
@dword_140007008 = external global i32

define dso_local i32 @sub_140001010() {
entry:
  %eax.save = alloca i32, align 4
  %owner = call i64 asm sideeffect "movq %gs:0x30, $0; movq 8($0), $0", "=r"()
  %lockptr.addr = load i64*, i64** @off_140004470, align 8
  br label %spin_loop

spin_loop:                                           ; preds = %sleepcall, %entry
  %cmpxchg = cmpxchg i64* %lockptr.addr, i64 0, i64 %owner seq_cst seq_cst
  %old = extractvalue { i64, i1 } %cmpxchg, 0
  %success = extractvalue { i64, i1 } %cmpxchg, 1
  br i1 %success, label %acquired, label %check_reentry

check_reentry:                                       ; preds = %spin_loop
  %is_reentry = icmp eq i64 %old, %owner
  br i1 %is_reentry, label %reentered, label %sleepcall

sleepcall:                                           ; preds = %check_reentry
  %sleep.fp = load void (i32)*, void (i32)** @qword_140008280, align 8
  call void %sleep.fp(i32 1000)
  br label %spin_loop

acquired:                                            ; preds = %spin_loop
  br label %post_lock

reentered:                                           ; preds = %check_reentry
  br label %post_lock

post_lock:                                           ; preds = %reentered, %acquired
  %reentry.flag = phi i1 [ false, %acquired ], [ true, %reentered ]
  %state.ptr.addr = load i32*, i32** @off_140004480, align 8
  %state = load i32, i32* %state.ptr.addr, align 4
  %is_one = icmp eq i32 %state, 1
  br i1 %is_one, label %state_is_one, label %check_zero

state_is_one:                                        ; preds = %post_lock
  call void @sub_140002670(i32 31)
  br label %after_state

check_zero:                                          ; preds = %post_lock
  %is_zero = icmp eq i32 %state, 0
  br i1 %is_zero, label %state_is_zero, label %state_other

state_is_zero:                                       ; preds = %check_zero
  store i32 1, i32* %state.ptr.addr, align 4
  call void @sub_1400018D0()
  %cb.addr = bitcast void ()* @sub_140001CB0 to i8*
  call void @sub_14000ED64(i8* %cb.addr)
  br label %after_state

state_other:                                         ; preds = %check_zero
  store i32 1, i32* @dword_140007004, align 4
  br label %after_state

after_state:                                         ; preds = %state_other, %state_is_zero, %state_is_one
  br i1 %reentry.flag, label %skip_unlock, label %do_unlock

do_unlock:                                           ; preds = %after_state
  %xchg.old = atomicrmw xchg i64* %lockptr.addr, i64 0 seq_cst
  br label %skip_unlock

skip_unlock:                                         ; preds = %do_unlock, %after_state
  %pp = load i8*, i8** @off_1400043F0, align 8
  %pp.cast = bitcast i8* %pp to i8**
  %cb.fn.addr = load i8*, i8** %pp.cast, align 8
  %has_cb = icmp eq i8* %cb.fn.addr, null
  br i1 %has_cb, label %after_cb, label %do_cb

do_cb:                                               ; preds = %skip_unlock
  %cb.fn = bitcast i8* %cb.fn.addr to void (i64, i32, i64)*
  call void %cb.fn(i64 0, i32 2, i64 0)
  br label %after_cb

after_cb:                                            ; preds = %do_cb, %skip_unlock
  %buf = call i8* @sub_140002660()
  %buf64 = bitcast i8* %buf to i64*
  %v = load i64, i64* @qword_140007010, align 8
  store i64 %v, i64* %buf64, align 8
  %arg1 = load i32, i32* @dword_140007020, align 4
  %arg2 = load i64, i64* @qword_140007018, align 8
  %arg3 = load i64, i64* @qword_140007010, align 8
  %eax.call = call i32 @sub_140002880(i32 %arg1, i64 %arg2, i64 %arg3)
  %cfg = load i32, i32* @dword_140007008, align 4
  %cfg.zero = icmp eq i32 %cfg, 0
  br i1 %cfg.zero, label %call_27A0, label %check_750

call_27A0:                                           ; preds = %after_cb
  call void @sub_1400027A0(i32 %eax.call)
  ret i32 %eax.call

check_750:                                           ; preds = %after_cb
  %f750 = load i32, i32* @dword_140007004, align 4
  %f750.zero = icmp eq i32 %f750, 0
  br i1 %f750.zero, label %call_2750, label %ret

call_2750:                                           ; preds = %check_750
  store i32 %eax.call, i32* %eax.save, align 4
  call void @sub_140002750()
  %eax.rest = load i32, i32* %eax.save, align 4
  ret i32 %eax.rest

ret:                                                 ; preds = %check_750
  ret i32 %eax.call
}