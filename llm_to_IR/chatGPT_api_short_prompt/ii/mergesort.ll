; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x10C0
; Intent: Bottom-up mergesort of 10 ints [9,1,5,3,7,2,8,6,4,0] using malloc’d buffer, then print ascending. (confidence=0.83). Evidence: iterative merge passes with width doubling; printf loop with “%d ” and newline.
; Preconditions: None
; Postconditions: Prints the sorted sequence followed by newline; returns 0.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
declare dso_local i32 @printf(i8*, ...)
declare dso_local i8* @malloc(i64)
declare dso_local void @free(i8*)
declare dso_local i32 @putchar(i32)

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arrp = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arrp, align 4
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

  %buf.raw = call dso_local i8* @malloc(i64 40)
  %buf.null = icmp eq i8* %buf.raw, null
  br i1 %buf.null, label %print, label %sort.init

sort.init:                                         ; preds = %entry
  %buf = bitcast i8* %buf.raw to i32*
  br label %outer.cond

outer.cond:                                        ; preds = %outer.next, %sort.init
  %width.ph = phi i32 [ 1, %sort.init ], [ %width.next, %outer.next ]
  %src.ph = phi i32* [ %arrp, %sort.init ], [ %src.next, %outer.next ]
  %dst.ph = phi i32* [ %buf, %sort.init ], [ %dst.next, %outer.next ]
  %cmp.width = icmp slt i32 %width.ph, 10
  br i1 %cmp.width, label %outer.body, label %sort.end

outer.body:                                        ; preds = %outer.cond
  br label %inner.cond

inner.cond:                                        ; preds = %inner.next, %outer.body
  %i.ph = phi i32 [ 0, %outer.body ], [ %i.next, %inner.next ]
  %i.lt.n = icmp slt i32 %i.ph, 10
  br i1 %i.lt.n, label %inner.body, label %outer.next

inner.body:                                        ; preds = %inner.cond
  %i.ext = sext i32 %i.ph to i64
  %l = %i.ph
  %l_plus_w = add nsw i32 %l, %width.ph
  %mid = call i32 @llvm.smin.i32(i32 %l_plus_w, i32 10)
  %l_plus_2w = add nsw i32 %l_plus_w, %width.ph
  %r = call i32 @llvm.smin.i32(i32 %l_plus_2w, i32 10)

  br label %merge.cond

merge.cond:                                        ; preds = %merge.body, %inner.body
  %t.ph = phi i32 [ %l, %inner.body ], [ %t.next, %merge.body ]
  %j.ph = phi i32 [ %l, %inner.body ], [ %j.next, %merge.body ]
  %k.ph = phi i32 [ %mid, %inner.body ], [ %k.next, %merge.body ]
  %t.ge.r = icmp sge i32 %t.ph, %r
  br i1 %t.ge.r, label %inner.next, label %merge.choose

merge.choose:                                      ; preds = %merge.cond
  %j.lt.mid = icmp slt i32 %j.ph, %mid
  %k.lt.r = icmp slt i32 %k.ph, %r
  %both = and i1 %j.lt.mid, %k.lt.r
  br i1 %both, label %both.path, label %single.path

both.path:                                         ; preds = %merge.choose
  %j.idx = sext i32 %j.ph to i64
  %k.idx = sext i32 %k.ph to i64
  %sj.ptr = getelementptr inbounds i32, i32* %src.ph, i64 %j.idx
  %sk.ptr = getelementptr inbounds i32, i32* %src.ph, i64 %k.idx
  %vj = load i32, i32* %sj.ptr, align 4
  %vk = load i32, i32* %sk.ptr, align 4
  %take.left = icmp sle i32 %vj, %vk
  br i1 %take.left, label %takeL, label %takeR

single.path:                                       ; preds = %merge.choose
  br i1 %j.lt.mid, label %takeL, label %takeR

