; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local void @selection_sort(i32*, i32)
declare dso_local i32 @printf(i8*, ...)

define dso_local i32 @main() {
entry:
  %array = alloca [5 x i32], align 16
  %len = alloca i32, align 4
  %i = alloca i32, align 4
  %array_gep0 = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 0
  store i32 29, i32* %array_gep0, align 4
  %array_gep1 = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 1
  store i32 10, i32* %array_gep1, align 4
  %array_gep2 = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 2
  store i32 14, i32* %array_gep2, align 4
  %array_gep3 = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 3
  store i32 37, i32* %array_gep3, align 4
  %array_gep4 = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 4
  store i32 13, i32* %array_gep4, align 4
  store i32 5, i32* %len, align 4
  %array_ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 0
  %len_val = load i32, i32* %len, align 4
  call void @selection_sort(i32* %array_ptr, i32 %len_val)
  %fmt = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i_val = load i32, i32* %i, align 4
  %len_val2 = load i32, i32* %len, align 4
  %cmp = icmp slt i32 %i_val, %len_val2
  br i1 %cmp, label %body, label %end

body:
  %i_val2 = load i32, i32* %i, align 4
  %idxext = sext i32 %i_val2 to i64
  %elem_ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 %idxext
  %elem = load i32, i32* %elem_ptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %elem)
  %i_val3 = load i32, i32* %i, align 4
  %inc = add nsw i32 %i_val3, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

end:
  ret i32 0
}