; ModuleID: 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_140004390 = external global i8*, align 8

declare i32 @j__crt_atexit(void ()*)
declare void @sub_140001820()

define i32 @sub_140001870() {
entry:
  %rdx_base = load i8*, i8** @off_140004390, align 8
  %base_i64 = bitcast i8* %rdx_base to i64*
  %first_qword = load i64, i64* %base_i64, align 8
  %first32 = trunc i64 %first_qword to i32
  %is_neg1 = icmp eq i32 %first32, -1
  br i1 %is_neg1, label %scan_init, label %have_count

scan_init:                                        ; preds = %entry
  br label %scan_loop

scan_loop:                                        ; preds = %scan_continue, %scan_init
  %idx = phi i32 [ 0, %scan_init ], [ %next, %scan_continue ]
  %next = add i32 %idx, 1
  %next_z = zext i32 %next to i64
  %offset = mul i64 %next_z, 8
  %ptr_cand = getelementptr i8, i8* %rdx_base, i64 %offset
  %slot = bitcast i8* %ptr_cand to void ()**
  %fp = load void ()*, void ()** %slot, align 8
  %notnull = icmp ne void ()* %fp, null
  br i1 %notnull, label %scan_continue, label %scan_done

scan_continue:                                    ; preds = %scan_loop
  br label %scan_loop

scan_done:                                        ; preds = %scan_loop
  br label %merge

have_count:                                       ; preds = %entry
  br label %merge

merge:                                            ; preds = %have_count, %scan_done
  %count = phi i32 [ %first32, %have_count ], [ %idx, %scan_done ]
  %is_zero = icmp eq i32 %count, 0
  br i1 %is_zero, label %call_atexit, label %loop_pre

loop_pre:                                         ; preds = %merge
  %count_z = zext i32 %count to i64
  %bytes = mul i64 %count_z, 8
  %rbx_start = getelementptr i8, i8* %rdx_base, i64 %bytes
  br label %loop

loop:                                             ; preds = %loop, %loop_pre
  %curr = phi i8* [ %rbx_start, %loop_pre ], [ %next_ptr2, %loop ]
  %slot2 = bitcast i8* %curr to void ()**
  %fp2 = load void ()*, void ()** %slot2, align 8
  call void %fp2()
  %next_ptr2 = getelementptr i8, i8* %curr, i64 -8
  %cmp2 = icmp ne i8* %next_ptr2, %rdx_base
  br i1 %cmp2, label %loop, label %call_atexit

call_atexit:                                      ; preds = %loop, %merge
  %res = tail call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %res
}