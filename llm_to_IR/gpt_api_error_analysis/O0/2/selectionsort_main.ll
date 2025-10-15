; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@.str = private constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private constant [4 x i8] c"%d \00", align 1

declare void @selection_sort(i32* noundef, i32 noundef)
declare i32 @printf(i8*, ...)

define i32 @main() local_unnamed_addr sspstrong {
entry:
  %array = alloca [5 x i32], align 16
  %i = alloca i32, align 4
  %array.elem0.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 0
  store i32 29, i32* %array.elem0.ptr
  %array.elem1.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 1
  store i32 10, i32* %array.elem1.ptr
  %array.elem2.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 2
  store i32 14, i32* %array.elem2.ptr
  %array.elem3.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 3
  store i32 37, i32* %array.elem3.ptr
  %array.elem4.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 4
  store i32 13, i32* %array.elem4.ptr
  %arraydecay = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 0
  call void @selection_sort(i32* noundef %arraydecay, i32 noundef 5)
  %p.str = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* noundef %p.str)
  store i32 0, i32* %i
  br label %loop

loop:
  %iv = load i32, i32* %i
  %cmp = icmp slt i32 %iv, 5
  br i1 %cmp, label %body, label %done

body:
  %idx.ext = sext i32 %iv to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr
  %p.str1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* noundef %p.str1, i32 noundef %elem)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i
  br label %loop

done:
  ret i32 0
}