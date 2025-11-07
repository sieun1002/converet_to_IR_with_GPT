; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

@__stack_chk_guard = external thread_local global i64

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
bb_144b:
  %arr = alloca [9 x i32], align 16
  %idx1 = alloca i64, align 8
  %idx2 = alloca i64, align 8
  %len = alloca i64, align 8
  %guard.slot = alloca i64, align 8

  %guard.load = load i64, i64* @__stack_chk_guard
  store i64 %guard.load, i64* %guard.slot, align 8

  ; initialize array elements
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7,  i32* %arr.base, align 4
  %e1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 3,  i32* %e1, align 4
  %e2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 9,  i32* %e2, align 4
  %e3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 1,  i32* %e3, align 4
  %e4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 4,  i32* %e4, align 4
  %e5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 8,  i32* %e5, align 4
  %e6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 2,  i32* %e6, align 4
  %e7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6,  i32* %e7, align 4
  %e8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 5,  i32* %e8, align 4

  store i64 9, i64* %len, align 8
  store i64 0, i64* %idx1, align 8
  br label %bb_14da

bb_14b7:
  %i.cur = load i64, i64* %idx1, align 8
  %elt.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %i.cur
  %elt = load i32, i32* %elt.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elt)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %idx1, align 8
  br label %bb_14da

bb_14da:
  %i.chk = load i64, i64* %idx1, align 8
  %n.chk = load i64, i64* %len, align 8
  %cond = icmp ult i64 %i.chk, %n.chk
  br i1 %cond, label %bb_14b7, label %bb_after_first_loop

bb_after_first_loop:
  %pcall1 = call i32 @putchar(i32 10)
  %n.for.sort = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arr.base, i64 %n.for.sort)
  store i64 0, i64* %idx2, align 8
  br label %bb_152e

bb_150b:
  %j.cur = load i64, i64* %idx2, align 8
  %elt2.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %j.cur
  %elt2 = load i32, i32* %elt2.ptr, align 4
  %fmtptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmtptr2, i32 %elt2)
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %idx2, align 8
  br label %bb_152e

bb_152e:
  %j.chk = load i64, i64* %idx2, align 8
  %n.chk2 = load i64, i64* %len, align 8
  %cond2 = icmp ult i64 %j.chk, %n.chk2
  br i1 %cond2, label %bb_150b, label %bb_after_second_loop

bb_after_second_loop:
  %pcall2 = call i32 @putchar(i32 10)
  ; canary check and epilogue
  %guard.cur = load i64, i64* @__stack_chk_guard
  %guard.saved = load i64, i64* %guard.slot, align 8
  %canary.ok = icmp eq i64 %guard.saved, %guard.cur
  br i1 %canary.ok, label %bb_155b, label %bb_fail

bb_fail:
  call void @__stack_chk_fail()
  unreachable

bb_155b:
  ret i32 0
}