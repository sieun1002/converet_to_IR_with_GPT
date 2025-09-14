; ModuleID = 'main'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str_notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i64 @binary_search(i32* noundef, i64 noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  store [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12], [9 x i32]* %arr, align 16
  store [3 x i32] [i32 2, i32 5, i32 -5], [3 x i32]* %keys, align 16
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %latch ]
  %cmp = icmp ult i64 %i, 3
  br i1 %cmp, label %body, label %exit

body:
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  %arrdecay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %idx = call i64 @binary_search(i32* noundef %arrdecay, i64 noundef 9, i32 noundef %key)
  %isneg = icmp slt i64 %idx, 0
  br i1 %isneg, label %notfound, label %found

found:
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* noundef %fmt1, i32 noundef %key, i64 noundef %idx)
  br label %latch

notfound:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_notfound, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* noundef %fmt2, i32 noundef %key)
  br label %latch

latch:
  %i.next = add nuw nsw i64 %i, 1
  br label %loop

exit:
  ret i32 0
}