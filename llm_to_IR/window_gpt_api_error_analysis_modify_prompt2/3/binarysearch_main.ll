; ModuleID = 'main'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@aKeyDNotFound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @binary_search(i32*, i32, i32)

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 4
  %arr1p = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 -1, i32* %arr1p, align 4
  %arr2p = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 0, i32* %arr2p, align 4
  %arr3p = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 2, i32* %arr3p, align 4
  %arr4p = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 2, i32* %arr4p, align 4
  %arr5p = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 3, i32* %arr5p, align 4
  %arr6p = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 7, i32* %arr6p, align 4
  %arr7p = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 9, i32* %arr7p, align 4
  %arr8p = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 12, i32* %arr8p, align 4
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds i32, i32* %keys0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds i32, i32* %keys0, i64 2
  store i32 -5, i32* %keys2, align 4
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %after ]
  %cond = icmp ult i64 %i, 3
  br i1 %cond, label %body, label %exit

body:
  %keyptr = getelementptr inbounds i32, i32* %keys0, i64 %i
  %key = load i32, i32* %keyptr, align 4
  %res = call i32 @binary_search(i32* %arr0, i32 9, i32 %key)
  %isneg = icmp slt i32 %res, 0
  br i1 %isneg, label %notfound, label %found

found:
  %fmt = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt, i32 %key, i32 %res)
  br label %after

notfound:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %after

after:
  %i.next = add i64 %i, 1
  br label %loop

exit:
  ret i32 0
}