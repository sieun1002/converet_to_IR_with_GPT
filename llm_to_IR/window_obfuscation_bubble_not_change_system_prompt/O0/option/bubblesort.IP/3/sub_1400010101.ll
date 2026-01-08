; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_140004470 = external global i64*
@qword_140008280 = external global i8*
@off_140004480 = external global i32*
@dword_140007004 = external global i32
@off_1400043F0 = external global i8*
@qword_140007010 = external global i8*
@qword_140007018 = external global i8*
@dword_140007020 = external global i32
@dword_140007008 = external global i32

declare i8* @sub_140002660()
declare i32 @sub_140002880(i32, i8*, i8*)
declare void @sub_140002750()
declare i32 @sub_140002670(i32)
declare void @sub_1400027A0(i32)
declare void @sub_1400018D0()
declare void @sub_14000ED64(i8*)
declare void @sub_140001CB0()

define i32 @sub_140001010() local_unnamed_addr {
entry:
  %saved_eax = alloca i32, align 4
  %lock.addr.ptr = load i64*, i64** @off_140004470, align 8
  %teb = call i8* asm sideeffect "mov $0, qword ptr gs:[0x30]", "=r"()
  %thr = call i64 asm sideeffect "mov $0, qword ptr [$1+8]", "=r,r"(i8* %teb)
  br label %loop_try

loop_try:                                         ; preds = %sleep, %entry
  %cmpx = cmpxchg i64* %lock.addr.ptr, i64 0, i64 %thr seq_cst seq_cst
  %oldval = extractvalue { i64, i1 } %cmpx, 0
  %success = extractvalue { i64, i1 } %cmpx, 1
  br i1 %success, label %acquired, label %check

check:                                            ; preds = %loop_try
  %eq = icmp eq i64 %thr, %oldval
  br i1 %eq, label %reentrant, label %sleep

sleep:                                            ; preds = %check
  %sleep_fp_ptr = load i8*, i8** @qword_140008280, align 8
  %sleep_fp = bitcast i8* %sleep_fp_ptr to void (i32)*
  call void %sleep_fp(i32 1000)
  br label %loop_try

reentrant:                                        ; preds = %check
  br label %post_lock

acquired:                                         ; preds = %loop_try
  br label %post_lock

post_lock:                                        ; preds = %acquired, %reentrant
  %isReentrant = phi i1 [ true, %reentrant ], [ false, %acquired ]
  %guard.ptr = load i32*, i32** @off_140004480, align 8
  %guard.val1 = load i32, i32* %guard.ptr, align 4
  %cmp1 = icmp eq i32 %guard.val1, 1
  br i1 %cmp1, label %L_3C8, label %check_zero

check_zero:                                       ; preds = %post_lock
  %guard.val2 = load i32, i32* %guard.ptr, align 4
  %isZero = icmp eq i32 %guard.val2, 0
  br i1 %isZero, label %L_110, label %after_guard

L_110:                                            ; preds = %check_zero
  store i32 1, i32* %guard.ptr, align 4
  call void @sub_1400018D0()
  %cb_addr = bitcast void ()* @sub_140001CB0 to i8*
  call void @sub_14000ED64(i8* %cb_addr)
  br label %after_guard

after_guard:                                      ; preds = %L_110, %check_zero
  store i32 1, i32* @dword_140007004, align 4
  br i1 %isReentrant, label %block_108d, label %unlock_then_108d

unlock_then_108d:                                 ; preds = %after_guard
  %xchg.old = atomicrmw xchg i64* %lock.addr.ptr, i64 0 seq_cst
  br label %block_108d

block_108d:                                       ; preds = %unlock_then_108d, %after_guard
  %tmp_ptr = load i8*, i8** @off_1400043F0, align 8
  %tmp_pp = bitcast i8* %tmp_ptr to i8**
  %fn_raw = load i8*, i8** %tmp_pp, align 8
  %fn_isnull = icmp eq i8* %fn_raw, null
  br i1 %fn_isnull, label %after_cb, label %do_cb

do_cb:                                            ; preds = %block_108d
  %fn_typed = bitcast i8* %fn_raw to void (i32, i32, i64)*
  call void %fn_typed(i32 0, i32 2, i64 0)
  br label %after_cb

after_cb:                                         ; preds = %do_cb, %block_108d
  %buf = call i8* @sub_140002660()
  %srcptr = load i8*, i8** @qword_140007010, align 8
  %buf_as_ptr = bitcast i8* %buf to i8**
  store i8* %srcptr, i8** %buf_as_ptr, align 8
  %ecxv = load i32, i32* @dword_140007020, align 4
  %rdxv = load i8*, i8** @qword_140007018, align 8
  %ret2880 = call i32 @sub_140002880(i32 %ecxv, i8* %rdxv, i8* %srcptr)
  %ecx3 = load i32, i32* @dword_140007008, align 4
  %ecx3_zero = icmp eq i32 %ecx3, 0
  br i1 %ecx3_zero, label %L_3D2, label %check_7004

check_7004:                                       ; preds = %after_cb
  %d7004 = load i32, i32* @dword_140007004, align 4
  %d7004_zero = icmp eq i32 %d7004, 0
  br i1 %d7004_zero, label %L_310, label %ret_epilogue

L_310:                                            ; preds = %check_7004
  store i32 %ret2880, i32* %saved_eax, align 4
  call void @sub_140002750()
  %restored = load i32, i32* %saved_eax, align 4
  ret i32 %restored

L_3C8:                                            ; preds = %post_lock
  %r670 = call i32 @sub_140002670(i32 31)
  br label %L_3D2_prep

L_3D2:                                            ; preds = %after_cb
  br label %L_3D2_prep

L_3D2_prep:                                       ; preds = %L_3D2, %L_3C8
  %to7a0 = phi i32 [ %r670, %L_3C8 ], [ %ret2880, %L_3D2 ]
  call void @sub_1400027A0(i32 %to7a0)
  ret i32 %to7a0

ret_epilogue:                                     ; preds = %check_7004
  ret i32 %ret2880
}