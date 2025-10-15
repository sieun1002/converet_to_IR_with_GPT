target triple = "x86_64-pc-windows-msvc"

@_Format = internal unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@aD = internal unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @selection_sort(i32*, i32)
declare dllimport i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %array = alloca [5 x i32], align 16
  %count = alloca i32, align 4
  %i = alloca i32, align 4
  %array0ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 0
  store i32 29, i32* %array0ptr, align 4
  %array1ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 1
  store i32 10, i32* %array1ptr, align 4
  %array2ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 2
  store i32 14, i32* %array2ptr, align 4
  %array3ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 3
  store i32 37, i32* %array3ptr, align 4
  %array4ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 4
  store i32 13, i32* %array4ptr, align 4
  store i32 5, i32* %count, align 4
  %array0ptr2 = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 0
  %countval = load i32, i32* %count, align 4
  call void @selection_sort(i32* %array0ptr2, i32 %countval)
  %fmtptr = getelementptr inbounds [15 x i8], [15 x i8]* @_Format, i64 0, i64 0
  %call1 = call i32 @printf(i8* %fmtptr)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i.curr = load i32, i32* %i, align 4
  %count.curr = load i32, i32* %count, align 4
  %cmp = icmp slt i32 %i.curr, %count.curr
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %i.curr2 = load i32, i32* %i, align 4
  %idxext = sext i32 %i.curr2 to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 %idxext
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call2 = call i32 @printf(i8* %fmtptr2, i32 %elem)
  %i.next = add nsw i32 %i.curr2, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop.cond

loop.end:
  ret i32 0
}