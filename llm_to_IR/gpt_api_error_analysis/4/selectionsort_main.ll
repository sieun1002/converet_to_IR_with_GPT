; ModuleID = 'main.ll'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @selection_sort(i32* noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)

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

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %n.cur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i, %n.cur
  br i1 %cmp, label %loop.body, label %after

loop.body:
  %idx.ext = sext i32 %i to i64
  %elt.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %elt = load i32, i32* %elt.ptr, align 4
  %fmt.num = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call.print.num = call i32 (i8*, ...) @printf(i8* noundef %fmt.num, i32 noundef %elt)
  br label %loop.latch

loop.latch:
  %i.next = add nsw i32 %i, 1
  br label %loop.cond

after:
  ret i32 0
}