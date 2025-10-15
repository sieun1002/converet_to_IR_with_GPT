; ModuleID = 'fixed'
source_filename = "fixed"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@g_owner = global i64 0, align 8
@off_140004450 = global ptr @g_owner, align 8

@g_phase = global i32 0, align 4
@off_140004460 = global ptr @g_phase, align 8

declare void @Sleep(i32)
declare i32 @GetCurrentThreadId()

define i32 @sub_140001010() {
entry:
  %tid32 = call i32 @GetCurrentThreadId()
  %tid = zext i32 %tid32 to i64
  br label %lock_try

lock_try:                                         ; preds = %sleep, %entry
  %owner_ptr0 = load ptr, ptr @off_140004450, align 8
  %cmp = cmpxchg ptr %owner_ptr0, i64 0, i64 %tid monotonic monotonic
  %old = extractvalue { i64, i1 } %cmp, 0
  %success = extractvalue { i64, i1 } %cmp, 1
  br i1 %success, label %acquired, label %check_reentrant

check_reentrant:                                  ; preds = %lock_try
  %is_same = icmp eq i64 %old, %tid
  br i1 %is_same, label %reentrant_owned, label %sleep

sleep:                                            ; preds = %check_reentrant
  call void @Sleep(i32 1000)
  br label %lock_try

acquired:                                         ; preds = %lock_try
  br label %after_lock

reentrant_owned:                                  ; preds = %check_reentrant
  br label %after_lock

after_lock:                                       ; preds = %reentrant_owned, %acquired
  %we_acquired = phi i1 [ true, %acquired ], [ false, %reentrant_owned ]
  %phase_ptr_ptr = load ptr, ptr @off_140004460, align 8
  %phase_val = load i32, ptr %phase_ptr_ptr, align 4
  %is_zero = icmp eq i32 %phase_val, 0
  br i1 %is_zero, label %init_phase, label %done

init_phase:                                       ; preds = %after_lock
  store i32 1, ptr %phase_ptr_ptr, align 4
  br label %done

done:                                             ; preds = %init_phase, %after_lock
  br i1 %we_acquired, label %release, label %ret

release:                                          ; preds = %done
  %owner_ptr1 = load ptr, ptr @off_140004450, align 8
  store i64 0, ptr %owner_ptr1, align 8
  br label %ret

ret:                                              ; preds = %release, %done
  ret i32 0
}