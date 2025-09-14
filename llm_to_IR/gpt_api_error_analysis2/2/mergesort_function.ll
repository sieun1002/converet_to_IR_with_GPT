; ModuleID = 'merge_sort'
target triple = "x86_64-pc-linux-gnu"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %alloc

alloc:
  %bytes = shl i64 %n, 2
  %tmp.raw = call i8* @malloc(i64 %bytes)
  %isnull = icmp eq i8* %tmp.raw, null
  br i1 %isnull, label %ret, label %init

init:
  %tmp.buf = bitcast i8* %tmp.raw to i32*
  br label %outer

outer:
  %width = phi i64 [ 1, %init ], [ %width.next, %after_outer_body ]
  %src = phi i32* [ %dest, %init ], [ %src.next, %after_outer_body ]
  %buf = phi i32* [ %tmp.buf, %init ], [ %buf.next, %after_outer_body ]
  %cond.outer = icmp ult i64 %width, %n
  br i1 %cond.outer, label %outer_body_init, label %after_outer

outer_body_init:
  br label %outer_body

outer_body:
  %i = phi i64 [ 0, %outer_body_init ], [ %i.next, %after_inner ]
  %cond.i = icmp ult i64 %i, %n
  br i1 %cond.i, label %merge_prep, label %after_outer_body

merge_prep:
  %i_plus_w = add i64 %i, %width
  %mid.cmp = icmp ult i64 %i_plus_w, %n
  %mid = select i1 %mid.cmp, i64 %i_plus_w, i64 %n
  %two_w = shl i64 %width, 1
  %i_plus_2w = add i64 %i, %two_w
  %rend.cmp = icmp ult i64 %i_plus_2w, %n
  %rightEnd = select i1 %rend.cmp, i64 %i_plus_2w, i64 %n
  br label %merge_loop

merge_loop:
  %left = phi i64 [ %i, %merge_prep ], [ %left.next, %take_left ], [ %left, %take_right ]
  %right = phi i64 [ %mid, %merge_prep ], [ %right, %take_left ], [ %right.next, %take_right ]
  %out = phi i64 [ %i, %merge_prep ], [ %out.next, %take_left ], [ %out.next2, %take_right ]
  %out.cmp = icmp ult i64 %out, %rightEnd
  br i1 %out.cmp, label %compare, label %after_inner

compare:
  %leftAvail = icmp ult i64 %left, %mid
  br i1 %leftAvail, label %check_right, label %take_right

check_right:
  %rightAvail = icmp ult i64 %right, %rightEnd
  br i1 %rightAvail, label %load_compare, label %take_left

load_compare:
  %lptr = getelementptr inbounds i32, i32* %src, i64 %left
  %lval = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %src, i64 %right
  %rval = load i32, i32* %rptr, align 4
  %le = icmp sle i32 %lval, %rval
  br i1 %le, label %take_left, label %take_right

take_left:
  %lptr.store = getelementptr inbounds i32, i32* %src, i64 %left
  %lval.store = load i32, i32* %lptr.store, align 4
  %optr.L = getelementptr inbounds i32, i32* %buf, i64 %out
  store i32 %lval.store, i32* %optr.L, align 4
  %left.next = add i64 %left, 1
  %out.next = add i64 %out, 1
  br label %merge_loop

take_right:
  %rptr.store = getelementptr inbounds i32, i32* %src, i64 %right
  %rval.store = load i32, i32* %rptr.store, align 4
  %optr.R = getelementptr inbounds i32, i32* %buf, i64 %out
  store i32 %rval.store, i32* %optr.R, align 4
  %right.next = add i64 %right, 1
  %out.next2 = add i64 %out, 1
  br label %merge_loop

after_inner:
  %i.next = add i64 %i, %two_w
  br label %outer_body

after_outer_body:
  %src.next = bitcast i32* %buf to i32*
  %buf.next = bitcast i32* %src to i32*
  %width.next = shl i64 %width, 1
  br label %outer

after_outer:
  %src.eq.dest = icmp eq i32* %src, %dest
  br i1 %src.eq.dest, label %free_block, label %do_memcpy

do_memcpy:
  %cpy.bytes = shl i64 %n, 2
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src to i8*
  %ignored = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %cpy.bytes)
  br label %free_block

free_block:
  call void @free(i8* %tmp.raw)
  br label %ret

ret:
  ret void
}