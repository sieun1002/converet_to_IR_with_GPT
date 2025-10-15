; ModuleID = 'merge_sort_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare dso_local i8* @malloc(i64)
declare dso_local void @free(i8*)
declare dso_local i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %early_ret, label %alloc

early_ret:
  ret void

alloc:
  %size_bytes = shl i64 %n, 2
  %raw = call i8* @malloc(i64 %size_bytes)
  %isnull = icmp eq i8* %raw, null
  br i1 %isnull, label %ret, label %init

ret:
  ret void

init:
  %buf = bitcast i8* %raw to i32*
  br label %outer_cond

outer_cond:
  %run = phi i64 [ 1, %init ], [ %run_next, %post_pair ]
  %src = phi i32* [ %arr, %init ], [ %src_next, %post_pair ]
  %tmp = phi i32* [ %buf, %init ], [ %tmp_next, %post_pair ]
  %cond1 = icmp ult i64 %run, %n
  br i1 %cond1, label %outer_body_start, label %after_outer

outer_body_start:
  br label %s_loop_cond

s_loop_cond:
  %s = phi i64 [ 0, %outer_body_start ], [ %s_next, %s_loop_latch ]
  %cmp_s = icmp ult i64 %s, %n
  br i1 %cmp_s, label %setup_pair, label %finish_pass

setup_pair:
  %mid_tmp = add i64 %s, %run
  %over1 = icmp ugt i64 %mid_tmp, %n
  %mid = select i1 %over1, i64 %n, i64 %mid_tmp
  %tworun = add i64 %run, %run
  %end_tmp = add i64 %s, %tworun
  %over2 = icmp ugt i64 %end_tmp, %n
  %end = select i1 %over2, i64 %n, i64 %end_tmp
  br label %merge_cond

merge_cond:
  %l = phi i64 [ %s, %setup_pair ], [ %l_next, %merge_latch ]
  %r = phi i64 [ %mid, %setup_pair ], [ %r_next, %merge_latch ]
  %d = phi i64 [ %s, %setup_pair ], [ %d_next, %merge_latch ]
  %d_lt_end = icmp ult i64 %d, %end
  br i1 %d_lt_end, label %choose, label %s_loop_latch

choose:
  %l_lt_mid = icmp ult i64 %l, %mid
  br i1 %l_lt_mid, label %check_right, label %take_right

check_right:
  %r_lt_end = icmp ult i64 %r, %end
  br i1 %r_lt_end, label %compare_vals, label %take_left

compare_vals:
  %lptr = getelementptr inbounds i32, i32* %src, i64 %l
  %lv = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %src, i64 %r
  %rv = load i32, i32* %rptr, align 4
  %le = icmp sle i32 %lv, %rv
  br i1 %le, label %take_left, label %take_right

take_left:
  %lptr2 = getelementptr inbounds i32, i32* %src, i64 %l
  %valL = load i32, i32* %lptr2, align 4
  %dptr = getelementptr inbounds i32, i32* %tmp, i64 %d
  store i32 %valL, i32* %dptr, align 4
  %l_next_L = add i64 %l, 1
  %r_next_L = add i64 %r, 0
  %d_next_L = add i64 %d, 1
  br label %merge_latch

take_right:
  %rptr2 = getelementptr inbounds i32, i32* %src, i64 %r
  %valR = load i32, i32* %rptr2, align 4
  %dptr2 = getelementptr inbounds i32, i32* %tmp, i64 %d
  store i32 %valR, i32* %dptr2, align 4
  %r_next_R = add i64 %r, 1
  %l_next_R = add i64 %l, 0
  %d_next_R = add i64 %d, 1
  br label %merge_latch

merge_latch:
  %l_next = phi i64 [ %l_next_L, %take_left ], [ %l_next_R, %take_right ]
  %r_next = phi i64 [ %r_next_L, %take_left ], [ %r_next_R, %take_right ]
  %d_next = phi i64 [ %d_next_L, %take_left ], [ %d_next_R, %take_right ]
  br label %merge_cond

s_loop_latch:
  %tworun2 = add i64 %run, %run
  %s_next = add i64 %s, %tworun2
  br label %s_loop_cond

finish_pass:
  %src_next = getelementptr inbounds i32, i32* %tmp, i64 0
  %tmp_next = getelementptr inbounds i32, i32* %src, i64 0
  %run_next = shl i64 %run, 1
  br label %post_pair

post_pair:
  br label %outer_cond

after_outer:
  %src_final = phi i32* [ %src, %outer_cond ]
  %eq = icmp eq i32* %src_final, %arr
  br i1 %eq, label %free_and_ret, label %do_memcpy

do_memcpy:
  %bytes = shl i64 %n, 2
  %dst = bitcast i32* %arr to i8*
  %srcb = bitcast i32* %src_final to i8*
  %mem = call i8* @memcpy(i8* %dst, i8* %srcb, i64 %bytes)
  br label %free_and_ret

free_and_ret:
  call void @free(i8* %raw)
  ret void
}