; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @j__crt_atexit(void ()*)
declare void @sub_140001820()

@off_140004390 = external global i8*

define i32 @sub_140001870() {
entry:
  %baseptr = load i8*, i8** @off_140004390, align 8
  %slots = bitcast i8* %baseptr to i8**
  %first_slot_ptr = getelementptr inbounds i8*, i8** %slots, i64 0
  %first_slot_val = load i8*, i8** %first_slot_ptr, align 8
  %first_as_i64 = ptrtoint i8* %first_slot_val to i64
  %first_as_i32 = trunc i64 %first_as_i64 to i32
  %is_m1 = icmp eq i32 %first_as_i32, -1
  br i1 %is_m1, label %scan, label %got_count

scan:
  br label %scan_loop

scan_loop:
  %idx = phi i64 [ 1, %scan ], [ %idx_next, %scan_loop ]
  %fparr_scan = bitcast i8** %slots to void ()**
  %elem_ptr2 = getelementptr inbounds void ()*, void ()** %fparr_scan, i64 %idx
  %fn2 = load void ()*, void ()** %elem_ptr2, align 8
  %is_nonnull = icmp ne void ()* %fn2, null
  %idx_next = add nuw i64 %idx, 1
  br i1 %is_nonnull, label %scan_loop, label %after_scan

after_scan:
  %cnt64 = add i64 %idx, -1
  %cnt32_from_scan = trunc i64 %cnt64 to i32
  br label %got_count

got_count:
  %cnt32 = phi i32 [ %first_as_i32, %entry ], [ %cnt32_from_scan, %after_scan ]
  %is_zero = icmp eq i32 %cnt32, 0
  br i1 %is_zero, label %register, label %loop_pre

loop_pre:
  %n64 = sext i32 %cnt32 to i64
  br label %loop

loop:
  %i = phi i64 [ %n64, %loop_pre ], [ %i_next, %loop ]
  %fparr = bitcast i8** %slots to void ()**
  %elem_ptr = getelementptr inbounds void ()*, void ()** %fparr, i64 %i
  %fn = load void ()*, void ()** %elem_ptr, align 8
  call void %fn()
  %i_next = add nsw i64 %i, -1
  %cont = icmp ne i64 %i_next, 0
  br i1 %cont, label %loop, label %register

register:
  %ret = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %ret
}