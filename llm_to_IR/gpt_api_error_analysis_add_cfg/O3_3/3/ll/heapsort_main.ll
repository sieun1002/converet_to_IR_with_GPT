; ModuleID = 'recovered_main'
target triple = "x86_64-pc-linux-gnu"

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail()

define i32 @main() {
loc_144B:
  %var8 = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %var38 = alloca i64, align 8
  %var48 = alloca i64, align 8
  %var40 = alloca i64, align 8
  %canary.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %canary.load, i64* %var8, align 8
  %arr.base0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr.base0, align 4
  %arr.idx1 = getelementptr inbounds i32, i32* %arr.base0, i64 1
  store i32 3, i32* %arr.idx1, align 4
  %arr.idx2 = getelementptr inbounds i32, i32* %arr.base0, i64 2
  store i32 9, i32* %arr.idx2, align 4
  %arr.idx3 = getelementptr inbounds i32, i32* %arr.base0, i64 3
  store i32 1, i32* %arr.idx3, align 4
  %arr.idx4 = getelementptr inbounds i32, i32* %arr.base0, i64 4
  store i32 4, i32* %arr.idx4, align 4
  %arr.idx5 = getelementptr inbounds i32, i32* %arr.base0, i64 5
  store i32 8, i32* %arr.idx5, align 4
  %arr.idx6 = getelementptr inbounds i32, i32* %arr.base0, i64 6
  store i32 2, i32* %arr.idx6, align 4
  %arr.idx7 = getelementptr inbounds i32, i32* %arr.base0, i64 7
  store i32 6, i32* %arr.idx7, align 4
  %arr.idx8 = getelementptr inbounds i32, i32* %arr.base0, i64 8
  store i32 5, i32* %arr.idx8, align 4
  store i64 9, i64* %var38, align 8
  store i64 0, i64* %var48, align 8
  br label %loc_14DA

loc_14B7:
  %i0 = load i64, i64* %var48, align 8
  %gep0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i0
  %val0 = load i32, i32* %gep0, align 4
  %fmt0 = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call_printf0 = call i32 (i8*, ...) @printf(i8* %fmt0, i32 %val0)
  %i0.old = load i64, i64* %var48, align 8
  %i0.inc = add i64 %i0.old, 1
  store i64 %i0.inc, i64* %var48, align 8
  br label %loc_14DA

loc_14DA:
  %i1 = load i64, i64* %var48, align 8
  %n0 = load i64, i64* %var38, align 8
  %cond0 = icmp ult i64 %i1, %n0
  br i1 %cond0, label %loc_14B7, label %loc_14E4

loc_14E4:
  %call_putchar0 = call i32 @putchar(i32 10)
  %n1 = load i64, i64* %var38, align 8
  %arr.decay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.decay, i64 %n1)
  store i64 0, i64* %var40, align 8
  br label %loc_152E

loc_150B:
  %i2 = load i64, i64* %var40, align 8
  %gep1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2
  %val1 = load i32, i32* %gep1, align 4
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call_printf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %val1)
  %i2.old = load i64, i64* %var40, align 8
  %i2.inc = add i64 %i2.old, 1
  store i64 %i2.inc, i64* %var40, align 8
  br label %loc_152E

loc_152E:
  %i3 = load i64, i64* %var40, align 8
  %n2 = load i64, i64* %var38, align 8
  %cond1 = icmp ult i64 %i3, %n2
  br i1 %cond1, label %loc_150B, label %loc_1538

loc_1538:
  %call_putchar1 = call i32 @putchar(i32 10)
  %saved_canary = load i64, i64* %var8, align 8
  %cur_canary = load i64, i64* @__stack_chk_guard, align 8
  %canary_ok = icmp eq i64 %saved_canary, %cur_canary
  br i1 %canary_ok, label %locret_155B, label %loc_1556

loc_1556:
  call void @__stack_chk_fail()
  br label %locret_155B

locret_155B:
  ret i32 0
}