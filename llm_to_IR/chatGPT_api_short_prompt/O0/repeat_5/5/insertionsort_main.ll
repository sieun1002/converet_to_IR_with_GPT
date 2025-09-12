; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1247
; Intent: Fill an array, sort it with insertion_sort, and print elements (confidence=0.93). Evidence: call to insertion_sort with array and length; loop printing "%d " followed by putchar('\n')
; Preconditions: None
; Postconditions: Prints the (sorted) array elements and a newline

@format = private unnamed_addr constant [4 x i8] c"%d \00"
@__stack_chk_guard = external global i64

; Only the necessary external declarations:
declare void @insertion_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; stack canary
  %canary.slot = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %g0 = load i64, i64* @__stack_chk_guard
  store i64 %g0, i64* %canary.slot, align 8

  ; initialize array contents
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9,  i32* %arr.base, align 4
  %p1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1,  i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 5,  i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 3,  i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7,  i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 2,  i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 8,  i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6,  i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4,  i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0,  i32* %p9, align 4

  ; n = 10
  store i64 10, i64* %n, align 8

  ; call insertion_sort(arr, n)
  %arr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  call void @insertion_sort(i32* %arr.ptr, i64 %n.val)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %n.cur = load i64, i64* %n, align 8
  %lt = icmp ult i64 %i.cur, %n.cur
  br i1 %lt, label %loop.body, label %loop.end

loop.body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.cur
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)

  ; stack canary check and return 0
  %g1 = load i64, i64* @__stack_chk_guard
  %g.saved = load i64, i64* %canary.slot, align 8
  %ok = icmp eq i64 %g.saved, %g1
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}