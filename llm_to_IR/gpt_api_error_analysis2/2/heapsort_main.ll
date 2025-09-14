; ModuleID = 'main'
target triple = "x86_64-pc-linux-gnu"

@.str_init = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str_sorted = private unnamed_addr constant [8 x i8] c"After: \00", align 1
@.str_d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %arr.idx0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr.idx0, align 4
  %arr.idx1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr.idx1, align 4
  %arr.idx2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr.idx2, align 4
  %arr.idx3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr.idx3, align 4
  %arr.idx4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr.idx4, align 4
  %arr.idx5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr.idx5, align 4
  %arr.idx6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr.idx6, align 4
  %arr.idx7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.idx7, align 4
  %arr.idx8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr.idx8, align 4
  %fmt.init.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str_init, i64 0, i64 0
  %call.printf.init = call i32 (i8*, ...) @printf(i8* %fmt.init.ptr)
  br label %loop1.cond

loop1.cond:
  %i0 = phi i64 [ 0, %entry ], [ %i0.next, %loop1.body ]
  %cmp0 = icmp ult i64 %i0, 9
  br i1 %cmp0, label %loop1.body, label %loop1.end

loop1.body:
  %elem.ptr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i0
  %elem0 = load i32, i32* %elem.ptr0, align 4
  %fmt.d.ptr0 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  %call.printf.d0 = call i32 (i8*, ...) @printf(i8* %fmt.d.ptr0, i32 %elem0)
  %i0.next = add nuw nsw i64 %i0, 1
  br label %loop1.cond

loop1.end:
  %nl0 = call i32 @putchar(i32 10)
  %arr.decay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.decay, i64 9)
  %fmt.sorted.ptr = getelementptr inbounds [8 x i8], [8 x i8]* @.str_sorted, i64 0, i64 0
  %call.printf.sorted = call i32 (i8*, ...) @printf(i8* %fmt.sorted.ptr)
  br label %loop2.cond

loop2.cond:
  %i1 = phi i64 [ 0, %loop1.end ], [ %i1.next, %loop2.body ]
  %cmp1 = icmp ult i64 %i1, 9
  br i1 %cmp1, label %loop2.body, label %loop2.end

loop2.body:
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1
  %elem1 = load i32, i32* %elem.ptr1, align 4
  %fmt.d.ptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  %call.printf.d1 = call i32 (i8*, ...) @printf(i8* %fmt.d.ptr1, i32 %elem1)
  %i1.next = add nuw nsw i64 %i1, 1
  br label %loop2.cond

loop2.end:
  %nl1 = call i32 @putchar(i32 10)
  ret i32 0
}