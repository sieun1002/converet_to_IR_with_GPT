; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort ; Address: 0x11E9
; Intent: Bottom-up stable merge sort of int32 array (confidence=0.92). Evidence: malloc of n*4, iterative width doubling, final memcpy if buffer holds result.
; Preconditions: dest points to at least n 32-bit ints
; Postconditions: If n<=1 or malloc fails: dest unchanged. Else: dest sorted in nondecreasing (signed) order.

; Only the necessary external declarations:
declare noalias i8* @_malloc(i64)
declare void @_free(i8*)
declare i8* @_memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* nocapture %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %alloc

alloc:
  %size.bytes = shl i64 %n, 2
  %buf.raw = call i8* @_malloc(i64 %size.bytes)
  %malloc.null = icmp eq i8* %buf.raw, null
  br i1 %malloc.null, label %ret, label %start

start:
  %buf.i32 = bitcast i8* %buf.raw to i32*
  br label %outer

outer:
  %src.phi = phi i32* [ %dest, %start ], [ %src.next, %post_stage ]
  %tmp.phi = phi i32* [ %buf.i32, %start ], [ %tmp.next, %post_stage ]
  %width = phi i64 [ 1, %start ], [ %width.dbl, %post_stage ]
  %cond.outer = icmp ult i64 %width, %n
  br i1 %cond.outer, label %stage, label %after_loops

stage:
  %twoW = add i64 %width, %width
  br label %chunk_loop

chunk_loop:
  %i = phi i64 [ 0, %stage ], [ %i.next, %chunk_end ]
  %i.cmp = icmp ult i64 %i, %n
  br i1 %i.cmp, label %do_merge, label %stage_done

do_merge:
  %i.plus.w = add i64 %i, %width
  %mid.cmp = icmp ult i64 %i.plus.w, %n
  %mid = select i1 %mid.cmp, i64 %i.plus.w, i64 %n
  %i.plus.2w = add i64 %i, %twoW
  %right.cmp = icmp ult i64 %i.plus.2w, %n
  %right = select i1 %right.cmp, i64 %i.plus.2w, i64 %n
  %l.init = add i64 %i, 0
  %r.init = add i64 %mid, 0
  %k.init = add i64 %i, 0
  br label %merge_loop

merge_loop:
  %l.ph = phi i64 [ %l.init, %do_merge ], [ %l.next, %copy_left ], [ %l.keep, %copy_right ]
  %r.ph = phi i64 [ %r.init, %do_merge ], [ %r.keep, %copy_left ], [ %r.next, %copy_right ]
  %k.ph = phi i64 [ %k.init, %do_merge ], [ %k.next, %copy_left ], [ %k.next2, %copy_right ]
  %k.lt.right = icmp ult i64 %k.ph, %right
  br i1 %k.lt.right, label %choose, label %merge_done

choose:
  %l.cur = add i64 %l.ph, 0
  %r.cur = add i64 %r.ph, 0
  %k.cur = add i64 %k.ph, 0
  %l.ge.mid = icmp uge i64 %l.cur, %mid
  br i1 %l.ge.mid, label %copy_right, label %chk_r

chk_r:
  %r.ge.right = icmp uge i64 %r.cur, %right
  br i1 %r.ge.right, label %copy_left, label %compare

compare:
  %lptr = getelementptr inbounds i32, i32* %src.phi, i64 %l.cur
  %lv = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %src.phi, i64 %r.cur
  %rv = load i32, i32* %rptr, align 4
  %l.le.r = icmp sle i32 %lv, %rv
  br i1 %l.le.r, label %copy_left, label %copy_right

copy_left:
  %lptr.w = getelementptr inbounds i32, i32* %src.phi, i64 %l.cur
  %valL = load i32, i32* %lptr.w, align 4
  %tptr.w = getelementptr inbounds i32, i32* %tmp.phi, i64 %k.cur
  store i32 %valL, i32* %tptr.w, align 4
  %l.next = add i64 %l.cur, 1
  %k.next = add i64 %k.cur, 1
  %r.keep = add i64 %r.cur, 0
  br label %merge_loop

copy_right:
  %rptr.w = getelementptr inbounds i32, i32* %src.phi, i64 %r.cur
  %valR = load i32, i32* %rptr.w, align 4
  %tptr.w2 = getelementptr inbounds i32, i32* %tmp.phi, i64 %k.cur
  store i32 %valR, i32* %tptr.w2, align 4
  %r.next = add i64 %r.cur, 1
  %k.next2 = add i64 %k.cur, 1
  %l.keep = add i64 %l.cur, 0
  br label %merge_loop

merge_done:
  br label %chunk_end

chunk_end:
  %i.next = add i64 %i, %twoW
  br label %chunk_loop

stage_done:
  %src.next = add i32* %tmp.phi, 0
  %tmp.next = add i32* %src.phi, 0
  %width.dbl = shl i64 %width, 1
  br label %outer

after_loops:
  %src.final = add i32* %src.phi, 0
  %src.ne.dest = icmp ne i32* %src.final, %dest
  br i1 %src.ne.dest, label %do_copy_back, label %freebuf

do_copy_back:
  %bytes.final = shl i64 %n, 2
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.final to i8*
  %memcpy.call = call i8* @_memcpy(i8* %dest.i8, i8* %src.i8, i64 %bytes.final)
  br label %freebuf

freebuf:
  call void @_free(i8* %buf.raw)
  br label %ret

ret:
  ret void
}