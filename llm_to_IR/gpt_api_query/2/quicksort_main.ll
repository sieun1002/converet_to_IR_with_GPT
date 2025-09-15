; ModuleID = 'recovered.ll'
source_filename = "recovered.c"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external thread_local global i64

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @quick_sort(i32*, i32, i64)
declare void @__stack_chk_fail()

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  %guard.init = load i64, i64* @__stack_chk_guard
  store i64 %guard.init, i64* %canary.slot, align 8

  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4

  store i64 10, i64* %len, align 8

  %lenv = load i64, i64* %len, align 8
  %cond = icmp ugt i64 %lenv, 1
  br i1 %cond, label %do_sort, label %after_sort

do_sort:
  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %right = add i64 %lenv, -1
  call void @quick_sort(i32* %arrdecay, i32 0, i64 %right)
  br label %after_sort

after_sort:
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %len, align 8
  %cmp.lt = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp.lt, label %print, label %done

print:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.cur
  %elem.val = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem.val)
  %inc = add i64 %i.cur, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

done:
  call i32 @putchar(i32 10)
  %guard.now = load i64, i64* @__stack_chk_guard
  %guard.saved = load i64, i64* %canary.slot, align 8
  %ok = icmp eq i64 %guard.saved, %guard.now
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  br label %ret

ret:
  ret i32 0
}