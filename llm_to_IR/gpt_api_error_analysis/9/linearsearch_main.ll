; ModuleID = 'linear_main'
source_filename = "linear_main.c"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %key = alloca i32, align 4
  %idx = alloca i32, align 4

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

  store i32 5, i32* %n, align 4
  store i32 4, i32* %key, align 4

  %5 = load i32, i32* %n, align 4
  %6 = load i32, i32* %key, align 4
  %7 = call i32 @linear_search(i32* %0, i32 %5, i32 %6)
  store i32 %7, i32* %idx, align 4

  %8 = load i32, i32* %idx, align 4
  %9 = icmp eq i32 %8, -1
  br i1 %9, label %notfound, label %found

found:
  %10 = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %11 = load i32, i32* %idx, align 4
  %12 = call i32 (i8*, ...) @printf(i8* %10, i32 %11)
  br label %end

notfound:
  %13 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %14 = call i32 @puts(i8* %13)
  br label %end

end:
  ret i32 0
}