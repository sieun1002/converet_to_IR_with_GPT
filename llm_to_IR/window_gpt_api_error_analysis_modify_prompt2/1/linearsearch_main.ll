target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00"
@Buffer = private unnamed_addr constant [18 x i8] c"Element not found\00"

declare i32 @linear_search(i32* noundef, i32 noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @puts(i8* noundef)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %var_8 = alloca i32, align 4
  %var_4 = alloca i32, align 4
  %var_C = alloca i32, align 4

  %p0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %p0, align 4
  %p1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %p2, align 4
  %p3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %p3, align 4
  %p4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %p4, align 4

  store i32 5, i32* %var_4, align 4
  store i32 4, i32* %var_8, align 4

  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %len = load i32, i32* %var_8, align 4
  %tgt = load i32, i32* %var_4, align 4
  %res = call i32 @linear_search(i32* noundef %arrptr, i32 noundef %tgt, i32 noundef %len)
  store i32 %res, i32* %var_C, align 4

  %res2 = load i32, i32* %var_C, align 4
  %cmp = icmp eq i32 %res2, -1
  br i1 %cmp, label %notfound, label %found

found:
  %idx = load i32, i32* %var_C, align 4
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @_Format, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* noundef %fmtptr, i32 noundef %idx)
  br label %done

notfound:
  %bufptr = getelementptr inbounds [18 x i8], [18 x i8]* @Buffer, i64 0, i64 0
  %callputs = call i32 @puts(i8* noundef %bufptr)
  br label %done

done:
  ret i32 0
}