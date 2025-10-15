; ModuleID = 'merge_sort_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %arg_0, i64 %arg_8) {
entry:
  %cmp_le1 = icmp ule i64 %arg_8, 1
  br i1 %cmp_le1, label %ret, label %alloc

alloc:
  %size = shl i64 %arg_8, 2
  %blk8 = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %blk8, null
  br i1 %isnull, label %ret, label %init

init:
  %block = bitcast i8* %blk8 to i32*
  br label %outer

outer:
  %run = phi i64 [ 1, %init ], [ %run_shl, %post_inner ]
  %src = phi i32* [ %arg_0, %init ], [ %dst_post, %post_inner ]
  %dst = phi i32* [ %block, %init ], [ %src_post, %post_inner ]
  %cond_outer = icmp ult i64 %run, %arg_8
  br i1 %cond_outer, label %setup_inner, label %after_outer

setup_inner:
  br label %inner

inner:
  %start = phi i64 [ 0, %setup_inner ], [ %next_start, %after_merge_loop ]
  %cond_inner = icmp ult i64 %start, %arg_8
  br i1 %cond_inner, label %compute_bounds, label %post_inner

compute_bounds:
  %mid_tmp = add i64 %start, %run
  %mid_le = icmp ule i64 %mid_tmp, %arg_8
  %mid = select i1 %mid_le, i64 %mid_tmp, i64 %arg_8
  %two = add i64 %run, %run
  %end_tmp = add i64 %start, %two
  %end_le = icmp ule i64 %end_tmp, %arg_8
  %end = select i1 %end_le, i64 %end_tmp, i64 %arg_8
  br label %merge

merge:
  %i = phi i64 [ %start, %compute_bounds ], [ %i_new, %merge_body_end ]
  %j = phi i64 [ %mid, %compute_bounds ], [ %j_new, %merge_body_end ]
  %k = phi i64 [ %start, %compute_bounds ], [ %k_new, %merge_body_end ]
  %k_lt_end = icmp ult i64 %k, %end
  br i1 %k_lt_end, label %merge_body, label %after_merge_loop

merge_body:
  %i_lt_mid = icmp ult i64 %i, %mid
  br i1 %i_lt_mid, label %check_j, label %take_right

check_j:
  %j_lt_end = icmp ult i64 %j, %end
  br i1 %j_lt_end, label %compare_vals, label %take_left

compare_vals:
  %i_ptr = getelementptr inbounds i32, i32* %src, i64 %i
  %i_val = load i32, i32* %i_ptr, align 4
  %j_ptr = getelementptr inbounds i32, i32* %src, i64 %j
  %j_val = load i32, i32* %j_ptr, align 4
  %left_gt_right = icmp sgt i32 %i_val, %j_val
  br i1 %left_gt_right, label %take_right, label %take_left

take_left:
  %i_ptr2 = getelementptr inbounds i32, i32* %src, i64 %i
  %valL = load i32, i32* %i_ptr2, align 4
  %k_ptr = getelementptr inbounds i32, i32* %dst, i64 %k
  store i32 %valL, i32* %k_ptr, align 4
  %i_inc = add i64 %i, 1
  %k_inc = add i64 %k, 1
  br label %merge_body_end

take_right:
  %j_ptr2 = getelementptr inbounds i32, i32* %src, i64 %j
  %valR = load i32, i32* %j_ptr2, align 4
  %k_ptr2 = getelementptr inbounds i32, i32* %dst, i64 %k
  store i32 %valR, i32* %k_ptr2, align 4
  %j_inc = add i64 %j, 1
  %k_inc2 = add i64 %k, 1
  br label %merge_body_end

merge_body_end:
  %i_new = phi i64 [ %i_inc, %take_left ], [ %i, %take_right ]
  %j_new = phi i64 [ %j, %take_left ], [ %j_inc, %take_right ]
  %k_new = phi i64 [ %k_inc, %take_left ], [ %k_inc2, %take_right ]
  br label %merge

after_merge_loop:
  %next_start = add i64 %start, %two
  br label %inner

post_inner:
  %src_post = getelementptr inbounds i32, i32* %src, i64 0
  %dst_post = getelementptr inbounds i32, i32* %dst, i64 0
  %run_shl = shl i64 %run, 1
  br label %outer

after_outer:
  %final_src = getelementptr inbounds i32, i32* %src, i64 0
  %neq = icmp ne i32* %final_src, %arg_0
  br i1 %neq, label %do_memcpy, label %free_block

do_memcpy:
  %size3 = shl i64 %arg_8, 2
  %dst8 = bitcast i32* %arg_0 to i8*
  %src8 = bitcast i32* %final_src to i8*
  %mem = call i8* @memcpy(i8* %dst8, i8* %src8, i64 %size3)
  br label %free_block

free_block:
  %blk_free = bitcast i32* %block to i8*
  call void @free(i8* %blk_free)
  br label %ret

ret:
  ret void
}