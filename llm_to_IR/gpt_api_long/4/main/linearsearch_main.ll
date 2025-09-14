; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x11D7
; Intent: Create an int array, invoke linear_search(arr, n, target), and print result (confidence=0.95). Evidence: call to linear_search with (int*, int, int); check for -1 and call printf/puts.

@format = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@s = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [5 x i32], align 16
  %0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %0, align 4
  %1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %1, align 4
  %2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %2, align 4
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %3, align 4
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %4, align 4
  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %idx = call i32 @linear_search(i32* %arrptr, i32 5, i32 4)
  %cmp = icmp eq i32 %idx, -1
  br i1 %cmp, label %notfound, label %found

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @format, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %idx)
  br label %ret

notfound:
  %sptr = getelementptr inbounds [18 x i8], [18 x i8]* @s, i64 0, i64 0
  %callputs = call i32 @puts(i8* %sptr)
  br label %ret

ret:
  ret i32 0
}