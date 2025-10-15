; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @selection_sort(i32* noundef, i32 noundef)
declare dllimport i32 @printf(i8* noundef, ...)

define dso_local i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  %arr0ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4ptr, align 4
  store i32 5, i32* %n, align 4
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  call void @selection_sort(i32* noundef %arrdecay, i32 noundef %nval)
  %fmt = getelementptr inbounds [15 x i8], [15 x i8]* @_Format, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* noundef %fmt)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %ival = load i32, i32* %i, align 4
  %ncur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %ival, %ncur
  br i1 %cmp, label %body, label %end

body:
  %iidx = load i32, i32* %i, align 4
  %idxext = sext i32 %iidx to i64
  %elemptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idxext
  %elem = load i32, i32* %elemptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* noundef %fmt2, i32 noundef %elem)
  %inc = add nsw i32 %iidx, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

end:
  ret i32 0
}