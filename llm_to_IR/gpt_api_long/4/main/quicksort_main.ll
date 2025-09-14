; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1325
; Intent: Sort 10 integers using quick_sort and print them (confidence=0.92). Evidence: call to quick_sort with lo=0/hi=n-1; loop printing with "%d ".
; Preconditions:
; - quick_sort expects: (i32* a, i64 lo, i64 hi), inclusive hi.
; Postconditions:
; - Prints the (sorted) array followed by a newline; returns 0.

@.str = private unnamed_addr constant [4 x i8] c"%d \00"
@__stack_chk_guard = external global i64

declare void @quick_sort(i32*, i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard0 = load i64, i64* @__stack_chk_guard
  %arr = alloca [10 x i32], align 16
  %baseptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  ; initialize array: {9,1,5,3,7,2,8,6,4,0}
  store i32 9,  i32* %baseptr, align 4
  %idx1 = getelementptr inbounds i32, i32* %baseptr, i64 1
  store i32 1,  i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %baseptr, i64 2
  store i32 5,  i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %baseptr, i64 3
  store i32 3,  i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %baseptr, i64 4
  store i32 7,  i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %baseptr, i64 5
  store i32 2,  i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %baseptr, i64 6
  store i32 8,  i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %baseptr, i64 7
  store i32 6,  i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %baseptr, i64 8
  store i32 4,  i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %baseptr, i64 9
  store i32 0,  i32* %idx9, align 4
  %n = add i64 0, 10
  %cond = icmp ugt i64 %n, 1
  br i1 %cond, label %do_sort, label %loop.init

do_sort:
  %hi = add i64 %n, -1
  call void @quick_sort(i32* %baseptr, i64 0, i64 %hi)
  br label %loop.init

loop.init:
  br label %loop.cond

loop.cond:
  %i = phi i64 [ 0, %loop.init ], [ %i.next, %loop.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %elem.ptr = getelementptr inbounds i32, i32* %baseptr, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %_ = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  br label %loop.inc

loop.inc:
  %i.next = add i64 %i, 1
  br label %loop.cond

loop.end:
  %__ = call i32 @putchar(i32 10)
  br label %check

check:
  %guard1 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard0, %guard1
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}