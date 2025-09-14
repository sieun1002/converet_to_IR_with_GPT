; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x128B
; Intent: sort an integer array with bubble_sort and print it (confidence=0.90). Evidence: call to bubble_sort(arr, 10); loop printing with "%d ".
; Preconditions: none
; Postconditions: prints sorted values and a newline; returns 0

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
declare void @bubble_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8
  %n = alloca i64, align 8

  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.base, align 4
  %idx1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 5, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 8, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %idx9, align 4

  store i64 10, i64* %n, align 8

  %nval = load i64, i64* %n, align 8
  call void @bubble_sort(i32* %arr.base, i64 %nval)

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %ncur = load i64, i64* %n, align 8
  %cmp = icmp ult i64 %iv, %ncur
  br i1 %cmp, label %body, label %after

body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %iv
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %inc = add i64 %iv, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

after:
  %put = call i32 @putchar(i32 10)
  ret i32 0
}