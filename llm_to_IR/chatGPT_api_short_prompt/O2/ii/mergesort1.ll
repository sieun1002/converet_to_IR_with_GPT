; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x10C0
; Intent: Bottom-up mergesort 10 ints then print them (confidence=0.95). Evidence: malloc(40) + 4 merge passes; iterative run doubling and merge logic; print loop with "%d ".
; Preconditions: None
; Postconditions: Prints ten integers separated by spaces and a trailing newline; returns 0.

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  store [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], [10 x i32]* %arr, align 16
  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %bufi8 = call i8* @malloc(i64 40)
  %bufnull = icmp eq i8* %bufi8, null
  br i1 %bufnull, label %print, label %sort.init

sort.init:                                        ; preds = %entry
  %bufi32 = bitcast i8* %bufi8 to i32*
  br label %pass

pass:                                             ; preds = %pass.end, %sort.init
  %p = phi i32 [ 4, %sort.init ], [ %p.dec, %pass.end ]
  %run = phi i32 [ 1, %sort.init ], [ %run.next, %pass.end ]
  %src = phi i32* [ %arrptr, %sort.init ], [ %src.next, %pass.end ]
  %dst = phi i32* [ %bufi32, %sort.init ], [ %dst.next, %pass.end ]
  br label %inner

inner:                                            ; preds = %inner.end, %pass
  %i = phi i32 [ 0, %pass ], [ %i.next, %inner.end ]
  %i.lt.n = icmp slt i32 %i, 10
  br i1 %i.lt.n, label %do.merge, label %pass.end

do.merge:                                         ; preds = %inner
  %mid.tmp = add nsw i32 %i, %run
  %mid.cmp = icmp slt i32 %mid.tmp, 10
  %mid = select i1 %mid.cmp, i32 %mid.tmp, i32 10
  %tworun = shl i32 %run, 1
  %end.tmp = add nsw i32 %i, %tworun
  %end.cmp = icmp slt i32 %end.tmp, 10
  %end = select i1 %end.cmp, i32 %end.tmp, i32 10
  br label %merge.loop

merge.loop:                                       ; preds = %emitRightOnly, %emitRight, %emitLeft, %do.merge
  %out = phi i32 [ %i, %do.merge ], [ %out.next.L, %emitLeft ], [ %out.next.R, %emitRight ], [ %out.next.RO, %emitRightOnly ]
  %left = phi i32 [ %i, %do.merge ], [ %left.next, %emitLeft ], [ %left.cur, %emitRight ], [ %left.cur2, %emitRightOnly ]
  %right = phi i32 [ %mid, %do.merge ], [ %right.cur, %emitLeft ], [ %right.next, %emitRight ], [ %right.next2, %emitRightOnly ]
  %out.lt.end = icmp slt i32 %out, %end
  br i1 %out.lt.end, label %check.left, label %inner.end

check.left:                                       ; preds = %merge.loop
  %left.lt.mid = icmp slt i32 %left, %mid
  br i1 %left.lt.mid, label %leftAvail, label %emitRightOnly

leftAvail:                                        ; preds = %check.left
  %left.idx64 = sext i32 %left to i64
  %lv.ptr = getelementptr inbounds i32, i32* %src, i64 %left.idx64
  %lv = load i32, i32* %lv.ptr, align 4
  %right.lt.end = icmp slt i32 %right, %end
  br i1 %right.lt.end, label %bothAvail, label %emitLeft

bothAvail:                                        ; preds = %leftAvail
  %right.idx64 = sext i32 %right to i64
  %rv.ptr = getelementptr inbounds i32, i32* %src, i64 %right.idx64
  %rv = load i32, i32* %rv.ptr, align 4
  %rv.lt.lv = icmp slt i32 %rv, %lv
  br i1 %rv.lt.lv, label %emitRight, label %emitLeft

