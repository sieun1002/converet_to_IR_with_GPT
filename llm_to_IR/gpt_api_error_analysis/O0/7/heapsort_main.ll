; ModuleID = 'heap_sort_main'
source_filename = "heap_sort_main.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.orig = private unnamed_addr constant [17 x i8] c"Original array: \00", align 1
@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)
declare dso_local void @heap_sort(i32* noundef, i64 noundef)

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  store i64 9, i64* %len, align 8
  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %p0, align 4
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %p8, align 4
  %fmt1.ptr = getelementptr inbounds [17 x i8], [17 x i8]* @.str.orig, i64 0, i64 0
  %call.printf.orig = call i32 (i8*, ...) @printf(i8* noundef %fmt1.ptr)
  br label %for1.cond

for1.cond:                                        ; preds = %for1.body, %entry
  %i1 = phi i64 [ 0, %entry ], [ %i1.next, %for1.body ]
  %len1 = load i64, i64* %len, align 8
  %cmp1 = icmp ult i64 %i1, %len1
  br i1 %cmp1, label %for1.body, label %for1.end

for1.body:                                        ; preds = %for1.cond
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1
  %elem1 = load i32, i32* %elem.ptr1, align 4
  %fmtd.ptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call.printf.val1 = call i32 (i8*, ...) @printf(i8* noundef %fmtd.ptr1, i32 noundef %elem1)
  %i1.next = add nuw nsw i64 %i1, 1
  br label %for1.cond

for1.end:                                         ; preds = %for1.cond
  %call.putchar.nl1 = call i32 @putchar(i32 noundef 10)
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len2 = load i64, i64* %len, align 8
  call void @heap_sort(i32* noundef %arr.base, i64 noundef %len2)
  %fmt2.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %call.printf.sorted = call i32 (i8*, ...) @printf(i8* noundef %fmt2.ptr)
  br label %for2.cond

for2.cond:                                        ; preds = %for2.body, %for1.end
  %i2 = phi i64 [ 0, %for1.end ], [ %i2.next, %for2.body ]
  %len3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %i2, %len3
  br i1 %cmp2, label %for2.body, label %for2.end

for2.body:                                        ; preds = %for2.cond
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %fmtd.ptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call.printf.val2 = call i32 (i8*, ...) @printf(i8* noundef %fmtd.ptr2, i32 noundef %elem2)
  %i2.next = add nuw nsw i64 %i2, 1
  br label %for2.cond

for2.end:                                         ; preds = %for2.cond
  %call.putchar.nl2 = call i32 @putchar(i32 noundef 10)
  ret i32 0
}