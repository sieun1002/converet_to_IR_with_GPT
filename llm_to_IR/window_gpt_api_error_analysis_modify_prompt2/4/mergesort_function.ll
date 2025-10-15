; ModuleID = 'merge_sort_module'
target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare i8* @memcpy(i8*, i8*, i64)
declare void @free(i8*)

define void @merge_sort(i32* %arg_0, i64 %arg_8) {
entry:
  %cmp_len_small = icmp ule i64 %arg_8, 1
  br i1 %cmp_len_small, label %exit, label %alloc

alloc:
  %size_bytes = shl i64 %arg_8, 2
  %blk_i8 = call i8* @malloc(i64 %size_bytes)
  %blk_is_null = icmp eq i8* %blk_i8, null
  br i1 %blk_is_null, label %exit, label %init

init:
  %blk_i32 = bitcast i8* %blk_i8 to i32*
  br label %outer.header

outer.header:
  %src.phi = phi i32* [ %arg_0, %init ], [ %tmp.next, %outer.latch ]
  %tmp.phi = phi i32* [ %blk_i32, %init ], [ %src.next, %outer.latch ]
  %run.phi = phi i64 [ 1, %init ], [ %run.next, %outer.latch ]
  %outer_cond = icmp ult i64 %run.phi, %arg_8
  br i1 %outer_cond, label %inner.init, label %post.outer

inner.init:
  br label %inner.header

inner.header:
  %base.phi = phi i64 [ 0, %inner.init ], [ %base.next, %inner.latch ]
  %inner_cond = icmp ult i64 %base.phi, %arg_8
  br i1 %inner_cond, label %merge.init, label %outer.latch

merge.init:
  %left = add i64 %base.phi, 0
  %mid0 = add i64 %left, %run.phi
  %mid_gt = icmp ugt i64 %mid0, %arg_8
  %mid = select i1 %mid_gt, i64 %arg_8, i64 %mid0
  %two_run = add i64 %run.phi, %run.phi
  %right0 = add i64 %left, %two_run
  %right_gt = icmp ugt i64 %right0, %arg_8
  %right = select i1 %right_gt, i64 %arg_8, i64 %right0
  br label %merge.header

merge.header:
  %i.phi = phi i64 [ %left, %merge.init ], [ %i.next, %merge.latch ]
  %j.phi = phi i64 [ %mid, %merge.init ], [ %j.next, %merge.latch ]
  %k.phi = phi i64 [ %left, %merge.init ], [ %k.next, %merge.latch ]
  %k_cond = icmp ult i64 %k.phi, %right
  br i1 %k_cond, label %choose, label %inner.latch

choose:
  %i_has = icmp ult i64 %i.phi, %mid
  br i1 %i_has, label %check_j, label %take_right

check_j:
  %j_has = icmp ult i64 %j.phi, %right
  br i1 %j_has, label %load_compare, label %take_left

load_compare:
  %ptr_i_cmp = getelementptr inbounds i32, i32* %src.phi, i64 %i.phi
  %val_i_cmp = load i32, i32* %ptr_i_cmp, align 4
  %ptr_j_cmp = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %val_j_cmp = load i32, i32* %ptr_j_cmp, align 4
  %i_gt_j = icmp sgt i32 %val_i_cmp, %val_j_cmp
  br i1 %i_gt_j, label %take_right, label %take_left

take_left:
  %ptr_i_store = getelementptr inbounds i32, i32* %src.phi, i64 %i.phi
  %val_i_store = load i32, i32* %ptr_i_store, align 4
  %dst_ptr_left = getelementptr inbounds i32, i32* %tmp.phi, i64 %k.phi
  store i32 %val_i_store, i32* %dst_ptr_left, align 4
  %i.inc = add i64 %i.phi, 1
  %k.inc.left = add i64 %k.phi, 1
  br label %merge.latch

take_right:
  %ptr_j_store = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %val_j_store = load i32, i32* %ptr_j_store, align 4
  %dst_ptr_right = getelementptr inbounds i32, i32* %tmp.phi, i64 %k.phi
  store i32 %val_j_store, i32* %dst_ptr_right, align 4
  %j.inc = add i64 %j.phi, 1
  %k.inc.right = add i64 %k.phi, 1
  br label %merge.latch

merge.latch:
  %i.next = phi i64 [ %i.inc, %take_left ], [ %i.phi, %take_right ]
  %j.next = phi i64 [ %j.phi, %take_left ], [ %j.inc, %take_right ]
  %k.next = phi i64 [ %k.inc.left, %take_left ], [ %k.inc.right, %take_right ]
  br label %merge.header

inner.latch:
  %two_run2 = add i64 %run.phi, %run.phi
  %base.next = add i64 %base.phi, %two_run2
  br label %inner.header

outer.latch:
  %src.next = bitcast i32* %tmp.phi to i32*
  %tmp.next = bitcast i32* %src.phi to i32*
  %run.next = add i64 %run.phi, %run.phi
  br label %outer.header

post.outer:
  %src.final = phi i32* [ %src.phi, %outer.header ]
  %src_is_orig = icmp eq i32* %src.final, %arg_0
  br i1 %src_is_orig, label %free.block, label %copyback

copyback:
  %bytes_copy = shl i64 %arg_8, 2
  %dst_i8 = bitcast i32* %arg_0 to i8*
  %src_i8 = bitcast i32* %src.final to i8*
  %memcpy_ret = call i8* @memcpy(i8* %dst_i8, i8* %src_i8, i64 %bytes_copy)
  br label %free.block

free.block:
  call void @free(i8* %blk_i8)
  br label %exit

exit:
  ret void
}