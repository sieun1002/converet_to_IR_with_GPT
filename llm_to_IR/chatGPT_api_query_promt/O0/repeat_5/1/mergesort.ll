; LLVM 14 IR for function: merge_sort

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* %dest, i64 %n) {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %alloc

alloc:
  %size_bytes = shl i64 %n, 2
  %buf_i8 = call i8* @malloc(i64 %size_bytes)
  %isnull = icmp eq i8* %buf_i8, null
  br i1 %isnull, label %ret, label %init

init:
  %buf = bitcast i8* %buf_i8 to i32*
  br label %outer.preheader

outer.preheader:
  %src0 = phi i32* [ %dest, %init ], [ %src.next, %after.pass ]
  %buf0 = phi i32* [ %buf, %init ], [ %buf.next, %after.pass ]
  %width0 = phi i64 [ 1, %init ], [ %width.next, %after.pass ]
  %continue = icmp ult i64 %width0, %n
  br i1 %continue, label %outer.body, label %outer.done

outer.body:
  br label %chunk.loop

chunk.loop:
  %chunk = phi i64 [ 0, %outer.body ], [ %chunk.next, %chunk.latch ]
  %has_chunk = icmp ult i64 %chunk, %n
  br i1 %has_chunk, label %compute.bounds, label %after.pass

compute.bounds:
  %left = %chunk
  %left_plus_w = add i64 %left, %width0
  %mid.isless = icmp ult i64 %left_plus_w, %n
  %mid = select i1 %mid.isless, i64 %left_plus_w, i64 %n
  %two_w = add i64 %width0, %width0
  %left_plus_2w = add i64 %left, %two_w
  %right.isless = icmp ult i64 %left_plus_2w, %n
  %right = select i1 %right.isless, i64 %left_plus_2w, i64 %n
  br label %merge.loop

merge.loop:
  %i = phi i64 [ %left, %compute.bounds ], [ %i.next, %merge.latch ]
  %j = phi i64 [ %mid, %compute.bounds ], [ %j.next, %merge.latch ]
  %k = phi i64 [ %left, %compute.bounds ], [ %k.next, %merge.latch ]
  %k_lt_right = icmp ult i64 %k, %right
  br i1 %k_lt_right, label %choose, label %chunk.latch

choose:
  %i_lt_mid = icmp ult i64 %i, %mid
  %j_lt_right = icmp ult i64 %j, %right
  br i1 %i_lt_mid, label %check_right, label %take_right

check_right:
  br i1 %j_lt_right, label %load_both, label %take_left

load_both:
  %i.ptr = getelementptr inbounds i32, i32* %src0, i64 %i
  %i.val = load i32, i32* %i.ptr, align 4
  %j.ptr = getelementptr inbounds i32, i32* %src0, i64 %j
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp_le = icmp sle i32 %i.val, %j.val
  br i1 %cmp_le, label %take_left_loaded, label %take_right_loaded

take_left_loaded:
  %dst.ptr1 = getelementptr inbounds i32, i32* %buf0, i64 %k
  store i32 %i.val, i32* %dst.ptr1, align 4
  %i.next1 = add i64 %i, 1
  br label %merge.latch

take_right_loaded:
  %dst.ptr2 = getelementptr inbounds i32, i32* %buf0, i64 %k
  store i32 %j.val, i32* %dst.ptr2, align 4
  %j.next1 = add i64 %j, 1
  br label %merge.latch

take_left:
  %i.ptr2 = getelementptr inbounds i32, i32* %src0, i64 %i
  %i.val2 = load i32, i32* %i.ptr2, align 4
  %dst.ptr3 = getelementptr inbounds i32, i32* %buf0, i64 %k
  store i32 %i.val2, i32* %dst.ptr3, align 4
  %i.next2 = add i64 %i, 1
  br label %merge.latch

take_right:
  %j.ptr2 = getelementptr inbounds i32, i32* %src0, i64 %j
  %j.val2 = load i32, i32* %j.ptr2, align 4
  %dst.ptr4 = getelementptr inbounds i32, i32* %buf0, i64 %k
  store i32 %j.val2, i32* %dst.ptr4, align 4
  %j.next2 = add i64 %j, 1
  br label %merge.latch

merge.latch:
  %i.next = phi i64 [ %i.next1, %take_left_loaded ], [ %i, %take_right_loaded ], [ %i.next2, %take_left ], [ %i, %take_right ]
  %j.next = phi i64 [ %j, %take_left_loaded ], [ %j.next1, %take_right_loaded ], [ %j, %take_left ], [ %j.next2, %take_right ]
  %k.next = add i64 %k, 1
  br label %merge.loop

chunk.latch:
  %two_w2 = add i64 %width0, %width0
  %chunk.next = add i64 %chunk, %two_w2
  br label %chunk.loop

after.pass:
  %src.next = %buf0
  %buf.next = %src0
  %width.next = shl i64 %width0, 1
  br label %outer.preheader

outer.done:
  %src_eq_dest = icmp eq i32* %src0, %dest
  br i1 %src_eq_dest, label %free.block, label %memcpy.block

memcpy.block:
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src0 to i8*
  %size_bytes2 = shl i64 %n, 2
  call i8* @memcpy(i8*, i8*, i64) %dest.i8, %src.i8, %size_bytes2
  br label %free.block

free.block:
  call void @free(i8* %buf_i8)
  br label %ret

ret:
  ret void
}