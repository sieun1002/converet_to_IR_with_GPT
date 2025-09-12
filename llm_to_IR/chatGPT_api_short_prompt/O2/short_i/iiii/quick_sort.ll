; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x10C0
; Intent: Iterative mergesort of 10 integers then print them (confidence=0.95). Evidence: malloc(0x28), double run-width loop, merge with min bounds and __printf_chk "%d ".
; Preconditions: None
; Postconditions: Prints 10 integers in ascending order and returns 0

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.i32 = bitcast [10 x i32]* %arr to i32*
  ; initialize: 9,1,5,3,7,2,8,6,4,0
  store i32 9, i32* %arr.i32, align 16
  %idx1 = getelementptr inbounds i32, i32* %arr.i32, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %arr.i32, i64 2
  store i32 5, i32* %idx2, align 8
  %idx3 = getelementptr inbounds i32, i32* %arr.i32, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %arr.i32, i64 4
  store i32 7, i32* %idx4, align 16
  %idx5 = getelementptr inbounds i32, i32* %arr.i32, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %arr.i32, i64 6
  store i32 8, i32* %idx6, align 8
  %idx7 = getelementptr inbounds i32, i32* %arr.i32, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %arr.i32, i64 8
  store i32 4, i32* %idx8, align 16
  %idx9 = getelementptr inbounds i32, i32* %arr.i32, i64 9
  store i32 0, i32* %idx9, align 4

  %tmp.raw = call i8* @malloc(i64 40)
  %tmp.isnull = icmp eq i8* %tmp.raw, null
  br i1 %tmp.isnull, label %print, label %sort.init

sort.init:                                        ; preds = %entry
  %tmp = bitcast i8* %tmp.raw to i32*
  ; src and dst buffers
  %src = alloca i32*, align 8
  %dst = alloca i32*, align 8
  %width = alloca i32, align 4
  store i32* %arr.i32, i32** %src, align 8
  store i32* %tmp, i32** %dst, align 8
  store i32 1, i32* %width, align 4
  br label %outer.cond

outer.cond:                                       ; preds = %outer.end, %sort.init
  %w = load i32, i32* %width, align 4
  %w.lt.n = icmp slt i32 %w, 10
  br i1 %w.lt.n, label %pass.begin, label %after.sort

pass.begin:                                       ; preds = %outer.cond
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  %src.p = load i32*, i32** %src, align 8
  %dst.p = load i32*, i32** %dst, align 8
  br label %inner.cond

inner.cond:                                       ; preds = %inner.end, %pass.begin
  %i.val = load i32, i32* %i, align 4
  %i.lt.n = icmp slt i32 %i.val, 10
  br i1 %i.lt.n, label %block.start, label %outer.end

block.start:                                      ; preds = %inner.cond
  ; l = i, m = min(i+w, n), r = min(i+2w, n)
  %w.cur = load i32, i32* %width, align 4
  %m.cand = add nsw i32 %i.val, %w.cur
  %m = call i32 @llvm.smin.i32(i32 %m.cand, i32 10)
  %tw = shl i32 %w.cur, 1
  %r.cand = add nsw i32 %i.val, %tw
  %r = call i32 @llvm.smin.i32(i32 %r.cand, i32 10)
  ; k = l, j = m, t = l
  %k = alloca i32, align 4
  %j = alloca i32, align 4
  %t = alloca i32, align 4
  store i32 %i.val, i32* %k, align 4
  store i32 %m, i32* %j, align 4
  store i32 %i.val, i32* %t, align 4
  br label %merge.cond

merge.cond:                                       ; preds = %take.right, %take.left, %take.from.rightonly, %take.from.leftonly, %block.start
  %t.val = load i32, i32* %t, align 4
  %t.lt.r = icmp slt i32 %t.val, %r
  br i1 %t.lt.r, label %check.left, label %merge.done

check.left:                                       ; preds = %merge.cond
  %k.val = load i32, i32* %k, align 4
  %left.avail = icmp slt i32 %k.val, %m
  br i1 %left.avail, label %check.right, label %right.only

check.right:                                      ; preds = %check.left
  %j.val = load i32, i32* %j, align 4
  %right.avail = icmp slt i32 %j.val, %r
  br i1 %right.avail, label %compare.both, label %left.only

left.only:                                        ; preds = %check.right
  ; take left[k]
  %k.idx64.lo = sext i32 %k.val to i64
  %lv.ptr = getelementptr inbounds i32, i32* %src.p, i64 %k.idx64.lo
  %lv = load i32, i32* %lv.ptr, align 4
  %t.idx64.lo = sext i32 %t.val to i64
  %dv.ptr.lo = getelementptr inbounds i32, i32* %dst.p, i64 %t.idx64.lo
  store i32 %lv, i32* %dv.ptr.lo, align 4
  %k.next = add nsw i32 %k.val, 1
  store i32 %k.next, i32* %k, align 4
  br label %take.left

right.only:                                       ; preds = %check.left
  ; take right[j]
  %j.idx64.ro = sext i32 %j.val to i64
  %rv.ptr.ro = getelementptr inbounds i32, i32* %src.p, i64 %j.idx64.ro
  %rv.ro = load i32, i32* %rv.ptr.ro, align 4
  %t.idx64.ro = sext i32 %t.val to i64
  %dv.ptr.ro = getelementptr inbounds i32, i32* %dst.p, i64 %t.idx64.ro
  store i32 %rv.ro, i32* %dv.ptr.ro, align 4
  %j.next.ro = add nsw i32 %j.val, 1
  store i32 %j.next.ro, i32* %j, align 4
  br label %take.from.rightonly

