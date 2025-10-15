; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @binary_search(i32*, i64, i32)

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %n = alloca i64, align 8
  %queries = alloca [3 x i32], align 16
  %m = alloca i64, align 8
  %i = alloca i64, align 8
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

  store i64 9, i64* %n, align 8

  %q0 = getelementptr inbounds [3 x i32], [3 x i32]* %queries, i64 0, i64 0
  store i32 2, i32* %q0, align 4
  %q1 = getelementptr inbounds [3 x i32], [3 x i32]* %queries, i64 0, i64 1
  store i32 5, i32* %q1, align 4
  %q2 = getelementptr inbounds [3 x i32], [3 x i32]* %queries, i64 0, i64 2
  store i32 -5, i32* %q2, align 4

  store i64 3, i64* %m, align 8
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.val = load i64, i64* %i, align 8
  %m.val = load i64, i64* %m, align 8
  %cmp = icmp ult i64 %i.val, %m.val
  br i1 %cmp, label %loop.body, label %after

loop.body:
  %idx = load i64, i64* %i, align 8
  %qelt.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %queries, i64 0, i64 %idx
  %key = load i32, i32* %qelt.ptr, align 4
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %nval = load i64, i64* %n, align 8
  %bs.ret = call i32 @binary_search(i32* %arr.ptr, i64 %nval, i32 %key)
  store i32 %bs.ret, i32* %res, align 4
  %res.val = load i32, i32* %res, align 4
  %is.neg = icmp slt i32 %res.val, 0
  br i1 %is.neg, label %not_found, label %found

found:
  %idx2 = load i64, i64* %i, align 8
  %qelt.ptr2 = getelementptr inbounds [3 x i32], [3 x i32]* %queries, i64 0, i64 %idx2
  %key2 = load i32, i32* %qelt.ptr2, align 4
  %res.val2 = load i32, i32* %res, align 4
  %fmt.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call.printf.found = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %key2, i32 %res.val2)
  br label %incr

not_found:
  %idx3 = load i64, i64* %i, align 8
  %qelt.ptr3 = getelementptr inbounds [3 x i32], [3 x i32]* %queries, i64 0, i64 %idx3
  %key3 = load i32, i32* %qelt.ptr3, align 4
  %fmt.ptr2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call.printf.notfound = call i32 (i8*, ...) @printf(i8* %fmt.ptr2, i32 %key3)
  br label %incr

incr:
  %i.cur = load i64, i64* %i, align 8
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

after:
  ret i32 0
}