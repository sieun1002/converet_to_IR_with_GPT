; ModuleID = 'main_with_heap_sort'
target triple = "x86_64-pc-linux-gnu"

@.str_before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str_after  = private unnamed_addr constant [8 x i8] c"After: \00", align 1
@.str_num    = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  store [9 x i32] [i32 7, i32 3, i32 9, i32 1, i32 4, i32 8, i32 2, i32 6, i32 5], [9 x i32]* %arr, align 16
  %0 = getelementptr inbounds [9 x i8], [9 x i8]* @.str_before, i64 0, i64 0
  %1 = call i32 (i8*, ...) @printf(i8* %0)
  br label %for.check

for.check:                                        ; preds = %for.inc, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %for.inc ]
  %2 = icmp ult i64 %i, 9
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.check
  %3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %4 = load i32, i32* %3, align 4
  %5 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_num, i64 0, i64 0
  %6 = call i32 (i8*, ...) @printf(i8* %5, i32 %4)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %i.next = add i64 %i, 1
  br label %for.check

for.end:                                          ; preds = %for.check
  %7 = call i32 @putchar(i32 10)
  %8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %8, i64 9)
  %9 = getelementptr inbounds [8 x i8], [8 x i8]* @.str_after, i64 0, i64 0
  %10 = call i32 (i8*, ...) @printf(i8* %9)
  br label %for2.check

for2.check:                                       ; preds = %for2.inc, %for.end
  %j = phi i64 [ 0, %for.end ], [ %j.next, %for2.inc ]
  %11 = icmp ult i64 %j, 9
  br i1 %11, label %for2.body, label %for2.end

for2.body:                                        ; preds = %for2.check
  %12 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %13 = load i32, i32* %12, align 4
  %14 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_num, i64 0, i64 0
  %15 = call i32 (i8*, ...) @printf(i8* %14, i32 %13)
  br label %for2.inc

for2.inc:                                         ; preds = %for2.body
  %j.next = add i64 %j, 1
  br label %for2.check

for2.end:                                         ; preds = %for2.check
  %16 = call i32 @putchar(i32 10)
  ret i32 0
}