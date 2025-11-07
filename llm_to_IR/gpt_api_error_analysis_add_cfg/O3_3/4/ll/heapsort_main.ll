; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
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
  %n = alloca i64, align 8
  %canary = alloca i64, align 8
  %guard_init = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard_init, i64* %canary, align 8
  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %p0, align 4
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %p8, align 4
  store i64 9, i64* %n, align 8
  store i64 0, i64* %idx1, align 8
  br label %bb_14da

bb_14b7:
  %t0 = load i64, i64* %idx1, align 8
  %t1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %t0
  %t2 = load i32, i32* %t1, align 4
  %fmt0 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt0, i32 %t2)
  %t3 = add i64 %t0, 1
  store i64 %t3, i64* %idx1, align 8
  br label %bb_14da

bb_14da:
  %t4 = load i64, i64* %idx1, align 8
  %t5 = load i64, i64* %n, align 8
  %t6 = icmp ult i64 %t4, %t5
  br i1 %t6, label %bb_14b7, label %bb_after_first_loop

bb_after_first_loop:
  %call1 = call i32 @putchar(i32 10)
  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %t7 = load i64, i64* %n, align 8
  call void @heap_sort(i32* %base, i64 %t7)
  store i64 0, i64* %idx2, align 8
  br label %bb_152e

bb_150b:
  %t8 = load i64, i64* %idx2, align 8
  %t9 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %t8
  %t10 = load i32, i32* %t9, align 4
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %t10)
  %t11 = add i64 %t8, 1
  store i64 %t11, i64* %idx2, align 8
  br label %bb_152e

bb_152e:
  %t12 = load i64, i64* %idx2, align 8
  %t13 = load i64, i64* %n, align 8
  %t14 = icmp ult i64 %t12, %t13
  br i1 %t14, label %bb_150b, label %bb_after_second_loop

bb_after_second_loop:
  %call3 = call i32 @putchar(i32 10)
  %saved = load i64, i64* %canary, align 8
  %guard_now = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %saved, %guard_now
  br i1 %ok, label %bb_155b, label %bb_fail

bb_fail:
  call void @__stack_chk_fail()
  unreachable

bb_155b:
  ret i32 0
}