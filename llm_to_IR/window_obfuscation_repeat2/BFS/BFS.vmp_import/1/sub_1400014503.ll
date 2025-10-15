; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002C90(i64)

define dso_local void @sub_140001450(i32* %arg0, i64 %arg8, i64 %arg10, i32* %arg18, i64* %arg20, i64* %arg28) local_unnamed_addr {
entry:
  %cmp0 = icmp eq i64 %arg8, 0
  %cmp1 = icmp uge i64 %arg10, %arg8
  %or.cond = or i1 %cmp0, %cmp1
  br i1 %or.cond, label %early_zero, label %init_loop

early_zero:
  store i64 0, i64* %arg28, align 8
  ret void

init_loop:
  br label %loop_set

loop_set:                                          ; preds = %loop_set.body, %init_loop
  %i = phi i64 [ 0, %init_loop ], [ %i.next, %loop_set.body ]
  %cmpi = icmp ult i64 %i, %arg8
  br i1 %cmpi, label %loop_set.body, label %post_init

loop_set.body:
  %gepvis = getelementptr inbounds i32, i32* %arg18, i64 %i
  store i32 -1, i32* %gepvis, align 4
  %i.next = add i64 %i, 1
  br label %loop_set

post_init:
  %sizeb = shl i64 %arg8, 3
  %raw = call i8* @sub_140002C90(i64 %sizeb)
  %queue = bitcast i8* %raw to i64*
  %isnull = icmp eq i64* %queue, null
  br i1 %isnull, label %alloc_fail, label %alloc_ok

alloc_fail:
  store i64 0, i64* %arg28, align 8
  ret void

alloc_ok:
  %gepstart = getelementptr inbounds i32, i32* %arg18, i64 %arg10
  store i32 0, i32* %gepstart, align 4
  %queue.slot0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %arg10, i64* %queue.slot0, align 8
  store i64 0, i64* %arg28, align 8
  br label %outer_cond

outer_cond:                                        ; preds = %outer_cont, %alloc_ok
  %head = phi i64 [ 0, %alloc_ok ], [ %head.next, %outer_cont ]
  %tail = phi i64 [ 1, %alloc_ok ], [ %tail.after, %outer_cont ]
  %cmp.ht = icmp ult i64 %head, %tail
  br i1 %cmp.ht, label %outer_body, label %done

outer_body:
  %curr.ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %curr = load i64, i64* %curr.ptr, align 8
  %head.next = add i64 %head, 1
  %cnt.old = load i64, i64* %arg28, align 8
  %cnt.new = add i64 %cnt.old, 1
  store i64 %cnt.new, i64* %arg28, align 8
  %out.slot = getelementptr inbounds i64, i64* %arg20, i64 %cnt.old
  store i64 %curr, i64* %out.slot, align 8
  br label %inner_cond

inner_cond:                                        ; preds = %inner_update_tail_or_not, %outer_body
  %j = phi i64 [ 0, %outer_body ], [ %j.next, %inner_update_tail_or_not ]
  %tail.in = phi i64 [ %tail, %outer_body ], [ %tail.out, %inner_update_tail_or_not ]
  %cond.j = icmp ult i64 %j, %arg8
  br i1 %cond.j, label %inner_body, label %outer_cont

inner_body:
  %mul = mul i64 %curr, %arg8
  %idx = add i64 %mul, %j
  %mat.ptr = getelementptr inbounds i32, i32* %arg0, i64 %idx
  %cell = load i32, i32* %mat.ptr, align 4
  %is.zero = icmp eq i32 %cell, 0
  br i1 %is.zero, label %inner_skip, label %check_visited

check_visited:
  %vis.j.ptr = getelementptr inbounds i32, i32* %arg18, i64 %j
  %vis.j = load i32, i32* %vis.j.ptr, align 4
  %is.minus1 = icmp eq i32 %vis.j, -1
  br i1 %is.minus1, label %enqueue, label %inner_skip

enqueue:
  %vis.curr.ptr = getelementptr inbounds i32, i32* %arg18, i64 %curr
  %vis.curr = load i32, i32* %vis.curr.ptr, align 4
  %vis.new = add i32 %vis.curr, 1
  store i32 %vis.new, i32* %vis.j.ptr, align 4
  %queue.slot = getelementptr inbounds i64, i64* %queue, i64 %tail.in
  store i64 %j, i64* %queue.slot, align 8
  %tail.inc = add i64 %tail.in, 1
  br label %inner_update_tail_or_not

inner_skip:
  br label %inner_update_tail_or_not

inner_update_tail_or_not:
  %tail.out = phi i64 [ %tail.inc, %enqueue ], [ %tail.in, %inner_skip ]
  %j.next = add i64 %j, 1
  br label %inner_cond

outer_cont:
  %tail.after = phi i64 [ %tail.in, %inner_cond ]
  br label %outer_cond

done:
  %raw.i8 = bitcast i64* %queue to i8*
  %freefp = bitcast i8* (i64)* @sub_140002C90 to i8* (i8*)*
  %ignored = call i8* %freefp(i8* %raw.i8)
  ret void
}