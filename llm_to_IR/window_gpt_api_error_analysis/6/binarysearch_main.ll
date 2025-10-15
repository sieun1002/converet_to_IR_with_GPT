; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare void @__main()
declare i32 @printf(i8*, ...)
declare i32 @binary_search(i32*, i32, i32)

define i32 @main() {
entry:
  call void @__main()
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %len = alloca i32, align 4
  %idx = alloca i64, align 8
  %nkeys = alloca i64, align 8
  %res = alloca i32, align 4
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
  store i32 9, i32* %len, align 4
  %k0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %k0, align 4
  %k1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %k1, align 4
  %k2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %k2, align 4
  store i64 3, i64* %nkeys, align 8
  store i64 0, i64* %idx, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %idx, align 8
  %nk.cur = load i64, i64* %nkeys, align 8
  %cmp = icmp ult i64 %i.cur, %nk.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.cur
  %key.val = load i32, i32* %key.ptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len.val = load i32, i32* %len, align 4
  %bs.ret = call i32 @binary_search(i32* %arr.base, i32 %len.val, i32 %key.val)
  store i32 %bs.ret, i32* %res, align 4
  %res.val = load i32, i32* %res, align 4
  %is.neg = icmp slt i32 %res.val, 0
  br i1 %is.neg, label %notfound, label %found

found:
  %fmt = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %res.val2 = load i32, i32* %res, align 4
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt, i32 %key.val, i32 %res.val2)
  br label %cont

notfound:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key.val)
  br label %cont

cont:
  %i.old = load i64, i64* %idx, align 8
  %i.next = add i64 %i.old, 1
  store i64 %i.next, i64* %idx, align 8
  br label %loop.cond

loop.end:
  ret i32 0
}