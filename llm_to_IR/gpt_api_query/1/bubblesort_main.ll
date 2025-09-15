; ModuleID = 'main.ll'
source_filename = "main.c"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

@__stack_chk_guard = external thread_local global i64
declare void @__stack_chk_fail() local_unnamed_addr
declare void @bubble_sort(i32*, i64) local_unnamed_addr
declare i32 @printf(i8*, ...) local_unnamed_addr
declare i32 @putchar(i32) local_unnamed_addr

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  ; stack protector prologue
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary, align 8

  ; initialize array elements
  %arr0.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0.ptr, align 4
  %arr1.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1.ptr, align 4
  %arr2.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2.ptr, align 4
  %arr3.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3.ptr, align 4
  %arr4.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4.ptr, align 4
  %arr5.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5.ptr, align 4
  %arr6.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6.ptr, align 4
  %arr7.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7.ptr, align 4
  %arr8.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8.ptr, align 4
  %arr9.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9.ptr, align 4

  ; len = 10
  store i64 10, i64* %len, align 8

  ; call bubble_sort(&arr[0], len)
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %len.val = load i64, i64* %len, align 8
  call void @bubble_sort(i32* %arr.base, i64 %len.val)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                           ; preds = %loop.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                           ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %i.cur
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:                                            ; preds = %loop.cond
  %call.putchar = call i32 @putchar(i32 10)

  ; epilogue: return 0 with stack protector check
  %retv = add i32 0, 0

  %canary.load = load i64, i64* %canary, align 8
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %canary.ok = icmp eq i64 %canary.load, %guard2
  br i1 %canary.ok, label %return, label %stack.fail

stack.fail:                                          ; preds = %loop.end
  call void @__stack_chk_fail()
  unreachable

return:                                              ; preds = %loop.end
  ret i32 %retv
}