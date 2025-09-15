; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/1/insertionsort.ll'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 16
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 8
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 16
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 8
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 16
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4
  call void @insertion_sort(i32* noundef nonnull %p0, i64 noundef 10)
  br label %loop

loop:                                             ; preds = %body, %entry
  %idx.0 = phi i64 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp ult i64 %idx.0, 10
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %elemPtr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idx.0
  %elem = load i32, i32* %elemPtr, align 4
  %call = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %elem)
  %inc = add i64 %idx.0, 1
  br label %loop

after:                                            ; preds = %loop
  %nl = call i32 @putchar(i32 noundef 10)
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define void @insertion_sort(i32* nocapture %arr, i64 %n) {
entry:
  br label %loop.header

loop.header:                                      ; preds = %insert, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %insert ]
  %cmp.i.n = icmp ult i64 %i, %n
  br i1 %cmp.i.n, label %loop.prep, label %exit

loop.prep:                                        ; preds = %loop.header
  %idx.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %idx.i, align 4
  br label %inner.check

inner.check:                                      ; preds = %inner.shift, %loop.prep
  %j = phi i64 [ %i, %loop.prep ], [ %j.minus1, %inner.shift ]
  %j.iszero = icmp eq i64 %j, 0
  br i1 %j.iszero, label %insert, label %compare

compare:                                          ; preds = %inner.check
  %j.minus1 = add i64 %j, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %lt = icmp slt i32 %key, %val.jm1
  br i1 %lt, label %inner.shift, label %insert

inner.shift:                                      ; preds = %compare
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val.jm1, i32* %ptr.j, align 4
  br label %inner.check

insert:                                           ; preds = %compare, %inner.check
  %dest = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %dest, align 4
  %i.next = add i64 %i, 1
  br label %loop.header

exit:                                             ; preds = %loop.header
  ret void
}
