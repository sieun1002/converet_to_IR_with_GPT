; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = constant [27 x i8] c"Element found at index %d\0A\00"
@Buffer = constant [18 x i8] c"Element not found\00"

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [5 x i32], align 16
  %size = alloca i32, align 4
  %target = alloca i32, align 4
  %result = alloca i32, align 4
  %0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 0
  store i32 5, i32* %0, align 4
  %1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 1
  store i32 3, i32* %1, align 4
  %2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 2
  store i32 8, i32* %2, align 4
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 3
  store i32 4, i32* %3, align 4
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 4
  store i32 2, i32* %4, align 4
  store i32 5, i32* %size, align 4
  store i32 4, i32* %target, align 4
  %5 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 0
  %6 = load i32, i32* %size, align 4
  %7 = load i32, i32* %target, align 4
  %8 = call i32 @linear_search(i32* %5, i32 %6, i32 %7)
  store i32 %8, i32* %result, align 4
  %9 = load i32, i32* %result, align 4
  %10 = icmp eq i32 %9, -1
  br i1 %10, label %notfound, label %found

found:
  %11 = load i32, i32* %result, align 4
  %12 = getelementptr inbounds [27 x i8], [27 x i8]* @_Format, i32 0, i32 0
  %13 = call i32 (i8*, ...) @printf(i8* %12, i32 %11)
  br label %end

notfound:
  %14 = getelementptr inbounds [18 x i8], [18 x i8]* @Buffer, i32 0, i32 0
  %15 = call i32 @puts(i8* %14)
  br label %end

end:
  ret i32 0
}