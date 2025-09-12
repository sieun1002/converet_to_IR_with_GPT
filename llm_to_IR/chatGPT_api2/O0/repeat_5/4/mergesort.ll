; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort  ; Address: 0x11E9
; Intent: Stable ascending merge sort of i32 array using iterative bottom-up merges with temp buffer (confidence=0.95). Evidence: width-doubling outer loop; final memcpy back if src != dest
; Preconditions: dest points to at least n i32 elements; n is the element count (0-based indexing)
; Postconditions: If n <= 1 or allocation fails, dest unchanged. Otherwise, dest is sorted ascending (stable)

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %alloc

alloc:
  %size = mul i64 %n, 4
  %tmpbuf_i8 = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %tmpbuf_i8, null
  br i1 %isnull, label %ret, label %init

init:
  %tmpbuf = bitcast i8* %tmpbuf_i8 to i32*
  br label %outer.cond

outer.cond:
  %width = phi i64 [ 1, %init ], [ %width.next, %after.inner ]
  %src = phi i32* [ %dest, %init ], [ %src.next, %after.inner ]
  %buf = phi i32* [ %tmpbuf, %init ], [ %buf.next, %after.inner ]
  %cond = icmp ult i64 %width, %n
  br i1 %cond, label %outer.body, label %outer.done

outer.body:
  br label %inner.cond

inner.cond:
  %start = phi i64 [ 0, %outer.body ], [ %start.next, %after.merge ]
  %more = icmp ult i64 %start, %n
  br i1 %more, label %merge.setup, label %after.inner

merge.setup:
  %left = add i64 %start, 0
  %t1 = add i64 %start, %width
  %mid.cmp = icmp ult i64 %t1, %n
  %mid = select i1 %mid.cmp, i64 %t1, i64 %n
  %w2 = shl i64 %width, 1
  %t2 = add i64 %start, %w2
  %rend.cmp = icmp ult i64 %t2, %n
  %rend = select i1 %rend.cmp, i64 %t2, i64 %n
  br label %merge.loop.cond

merge.loop.cond:
  %i = phi i64 [ %left, %merge.setup ], [ %i.next, %merge.loop.body.end ]
  %j = phi i64 [ %mid, %merge.setup ], [ %j.next, %merge.loop.body.end ]
  %k = phi i64 [ %left, %merge.setup ], [ %k.next, %merge.loop.body.end ]
  %k.lt.rend = icmp ult i64 %k, %rend
  br i1 %k.lt.rend, label %merge.check_i, label %merge.loop.end

merge.check_i:
  %i.lt.mid = icmp ult i64 %i, %mid
  br i1 %i.lt.mid, label %merge.check_j, label %take_right

merge.check_j:
  %j.lt.rend = icmp ult i64 %j, %rend
  br i1 %j.lt.rend, label %merge.cmp_vals, label %take_left

merge.cmp_vals:
  %i.ptr = getelementptr inbounds i32, i32* %src, i64 %i
  %i.val = load i32, i32* %i.ptr, align 4
  %j.ptr = getelementptr inbounds i32, i32* %src, i64 %j
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.sgt = icmp sgt i32 %i.val, %j.val
  br i1 %cmp.sgt, label %take_right, label %take_left

take_left:
  %src.i.ptr = getelementptr inbounds i32, i32* %src, i64 %i
  %val.left = load i32, i32* %src.i.ptr, align 4
  %buf.k.ptr = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %val.left, i32* %buf.k.ptr, align 4
  %i.next = add i64 %i, 1
  %j.next.left = add i64 %j, 0
  %k.next = add i64 %k, 1
  br label %merge.loop.body.end

take_right:
  %src.j.ptr = getelementptr inbounds i32, i32* %src, i64 %j
  %val.right = load i32, i32* %src.j.ptr, align 4
  %buf.k.ptr1 = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %val.right, i32* %buf.k.ptr1, align 4
  %j.next = add i64 %j, 1
  %i.next.right = add i64 %i, 0
  %k.next1 = add i64 %k, 1
  br label %merge.loop.body.end

merge.loop.body.end:
  %i.next.sel = phi i64 [ %i.next, %take_left ], [ %i.next.right, %take_right ]
  %j.next.sel = phi i64 [ %j.next.left, %take_left ], [ %j.next, %take_right ]
  %k.next.sel = phi i64 [ %k.next, %take_left ], [ %k.next1, %take_right ]
  br label %merge.loop.cond

merge.loop.end:
  %start.next = add i64 %start, %w2
  br label %after.merge

after.merge:
  br label %inner.cond

after.inner:
  ; swap src and buf; double width
  %src.next = %buf
  %buf.next = %src
  %width.next = shl i64 %width, 1
  br label %outer.cond

outer.done:
  %src.final = phi i32* [ %src, %outer.cond ]
  %need_copy = icmp ne i32* %src.final, %dest
  br i1 %need_copy, label %do_copy, label %after_copy

do_copy:
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.final to i8*
  %call.memcpy = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %size)
  br label %after_copy

after_copy:
  call void @free(i8* %tmpbuf_i8)
  br label %ret

ret:
  ret void
}