; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail()

define i32 @main() {
entry_144b:
  %arr = alloca [9 x i32], align 16
  %idx1 = alloca i64, align 8
  %idx2 = alloca i64, align 8
  %count = alloca i64, align 8
  %canary_save = alloca i64, align 8
  %c0 = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  store i64 %c0, i64* %canary_save, align 8
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
  store i64 9, i64* %count, align 8
  store i64 0, i64* %idx1, align 8
  br label %block_14da

block_14b7:
  %i = load i64, i64* %idx1, align 8
  %elem_ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem_ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %val)
  %i.next = add i64 %i, 1
  store i64 %i.next, i64* %idx1, align 8
  br label %block_14da

block_14da:
  %i2 = load i64, i64* %idx1, align 8
  %n = load i64, i64* %count, align 8
  %cond = icmp ult i64 %i2, %n
  br i1 %cond, label %block_14b7, label %block_14e4

block_14e4:
  %call2 = call i32 @putchar(i32 10)
  %arr_base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n3 = load i64, i64* %count, align 8
  call void @heap_sort(i32* %arr_base, i64 %n3)
  store i64 0, i64* %idx2, align 8
  br label %block_152e

block_150b:
  %j = load i64, i64* %idx2, align 8
  %elem_ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %val2 = load i32, i32* %elem_ptr2, align 4
  %fmtptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @printf(i8* %fmtptr2, i32 %val2)
  %j.next = add i64 %j, 1
  store i64 %j.next, i64* %idx2, align 8
  br label %block_152e

block_152e:
  %j2 = load i64, i64* %idx2, align 8
  %n4 = load i64, i64* %count, align 8
  %cond2 = icmp ult i64 %j2, %n4
  br i1 %cond2, label %block_150b, label %block_1538

block_1538:
  %call4 = call i32 @putchar(i32 10)
  br label %block_1547

block_1547:
  %saved = load i64, i64* %canary_save, align 8
  %c1 = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  %ok = icmp eq i64 %saved, %c1
  br i1 %ok, label %block_155b, label %block_1556

block_1556:
  call void @__stack_chk_fail()
  br label %block_155b

block_155b:
  ret i32 0
}