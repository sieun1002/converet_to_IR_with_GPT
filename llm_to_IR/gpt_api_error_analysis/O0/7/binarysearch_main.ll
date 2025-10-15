; ModuleID = 'reconstructed'
target triple = "x86_64-pc-linux-gnu"

@.fmt_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.fmt_nf    = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i32 @printf(i8*, ...)
declare i64 @binary_search(i32*, i64, i32)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16

  %arr0.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0.ptr, align 4
  %arr1.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr1.ptr, align 4
  %arr2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr2.ptr, align 4
  %arr3.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr3.ptr, align 4
  %arr4.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4.ptr, align 4
  %arr5.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr5.ptr, align 4
  %arr6.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr6.ptr, align 4
  %arr7.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr7.ptr, align 4
  %arr8.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8.ptr, align 4

  %key0.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %key0.ptr, align 4
  %key1.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %key1.ptr, align 4
  %key2.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %key2.ptr, align 4

  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %cont ]
  %cmp = icmp ult i64 %i, 3
  br i1 %cmp, label %body, label %exit

body:
  %keys.base = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  %key.elem.ptr = getelementptr inbounds i32, i32* %keys.base, i64 %i
  %key.val = load i32, i32* %key.elem.ptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %res = call i64 @binary_search(i32* %arr.base, i64 9, i32 %key.val)
  %isneg = icmp slt i64 %res, 0
  br i1 %isneg, label %notfound, label %found

found:
  %fmtf.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.fmt_found, i64 0, i64 0
  %callf = call i32 (i8*, ...) @printf(i8* %fmtf.ptr, i32 %key.val, i64 %res)
  br label %cont

notfound:
  %fmtn.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.fmt_nf, i64 0, i64 0
  %calln = call i32 (i8*, ...) @printf(i8* %fmtn.ptr, i32 %key.val)
  br label %cont

cont:
  %i.next = add i64 %i, 1
  br label %loop

exit:
  ret i32 0
}