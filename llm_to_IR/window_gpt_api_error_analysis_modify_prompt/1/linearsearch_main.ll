; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@_Format = dso_local unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@Buffer   = dso_local unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare dso_local void @__main()
declare dso_local i32 @linear_search(i32* noundef, i32 noundef, i32 noundef)
declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @puts(i8* noundef)

define dso_local i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %var4 = alloca i32, align 4
  %var8 = alloca i32, align 4
  %varc = alloca i32, align 4

  call void @__main()

  %arr0ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4ptr, align 4

  store i32 5, i32* %var4, align 4
  store i32 4, i32* %var8, align 4

  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %key = load i32, i32* %var4, align 4
  %n = load i32, i32* %var8, align 4
  %res = call i32 @linear_search(i32* %arrdecay, i32 %key, i32 %n)
  store i32 %res, i32* %varc, align 4

  %res2 = load i32, i32* %varc, align 4
  %cmp = icmp eq i32 %res2, -1
  br i1 %cmp, label %notfound, label %found

found:
  %res3 = load i32, i32* %varc, align 4
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @_Format, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %res3)
  br label %end

notfound:
  %bufptr = getelementptr inbounds [18 x i8], [18 x i8]* @Buffer, i64 0, i64 0
  %callputs = call i32 @puts(i8* %bufptr)
  br label %end

end:
  ret i32 0
}