emitLeft:                                         ; preds = %bothAvail, %leftAvail
  %lv.sel = phi i32 [ %lv, %bothAvail ], [ %lv, %leftAvail ]
  %out.idx64.L = sext i32 %out to i64
  %out.ptr.L = getelementptr inbounds i32, i32* %dst, i64 %out.idx64.L
  store i32 %lv.sel, i32* %out.ptr.L, align 4
  %out.next.L = add nsw i32 %out, 1
  %left.next = add nsw i32 %left, 1
  br label %merge.loop

emitRight:                                        ; preds = %bothAvail
  %out.idx64.R = sext i32 %out to i64
  %out.ptr.R = getelementptr inbounds i32, i32* %dst, i64 %out.idx64.R
  store i32 %rv, i32* %out.ptr.R, align 4
  %out.next.R = add nsw i32 %out, 1
  %right.next = add nsw i32 %right, 1
  %left.cur = phi i32 [ %left, %bothAvail ]
  br label %merge.loop

emitRightOnly:                                    ; preds = %check.left
  %right.idx64.ro = sext i32 %right to i64
  %rv.ptr.ro = getelementptr inbounds i32, i32* %src, i64 %right.idx64.ro
  %rv.ro = load i32, i32* %rv.ptr.ro, align 4
  %out.idx64.RO = sext i32 %out to i64
  %out.ptr.RO = getelementptr inbounds i32, i32* %dst, i64 %out.idx64.RO
  store i32 %rv.ro, i32* %out.ptr.RO, align 4
  %out.next.RO = add nsw i32 %out, 1
  %right.next2 = add nsw i32 %right, 1
  %left.cur2 = phi i32 [ %left, %check.left ]
  br label %merge.loop

inner.end:                                        ; preds = %merge.loop
  %i.next = add nsw i32 %i, %tworun
  br label %inner

pass.end:                                         ; preds = %inner
  %run.next = shl i32 %run, 1
  %p.dec = add nsw i32 %p, -1
  %done = icmp eq i32 %p.dec, 0
  %src.next = select i1 %done, i32* %src, i32* %dst
  %dst.next = select i1 %done, i32* %dst, i32* %src
  br i1 %done, label %after, label %pass

after:                                            ; preds = %pass.end
  ; If final destination is not the stack array, copy back
  %dst.ne.arr = icmp ne i32* %dst.next, %arrptr
  br i1 %dst.ne.arr, label %copy.loop, label %after.free

copy.loop:                                        ; preds = %after, %copy.loop
  %k = phi i32 [ 0, %after ], [ %k.next, %copy.loop ]
  %k64 = sext i32 %k to i64
  %src.cp.ptr = getelementptr inbounds i32, i32* %dst.next, i64 %k64
  %val.cp = load i32, i32* %src.cp.ptr, align 4
  %dst.cp.ptr = getelementptr inbounds i32, i32* %arrptr, i64 %k64
  store i32 %val.cp, i32* %dst.cp.ptr, align 4
  %k.next = add nsw i32 %k, 1
  %k.lt = icmp slt i32 %k.next, 10
  br i1 %k.lt, label %copy.loop, label %after.free

after.free:                                       ; preds = %copy.loop, %after
  call void @free(i8* %bufi8)
  br label %print

print:                                            ; preds = %after.free, %entry
  %idx = phi i32 [ 0, %after.free ], [ 0, %entry ]
  br label %print.loop

print.loop:                                       ; preds = %print.loop, %print
  %i.pl = phi i32 [ %idx, %print ], [ %i.next.pl, %print.loop ]
  %i64.pl = sext i32 %i.pl to i64
  %p.elem = getelementptr inbounds i32, i32* %arrptr, i64 %i64.pl
  %val = load i32, i32* %p.elem, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %val)
  %i.next.pl = add nsw i32 %i.pl, 1
  %cont.pl = icmp slt i32 %i.next.pl, 10
  br i1 %cont.pl, label %print.loop, label %print.done

print.done:                                       ; preds = %print.loop
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}