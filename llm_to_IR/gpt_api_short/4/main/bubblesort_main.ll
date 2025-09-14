; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x128B
; Intent: sort and print an integer array (confidence=0.90). Evidence: call to bubble_sort with local int array; loop printing each element with "%d " followed by putchar('\n')
; Preconditions: bubble_sort(int*, size_t) must be available
; Postconditions: prints the sorted array elements and a trailing newline; returns 0

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)
declare void @bubble_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16

  ; Initialize array: {9,1,5,3,7,2,8,6,4,0}
  %a0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %a0, align 4
  %a1 = getelementptr inbounds i32, i32* %a0, i64 1
  store i32 1, i32* %a1, align 4
  %a2 = getelementptr inbounds i32, i32* %a0, i64 2
  store i32 5, i32* %a2, align 4
  %a3 = getelementptr inbounds i32, i32* %a0, i64 3
  store i32 3, i32* %a3, align 4
  %a4 = getelementptr inbounds i32, i32* %a0, i64 4
  store i32 7, i32* %a4, align 4
  %a5 = getelementptr inbounds i32, i32* %a0, i64 5
  store i32 2, i32* %a5, align 4
  %a6 = getelementptr inbounds i32, i32* %a0, i64 6
  store i32 8, i32* %a6, align 4
  %a7 = getelementptr inbounds i32, i32* %a0, i64 7
  store i32 6, i32* %a7, align 4
  %a8 = getelementptr inbounds i32, i32* %a0, i64 8
  store i32 4, i32* %a8, align 4
  %a9 = getelementptr inbounds i32, i32* %a0, i64 9
  store i32 0, i32* %a9, align 4

  ; Call bubble_sort(arr, 10)
  call void @bubble_sort(i32* %a0, i64 10)

  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop_body_end ]
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %loop_body, label %after_loop

loop_body:
  %elem.ptr = getelementptr inbounds i32, i32* %a0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %i.next = add nuw nsw i64 %i, 1
  br label %loop_body_end

loop_body_end:
  br label %loop

after_loop:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}