; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
bb_144b:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i1 = alloca i64, align 8
  %i2 = alloca i64, align 8
  %canary.save = alloca i64, align 8
  store i64 0, i64* %canary.save, align 8
  %a0p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %a0p, align 4
  %a1p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %a1p, align 4
  %a2p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %a2p, align 4
  %a3p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %a3p, align 4
  %a4p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %a4p, align 4
  %a5p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %a5p, align 4
  %a6p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %a6p, align 4
  %a7p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %a7p, align 4
  %a8p = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %a8p, align 4
  store i64 9, i64* %len, align 8
  store i64 0, i64* %i1, align 8
  br label %bb_14da

bb_14b7:
  %idx1 = load i64, i64* %i1, align 8
  %eltptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %idx1
  %val1 = load i32, i32* %eltptr1, align 4
  %fmtptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call_printf1 = call i32 (i8*, ...) @printf(i8* %fmtptr1, i32 %val1)
  %inc1 = add i64 %idx1, 1
  store i64 %inc1, i64* %i1, align 8
  br label %bb_14da

bb_14da:
  %cur1 = load i64, i64* %i1, align 8
  %n1 = load i64, i64* %len, align 8
  %cmp1 = icmp ult i64 %cur1, %n1
  br i1 %cmp1, label %bb_14b7, label %bb_14e4

bb_14e4:
  %call_nl1 = call i32 @putchar(i32 10)
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n2 = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arr0, i64 %n2)
  store i64 0, i64* %i2, align 8
  br label %bb_152e

bb_150b:
  %idx2 = load i64, i64* %i2, align 8
  %eltptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %idx2
  %val2 = load i32, i32* %eltptr2, align 4
  %fmtptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call_printf2 = call i32 (i8*, ...) @printf(i8* %fmtptr2, i32 %val2)
  %inc2 = add i64 %idx2, 1
  store i64 %inc2, i64* %i2, align 8
  br label %bb_152e

bb_152e:
  %cur2 = load i64, i64* %i2, align 8
  %n3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %cur2, %n3
  br i1 %cmp2, label %bb_150b, label %bb_1538

bb_1538:
  %call_nl2 = call i32 @putchar(i32 10)
  br label %bb_1542

bb_1542:
  %saved_canary = load i64, i64* %canary.save, align 8
  br label %bb_1554

bb_1554:
  %guard.fini = load i64, i64* %canary.save, align 8
  %ok = icmp eq i64 %saved_canary, %guard.fini
  br i1 %ok, label %bb_155b, label %bb_1556

bb_1556:
  call void @__stack_chk_fail()
  unreachable

bb_155b:
  ret i32 0
}