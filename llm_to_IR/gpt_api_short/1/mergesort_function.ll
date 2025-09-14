; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort ; Address: 0x11E9
; Intent: Stable in-place bottom-up mergesort of int32 array (confidence=0.94). Evidence: alloc n*4 temp buffer; iterative run doubling; two-way merge; final memcpy back if needed.
; Preconditions: dest must be valid for reading/writing n int32s when n > 0.
; Postconditions: On success, dest[0..n) is sorted ascending (stable). If malloc fails, array is left unchanged.

; Only the necessary external declarations:
declare i8* @memcpy(i8*, i8*, i64)
declare i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp.le1 = icmp ule i64 %n, 1
  br i1 %cmp.le1, label %ret, label %alloc

alloc:
  %size.bytes = shl i64 %n, 2
  %buf.raw = call i8* @malloc(i64 %size.bytes)
  %isnull = icmp eq i8* %buf.raw, null
  br i1 %isnull, label %ret, label %init

init:
  %buf.i32 = bitcast i8* %buf.raw to i32*
  br label %outer.cond

outer.cond:
  %src.phi = phi i32* [ %dest, %init ], [ %src.next, %outer.swap ]
  %dst.phi = phi i32* [ %buf.i32, %init ], [ %dst.next, %outer.swap ]
  %run = phi i64 [ 1, %init ], [ %run2, %outer.swap ]
  %cmp.run = icmp ult i64 %run, %n
  br i1 %cmp.run, label %outer.body, label %after.outer

outer.body:
  br label %inner.cond

inner.cond:
  %start = phi i64 [ 0, %outer.body ], [ %start.next, %after.merge.segment ]
  %cond.start = icmp ult i64 %start, %n
  br i1 %cond.start, label %segment.init, label %outer.after.inner

segment.init:
  %l0 = add i64 %start, 0
  %start.plus.run = add i64 %start, %run
  %t0 = icmp ult i64 %start.plus.run, %n
  %mid = select i1 %t0, i64 %start.plus.run, i64 %n
  %r0 = add i64 %mid, 0
  %tworun = add i64 %run, %run
  %start.plus.2run = add i64 %start, %tworun
  %t1 = icmp ult i64 %start.plus.2run, %n
  %end = select i1 %t1, i64 %start.plus.2run, i64 %n
  %out0 = add i64 %start, 0
  br label %merge.loop

merge.loop:
  %l = phi i64 [ %l0, %segment.init ], [ %l.next, %take.left ], [ %l2, %take.right ]
  %r = phi i64 [ %r0, %segment.init ], [ %r1, %take.left ], [ %r.next, %take.right ]
  %out = phi i64 [ %out0, %segment.init ], [ %out.next, %take.left ], [ %out.next2, %take.right ]
  %more = icmp ult i64 %out, %end
  br i1 %more, label %decide, label %after.merge.segment

decide:
  %l.lt.mid = icmp ult i64 %l, %mid
  br i1 %l.lt.mid, label %check.right, label %pick.right

check.right:
  %r.lt.end = icmp ult i64 %r, %end
  br i1 %r.lt.end, label %compare, label %pick.left

compare:
  %lptr = getelementptr inbounds i32, i32* %src.phi, i64 %l
  %lv = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %src.phi, i64 %r
  %rv = load i32, i32* %rptr, align 4
  %le = icmp sle i32 %lv, %rv
  br i1 %le, label %pick.left, label %pick.right

pick.left:
  %lptr1 = getelementptr inbounds i32, i32* %src.phi, i64 %l
  %valL = load i32, i32* %lptr1, align 4
  %outptr = getelementptr inbounds i32, i32* %dst.phi, i64 %out
  store i32 %valL, i32* %outptr, align 4
  %l.next = add i64 %l, 1
  %out.next = add i64 %out, 1
  br label %take.left

take.left:
  %r1 = add i64 %r, 0
  br label %merge.loop

pick.right:
  %rptr1 = getelementptr inbounds i32, i32* %src.phi, i64 %r
  %valR = load i32, i32* %rptr1, align 4
  %outptr2 = getelementptr inbounds i32, i32* %dst.phi, i64 %out
  store i32 %valR, i32* %outptr2, align 4
  %r.next = add i64 %r, 1
  %out.next2 = add i64 %out, 1
  %l2 = add i64 %l, 0
  br label %take.right

take.right:
  br label %merge.loop

after.merge.segment:
  %start.next = add i64 %start, %tworun
  br label %inner.cond

outer.after.inner:
  br label %outer.swap

outer.swap:
  %src.next = add i32* %dst.phi, 0
  %dst.next = add i32* %src.phi, 0
  %run2 = shl i64 %run, 1
  br label %outer.cond

after.outer:
  %src.final = phi i32* [ %src.phi, %outer.cond ]
  %neq = icmp ne i32* %src.final, %dest
  br i1 %neq, label %do.memcpy, label %after.copy

do.memcpy:
  %bytes = shl i64 %n, 2
  %dest8 = bitcast i32* %dest to i8*
  %src8 = bitcast i32* %src.final to i8*
  %callmc = call i8* @memcpy(i8* %dest8, i8* %src8, i64 %bytes)
  br label %after.copy

after.copy:
  call void @free(i8* %buf.raw)
  br label %ret

ret:
  ret void
}