; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10C0
; Intent: Iterative merge sort of 10 fixed integers and print them (confidence=0.95). Evidence: malloc(40) temp buffer, width-doubling merge loops, prints "%d ".
; Preconditions: None
; Postconditions: Prints ten integers separated by spaces followed by newline; returns 0.

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.strnl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Only the needed extern declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arrp = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  ; Initialize the array: [9,1,5,3,7,2,8,6,4,0]
  %p0 = getelementptr inbounds i32, i32* %arrp, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %arrp, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arrp, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arrp, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arrp, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arrp, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arrp, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arrp, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arrp, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arrp, i64 9
  store i32 0, i32* %p9, align 4

  %bufraw = call noalias i8* @malloc(i64 40)
  %ok = icmp ne i8* %bufraw, null
  br i1 %ok, label %sort.init, label %print.init

sort.init:
  %buf = bitcast i8* %bufraw to i32*
  br label %outer

outer:
  %src = phi i32* [ %arrp, %sort.init ], [ %dst.next, %afterPass ]
  %dst = phi i32* [ %buf, %sort.init ], [ %src.next, %afterPass ]
  %width = phi i32 [ 1, %sort.init ], [ %width.next, %afterPass ]
  %width_ge_n = icmp sge i32 %width, 10
  br i1 %width_ge_n, label %afterSort, label %mergePass.init

mergePass.init:
  br label %mergeLoop

mergeLoop:
  %base = phi i32 [ 0, %mergePass.init ], [ %base.next, %afterMergeOne ]
  %base_ge_n = icmp sge i32 %base, 10
  br i1 %base_ge_n, label %afterPass, label %computeBounds

computeBounds:
  %left_end_tmp = add nsw i32 %base, %width
  %left_end_cmp = icmp slt i32 %left_end_tmp, 10
  %left_end = select i1 %left_end_cmp, i32 %left_end_tmp, i32 10
  %right_end_tmp = add nsw i32 %left_end_tmp, %width
  %right_end_cmp = icmp slt i32 %right_end_tmp, 10
  %right_end = select i1 %right_end_cmp, i32 %right_end_tmp, i32 10
  br label %mergeWhileMain

mergeWhileMain:
  %l = phi i32 [ %base, %computeBounds ], [ %l.next, %chooseLeft ], [ %l.next2, %copyLeft.loop ], [ %l, %copyRight.loop ]
  %r = phi i32 [ %left_end, %computeBounds ], [ %r, %chooseLeft ], [ %r, %copyLeft.loop ], [ %r.next2, %copyRight.loop ]
  %out = phi i32 [ %base, %computeBounds ], [ %out.next, %chooseLeft ], [ %out.nextL, %copyLeft.loop ], [ %out.nextR, %copyRight.loop ]
  %hasL = icmp slt i32 %l, %left_end
  %hasR = icmp slt i32 %r, %right_end
  %both = and i1 %hasL, %hasR
  br i1 %both, label %choose, label %remainder

choose:
  %l.z = sext i32 %l to i64
  %r.z = sext i32 %r to i64
  %out.z = sext i32 %out to i64
  %lp = getelementptr inbounds i32, i32* %src, i64 %l.z
  %rp = getelementptr inbounds i32, i32* %src, i64 %r.z
  %op = getelementptr inbounds i32, i32* %dst, i64 %out.z
  %a = load i32, i32* %lp, align 4
  %b = load i32, i32* %rp, align 4
  %b_lt_a = icmp slt i32 %b, %a
  br i1 %b_lt_a, label %chooseRight, label %chooseLeft

chooseLeft:
  %l.next = add nsw i32 %l, 1
  %out.z.cl = sext i32 %out to i64
  %op.cl = getelementptr inbounds i32, i32* %dst, i64 %out.z.cl
  store i32 %a, i32* %op.cl, align 4
  %out.next = add nsw i32 %out, 1
  br label %mergeWhileMain

chooseRight:
  %r.next = add nsw i32 %r, 1
  %out.z.cr = sext i32 %out to i64
  %op.cr = getelementptr inbounds i32, i32* %dst, i64 %out.z.cr
  store i32 %b, i32* %op.cr, align 4
  %out.next.r = add nsw i32 %out, 1
  ; rename for phis
  br label %copyRight.enter

