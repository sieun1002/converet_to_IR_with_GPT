; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1325
; Intent: Sort a fixed int array with quick_sort and print elements (confidence=0.95). Evidence: call to quick_sort with low/high indices; printf of "%d ".
; Preconditions: Expects C-ABI quick_sort(int* a, int lo, int hi).
; Postconditions: Prints 10 integers followed by a newline; returns 0.

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Only the needed extern declarations:
declare void @quick_sort(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  ; Initialize array: 9,1,5,3,7,2,8,6,4,0
  %elt0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %elt0, align 4
  %elt1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %elt1, align 4
  %elt2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %elt2, align 4
  %elt3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %elt3, align 4
  %elt4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %elt4, align 4
  %elt5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %elt5, align 4
  %elt6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %elt6, align 4
  %elt7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %elt7, align 4
  %elt8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %elt8, align 4
  %elt9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %elt9, align 4

  %len = add i64 0, 10
  %cond = icmp ule i64 %len, 1
  br i1 %cond, label %after_sort, label %do_sort

do_sort:
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %base, i32 0, i32 9)
  br label %after_sort

after_sort:
  br label %loop.head

loop.head:
  %i = phi i64 [ 0, %after_sort ], [ %i.next, %loop.body_end ]
  %cmp = icmp ult i64 %i, %len
  br i1 %cmp, label %loop.body, label %after_loop

loop.body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %val)
  br label %loop.body_end

loop.body_end:
  %i.next = add i64 %i, 1
  br label %loop.head

after_loop:
  %putc = call i32 @putchar(i32 10)
  br label %stack_chk

stack_chk:
  ; Simulated stack canary check path
  %saved = add i64 0, 0
  %cur = add i64 0, 0
  %ok = icmp eq i64 %saved, %cur
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  br label %ret

ret:
  ret i32 0
}