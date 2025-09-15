; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/3/insertionsort.ll'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.elem0.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.elem0.ptr, align 16
  %arr.elem1.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr.elem1.ptr, align 4
  %arr.elem2.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr.elem2.ptr, align 8
  %arr.elem3.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr.elem3.ptr, align 4
  %arr.elem4.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr.elem4.ptr, align 16
  %arr.elem5.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr.elem5.ptr, align 4
  %arr.elem6.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr.elem6.ptr, align 8
  %arr.elem7.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.elem7.ptr, align 4
  %arr.elem8.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.elem8.ptr, align 16
  %arr.elem9.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.elem9.ptr, align 4
  call void @insertion_sort(i32* nonnull %arr.elem0.ptr, i64 10)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp ult i64 %i.0, 10
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.0
  %elem = load i32, i32* %elem.ptr, align 4
  %call.printf = call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %elem)
  %i.next = add i64 %i.0, 1
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define void @insertion_sort(i32* nocapture %arr, i64 %n) {
entry:
  br label %outer.header

outer.header:                                     ; preds = %after.inner, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %after.inner ]
  %cmp.i = icmp ult i64 %i, %n
  br i1 %cmp.i, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.header
  %idx.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %idx.ptr, align 4
  br label %inner.header

inner.header:                                     ; preds = %shift, %outer.body
  %j = phi i64 [ %i, %outer.body ], [ %jm1, %shift ]
  %j.is0 = icmp eq i64 %j, 0
  br i1 %j.is0, label %after.inner, label %check

check:                                            ; preds = %inner.header
  %jm1 = add i64 %j, -1
  %addr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %val.jm1 = load i32, i32* %addr.jm1, align 4
  %cmp.key = icmp slt i32 %key, %val.jm1
  br i1 %cmp.key, label %shift, label %after.inner

shift:                                            ; preds = %check
  %addr.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val.jm1, i32* %addr.j, align 4
  br label %inner.header

after.inner:                                      ; preds = %check, %inner.header
  %addr.jf = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %addr.jf, align 4
  %i.next = add i64 %i, 1
  br label %outer.header

exit:                                             ; preds = %outer.header
  ret void
}
