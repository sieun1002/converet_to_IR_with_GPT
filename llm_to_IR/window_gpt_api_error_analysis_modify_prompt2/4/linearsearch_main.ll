; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@Buffer = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare dso_local i32 @linear_search(i32*, i32, i32)
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @puts(i8*)

define dso_local i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %var4 = alloca i32, align 4
  %var8 = alloca i32, align 4
  %res = alloca i32, align 4

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

  store i32 5, i32* %var4, align 4
  store i32 4, i32* %var8, align 4

  %5 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %6 = load i32, i32* %var4, align 4
  %7 = load i32, i32* %var8, align 4
  %8 = call i32 @linear_search(i32* %5, i32 %6, i32 %7)
  store i32 %8, i32* %res, align 4

  %9 = load i32, i32* %res, align 4
  %10 = icmp eq i32 %9, -1
  br i1 %10, label %notfound, label %found

found:
  %11 = load i32, i32* %res, align 4
  %12 = getelementptr inbounds [27 x i8], [27 x i8]* @_Format, i64 0, i64 0
  %13 = call i32 (i8*, ...) @printf(i8* %12, i32 %11)
  br label %done

notfound:
  %14 = getelementptr inbounds [18 x i8], [18 x i8]* @Buffer, i64 0, i64 0
  %15 = call i32 @puts(i8* %14)
  br label %done

done:
  ret i32 0
}