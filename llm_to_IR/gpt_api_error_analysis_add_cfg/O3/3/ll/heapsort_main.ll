; ModuleID = 'main_from_asm'
target triple = "x86_64-pc-linux-gnu"

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external thread_local global i64

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail()

define i32 @main() {
loc_144B:
  %arr = alloca [9 x i32], align 16
  %var_38 = alloca i64, align 8
  %var_48 = alloca i64, align 8
  %var_40 = alloca i64, align 8
  %var_8 = alloca i64, align 8
  %retval = alloca i32, align 4
  %canary_init = load i64, i64* @__stack_chk_guard
  store i64 %canary_init, i64* %var_8, align 8
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
  store i64 9, i64* %var_38, align 8
  store i64 0, i64* %var_48, align 8
  br label %loc_14DA

loc_14B7:
  %i_load0 = load i64, i64* %var_48, align 8
  %elem_ptr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i_load0
  %elem0 = load i32, i32* %elem_ptr0, align 4
  %fmt_ptr0 = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call_printf0 = call i32 (i8*, ...) @printf(i8* %fmt_ptr0, i32 %elem0)
  %i_inc0 = add i64 %i_load0, 1
  store i64 %i_inc0, i64* %var_48, align 8
  br label %loc_14DA

loc_14DA:
  %i_load1 = load i64, i64* %var_48, align 8
  %n_load0 = load i64, i64* %var_38, align 8
  %cmp_jb0 = icmp ult i64 %i_load1, %n_load0
  br i1 %cmp_jb0, label %loc_14B7, label %bb_after_14DA

bb_after_14DA:
  %putc0 = call i32 @putchar(i32 10)
  %arr_base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n_load1 = load i64, i64* %var_38, align 8
  call void @heap_sort(i32* %arr_base, i64 %n_load1)
  store i64 0, i64* %var_40, align 8
  br label %loc_152E

loc_150B:
  %j_load0 = load i64, i64* %var_40, align 8
  %elem_ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j_load0
  %elem1 = load i32, i32* %elem_ptr1, align 4
  %fmt_ptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call_printf1 = call i32 (i8*, ...) @printf(i8* %fmt_ptr1, i32 %elem1)
  %j_inc0 = add i64 %j_load0, 1
  store i64 %j_inc0, i64* %var_40, align 8
  br label %loc_152E

loc_152E:
  %j_load1 = load i64, i64* %var_40, align 8
  %n_load2 = load i64, i64* %var_38, align 8
  %cmp_jb1 = icmp ult i64 %j_load1, %n_load2
  br i1 %cmp_jb1, label %loc_150B, label %bb_after_152E

bb_after_152E:
  %putc1 = call i32 @putchar(i32 10)
  store i32 0, i32* %retval, align 4
  %saved_can = load i64, i64* %var_8, align 8
  %cur_can = load i64, i64* @__stack_chk_guard
  %can_diff = sub i64 %saved_can, %cur_can
  %can_ok = icmp eq i64 %can_diff, 0
  br i1 %can_ok, label %locret_155B, label %bb_1556

bb_1556:
  call void @__stack_chk_fail()
  br label %locret_155B

locret_155B:
  %rv = load i32, i32* %retval, align 4
  ret i32 %rv
}