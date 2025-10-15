; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str_nf    = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i64 @binary_search(i32* nocapture readonly, i64, i32)
declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %n = alloca i64, align 8
  %kcount = alloca i64, align 8
  %i = alloca i64, align 8
  %idx = alloca i64, align 8

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

  %k0ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %k0ptr, align 4
  %k1ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %k1ptr, align 4
  %k2ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %k2ptr, align 4

  store i64 9, i64* %n, align 8
  store i64 3, i64* %kcount, align 8
  store i64 0, i64* %i, align 8

  br label %loop.cond

loop.cond:                                        ; preds = %inc, %entry
  %i.val = load i64, i64* %i, align 8
  %kcount.val = load i64, i64* %kcount, align 8
  %cmp = icmp ult i64 %i.val, %kcount.val
  br i1 %cmp, label %loop.body, label %ret

loop.body:                                        ; preds = %loop.cond
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.val
  %key = load i32, i32* %keyptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %idx.call = call i64 @binary_search(i32* %arr.base, i64 %n.val, i32 %key)
  store i64 %idx.call, i64* %idx, align 8
  %foundcmp = icmp slt i64 %idx.call, 0
  br i1 %foundcmp, label %notfound, label %found

found:                                            ; preds = %loop.body
  %fmt.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  %idx.loaded = load i64, i64* %idx, align 8
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %key, i64 %idx.loaded)
  br label %inc

notfound:                                         ; preds = %loop.body
  %fmt2.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_nf, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i32 %key)
  br label %inc

inc:                                              ; preds = %notfound, %found
  %i.val2 = load i64, i64* %i, align 8
  %i.next = add i64 %i.val2, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

ret:                                              ; preds = %loop.cond
  ret i32 0
}