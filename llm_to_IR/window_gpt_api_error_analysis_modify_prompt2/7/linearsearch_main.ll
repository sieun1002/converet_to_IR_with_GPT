; Target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

@_Format = internal constant [27 x i8] c"Element found at index %d\0A\00"
@Buffer  = internal constant [18 x i8] c"Element not found\00"

declare dso_local i32 @linear_search(i32*, i32, i32)
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @puts(i8*)

define dso_local i32 @main() {
entry:
  %arr = alloca [5 x i32], align 4
  %var8 = alloca i32, align 4
  %var4 = alloca i32, align 4
  %varC = alloca i32, align 4

  %p0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 0
  store i32 5, i32* %p0, align 4
  %p1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 2
  store i32 8, i32* %p2, align 4
  %p3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 3
  store i32 4, i32* %p3, align 4
  %p4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 4
  store i32 2, i32* %p4, align 4

  store i32 5, i32* %var4, align 4
  store i32 4, i32* %var8, align 4

  %base = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 0
  %key = load i32, i32* %var4, align 4
  %n = load i32, i32* %var8, align 4
  %idx = call i32 @linear_search(i32* %base, i32 %key, i32 %n)
  store i32 %idx, i32* %varC, align 4

  %res = load i32, i32* %varC, align 4
  %isneg1 = icmp eq i32 %res, -1
  br i1 %isneg1, label %notfound, label %found

found:
  %res2 = load i32, i32* %varC, align 4
  %fmt = getelementptr inbounds [27 x i8], [27 x i8]* @_Format, i32 0, i32 0
  %call_printf = call i32 (i8*, ...) @printf(i8* %fmt, i32 %res2)
  br label %done

notfound:
  %msg = getelementptr inbounds [18 x i8], [18 x i8]* @Buffer, i32 0, i32 0
  %call_puts = call i32 @puts(i8* %msg)
  br label %done

done:
  ret i32 0
}