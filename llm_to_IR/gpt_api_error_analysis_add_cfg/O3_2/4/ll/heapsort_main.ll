; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @___stack_chk_fail() noreturn nounwind

define i32 @main() {
bb_144b:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i1 = alloca i64, align 8
  %i2 = alloca i64, align 8
  %canary = alloca i64, align 8
  %can.load = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  store i64 %can.load, i64* %canary, align 8
  %gep0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %gep0, align 4
  %gep1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %gep2, align 4
  %gep3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %gep3, align 4
  %gep4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %gep4, align 4
  %gep5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %gep5, align 4
  %gep6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %gep6, align 4
  %gep7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %gep7, align 4
  %gep8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %gep8, align 4
  store i64 9, i64* %len, align 8
  store i64 0, i64* %i1, align 8
  br label %bb_14da

bb_14b7:
  %idx1 = load i64, i64* %i1, align 8
  %eltptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %idx1
  %val1 = load i32, i32* %eltptr1, align 4
  %fmtptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %callprintf1 = call i32 (i8*, ...) @printf(i8* %fmtptr1, i32 %val1)
  %idx1.next = add i64 %idx1, 1
  store i64 %idx1.next, i64* %i1, align 8
  br label %bb_14da

bb_14da:
  %cur1 = load i64, i64* %i1, align 8
  %len1 = load i64, i64* %len, align 8
  %cmp1 = icmp ult i64 %cur1, %len1
  br i1 %cmp1, label %bb_14b7, label %bb_14e4

bb_14e4:
  %pc1 = call i32 @putchar(i32 10)
  %arrbase = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len2 = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arrbase, i64 %len2)
  store i64 0, i64* %i2, align 8
  br label %bb_152e

bb_150b:
  %idx2 = load i64, i64* %i2, align 8
  %eltptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %idx2
  %val2 = load i32, i32* %eltptr2, align 4
  %fmtptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %callprintf2 = call i32 (i8*, ...) @printf(i8* %fmtptr2, i32 %val2)
  %idx2.next = add i64 %idx2, 1
  store i64 %idx2.next, i64* %i2, align 8
  br label %bb_152e

bb_152e:
  %cur2 = load i64, i64* %i2, align 8
  %len3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %cur2, %len3
  br i1 %cmp2, label %bb_150b, label %bb_1538

bb_1538:
  %pc2 = call i32 @putchar(i32 10)
  %stored_can = load i64, i64* %canary, align 8
  %can.now = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  %ok = icmp eq i64 %stored_can, %can.now
  br i1 %ok, label %bb_155b, label %bb_1556

bb_1556:
  call void @___stack_chk_fail()
  unreachable

bb_155b:
  ret i32 0
}