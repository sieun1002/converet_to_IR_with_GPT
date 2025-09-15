; ModuleID = 'main.ll'
source_filename = "main"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare void @__stack_chk_fail() nounwind
declare void @bubble_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  ; stack protector setup
  %canary.slot = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary.slot, align 8

  ; initialize array: 9,1,5,3,7,2,8,6,4,0
  store [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], [10 x i32]* %arr, align 16

  ; call bubble_sort(&arr[0], 10)
  %arr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @bubble_sort(i32* %arr.ptr, i64 10)

  ; for (i = 0; i < 10; i++) printf("%d ", arr[i]);
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %val)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %i.next = add nuw nsw i64 %i, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  call i32 @putchar(i32 10)

  ; stack protector check and return 0
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %canary.slot, align 8
  %guard.cmp = icmp ne i64 %guard1, %saved
  br i1 %guard.cmp, label %stkfail, label %retblk

stkfail:                                          ; preds = %for.end
  call void @__stack_chk_fail() nounwind
  unreachable

retblk:                                           ; preds = %for.end
  ret i32 0
}