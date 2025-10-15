; ModuleID = 'main_module'
target triple = "x86_64-pc-windows-msvc"

@Format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local void @heap_sort(i32* noundef, i64 noundef)
declare dso_local i32 @printf(i8* noundef, ...)

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %arr0ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4ptr, align 4
  %arr5ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5ptr, align 4
  %arr6ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6ptr, align 4
  %arr7ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7ptr, align 4
  %arr8ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8ptr, align 4
  store i64 9, i64* %n, align 8
  %decay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %nval = load i64, i64* %n, align 8
  call void @heap_sort(i32* noundef %decay, i64 noundef %nval)
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %n.cur = load i64, i64* %n, align 8
  %cmp = icmp ult i64 %i.cur, %n.cur
  br i1 %cmp, label %loop.body, label %after

loop.body:
  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %elem.ptr = getelementptr inbounds i32, i32* %base, i64 %i.cur
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @Format, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr, i32 noundef %elem)
  %inc = add i64 %i.cur, 1
  store i64 %inc, i64* %i, align 8
  br label %loop.cond

after:
  ret i32 0
}