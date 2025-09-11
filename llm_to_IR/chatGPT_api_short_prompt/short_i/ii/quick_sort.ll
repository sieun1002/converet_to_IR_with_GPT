; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x10c0
; Intent: sort and print a fixed array using iterative mergesort (confidence=0.86). Evidence: iterative merge passes (run doubling, buffer swap), printing "%d " then newline.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr
declare i32 @__printf_chk(i32, i8*, ...) local_unnamed_addr

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %arr.p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  %arr.p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  %arr.p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  %arr.p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  %arr.p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  %arr.p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  %arr.p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  %arr.p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  %arr.p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 9,  i32* %arr.p0, align 4
  store i32 1,  i32* %arr.p1, align 4
  store i32 5,  i32* %arr.p2, align 4
  store i32 3,  i32* %arr.p3, align 4
  store i32 7,  i32* %arr.p4, align 4
  store i32 2,  i32* %arr.p5, align 4
  store i32 8,  i32* %arr.p6, align 4
  store i32 6,  i32* %arr.p7, align 4
  store i32 4,  i32* %arr.p8, align 4
  store i32 0,  i32* %arr.p9, align 4
  %m = call i8* @malloc(i64 40)
  %isnull = icmp eq i8* %m, null
  br i1 %isnull, label %after.sort, label %sort

sort:                                             ; preds = %entry
  %heap.i32 = bitcast i8* %m to i32*
  br label %outer

outer:                                            ; preds = %after.pass, %sort
  %src = phi i32* [ %arr.p0, %sort ], [ %next.src, %after.pass ]
  %dest = phi i32* [ %heap.i32, %sort ], [ %next.dest, %after.pass ]
  %run = phi i32 [ 1, %sort ], [ %run2, %after.pass ]
  %pc = phi i32 [ 0, %sort ], [ %pc2, %after.pass ]
  br label %base.loop

base.loop:                                        ; preds = %after.merge.segment, %outer
  %base = phi i32 [ 0, %outer ], [ %base.next, %after.merge.segment ]
  %base.ge.n = icmp sge i32 %base, 10
  br i1 %base.ge.n, label %finish.pass, label %compute.bounds

compute.bounds:                                   ; preds = %base.loop
  %left = add nsw i32 %base, 0
  %t0 = add nsw i32 %base, %run
  %left.end.sel = icmp slt i32 %t0, 10
  %left.end = select i1 %left.end.sel, i32 %t0, i32 10
  %right = add nsw i32 %left.end, 0
  %t1 = add nsw i32 %right, %run
  %right.end.sel = icmp slt i32 %t1, 10
  %right.end = select i1 %right.end.sel, i32 %t1, i32 10
  br label %merge.loop

merge.loop:                                       ; preds = %choose.right, %choose.left, %compute.bounds
  %i = phi i32 [ %left, %compute.bounds ], [ %i.next, %choose.left ], [ %i, %choose.right ]
  %j = phi i32 [ %right, %compute.bounds ], [ %j, %choose.left ], [ %j.next, %choose.right ]
  %k = phi i32 [ %left, %compute.bounds ], [ %k.next, %choose.left ], [ %k.next, %choose.right ]
  %k.lt.re = icmp slt i32 %k, %right.end
  br i1 %k.lt.re, label %have.work, label %after.merge.segment

have.work:                                        ; preds = %merge.loop
  %i.lt.le = icmp slt i32 %i, %left.end
  %j.lt.re = icmp slt i32 %j, %right.end
  %need.left = and i1 %i.lt.le, %j.lt.re
  br i1 %need.left, label %both.have, label %only.one

both.have:                                        ; preds = %have.work
  %i.idx64 = sext i32 %i to i64
  %j.idx64 = sext i32 %j to i64
  %i.ptr = getelementptr inbounds i32, i32* %src, i64 %i.idx64
  %j.ptr = getelementptr inbounds i32, i32* %src, i64 %j.idx64
  %vi = load i32, i32* %i.ptr, align 4
  %vj = load i32, i32* %j.ptr, align 4
  %cmp.le = icmp sle i32 %vi, %vj
  br i1 %cmp.le, label %choose.left, label %choose.right

