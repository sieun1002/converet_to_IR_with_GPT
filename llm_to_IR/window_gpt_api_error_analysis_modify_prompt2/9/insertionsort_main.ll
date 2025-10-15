; ModuleID = 'main_module'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local void @insertion_sort(i32*, i64)
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %arr0ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 1
  store i32 1, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 2
  store i32 5, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 3
  store i32 3, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 4
  store i32 7, i32* %arr4ptr, align 4
  %arr5ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 5
  store i32 2, i32* %arr5ptr, align 4
  %arr6ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 6
  store i32 8, i32* %arr6ptr, align 4
  %arr7ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 7
  store i32 6, i32* %arr7ptr, align 4
  %arr8ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 8
  store i32 4, i32* %arr8ptr, align 4
  %arr9ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 9
  store i32 0, i32* %arr9ptr, align 4
  store i64 10, i64* %len, align 8
  %len.load = load i64, i64* %len, align 8
  call void @insertion_sort(i32* %arr0ptr, i64 %len.load)
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %len, align 8
  %cond = icmp ult i64 %i.cur, %len.cur
  br i1 %cond, label %body, label %done

body:
  %idx = load i64, i64* %i, align 8
  %elt.ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 %idx
  %val = load i32, i32* %elt.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %val)
  %inc = add i64 %idx, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

done:
  %pcall = call i32 @putchar(i32 10)
  ret i32 0
}