compare.both:                                     ; preds = %check.right
  ; load both and compare: if right < left take right else take left
  %k.idx64.cb = sext i32 %k.val to i64
  %lv.ptr.cb = getelementptr inbounds i32, i32* %src.p, i64 %k.idx64.cb
  %lv.cb = load i32, i32* %lv.ptr.cb, align 4
  %j.idx64.cb = sext i32 %j.val to i64
  %rv.ptr.cb = getelementptr inbounds i32, i32* %src.p, i64 %j.idx64.cb
  %rv.cb = load i32, i32* %rv.ptr.cb, align 4
  %right.lt.left = icmp slt i32 %rv.cb, %lv.cb
  br i1 %right.lt.left, label %take.right, label %take.left

take.left:                                        ; preds = %left.only, %compare.both
  ; write left value (already in %lv.*)
  ; if coming from compare, %lv.cb is valid; if from left.only, %lv was written already
  ; unify value
  %lv.sel = phi i32 [ %lv.cb, %compare.both ], [ %lv, %left.only ]
  %t.now.l = load i32, i32* %t, align 4
  %t.idx64.l = sext i32 %t.now.l to i64
  %dv.ptr.l = getelementptr inbounds i32, i32* %dst.p, i64 %t.idx64.l
  store i32 %lv.sel, i32* %dv.ptr.l, align 4
  ; increment k if came from compare; already incremented in left.only path
  %k.now = load i32, i32* %k, align 4
  %k.next2 = select i1 (icmp eq i32 %lv.sel, %lv.cb), i32 (add nsw i32 %k.now, 1), i32 %k.now
  store i32 %k.next2, i32* %k, align 4
  ; t++
  %t.inc.l = add nsw i32 %t.now.l, 1
  store i32 %t.inc.l, i32* %t, align 4
  br label %merge.cond

take.right:                                       ; preds = %compare.both
  %t.now.r = load i32, i32* %t, align 4
  %t.idx64.r = sext i32 %t.now.r to i64
  %dv.ptr.r = getelementptr inbounds i32, i32* %dst.p, i64 %t.idx64.r
  store i32 %rv.cb, i32* %dv.ptr.r, align 4
  %j.now = load i32, i32* %j, align 4
  %j.next2 = add nsw i32 %j.now, 1
  store i32 %j.next2, i32* %j, align 4
  %t.inc.r = add nsw i32 %t.now.r, 1
  store i32 %t.inc.r, i32* %t, align 4
  br label %merge.cond

take.from.rightonly:                              ; preds = %right.only
  %t.now.ro2 = load i32, i32* %t, align 4
  %t.inc.ro2 = add nsw i32 %t.now.ro2, 1
  store i32 %t.inc.ro2, i32* %t, align 4
  br label %merge.cond

merge.done:                                       ; preds = %merge.cond
  ; i = r
  store i32 %r, i32* %i, align 4
  br label %inner.end

inner.end:                                        ; preds = %merge.done
  br label %inner.cond

outer.end:                                        ; preds = %inner.cond
  ; swap src/dst and double width
  %old.src = load i32*, i32** %src, align 8
  %old.dst = load i32*, i32** %dst, align 8
  store i32* %old.dst, i32** %src, align 8
  store i32* %old.src, i32** %dst, align 8
  %w2 = load i32, i32* %width, align 4
  %w.shl = shl i32 %w2, 1
  store i32 %w.shl, i32* %width, align 4
  br label %outer.cond

after.sort:                                       ; preds = %outer.cond
  ; if final data not in arr, copy back from src to arr
  %final.src = load i32*, i32** %src, align 8
  %in.arr = icmp eq i32* %final.src, %arr.i32
  br i1 %in.arr, label %free.block, label %copyback

copyback:                                         ; preds = %after.sort
  ; copy 10 ints from final.src to arr
  %cb.i = alloca i32, align 4
  store i32 0, i32* %cb.i, align 4
  br label %cb.cond

cb.cond:                                          ; preds = %cb.body, %copyback
  %cb.idx = load i32, i32* %cb.i, align 4
  %cb.more = icmp slt i32 %cb.idx, 10
  br i1 %cb.more, label %cb.body, label %free.block

cb.body:                                          ; preds = %cb.cond
  %idx64.cb = sext i32 %cb.idx to i64
  %src.ptr.cb = getelementptr inbounds i32, i32* %final.src, i64 %idx64.cb
  %val.cb = load i32, i32* %src.ptr.cb, align 4
  %dst.ptr.cb = getelementptr inbounds i32, i32* %arr.i32, i64 %idx64.cb
  store i32 %val.cb, i32* %dst.ptr.cb, align 4
  %cb.next = add nsw i32 %cb.idx, 1
  store i32 %cb.next, i32* %cb.i, align 4
  br label %cb.cond

free.block:                                       ; preds = %cb.cond, %after.sort
  call void @free(i8* %tmp.raw)
  br label %print

print:                                            ; preds = %free.block, %entry
  ; print 10 integers with "%d " then newline
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %pi = alloca i32, align 4
  store i32 0, i32* %pi, align 4
  br label %p.cond

p.cond:                                           ; preds = %p.body, %print
  %pi.val = load i32, i32* %pi, align 4
  %pi.more = icmp slt i32 %pi.val, 10
  br i1 %pi.more, label %p.body, label %p.done

p.body:                                           ; preds = %p.cond
  %p.idx64 = sext i32 %pi.val to i64
  %p.val.ptr = getelementptr inbounds i32, i32* %arr.i32, i64 %p.idx64
  %p.val = load i32, i32* %p.val.ptr, align 4
  %call.print = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %p.val)
  %pi.next = add nsw i32 %pi.val, 1
  store i32 %pi.next, i32* %pi, align 4
  br label %p.cond

p.done:                                           ; preds = %p.cond
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}

; helpers
declare i32 @llvm.smin.i32(i32, i32) nounwind readnone speculatable intrinsic