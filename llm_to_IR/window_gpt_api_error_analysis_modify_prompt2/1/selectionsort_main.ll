target triple = "x86_64-pc-windows-msvc"

@_Format = internal constant [15 x i8] c"Sorted array: \00", align 1
@aD = internal constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local void @selection_sort(i32*, i32)

define dso_local i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %i = alloca i32, align 4

  %gep0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %gep0, align 4
  %gep1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %gep2, align 4
  %gep3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %gep3, align 4
  %gep4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %gep4, align 4

  store i32 5, i32* %n, align 4

  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  call void @selection_sort(i32* %arrptr, i32 %nval)

  %fmtptr = getelementptr inbounds [15 x i8], [15 x i8]* @_Format, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmtptr)

  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i0 = load i32, i32* %i, align 4
  %n1 = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i0, %n1
  br i1 %cmp, label %body, label %done

body:
  %i1 = load i32, i32* %i, align 4
  %idxext = sext i32 %i1 to i64
  %elemaddr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idxext
  %val = load i32, i32* %elemaddr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %val)
  %i_old = load i32, i32* %i, align 4
  %i_inc = add nsw i32 %i_old, 1
  store i32 %i_inc, i32* %i, align 4
  br label %loop

done:
  ret i32 0
}