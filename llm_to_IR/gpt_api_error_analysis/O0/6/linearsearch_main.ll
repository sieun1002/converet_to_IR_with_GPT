; ModuleID = 'main'
source_filename = "main.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.notfound = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr0.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0.ptr, align 4
  %arr1.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1.ptr, align 4
  %arr2.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr2.ptr, align 4
  %arr3.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr3.ptr, align 4
  %arr4.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4.ptr, align 4
  %call.idx = call i32 @linear_search(i32* %arr0.ptr, i32 5, i32 4)
  %cmp.notneg1 = icmp ne i32 %call.idx, -1
  br i1 %cmp.notneg1, label %found, label %notfound

found:
  %fmt.ptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str.found, i64 0, i64 0
  %printf.call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %call.idx)
  br label %ret

notfound:
  %msg.ptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.notfound, i64 0, i64 0
  %puts.call = call i32 @puts(i8* %msg.ptr)
  br label %ret

ret:
  ret i32 0
}