copyRight.enter:
  ; Continue main loop from right-choice path
  ; Map to %mergeWhileMain phis
  %l.keep = %l
  %r.keep = %r.next
  %out.keep = %out.next.r
  br label %mergeWhileMain

remainder:
  br i1 %hasL, label %copyLeft.loop, label %remainderR

copyLeft.loop:
  %l.cl = phi i32 [ %l, %remainder ], [ %l.next2, %copyLeft.loop ]
  %out.cl = phi i32 [ %out, %remainder ], [ %out.nextL, %copyLeft.loop ]
  %condL = icmp slt i32 %l.cl, %left_end
  br i1 %condL, label %doCopyLeft, label %afterMergeOne

doCopyLeft:
  %l.cl.z = sext i32 %l.cl to i64
  %out.cl.z = sext i32 %out.cl to i64
  %lp.cl = getelementptr inbounds i32, i32* %src, i64 %l.cl.z
  %op.cl = getelementptr inbounds i32, i32* %dst, i64 %out.cl.z
  %valL = load i32, i32* %lp.cl, align 4
  store i32 %valL, i32* %op.cl, align 4
  %l.next2 = add nsw i32 %l.cl, 1
  %out.nextL = add nsw i32 %out.cl, 1
  br label %copyLeft.loop

remainderR:
  br i1 %hasR, label %copyRight.loop, label %afterMergeOne

copyRight.loop:
  %r.cr = phi i32 [ %r, %remainderR ], [ %r.next2, %copyRight.loop ]
  %out.cr = phi i32 [ %out, %remainderR ], [ %out.nextR, %copyRight.loop ]
  %condR = icmp slt i32 %r.cr, %right_end
  br i1 %condR, label %doCopyRight, label %afterMergeOne

doCopyRight:
  %r.cr.z = sext i32 %r.cr to i64
  %out.cr.z = sext i32 %out.cr to i64
  %rp.cr = getelementptr inbounds i32, i32* %src, i64 %r.cr.z
  %op.cr2 = getelementptr inbounds i32, i32* %dst, i64 %out.cr.z
  %valR = load i32, i32* %rp.cr, align 4
  store i32 %valR, i32* %op.cr2, align 4
  %r.next2 = add nsw i32 %r.cr, 1
  %out.nextR = add nsw i32 %out.cr, 1
  br label %copyRight.loop

afterMergeOne:
  %tw = shl i32 %width, 1
  %base.next = add nsw i32 %base, %tw
  br label %mergeLoop

afterPass:
  ; swap src/dst, double width
  %src.next = %dst
  %dst.next = %src
  %width.next = shl i32 %width, 1
  br label %outer

afterSort:
  ; If result not in original array, copy back 10 ints
  %needCopy = icmp ne i32* %src, %arrp
  br i1 %needCopy, label %copyBack.loop, label %afterCopy

copyBack.loop:
  %i.cb = phi i32 [ 0, %afterSort ], [ %i.next.cb, %copyBack.loop ]
  %done.cb = icmp sge i32 %i.cb, 10
  br i1 %done.cb, label %afterCopy, label %doCopyBack

doCopyBack:
  %i.cb.z = sext i32 %i.cb to i64
  %sp.cb = getelementptr inbounds i32, i32* %src, i64 %i.cb.z
  %dp.cb = getelementptr inbounds i32, i32* %arrp, i64 %i.cb.z
  %v.cb = load i32, i32* %sp.cb, align 4
  store i32 %v.cb, i32* %dp.cb, align 4
  %i.next.cb = add nsw i32 %i.cb, 1
  br label %copyBack.loop

afterCopy:
  call void @free(i8* %bufraw)
  br label %print.init

print.init:
  ; Print the array
  br label %print.loop

print.loop:
  %i.pr = phi i32 [ 0, %print.init ], [ %i.next.pr, %print.loop.body ]
  %done.pr = icmp sge i32 %i.pr, 10
  br i1 %done.pr, label %print.nl, label %print.loop.body

print.loop.body:
  %i.pr.z = sext i32 %i.pr to i64
  %pp = getelementptr inbounds i32, i32* %arrp, i64 %i.pr.z
  %val = load i32, i32* %pp, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt, i32 %val)
  %i.next.pr = add nsw i32 %i.pr, 1
  br label %print.loop

print.nl:
  %nl = getelementptr inbounds [2 x i8], [2 x i8]* @.strnl, i64 0, i64 0
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl)
  ret i32 0
}