; ModuleID = 'fixed_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@aKeyDNotFound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare dso_local void @__main()
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @binary_search(i32*, i64, i32)

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %len = alloca i64, align 8
  %nkeys = alloca i64, align 8
  %i = alloca i64, align 8
  %res = alloca i32, align 4
  %arr0ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 1
  store i32 -1, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 2
  store i32 0, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 3
  store i32 2, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 4
  store i32 2, i32* %arr4ptr, align 4
  %arr5ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 5
  store i32 3, i32* %arr5ptr, align 4
  %arr6ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 6
  store i32 7, i32* %arr6ptr, align 4
  %arr7ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 7
  store i32 9, i32* %arr7ptr, align 4
  %arr8ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 8
  store i32 12, i32* %arr8ptr, align 4
  %keys0ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0ptr, align 4
  %keys1ptr = getelementptr inbounds i32, i32* %keys0ptr, i64 1
  store i32 5, i32* %keys1ptr, align 4
  %keys2ptr = getelementptr inbounds i32, i32* %keys0ptr, i64 2
  store i32 -5, i32* %keys2ptr, align 4
  store i64 9, i64* %len, align 8
  store i64 3, i64* %nkeys, align 8
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.val = load i64, i64* %i, align 8
  %nkeys.val = load i64, i64* %nkeys, align 8
  %cond = icmp ult i64 %i.val, %nkeys.val
  br i1 %cond, label %body, label %done

body:
  %key.ptr = getelementptr inbounds i32, i32* %keys0ptr, i64 %i.val
  %key = load i32, i32* %key.ptr, align 4
  %len.val = load i64, i64* %len, align 8
  %call = call i32 @binary_search(i32* %arr0ptr, i64 %len.val, i32 %key)
  store i32 %call, i32* %res, align 4
  %res.val = load i32, i32* %res, align 4
  %is.neg = icmp slt i32 %res.val, 0
  br i1 %is.neg, label %notfound, label %found

found:
  %fmt.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i64 0, i64 0
  %res.print = load i32, i32* %res, align 4
  %call.printf.found = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %key, i32 %res.print)
  br label %inc

notfound:
  %fmt2.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %call.printf.nf = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i32 %key)
  br label %inc

inc:
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop

done:
  ret i32 0
}