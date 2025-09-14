; Source: recovered from disassembly
; Target: LLVM 14, x86_64 Linux

source_filename = "recovered.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local void @bubble_sort(i32* noundef, i64 noundef)
declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8

  ; initialize array: {9,1,5,3,7,2,8,6,4,0}
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 16
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2, align 8
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4, align 16
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6, align 8
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 16
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9, align 4

  ; call bubble_sort(arr, 10)
  %arr_base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @bubble_sort(i32* noundef %arr_base, i64 noundef 10)

  ; for (i = 0; i < 10; ++i) printf("%d ", arr[i]);
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.val = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i.val, 10
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr, i32 %elem)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  %call.putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}