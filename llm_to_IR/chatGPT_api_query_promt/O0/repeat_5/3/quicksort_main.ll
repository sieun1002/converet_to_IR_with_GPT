; ModuleID = 'recovered.ll'
source_filename = "recovered"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32* nocapture, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [10 x i32], align 16

  ; initialize array: {9,1,5,3,7,2,8,6,4,0}
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 16
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 8
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 16
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 8
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 16
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4

  ; n = 10
  %n = add i64 0, 10

  ; if (n > 1) quick_sort(arr, 0, n-1)
  %cmp = icmp ugt i64 %n, 1
  br i1 %cmp, label %sort, label %after_sort

sort:
  %high64 = add i64 %n, -1
  %high32 = trunc i64 %high64 to i32
  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %arrdecay, i32 0, i32 %high32)
  br label %after_sort

after_sort:
  ; for (i = 0; i < n; ++i) printf("%d ", arr[i]);
  br label %loop

loop:
  %i = phi i64 [ 0, %after_sort ], [ %i.next, %body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %body, label %done

body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %i.next = add i64 %i, 1
  br label %loop

done:
  call i32 @putchar(i32 10)
  ret i32 0
}