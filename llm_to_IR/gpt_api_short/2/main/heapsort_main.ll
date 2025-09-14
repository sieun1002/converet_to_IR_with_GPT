; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x144B
; Intent: Print an int array, heap-sort it, then print it again (confidence=0.86). Evidence: calls to heap_sort with int array; two print loops with "%d ".
; Preconditions: none
; Postconditions: returns 0

; Only the necessary external declarations:
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)
declare void @heap_sort(i32*, i64)

@.str_before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str_after = private unnamed_addr constant [8 x i8] c"After: \00", align 1
@.str_d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %0, align 4
  %1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %1, align 4
  %2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %2, align 4
  %3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %3, align 4
  %4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %4, align 4
  %5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %5, align 4
  %6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %6, align 4
  %7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %8, align 4

  %before.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str_before, i64 0, i64 0
  %call0 = call i32 @_printf(i8* %before.ptr)

  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp ult i64 %i, 9
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  %call1 = call i32 @_printf(i8* %fmt.ptr, i32 %val)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nuw nsw i64 %i, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %putnl1 = call i32 @_putchar(i32 10)

  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.base, i64 9)

  %after.ptr = getelementptr inbounds [8 x i8], [8 x i8]* @.str_after, i64 0, i64 0
  %call2 = call i32 @_printf(i8* %after.ptr)

  br label %for2.cond

for2.cond:                                        ; preds = %for2.inc, %for.end
  %j = phi i64 [ 0, %for.end ], [ %inc2, %for2.inc ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %for2.body, label %for2.end

for2.body:                                        ; preds = %for2.cond
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %val2 = load i32, i32* %elem2.ptr, align 4
  %fmt2.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  %call3 = call i32 @_printf(i8* %fmt2.ptr, i32 %val2)
  br label %for2.inc

for2.inc:                                         ; preds = %for2.body
  %inc2 = add nuw nsw i64 %j, 1
  br label %for2.cond

for2.end:                                         ; preds = %for2.cond
  %putnl2 = call i32 @_putchar(i32 10)
  ret i32 0
}