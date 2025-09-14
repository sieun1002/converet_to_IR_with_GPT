; ModuleID = 'main_module'
source_filename = "main_module"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @merge_sort(i32* noundef, i64 noundef)
declare i32 @_printf(i8* noundef, ...)
declare i32 @_putchar(i32 noundef)
declare i64 @__stack_chk_guard()
declare void @__stack_chk_fail() noreturn

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [10 x i32], align 16
  %idx = alloca i64, align 8
  %len = alloca i64, align 8
  %canary = alloca i64, align 8

  ; stack protector setup
  %guard.load = call i64 @__stack_chk_guard()
  store i64 %guard.load, i64* %canary, align 8

  ; initialize array: [9,1,5,3,7,2,8,6,4,0]
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 4
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 5, i32* %arr2, align 4
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 7, i32* %arr4, align 4
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 8, i32* %arr6, align 4
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4, i32* %arr8, align 4
  %arr9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 0, i32* %arr9, align 4

  store i64 10, i64* %len, align 8

  ; call merge_sort(arr, len)
  %len.val = load i64, i64* %len, align 8
  call void @merge_sort(i32* noundef %arr0, i64 noundef %len.val)

  ; for (i = 0; i < len; i++) printf("%d ", arr[i]);
  store i64 0, i64* %idx, align 8
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = load i64, i64* %idx, align 8
  %len.cur = load i64, i64* %len, align 8
  %cond = icmp ult i64 %i, %len.cur
  br i1 %cond, label %body, label %after

body:                                             ; preds = %loop
  %elt.ptr = getelementptr inbounds i32, i32* %arr0, i64 %i
  %elt = load i32, i32* %elt.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @_printf(i8* noundef %fmt.ptr, i32 noundef %elt)
  %inc = add i64 %i, 1
  store i64 %inc, i64* %idx, align 8
  br label %loop

after:                                            ; preds = %loop
  %call.putchar = call i32 @_putchar(i32 noundef 10)

  ; stack protector check
  %canary.cur = load i64, i64* %canary, align 8
  %guard.now = call i64 @__stack_chk_guard()
  %ok = icmp eq i64 %canary.cur, %guard.now
  br i1 %ok, label %ret, label %stkfail

stkfail:                                          ; preds = %after
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after
  ret i32 0
}