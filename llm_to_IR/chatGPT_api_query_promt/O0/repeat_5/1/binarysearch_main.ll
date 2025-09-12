; target triple for Linux x86-64
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i64 @binary_search(i32*, i64, i32)
declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %n = alloca i64, align 8
  %numKeys = alloca i64, align 8
  %i = alloca i64, align 8

  ; initialize array: [-5, -1, 0, 2, 2, 3, 7, 9, 12]
  %a0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %a0, align 4
  %a1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %a1, align 4
  %a2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %a2, align 4
  %a3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %a3, align 4
  %a4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %a4, align 4
  %a5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %a5, align 4
  %a6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %a6, align 4
  %a7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %a7, align 4
  %a8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %a8, align 4

  ; initialize keys: [2, 5, -5]
  %k0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %k0, align 4
  %k1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %k1, align 4
  %k2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %k2, align 4

  store i64 9, i64* %n, align 8
  store i64 3, i64* %numKeys, align 8
  store i64 0, i64* %i, align 8

  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %nk = load i64, i64* %numKeys, align 8
  %cond = icmp ult i64 %iv, %nk
  br i1 %cond, label %body, label %done

body:
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %iv
  %key = load i32, i32* %key.ptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len = load i64, i64* %n, align 8
  %idx = call i64 @binary_search(i32* %arr.base, i64 %len, i32 %key)
  %found = icmp sge i64 %idx, 0
  br i1 %found, label %printFound, label %printNot

printFound:
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %pf = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %key, i64 %idx)
  br label %inc

printNot:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %pn = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %inc

inc:
  %next = add i64 %iv, 1
  store i64 %next, i64* %i, align 8
  br label %loop

done:
  ret i32 0
}