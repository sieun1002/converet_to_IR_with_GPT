; ModuleID = 'bin2ir'
target triple = "x86_64-pc-linux-gnu"

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@.str_not_found = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"

declare i64 @binary_search(i32* noundef, i64 noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)

define dso_local i32 @main() {
entry:
  ; locals
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %i = alloca i64, align 8
  %n = alloca i64, align 8
  %kcnt = alloca i64, align 8
  %idx = alloca i64, align 8

  ; init arr = {-5, -1, 0, 2, 2, 3, 7, 9, 12}
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 -1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 0, i32* %arr2, align 4
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 2, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 2, i32* %arr4, align 4
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 3, i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 7, i32* %arr6, align 4
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 9, i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 12, i32* %arr8, align 4

  ; init keys = {2, 5, -5}
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds i32, i32* %keys0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds i32, i32* %keys0, i64 2
  store i32 -5, i32* %keys2, align 4

  ; n = 9, kcnt = 3, i = 0
  store i64 9, i64* %n, align 8
  store i64 3, i64* %kcnt, align 8
  store i64 0, i64* %i, align 8

  br label %loop

loop:
  %i.val = load i64, i64* %i, align 8
  %kcnt.val = load i64, i64* %kcnt, align 8
  %cmp = icmp ult i64 %i.val, %kcnt.val
  br i1 %cmp, label %body, label %done

body:
  ; key = keys[i]
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.val
  %key = load i32, i32* %key.ptr, align 4

  ; call idx = binary_search(arr, n, key)
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %ret = call i64 @binary_search(i32* noundef %arr.ptr, i64 noundef %n.val, i32 noundef %key)
  store i64 %ret, i64* %idx, align 8

  ; if (idx >= 0) print found else print not found
  %idx.val = load i64, i64* %idx, align 8
  %neg = icmp slt i64 %idx.val, 0
  br i1 %neg, label %print_not_found, label %print_found

print_found:
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* noundef %fmt1, i32 noundef %key, i64 noundef %idx.val)
  br label %incr

print_not_found:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_not_found, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* noundef %fmt2, i32 noundef %key)
  br label %incr

incr:
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop

done:
  ret i32 0
}