takeL:                                             ; preds = %single.path, %both.path
  %j.gidx = sext i32 %j.ph to i64
  %sj.ptr2 = getelementptr inbounds i32, i32* %src.ph, i64 %j.gidx
  %vL = load i32, i32* %sj.ptr2, align 4
  %t.idxL = sext i32 %t.ph to i64
  %dt.ptrL = getelementptr inbounds i32, i32* %dst.ph, i64 %t.idxL
  store i32 %vL, i32* %dt.ptrL, align 4
  %j.nextL = add nsw i32 %j.ph, 1
  %k.nextL = %k.ph
  %t.nextL = add nsw i32 %t.ph, 1
  br label %merge.body

takeR:                                             ; preds = %single.path, %both.path
  %k.gidx = sext i32 %k.ph to i64
  %sk.ptr2 = getelementptr inbounds i32, i32* %src.ph, i64 %k.gidx
  %vR = load i32, i32* %sk.ptr2, align 4
  %t.idxR = sext i32 %t.ph to i64
  %dt.ptrR = getelementptr inbounds i32, i32* %dst.ph, i64 %t.idxR
  store i32 %vR, i32* %dt.ptrR, align 4
  %k.nextR = add nsw i32 %k.ph, 1
  %j.nextR = %j.ph
  %t.nextR = add nsw i32 %t.ph, 1
  br label %merge.body

merge.body:                                        ; preds = %takeR, %takeL
  %j.next = phi i32 [ %j.nextL, %takeL ], [ %j.nextR, %takeR ]
  %k.next = phi i32 [ %k.nextL, %takeL ], [ %k.nextR, %takeR ]
  %t.next = phi i32 [ %t.nextL, %takeL ], [ %t.nextR, %takeR ]
  br label %merge.cond

inner.next:                                        ; preds = %merge.cond
  %i.next = %r
  br label %inner.cond

outer.next:                                        ; preds = %inner.cond
  %width.next = shl i32 %width.ph, 1
  ; swap src and dst for next pass
  %src.next = %dst.ph
  %dst.next = %src.ph
  br label %outer.cond

sort.end:                                          ; preds = %outer.cond
  ; Results reside in %src.ph. Copy back to arr if needed.
  %src.final.eq.arr = icmp eq i32* %src.ph, %arrp
  br i1 %src.final.eq.arr, label %free.and.print, label %copyback

copyback:                                          ; preds = %sort.end
  br label %copy.loop

copy.loop:                                         ; preds = %copy.loop, %copyback
  %ci = phi i32 [ 0, %copyback ], [ %ci.next, %copy.loop ]
  %ci.lt = icmp slt i32 %ci, 10
  br i1 %ci.lt, label %copy.body, label %copy.done

copy.body:                                         ; preds = %copy.loop
  %ci.idx = sext i32 %ci to i64
  %s.ptr = getelementptr inbounds i32, i32* %src.ph, i64 %ci.idx
  %a.ptr = getelementptr inbounds i32, i32* %arrp, i64 %ci.idx
  %v = load i32, i32* %s.ptr, align 4
  store i32 %v, i32* %a.ptr, align 4
  %ci.next = add nsw i32 %ci, 1
  br label %copy.loop

copy.done:                                         ; preds = %copy.loop
  br label %free.and.print

free.and.print:                                    ; preds = %copy.done, %sort.end
  call dso_local void @free(i8* %buf.raw)
  br label %print

print:                                             ; preds = %free.and.print, %entry
  br label %print.loop

print.loop:                                        ; preds = %print.loop, %print
  %pi = phi i32 [ 0, %print ], [ %pi.next, %print.loop ]
  %pi.lt = icmp slt i32 %pi, 10
  br i1 %pi.lt, label %print.body, label %print.done

print.body:                                        ; preds = %print.loop
  %pi.idx = sext i32 %pi to i64
  %pv.ptr = getelementptr inbounds i32, i32* %arrp, i64 %pi.idx
  %pv = load i32, i32* %pv.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call dso_local i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %pv)
  %pi.next = add nsw i32 %pi, 1
  br label %print.loop

print.done:                                        ; preds = %print.loop
  %nl = call dso_local i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @llvm.smin.i32(i32, i32) nounwind readnone willreturn