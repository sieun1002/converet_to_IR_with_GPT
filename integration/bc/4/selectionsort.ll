; ModuleID = 'selectionsort.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %arr.elem0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr.elem0, align 4
  %arr.elem1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr.elem1, align 4
  %arr.elem2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr.elem2, align 4
  %arr.elem3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr.elem3, align 4
  %arr.elem4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr.elem4, align 4
  store i32 5, i32* %n, align 4
  %arr.decay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %n.val = load i32, i32* %n, align 4
  call void @selection_sort(i32* noundef %arr.decay, i32 noundef %n.val)
  %fmt.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call.print.header = call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %n.cur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i, %n.cur
  br i1 %cmp, label %loop.body, label %after

loop.body:                                        ; preds = %loop.cond
  %idx.ext = sext i32 %i to i64
  %elt.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %elt = load i32, i32* %elt.ptr, align 4
  %fmt.num = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call.print.num = call i32 (i8*, ...) @printf(i8* noundef %fmt.num, i32 noundef %elt)
  br label %loop.latch

loop.latch:                                       ; preds = %loop.body
  %i.next = add nsw i32 %i, 1
  br label %loop.cond

after:                                            ; preds = %loop.cond
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

define void @selection_sort(i32* nocapture %arr, i32 %n) {
entry:
  br label %outer.loop

outer.loop:                                       ; preds = %outer.after.swap, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.after.swap ]
  %n.sub = add nsw i32 %n, -1
  %cond.outer = icmp slt i32 %i, %n.sub
  br i1 %cond.outer, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.loop
  %min.init = phi i32 [ %i, %outer.loop ]
  %j.init = add nsw i32 %i, 1
  br label %inner.loop

inner.loop:                                       ; preds = %inner.inc, %outer.body
  %min.cur = phi i32 [ %min.init, %outer.body ], [ %min.next, %inner.inc ]
  %j.cur = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.inc ]
  %cmp.j = icmp slt i32 %j.cur, %n
  br i1 %cmp.j, label %inner.compare, label %inner.end

inner.compare:                                    ; preds = %inner.loop
  %j.ext = sext i32 %j.cur to i64
  %min.ext = sext i32 %min.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %val.j = load i32, i32* %j.ptr, align 4
  %val.min = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %val.j, %val.min
  br i1 %lt, label %inner.update, label %inner.inc

inner.update:                                     ; preds = %inner.compare
  br label %inner.inc

inner.inc:                                        ; preds = %inner.update, %inner.compare
  %min.next = phi i32 [ %j.cur, %inner.update ], [ %min.cur, %inner.compare ]
  %j.next = add nsw i32 %j.cur, 1
  br label %inner.loop

inner.end:                                        ; preds = %inner.loop
  %min.final = phi i32 [ %min.cur, %inner.loop ]
  %i.ext = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %tmp = load i32, i32* %i.ptr, align 4
  %min.final.ext = sext i32 %min.final to i64
  %min.final.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.final.ext
  %val.min2 = load i32, i32* %min.final.ptr, align 4
  store i32 %val.min2, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.final.ptr, align 4
  br label %outer.after.swap

outer.after.swap:                                 ; preds = %inner.end
  %i.next = add nsw i32 %i, 1
  br label %outer.loop

exit:                                             ; preds = %outer.loop
  ret void
}