only.one:                                         ; preds = %have.work
  ; if only one side available: pick left if i<left.end, else pick right
  br i1 %i.lt.le, label %pick.left.only, label %pick.right.only

pick.left.only:                                   ; preds = %only.one
  %i.idx64.po = sext i32 %i to i64
  %i.ptr.po = getelementptr inbounds i32, i32* %src, i64 %i.idx64.po
  %vi.po = load i32, i32* %i.ptr.po, align 4
  br label %choose.left

pick.right.only:                                  ; preds = %only.one
  %j.idx64.po = sext i32 %j to i64
  %j.ptr.po = getelementptr inbounds i32, i32* %src, i64 %j.idx64.po
  %vj.po = load i32, i32* %j.ptr.po, align 4
  br label %choose.right

choose.left:                                      ; preds = %pick.left.only, %both.have
  %val.left = phi i32 [ %vi.po, %pick.left.only ], [ %vi, %both.have ]
  %k.idx64.l = sext i32 %k to i64
  %k.ptr.l = getelementptr inbounds i32, i32* %dest, i64 %k.idx64.l
  store i32 %val.left, i32* %k.ptr.l, align 4
  %i.next = add nsw i32 %i, 1
  %k.next = add nsw i32 %k, 1
  br label %merge.loop

choose.right:                                     ; preds = %pick.right.only, %both.have
  %val.right = phi i32 [ %vj.po, %pick.right.only ], [ %vj, %both.have ]
  %k.idx64.r = sext i32 %k to i64
  %k.ptr.r = getelementptr inbounds i32, i32* %dest, i64 %k.idx64.r
  store i32 %val.right, i32* %k.ptr.r, align 4
  %j.next = add nsw i32 %j, 1
  %k.next = add nsw i32 %k, 1
  br label %merge.loop

after.merge.segment:                              ; preds = %merge.loop
  %two.run = shl i32 %run, 1
  %base.next = add nsw i32 %base, %two.run
  br label %base.loop

finish.pass:                                      ; preds = %base.loop
  %run2 = shl i32 %run, 1
  %pc2 = add nuw nsw i32 %pc, 1
  %done = icmp eq i32 %pc2, 4
  br i1 %done, label %finalize.sort, label %after.pass

after.pass:                                       ; preds = %finish.pass
  %next.src = %dest
  %next.dest = %src
  br label %outer

finalize.sort:                                    ; preds = %finish.pass
  %arr.base = %arr.p0
  %need.copy = icmp ne i32* %dest, %arr.base
  br i1 %need.copy, label %copy.loop, label %free.and.join

copy.loop:                                        ; preds = %finalize.sort, %copy.loop
  %ci = phi i32 [ 0, %finalize.sort ], [ %ci.next, %copy.loop ]
  %ci.lt = icmp slt i32 %ci, 10
  br i1 %ci.lt, label %copy.body, label %free.and.join

copy.body:                                        ; preds = %copy.loop
  %ci64 = sext i32 %ci to i64
  %src.ci.ptr = getelementptr inbounds i32, i32* %dest, i64 %ci64
  %val.ci = load i32, i32* %src.ci.ptr, align 4
  %dst.ci.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %ci64
  store i32 %val.ci, i32* %dst.ci.ptr, align 4
  %ci.next = add nsw i32 %ci, 1
  br label %copy.loop

free.and.join:                                    ; preds = %copy.loop, %finalize.sort
  call void @free(i8* %m)
  br label %after.sort

after.sort:                                       ; preds = %free.and.join, %entry
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %pi = phi i32 [ 0, %free.and.join ], [ 0, %entry ]
  br label %print.loop

print.loop:                                       ; preds = %print.loop, %after.sort
  %i.cur = phi i32 [ %pi, %after.sort ], [ %i.next2, %print.loop ]
  %i.lt.10 = icmp slt i32 %i.cur, 10
  br i1 %i.lt.10, label %print.body, label %print.nl

print.body:                                       ; preds = %print.loop
  %i64 = sext i32 %i.cur to i64
  %p.elem = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i64
  %val = load i32, i32* %p.elem, align 4
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %val)
  %i.next2 = add nsw i32 %i.cur, 1
  br label %print.loop

print.nl:                                         ; preds = %print.loop
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}