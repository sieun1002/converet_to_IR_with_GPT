; ModuleID = 'recovered_from_0x144b_0x155d'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64, align 8

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail()

define i32 @main() {
entry_144b:
  %arr = alloca [9 x i32], align 16
  %var_48 = alloca i64, align 8
  %var_38 = alloca i64, align 8
  %var_40 = alloca i64, align 8
  %canary = alloca i64, align 8
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary, align 8
  ; initialize array elements [rbp+var_30 .. var_10]
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

loc_14B7:                                            ; 0x14b7
  %idx0 = load i64, i64* %var_48, align 8
  %eltptr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %idx0
  %val0 = load i32, i32* %eltptr0, align 4
  %fmt0 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call_printf0 = call i32 (i8*, ...) @printf(i8* %fmt0, i32 %val0)
  %idx0.next = add i64 %idx0, 1
  store i64 %idx0.next, i64* %var_48, align 8
  br label %loc_14DA

loc_14DA:                                            ; 0x14da
  %i_cmp0 = load i64, i64* %var_48, align 8
  %n_cmp0 = load i64, i64* %var_38, align 8
  %cond0 = icmp ult i64 %i_cmp0, %n_cmp0
  br i1 %cond0, label %loc_14B7, label %bb_14e4

bb_14e4:                                             ; 0x14e4 fall-through
  %call_putchar0 = call i32 @putchar(i32 10)
  %n_for_sort = load i64, i64* %var_38, align 8
  %arrdecay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arrdecay, i64 %n_for_sort)
  store i64 0, i64* %var_40, align 8
  br label %loc_152E

loc_150B:                                            ; 0x150b
  %j0 = load i64, i64* %var_40, align 8
  %eltptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j0
  %val1 = load i32, i32* %eltptr1, align 4
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call_printf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %val1)
  %j0.next = add i64 %j0, 1
  store i64 %j0.next, i64* %var_40, align 8
  br label %loc_152E

loc_152E:                                            ; 0x152e
  %j_cmp0 = load i64, i64* %var_40, align 8
  %n_cmp1 = load i64, i64* %var_38, align 8
  %cond1 = icmp ult i64 %j_cmp0, %n_cmp1
  br i1 %cond1, label %loc_150B, label %bb_1538

bb_1538:                                             ; 0x1538 fall-through
  %call_putchar1 = call i32 @putchar(i32 10)
  %saved_can = load i64, i64* %canary, align 8
  %cur_can = load i64, i64* @__stack_chk_guard, align 8
  %can_eq = icmp eq i64 %saved_can, %cur_can
  br i1 %can_eq, label %locret_155B, label %bb_1556

bb_1556:                                             ; 0x1556
  call void @__stack_chk_fail()
  br label %locret_155B

locret_155B:                                         ; 0x155b
  ret i32 0
}