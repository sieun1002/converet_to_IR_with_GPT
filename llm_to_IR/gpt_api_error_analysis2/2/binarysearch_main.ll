; ModuleID = 'main_binary_search.ll'
target triple = "x86_64-pc-linux-gnu"

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str_notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i64 @binary_search(i32* nocapture, i64, i32)
declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %i = alloca i64, align 8

  %arr0ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4ptr, align 4
  %arr5ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr5ptr, align 4
  %arr6ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr6ptr, align 4
  %arr7ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr7ptr, align 4
  %arr8ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8ptr, align 4

  %key0ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %key0ptr, align 4
  %key1ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %key1ptr, align 4
  %key2ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %key2ptr, align 4

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.val = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i.val, 3
  br i1 %cmp, label %body, label %exit

body:
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.val
  %key = load i32, i32* %keyptr, align 4
  %arrbase = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %call = call i64 @binary_search(i32* %arrbase, i64 9, i32 %key)
  %found = icmp sge i64 %call, 0
  br i1 %found, label %print_found, label %print_notfound

print_found:
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  %callpf = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %key, i64 %call)
  br label %inc

print_notfound:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_notfound, i64 0, i64 0
  %callpnf = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %inc

inc:
  %i.val2 = load i64, i64* %i, align 8
  %incv = add i64 %i.val2, 1
  store i64 %incv, i64* %i, align 8
  br label %loop

exit:
  ret i32 0
}