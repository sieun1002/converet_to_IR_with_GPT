; ModuleID = 'main.ll'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @selection_sort(i32* noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)

define i32 @main(i32 %argc, i8** %argv) local_unnamed_addr #0 {
entry:
  %array = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %i = alloca i32, align 4

  ; initialize array elements: {29, 10, 14, 37, 13}
  %0 = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 0
  store i32 29, i32* %0, align 4
  %1 = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 1
  store i32 10, i32* %1, align 4
  %2 = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 2
  store i32 14, i32* %2, align 4
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 3
  store i32 37, i32* %3, align 4
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 4
  store i32 13, i32* %4, align 4

  ; n = 5
  store i32 5, i32* %n, align 4

  ; call selection_sort(&array[0], n)
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  call void @selection_sort(i32* noundef %arrdecay, i32 noundef %nval)

  ; printf("Sorted array: ")
  %fmt_sorted = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %fmt_sorted)

  ; i = 0
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.cur = load i32, i32* %i, align 4
  %n.cur = load i32, i32* %n, align 4
  %cond = icmp slt i32 %i.cur, %n.cur
  br i1 %cond, label %body, label %done

body:
  %idx = sext i32 %i.cur to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 %idx
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt_d = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %fmt_d, i32 noundef %elem)
  %inc = add nsw i32 %i.cur, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

done:
  ret i32 0
}

attributes #0 = { sspstrong uwtable }