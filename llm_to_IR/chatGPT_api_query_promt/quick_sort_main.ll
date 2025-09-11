; ModuleID = 'quicksort.ll'
source_filename = "quicksort.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

@__stack_chk_guard = external thread_local global i64

declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

define dso_local void @quick_sort(i32* nocapture %a, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  br label %outer

outer:                                            ; preds = %cont, %entry
  %lo.phi = phi i64 [ %lo, %entry ], [ %lo.next, %cont ]
  %hi.phi = phi i64 [ %hi, %entry ], [ %hi.next, %cont ]
  %cmp.ge = icmp sge i64 %lo.phi, %hi.phi
  br i1 %cmp.ge, label %ret, label %compute_pivot

compute_pivot:                                    ; preds = %outer
  %diff = sub i64 %hi.phi, %lo.phi
  %half = sdiv i64 %diff, 2
  %mid = add i64 %lo.phi, %half
  %midptr = getelementptr inbounds i32, i32* %a, i64 %mid
  %pivot = load i32, i32* %midptr, align 4
  %i.init = add i64 %lo.phi, 0
  %j.init = add i64 %hi.phi, 0
  br label %inc_i

inc_i:                                            ; preds = %after_swap, %inc_i, %compute_pivot
  %i.cur = phi i64 [ %i.init, %compute_pivot ], [ %i.next, %inc_i ], [ %i.next.swap, %after_swap ]
  %iptr = getelementptr inbounds i32, i32* %a, i64 %i.cur
  %ival = load i32, i32* %iptr, align 4
  %i.lt = icmp slt i32 %ival, %pivot
  %i.next = add i64 %i.cur, 1
  br i1 %i.lt, label %inc_i, label %dec_j.init

dec_j.init:                                       ; preds = %inc_i
  br label %dec_j

dec_j:                                            ; preds = %dec_j, %dec_j.init
  %i.at.j = phi i64 [ %i.cur, %dec_j.init ], [ %i.at.j, %dec_j ]
  %j.cur = phi i64 [ %j.init, %dec_j.init ], [ %j.next, %dec_j ]
  %jptr = getelementptr inbounds i32, i32* %a, i64 %j.cur
  %jval = load i32, i32* %jptr, align 4
  %pivot_lt_j = icmp slt i32 %pivot, %jval
  %j.next = add i64 %j.cur, -1
  br i1 %pivot_lt_j, label %dec_j, label %check

check:                                            ; preds = %dec_j
  %i.check = phi i64 [ %i.at.j, %dec_j ]
  %j.check = phi i64 [ %j.cur, %dec_j ]
  %i_le_j = icmp sle i64 %i.check, %j.check
  br i1 %i_le_j, label %do_swap, label %partition_done

do_swap:                                          ; preds = %check
  %iptr2 = getelementptr inbounds i32, i32* %a, i64 %i.check
  %ival2 = load i32, i32* %iptr2, align 4
  %jptr2 = getelementptr inbounds i32, i32* %a, i64 %j.check
  %jval2 = load i32, i32* %jptr2, align 4
  store i32 %jval2, i32* %iptr2, align 4
  store i32 %ival2, i32* %jptr2, align 4
  %i.next.swap = add i64 %i.check, 1
  %j.next.after = add i64 %j.check, -1
  br label %after_swap

after_swap:                                       ; preds = %do_swap
  %cont.cond = icmp sle i64 %i.next.swap, %j.next.after
  br i1 %cont.cond, label %inc_i, label %partition_done2

partition_done2:                                  ; preds = %after_swap
  br label %partition_done

partition_done:                                   ; preds = %partition_done2, %check
  %i.part = phi i64 [ %i.next.swap, %partition_done2 ], [ %i.check, %check ]
  %j.part = phi i64 [ %j.next.after, %partition_done2 ], [ %j.check, %check ]
  %left.size = sub i64 %j.part, %lo.phi
  %right.size = sub i64 %hi.phi, %i.part
  %left.lt.right = icmp slt i64 %left.size, %right.size
  br i1 %left.lt.right, label %recurse_left_first, label %recurse_right_first

recurse_left_first:                               ; preds = %partition_done
  %lo_lt_j = icmp slt i64 %lo.phi, %j.part
  br i1 %lo_lt_j, label %call.left, label %skip.left

call.left:                                        ; preds = %recurse_left_first
  call void @quick_sort(i32* %a, i64 %lo.phi, i64 %j.part)
  br label %skip.left

skip.left:                                        ; preds = %call.left, %recurse_left_first
  %lo.next.l = add i64 %i.part, 0
  %hi.next.l = add i64 %hi.phi, 0
  br label %cont

recurse_right_first:                              ; preds = %partition_done
  %i_lt_hi = icmp slt i64 %i.part, %hi.phi
  br i1 %i_lt_hi, label %call.right, label %skip.right

call.right:                                       ; preds = %recurse_right_first
  call void @quick_sort(i32* %a, i64 %i.part, i64 %hi.phi)
  br label %skip.right

skip.right:                                       ; preds = %call.right, %recurse_right_first
  %lo.next.r = add i64 %lo.phi, 0
  %hi.next.r = add i64 %j.part, 0
  br label %cont

cont:                                             ; preds = %skip.right, %skip.left
  %lo.next = phi i64 [ %lo.next.l, %skip.left ], [ %lo.next.r, %skip.right ]
  %hi.next = phi i64 [ %hi.next.l, %skip.left ], [ %hi.next.r, %skip.right ]
  br label %outer

ret:                                              ; preds = %outer
  ret void
}

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [10 x i32], align 16

  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %canary, align 8

  %arr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  ; Initialize array: [9,1,5,3,7,2,8,6,4,0]
  store i32 9, i32* %arr.ptr, align 4
  %p1 = getelementptr inbounds i32, i32* %arr.ptr, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr.ptr, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr.ptr, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr.ptr, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr.ptr, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr.ptr, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr.ptr, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr.ptr, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arr.ptr, i64 9
  store i32 0, i32* %p9, align 4

  call void @quick_sort(i32* %arr.ptr, i64 0, i64 9)

  br label %print.loop

print.loop:                                       ; preds = %print.loop, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %print.loop ]
  %elt.ptr = getelementptr inbounds i32, i32* %arr.ptr, i64 %i
  %elt = load i32, i32* %elt.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %elt)
  %i.next = add i64 %i, 1
  %cond = icmp sle i64 %i.next, 9
  br i1 %cond, label %print.loop, label %print.done

print.done:                                       ; preds = %print.loop
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)

  %guard.cur = load i64, i64* @__stack_chk_guard
  %guard.saved = load i64, i64* %canary, align 8
  %chk = icmp ne i64 %guard.cur, %guard.saved
  br i1 %chk, label %stackfail, label %ret

stackfail:                                        ; preds = %print.done
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %print.done
  ret i32 0
}