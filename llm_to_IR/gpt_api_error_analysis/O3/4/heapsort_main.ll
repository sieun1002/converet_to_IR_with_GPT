; ModuleID = 'heapsort_main'
target triple = "x86_64-pc-linux-gnu"

@.str = private constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail()

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %count = alloca i64, align 8
  %saved_canary = alloca i64, align 8
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %saved_canary, align 8
  store i32 7, i32* %arr.base, align 4
  %idx1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 3, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 9, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 1, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 4, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 8, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 2, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 5, i32* %idx8, align 4
  store i64 9, i64* %count, align 8
  br label %loop1.cond

loop1.cond:                                       ; preds = %loop1.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop1.body ]
  %n1 = load i64, i64* %count, align 8
  %cmp1 = icmp ult i64 %i, %n1
  br i1 %cmp1, label %loop1.body, label %after_print1

loop1.body:                                       ; preds = %loop1.cond
  %elem.ptr1 = getelementptr inbounds i32, i32* %arr.base, i64 %i
  %val1 = load i32, i32* %elem.ptr1, align 4
  %fmtptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmtptr1, i32 %val1)
  %i.next = add i64 %i, 1
  br label %loop1.cond

after_print1:                                     ; preds = %loop1.cond
  %putc1 = call i32 @putchar(i32 10)
  %n2 = load i64, i64* %count, align 8
  call void @heap_sort(i32* %arr.base, i64 %n2)
  br label %loop2.cond

loop2.cond:                                       ; preds = %loop2.body, %after_print1
  %j = phi i64 [ 0, %after_print1 ], [ %j.next, %loop2.body ]
  %n3 = load i64, i64* %count, align 8
  %cmp2 = icmp ult i64 %j, %n3
  br i1 %cmp2, label %loop2.body, label %after_print2

loop2.body:                                       ; preds = %loop2.cond
  %elem.ptr2 = getelementptr inbounds i32, i32* %arr.base, i64 %j
  %val2 = load i32, i32* %elem.ptr2, align 4
  %fmtptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmtptr2, i32 %val2)
  %j.next = add i64 %j, 1
  br label %loop2.cond

after_print2:                                     ; preds = %loop2.cond
  %putc2 = call i32 @putchar(i32 10)
  %saved = load i64, i64* %saved_canary, align 8
  %current = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %saved, %current
  br i1 %ok, label %retblock, label %stackfail

stackfail:                                        ; preds = %after_print2
  call void @__stack_chk_fail()
  br label %retblock

retblock:                                         ; preds = %stackfail, %after_print2
  ret i32 0
}