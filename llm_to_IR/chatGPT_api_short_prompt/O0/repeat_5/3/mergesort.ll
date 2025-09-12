; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort ; Address: 0x11E9
; Intent: Bottom-up stable merge sort for 32-bit integers (confidence=0.93). Evidence: iterative merging with step doubling; temporary buffer via malloc and final memcpy.
; Preconditions: dest points to at least n 32-bit signed integers; if n <= 1, returns immediately.
; Postconditions: If allocation succeeds, dest is sorted in nondecreasing signed order; on malloc failure, dest is left unchanged.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp.le1 = icmp ule i64 %n, 1
  br i1 %cmp.le1, label %ret, label %alloc

alloc:                                             ; n > 1
  %bytes = shl i64 %n, 2
  %tmpraw = call noalias i8* @malloc(i64 %bytes)
  %tmp = bitcast i8* %tmpraw to i32*
  %ok = icmp ne i32* %tmp, null
  br i1 %ok, label %init, label %ret

init:
  br label %outer

outer:                                             ; outer pass loop
  %src.phi = phi i32* [ %dest, %init ], [ %buf.next, %after_inner ]
  %buf.phi = phi i32* [ %tmp, %init ],   [ %src.next, %after_inner ]
  %step.phi = phi i64 [ 1, %init ], [ %step.next, %after_inner ]
  %cond.outer = icmp ult i64 %step.phi, %n
  br i1 %cond.outer, label %for.preheader, label %outer_end

for.preheader:
  %step2 = shl i64 %step.phi, 1
  br label %for.cond

for.cond:
  %i.phi = phi i64 [ 0, %for.preheader ], [ %i.next, %after_merge ]
  %i.lt.n = icmp ult i64 %i.phi, %n
  br i1 %i.lt.n, label %merge.setup, label %after_inner

merge.setup:
  %left.init = %i.phi
  %mid.tmp = add i64 %i.phi, %step.phi
  %mid = select i1 (icmp ult i64 %mid.tmp, %n), i64 %mid.tmp, i64 %n
  %end.tmp = add i64 %i.phi, %step2
  %end = select i1 (icmp ult i64 %end.tmp, %n), i64 %end.tmp, i64 %n
  %right.init = %mid
  %out.init = %i.phi
  br label %inner.cond

inner.cond:
  %left.phi = phi i64 [ %left.init, %merge.setup ], [ %left.next, %inner.next ]
  %right.phi = phi i64 [ %right.init, %merge.setup ], [ %right.next, %inner.next ]
  %out.phi = phi i64 [ %out.init, %merge.setup ], [ %out.next, %inner.next ]
  %more = icmp ult i64 %out.phi, %end
  br i1 %more, label %avail.check, label %after_merge

avail.check:
  %leftAvail = icmp ult i64 %left.phi, %mid
  %rightAvail = icmp ult i64 %right.phi, %end
  br i1 %leftAvail, label %lA.true, label %choose_right

lA.true:
  br i1 %rightAvail, label %bothAvail, label %choose_left

bothAvail:
  %pL = getelementptr inbounds i32, i32* %src.phi, i64 %left.phi
  %vL = load i32, i32* %pL, align 4
  %pR = getelementptr inbounds i32, i32* %src.phi, i64 %right.phi
  %vR = load i32, i32* %pR, align 4
  %leftGreater = icmp sgt i32 %vL, %vR
  br i1 %leftGreater, label %choose_right, label %choose_left

choose_left:
  %pL2 = getelementptr inbounds i32, i32* %src.phi, i64 %left.phi
  %valL = load i32, i32* %pL2, align 4
  %pOutL = getelementptr inbounds i32, i32* %buf.phi, i64 %out.phi
  store i32 %valL, i32* %pOutL, align 4
  %left.inc = add i64 %left.phi, 1
  %out.incL = add i64 %out.phi, 1
  br label %inner.next

choose_right:
  %pR2 = getelementptr inbounds i32, i32* %src.phi, i64 %right.phi
  %valR = load i32, i32* %pR2, align 4
  %pOutR = getelementptr inbounds i32, i32* %buf.phi, i64 %out.phi
  store i32 %valR, i32* %pOutR, align 4
  %right.inc = add i64 %right.phi, 1
  %out.incR = add i64 %out.phi, 1
  br label %inner.next

inner.next:
  %left.next = phi i64 [ %left.inc, %choose_left ], [ %left.phi, %choose_right ]
  %right.next = phi i64 [ %right.phi, %choose_left ], [ %right.inc, %choose_right ]
  %out.next = phi i64 [ %out.incL, %choose_left ], [ %out.incR, %choose_right ]
  br label %inner.cond

after_merge:
  %i.next = add i64 %i.phi, %step2
  br label %for.cond

after_inner:
  ; swap src and buf; step <<= 1
  %src.next = %buf.phi
  %buf.next = %src.phi
  %step.next = shl i64 %step.phi, 1
  br label %outer

outer_end:
  %src.final = %src.phi
  %same = icmp eq i32* %src.final, %dest
  br i1 %same, label %do_free, label %do_copy

do_copy:
  %dst8 = bitcast i32* %dest to i8*
  %src8 = bitcast i32* %src.final to i8*
  call i8* @memcpy(i8* %dst8, i8* %src8, i64 %bytes)
  br label %do_free

do_free:
  call void @free(i8* %tmpraw)
  br label %ret

ret:
  ret void
}