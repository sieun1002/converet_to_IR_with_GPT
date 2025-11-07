; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail() noreturn nounwind

define i32 @main() {
b144b:
  %arr = alloca [9 x i32], align 16
  %v48 = alloca i64, align 8
  %v40 = alloca i64, align 8
  %v38 = alloca i64, align 8
  %canary = alloca i64, align 8
  %c0 = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  store i64 %c0, i64* %canary, align 8
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
  store i64 9, i64* %v38, align 8
  store i64 0, i64* %v48, align 8
  br label %b14da

b14b7:                                            ; loc_14B7
  %idx1 = load i64, i64* %v48, align 8
  %eltptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %idx1
  %val1 = load i32, i32* %eltptr1, align 4
  %fmtptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call_printf1 = call i32 (i8*, ...) @printf(i8* %fmtptr1, i32 %val1)
  %old48 = load i64, i64* %v48, align 8
  %inc48 = add i64 %old48, 1
  store i64 %inc48, i64* %v48, align 8
  br label %b14da

b14da:                                            ; loc_14DA
  %i = load i64, i64* %v48, align 8
  %n = load i64, i64* %v38, align 8
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %b14b7, label %after_first_loop

after_first_loop:
  %pc1 = call i32 @putchar(i32 10)
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n2 = load i64, i64* %v38, align 8
  call void @heap_sort(i32* %arr0, i64 %n2)
  store i64 0, i64* %v40, align 8
  br label %b152e

b150b:                                            ; loc_150B
  %idx2 = load i64, i64* %v40, align 8
  %eltptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %idx2
  %val2 = load i32, i32* %eltptr2, align 4
  %fmtptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call_printf2 = call i32 (i8*, ...) @printf(i8* %fmtptr2, i32 %val2)
  %old40 = load i64, i64* %v40, align 8
  %inc40 = add i64 %old40, 1
  store i64 %inc40, i64* %v40, align 8
  br label %b152e

b152e:                                            ; loc_152E
  %i2 = load i64, i64* %v40, align 8
  %n3 = load i64, i64* %v38, align 8
  %cond2 = icmp ult i64 %i2, %n3
  br i1 %cond2, label %b150b, label %after_second_loop

after_second_loop:
  %pc2 = call i32 @putchar(i32 10)
  %saved = load i64, i64* %canary, align 8
  %c1 = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  %ok = icmp eq i64 %saved, %c1
  br i1 %ok, label %b155b, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

b155b:                                            ; locret_155B
  ret i32 0
}