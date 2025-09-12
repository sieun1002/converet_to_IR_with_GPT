; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x144B
; Intent: print an array before/after calling heap_sort (confidence=0.90). Evidence: calls to heap_sort and printf loops over array elements.
; Preconditions: none
; Postconditions: prints the original and sorted arrays to stdout

@format = private unnamed_addr constant [17 x i8] c"Original array: \00"
@aD = private unnamed_addr constant [4 x i8] c"%d \00"
@byte_2011 = private unnamed_addr constant [15 x i8] c"Sorted array: \00"

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; allocate local array
  %arr = alloca [9 x i32], align 16

  ; initialize array: 7,3,9,1,4,8,2,6,5
  %a0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %a0, align 4
  %a1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %a1, align 4
  %a2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %a2, align 4
  %a3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %a3, align 4
  %a4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %a4, align 4
  %a5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %a5, align 4
  %a6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %a6, align 4
  %a7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %a7, align 4
  %a8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %a8, align 4

  ; printf("Original array: ")
  %fmt0 = getelementptr inbounds [17 x i8], [17 x i8]* @format, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt0)

  ; for i = 0 .. 8: printf("%d ", arr[i])
  br label %loop1

loop1:                                            ; preds = %entry, %loop1.body
  %i1 = phi i64 [ 0, %entry ], [ %i1.next, %loop1.body ]
  %cond1 = icmp ult i64 %i1, 9
  br i1 %cond1, label %loop1.body, label %loop1.end

loop1.body:                                       ; preds = %loop1
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1
  %val1 = load i32, i32* %elem.ptr1, align 4
  %fmt_num = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_num, i32 %val1)
  %i1.next = add nuw nsw i64 %i1, 1
  br label %loop1

loop1.end:                                        ; preds = %loop1
  call i32 @putchar(i32 10)

  ; heap_sort(arr, 9)
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.ptr, i64 9)

  ; printf("Sorted array: ")
  %fmt1 = getelementptr inbounds [15 x i8], [15 x i8]* @byte_2011, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt1)

  ; for i = 0 .. 8: printf("%d ", arr[i])
  br label %loop2

loop2:                                            ; preds = %loop1.end, %loop2.body
  %i2 = phi i64 [ 0, %loop1.end ], [ %i2.next, %loop2.body ]
  %cond2 = icmp ult i64 %i2, 9
  br i1 %cond2, label %loop2.body, label %loop2.end

loop2.body:                                       ; preds = %loop2
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2
  %val2 = load i32, i32* %elem.ptr2, align 4
  %fmt_num2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_num2, i32 %val2)
  %i2.next = add nuw nsw i64 %i2, 1
  br label %loop2

loop2.end:                                        ; preds = %loop2
  call i32 @putchar(i32 10)
  ret i32 0
}