; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@Buffer = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32* noundef, i32 noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @puts(i8* noundef)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %len = alloca i32, align 4
  %target = alloca i32, align 4
  %idx = alloca i32, align 4

  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4, align 4

  store i32 5, i32* %len, align 4
  store i32 4, i32* %target, align 4

  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %lenval = load i32, i32* %len, align 4
  %tgtval = load i32, i32* %target, align 4
  %call = call i32 @linear_search(i32* noundef %arrptr, i32 noundef %lenval, i32 noundef %tgtval)
  store i32 %call, i32* %idx, align 4

  %idxv = load i32, i32* %idx, align 4
  %cmp = icmp eq i32 %idxv, -1
  br i1 %cmp, label %notfound, label %found

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @_Format, i64 0, i64 0
  %idxv2 = load i32, i32* %idx, align 4
  %p = call i32 (i8*, ...) @printf(i8* noundef %fmtptr, i32 noundef %idxv2)
  br label %ret

notfound:
  %bufptr = getelementptr inbounds [18 x i8], [18 x i8]* @Buffer, i64 0, i64 0
  %q = call i32 @puts(i8* noundef %bufptr)
  br label %ret

ret:
  ret i32 0
}