; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-linux-gnu"

@.str.idx = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.nf  = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i64 @binary_search(i32* noundef, i64 noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)

define i32 @main() {
entry:
  %arr    = alloca [9 x i32], align 16
  %keys   = alloca [3 x i32], align 16
  %n      = alloca i64, align 8
  %kcount = alloca i64, align 8
  %i      = alloca i64, align 8
  %idx    = alloca i64, align 8

  ; arr = {-5, -1, 0, 2, 2, 3, 7, 9, 12}
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

  ; keys = {2, 5, -5}
  %k0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %k0, align 4
  %k1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %k1, align 4
  %k2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %k2, align 4

  store i64 9, i64* %n, align 8
  store i64 3, i64* %kcount, align 8
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.cur = load i64, i64* %i, align 8
  %kc    = load i64, i64* %kcount, align 8
  %cont  = icmp ult i64 %i.cur, %kc
  br i1 %cont, label %body, label %done

body:
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.cur
  %key     = load i32, i32* %key.ptr, align 4

  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %nval     = load i64, i64* %n, align 8
  %ret      = call i64 @binary_search(i32* noundef %arr.base, i64 noundef %nval, i32 noundef %key)
  store i64 %ret, i64* %idx, align 8

  %neg = icmp slt i64 %ret, 0
  br i1 %neg, label %notfound, label %found

found:
  %fmt    = getelementptr inbounds [21 x i8], [21 x i8]* @.str.idx, i64 0, i64 0
  %retld  = load i64, i64* %idx, align 8
  %call1  = call i32 (i8*, ...) @printf(i8* noundef %fmt, i32 noundef %key, i64 noundef %retld)
  br label %inc

notfound:
  %fmt2   = getelementptr inbounds [21 x i8], [21 x i8]* @.str.nf, i64 0, i64 0
  %call2  = call i32 (i8*, ...) @printf(i8* noundef %fmt2, i32 noundef %key)
  br label %inc

inc:
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop

done:
  ret i32 0
}