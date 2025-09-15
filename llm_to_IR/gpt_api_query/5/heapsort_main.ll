; ModuleID = 'main.ll'
source_filename = "main"

@__stack_chk_guard = external global i64
@format       = private unnamed_addr constant [9 x i8]  c"Before: \00", align 1
@byte_2011    = private unnamed_addr constant [8 x i8]  c"After: \00",  align 1
@.str.int     = private unnamed_addr constant [4 x i8]  c"%d \00",      align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail() noreturn
declare void @heap_sort(i32*, i64)

define dso_local i32 @main() {
entry:
  %canary.slot = alloca i64, align 8
  %arr         = alloca [9 x i32], align 16
  %i           = alloca i64, align 8
  %j           = alloca i64, align 8
  %n           = alloca i64, align 8

  ; stack protector prologue
  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %canary.slot, align 8

  ; initialize array: {7,3,9,1,4,8,2,6,5}
  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %p0, align 16
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %p2, align 8
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %p4, align 16
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 8
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %p8, align 16

  ; n = 9
  store i64 9, i64* %n, align 8

  ; printf(format)
  %fmt0 = getelementptr inbounds [9 x i8], [9 x i8]* @format, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt0)

  ; for (i = 0; i < n; ++i) printf("%d ", arr[i]);
  store i64 0, i64* %i, align 8
  br label %loop.pre

loop.pre:
  %i.cur = load i64, i64* %i, align 8
  %n.cur = load i64, i64* %n, align 8
  %cmp0  = icmp ult i64 %i.cur, %n.cur
  br i1 %cmp0, label %loop.body, label %loop.end

loop.body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.cur
  %elem     = load i32, i32* %elem.ptr, align 4
  %fmt.int  = getelementptr inbounds [4 x i8], [4 x i8]* @.str.int, i64 0, i64 0
  %call1    = call i32 (i8*, ...) @printf(i8* %fmt.int, i32 %elem)
  %i.next   = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.pre

loop.end:
  ; putchar('\n')
  %nl0 = call i32 @putchar(i32 10)

  ; heap_sort(arr, n)
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n.now    = load i64, i64* %n, align 8
  call void @heap_sort(i32* %arr.base, i64 %n.now)

  ; printf(after)
  %fmt1 = getelementptr inbounds [8 x i8], [8 x i8]* @byte_2011, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt1)

  ; for (j = 0; j < n; ++j) printf("%d ", arr[j]);
  store i64 0, i64* %j, align 8
  br label %loop2.pre

loop2.pre:
  %j.cur = load i64, i64* %j, align 8
  %n2.cur = load i64, i64* %n, align 8
  %cmp1  = icmp ult i64 %j.cur, %n2.cur
  br i1 %cmp1, label %loop2.body, label %loop2.end

loop2.body:
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.cur
  %elem2     = load i32, i32* %elem2.ptr, align 4
  %fmt.int2  = getelementptr inbounds [4 x i8], [4 x i8]* @.str.int, i64 0, i64 0
  %call3     = call i32 (i8*, ...) @printf(i8* %fmt.int2, i32 %elem2)
  %j.next    = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2.pre

loop2.end:
  ; putchar('\n')
  %nl1 = call i32 @putchar(i32 10)

  ; stack protector epilogue
  %canary.cur = load i64, i64* %canary.slot, align 8
  %guard.now  = load i64, i64* @__stack_chk_guard
  %ok         = icmp eq i64 %canary.cur, %guard.now
  br i1 %ok, label %ret, label %stack_fail

stack_fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}