; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [4 x i8] c"%d \00"

declare void @heap_sort(i32* noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)

define i32 @main() {
entry:
  %arr = alloca [9 x i32]
  %arr.elem0.ptr = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr.elem0.ptr, align 4
  %arr.elem1.ptr = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr.elem1.ptr, align 4
  %arr.elem2.ptr = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr.elem2.ptr, align 4
  %arr.elem3.ptr = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr.elem3.ptr, align 4
  %arr.elem4.ptr = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr.elem4.ptr, align 4
  %arr.elem5.ptr = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr.elem5.ptr, align 4
  %arr.elem6.ptr = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr.elem6.ptr, align 4
  %arr.elem7.ptr = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.elem7.ptr, align 4
  %arr.elem8.ptr = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr.elem8.ptr, align 4
  %arr.base = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.base, i64 9)
  br label %cond

cond:
  %i = phi i64 [ 0, %entry ], [ %i.next, %body ]
  %cmp = icmp ult i64 %i, 9
  br i1 %cmp, label %body, label %after

body:
  %elem.ptr = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %i.next = add i64 %i, 1
  br label %cond

after:
  ret i32 0
}