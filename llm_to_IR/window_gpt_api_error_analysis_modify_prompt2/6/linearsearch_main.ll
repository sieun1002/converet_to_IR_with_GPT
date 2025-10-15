; ModuleID: linear_search_main
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@_Format = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@Buffer = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %var4 = alloca i32, align 4
  %var8 = alloca i32, align 4
  %idx = alloca i32, align 4

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

  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %val_var4 = load i32, i32* %var4, align 4
  %val_var8 = load i32, i32* %var8, align 4
  %call = call i32 @linear_search(i32* %arrptr, i32 %val_var4, i32 %val_var8)
  store i32 %call, i32* %idx, align 4

  %ret = load i32, i32* %idx, align 4
  %cmp = icmp eq i32 %ret, -1
  br i1 %cmp, label %notfound, label %found

found:                                            ; preds = %entry
  %ret2 = load i32, i32* %idx, align 4
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @_Format, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %ret2)
  br label %end

notfound:                                         ; preds = %entry
  %bufptr = getelementptr inbounds [18 x i8], [18 x i8]* @Buffer, i64 0, i64 0
  %callputs = call i32 @puts(i8* %bufptr)
  br label %end

end:                                              ; preds = %found, %notfound
  ret i32 0
}