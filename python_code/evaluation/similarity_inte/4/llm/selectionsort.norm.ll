; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/4/selectionsort.ll'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr.elem0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr.elem0, align 16
  %arr.elem1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr.elem1, align 4
  %arr.elem2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr.elem2, align 8
  %arr.elem3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr.elem3, align 4
  %arr.elem4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr.elem4, align 16
  call void @selection_sort(i32* noundef nonnull %arr.elem0, i32 noundef 5)
  %call.print.header = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i64 0, i64 0))
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp ult i32 %i, 5
  br i1 %cmp, label %loop.body, label %after

loop.body:                                        ; preds = %loop.cond
  %idx.ext = zext i32 %i to i64
  %elt.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %elt = load i32, i32* %elt.ptr, align 4
  %call.print.num = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef %elt)
  %i.next = add nuw nsw i32 %i, 1
  br label %loop.cond

after:                                            ; preds = %loop.cond
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

define void @selection_sort(i32* nocapture %arr, i32 %n) {
entry:
  br label %outer.loop

outer.loop:                                       ; preds = %inner.end, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %inner.end ]
  %n.sub = add nsw i32 %n, -1
  %cond.outer = icmp slt i32 %i, %n.sub
  br i1 %cond.outer, label %inner.loop, label %exit

inner.loop:                                       ; preds = %outer.loop, %inner.compare
  %min.cur = phi i32 [ %spec.select, %inner.compare ], [ %i, %outer.loop ]
  %j.cur.in = phi i32 [ %j.cur, %inner.compare ], [ %i, %outer.loop ]
  %j.cur = add nuw nsw i32 %j.cur.in, 1
  %cmp.j = icmp slt i32 %j.cur, %n
  br i1 %cmp.j, label %inner.compare, label %inner.end

inner.compare:                                    ; preds = %inner.loop
  %j.ext = zext i32 %j.cur to i64
  %min.ext = sext i32 %min.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %val.j = load i32, i32* %j.ptr, align 4
  %val.min = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %val.j, %val.min
  %spec.select = select i1 %lt, i32 %j.cur, i32 %min.cur
  br label %inner.loop

inner.end:                                        ; preds = %inner.loop
  %i.ext = zext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %tmp = load i32, i32* %i.ptr, align 4
  %min.final.ext = sext i32 %min.cur to i64
  %min.final.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.final.ext
  %val.min2 = load i32, i32* %min.final.ptr, align 4
  store i32 %val.min2, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.final.ptr, align 4
  %i.next = add nuw nsw i32 %i, 1
  br label %outer.loop

exit:                                             ; preds = %outer.loop
  ret void
}
