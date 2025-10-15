; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = internal unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@aKeyDNotFound = internal unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare dso_local i32 @binary_search(i32* noundef, i32 noundef, i32 noundef)
declare dso_local i32 @printf(i8* noundef, ...)

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %size64 = alloca i64, align 8
  %count64 = alloca i64, align 8
  %i64 = alloca i64, align 8
  %res32 = alloca i32, align 4
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
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2, align 4
  store i64 9, i64* %size64, align 8
  store i64 3, i64* %count64, align 8
  store i64 0, i64* %i64, align 8
  br label %loop.test

loop.test:                                        ; preds = %after.print, %entry
  %i.cur = phi i64 [ 0, %entry ], [ %i.next, %after.print ]
  %count.ld = load i64, i64* %count64, align 8
  %cmp = icmp ult i64 %i.cur, %count.ld
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop.test
  %keys.base = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  %key.ptr = getelementptr inbounds i32, i32* %keys.base, i64 %i.cur
  %key.val = load i32, i32* %key.ptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %size.ld64 = load i64, i64* %size64, align 8
  %size.ld32 = trunc i64 %size.ld64 to i32
  %bs.ret = call i32 @binary_search(i32* %arr.base, i32 %size.ld32, i32 %key.val)
  store i32 %bs.ret, i32* %res32, align 4
  %res.ld = load i32, i32* %res32, align 4
  %neg = icmp slt i32 %res.ld, 0
  br i1 %neg, label %notfound, label %found

found:                                            ; preds = %loop.body
  %fmt.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i64 0, i64 0
  %res.ld2 = load i32, i32* %res32, align 4
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %key.val, i32 %res.ld2)
  br label %after.print

notfound:                                         ; preds = %loop.body
  %fmt2.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i32 %key.val)
  br label %after.print

after.print:                                      ; preds = %notfound, %found
  %i.next = add i64 %i.cur, 1
  br label %loop.test

exit:                                             ; preds = %loop.test
  ret i32 0
}