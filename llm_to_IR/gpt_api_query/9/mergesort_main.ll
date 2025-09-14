; ModuleID = 'main_from_asm'
target triple = "x86_64-pc-linux-gnu"

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external thread_local global i64

declare void @merge_sort(i32* nocapture, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail() noreturn

define dso_local i32 @main() sspstrong {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8

  ; stack canary setup
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary, align 8

  ; initialize array: {9,1,5,3,7,2,8,6,4,0}
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 4
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9, align 4

  ; n = 10
  store i64 10, i64* %n, align 8

  ; call merge_sort(&arr[0], n)
  %arr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  call void @merge_sort(i32* %arr.ptr, i64 %n.val)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.cur = load i64, i64* %i, align 8
  %n.cur = load i64, i64* %n, align 8
  %cond = icmp ult i64 %i.cur, %n.cur
  br i1 %cond, label %body, label %done

body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.cur
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop

done:
  %call.putchar = call i32 @putchar(i32 10)

  ; stack canary check
  %guard.load.end = load i64, i64* @__stack_chk_guard, align 8
  %canary.saved = load i64, i64* %canary, align 8
  %canary.ok = icmp eq i64 %canary.saved, %guard.load.end
  br i1 %canary.ok, label %ret, label %canary.fail

canary.fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}