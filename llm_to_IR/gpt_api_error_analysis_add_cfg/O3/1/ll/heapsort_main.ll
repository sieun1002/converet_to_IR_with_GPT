; ModuleID = 'main_module'
target triple = "x86_64-unknown-linux-gnu"

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail()

define i32 @main() {
0x144b:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %idx1 = alloca i64, align 8
  %idx2 = alloca i64, align 8
  %canary = alloca i64, align 8

  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary, align 8

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
  store i64 0, i64* %idx1, align 8
  br label %loc_14DA

loc_14B7:
  %i1_0 = load i64, i64* %idx1, align 8
  %elem_ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1_0
  %elem1 = load i32, i32* %elem_ptr1, align 4
  %fmtptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call_printf1 = call i32 (i8*, ...) @printf(i8* %fmtptr1, i32 %elem1)
  %i1_inc = add i64 %i1_0, 1
  store i64 %i1_inc, i64* %idx1, align 8
  br label %loc_14DA

loc_14DA:
  %i1_cmp_l = load i64, i64* %idx1, align 8
  %len_l = load i64, i64* %len, align 8
  %cmp1 = icmp ult i64 %i1_cmp_l, %len_l
  br i1 %cmp1, label %loc_14B7, label %"0x14e4"

0x14e4:
  %call_putchar1 = call i32 @putchar(i32 10)
  %arr_base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len_to_pass = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arr_base, i64 %len_to_pass)
  store i64 0, i64* %idx2, align 8
  br label %loc_152E

loc_150B:
  %i2_0 = load i64, i64* %idx2, align 8
  %elem_ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2_0
  %elem2 = load i32, i32* %elem_ptr2, align 4
  %fmtptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call_printf2 = call i32 (i8*, ...) @printf(i8* %fmtptr2, i32 %elem2)
  %i2_inc = add i64 %i2_0, 1
  store i64 %i2_inc, i64* %idx2, align 8
  br label %loc_152E

loc_152E:
  %i2_cmp_l = load i64, i64* %idx2, align 8
  %len_l2 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %i2_cmp_l, %len_l2
  br i1 %cmp2, label %loc_150B, label %"0x1538"

0x1538:
  %call_putchar2 = call i32 @putchar(i32 10)
  %saved_guard = load i64, i64* %canary, align 8
  %cur_guard = load i64, i64* @__stack_chk_guard, align 8
  %diff = sub i64 %saved_guard, %cur_guard
  %iszero = icmp eq i64 %diff, 0
  br i1 %iszero, label %locret_155B, label %"0x1556"

0x1556:
  call void @__stack_chk_fail()
  unreachable

locret_155B:
  ret i32 0
}