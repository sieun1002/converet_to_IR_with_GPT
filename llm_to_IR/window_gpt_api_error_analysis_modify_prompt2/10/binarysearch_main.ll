; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@aKeyDNotFound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare dso_local i32 @binary_search(i32* noundef, i64 noundef, i32 noundef)
declare dso_local i32 @printf(i8* noundef, ...)

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %n = alloca i64, align 8
  %res = alloca i32, align 4
  %nkeys = alloca i64, align 8
  %i = alloca i64, align 8

  ; arr initialization: [-5, -1, 0, 2, 2, 3, 7, 9, 12]
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8, align 4

  ; n = 9 (i64)
  store i64 9, i64* %n, align 8

  ; keys initialization: [2, 5, -5]
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2, align 4

  ; nkeys = 3, i = 0
  store i64 3, i64* %nkeys, align 8
  store i64 0, i64* %i, align 8

  br label %cond

cond:                                             ; preds = %afterprint, %entry
  %i.val = load i64, i64* %i, align 8
  %nkeys.val = load i64, i64* %nkeys, align 8
  %cmp = icmp ult i64 %i.val, %nkeys.val
  br i1 %cmp, label %loop, label %exit

loop:                                             ; preds = %cond
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.val
  %key = load i32, i32* %keyptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %call = call i32 @binary_search(i32* noundef %arr.base, i64 noundef %n.val, i32 noundef %key)
  store i32 %call, i32* %res, align 4
  %isneg = icmp slt i32 %call, 0
  br i1 %isneg, label %notfound, label %found

found:                                            ; preds = %loop
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i64 0, i64 0
  %p1 = call i32 (i8*, ...) @printf(i8* noundef %fmt1, i32 noundef %key, i32 noundef %call)
  br label %afterprint

notfound:                                         ; preds = %loop
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %p2 = call i32 (i8*, ...) @printf(i8* noundef %fmt2, i32 noundef %key)
  br label %afterprint

afterprint:                                       ; preds = %notfound, %found
  %i.curr = load i64, i64* %i, align 8
  %i.next = add i64 %i.curr, 1
  store i64 %i.next, i64* %i, align 8
  br label %cond

exit:                                             ; preds = %cond
  ret i32 0
}