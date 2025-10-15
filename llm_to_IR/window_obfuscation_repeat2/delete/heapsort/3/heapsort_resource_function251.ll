; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = dso_local global i32 0, align 4
@Block = dso_local global i8* null, align 8
@CriticalSection = dso_local global [40 x i8] zeroinitializer, align 8
@__imp_DeleteCriticalSection = external dso_local global void (i8*)*, align 8
@__imp_InitializeCriticalSection = external dso_local global void (i8*)*, align 8

declare dso_local void @free(i8* noundef)
declare dso_local void @sub_140002240()
declare dso_local void @sub_1400024E0()

define dso_local i32 @sub_1400023D0(i32 %arg1, i32 %arg2) {
entry:
  %var10 = alloca i8*, align 8
  %cmp_eq2 = icmp eq i32 %arg2, 2
  br i1 %cmp_eq2, label %bb_case2, label %bb_check_gt2

bb_check_gt2:                                     ; preds = %entry
  %cmp_gt2 = icmp ugt i32 %arg2, 2
  br i1 %cmp_gt2, label %bb_compare3, label %bb_check_zero

bb_check_zero:                                    ; preds = %bb_check_gt2
  %is_zero = icmp eq i32 %arg2, 0
  br i1 %is_zero, label %bb_case0, label %bb_case1

bb_case1:                                         ; preds = %bb_check_zero
  %t1 = load i32, i32* @dword_1400070E8, align 4
  %is_zero2 = icmp eq i32 %t1, 0
  br i1 %is_zero2, label %bb_initcrit, label %bb_setflagreturn

bb_initcrit:                                      ; preds = %bb_case1
  %imp_init_ptr = load void (i8*)*, void (i8*)** @__imp_InitializeCriticalSection, align 8
  %critptr_gep = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void %imp_init_ptr(i8* %critptr_gep)
  br label %bb_setflagreturn

bb_setflagreturn:                                 ; preds = %bb_initcrit, %bb_case1
  store i32 1, i32* @dword_1400070E8, align 4
  br label %bb_ret1

bb_compare3:                                      ; preds = %bb_check_gt2
  %is_eq3 = icmp eq i32 %arg2, 3
  br i1 %is_eq3, label %bb_case3, label %bb_ret1

bb_case3:                                         ; preds = %bb_compare3
  %v = load i32, i32* @dword_1400070E8, align 4
  %v_zero = icmp eq i32 %v, 0
  br i1 %v_zero, label %bb_ret1, label %bb_call_sub_then_ret

bb_call_sub_then_ret:                             ; preds = %bb_case3
  call void @sub_140002240()
  br label %bb_ret1

bb_case0:                                         ; preds = %bb_check_zero
  %t0 = load i32, i32* @dword_1400070E8, align 4
  %t0_nonzero = icmp ne i32 %t0, 0
  br i1 %t0_nonzero, label %bb_call_sub_then_after, label %bb_42E

bb_call_sub_then_after:                           ; preds = %bb_case0
  call void @sub_140002240()
  br label %bb_42E

bb_42E:                                           ; preds = %bb_call_sub_then_after, %bb_case0
  %t2 = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %t2, 1
  br i1 %is_one, label %bb_free_loop_entry, label %bb_ret1

bb_free_loop_entry:                               ; preds = %bb_42E
  %blk0 = load i8*, i8** @Block, align 8
  br label %bb_free_loop

bb_free_loop:                                     ; preds = %bb_free_one, %bb_free_loop_entry
  %curr = phi i8* [ %blk0, %bb_free_loop_entry ], [ %blk_next, %bb_free_one ]
  %curr_null = icmp eq i8* %curr, null
  br i1 %curr_null, label %bb_after_free, label %bb_free_one

bb_free_one:                                      ; preds = %bb_free_loop
  %next_addr = getelementptr inbounds i8, i8* %curr, i64 16
  %next_ptrptr = bitcast i8* %next_addr to i8**
  %next_val = load i8*, i8** %next_ptrptr, align 8
  store i8* %next_val, i8** %var10, align 8
  call void @free(i8* %curr)
  %blk_next = load i8*, i8** %var10, align 8
  br label %bb_free_loop

bb_after_free:                                    ; preds = %bb_free_loop
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %imp_del = load void (i8*)*, void (i8*)** @__imp_DeleteCriticalSection, align 8
  %critptr2 = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void %imp_del(i8* %critptr2)
  br label %bb_ret1

bb_case2:                                         ; preds = %entry
  call void @sub_1400024E0()
  br label %bb_ret1

bb_ret1:                                          ; preds = %bb_case2, %bb_after_free, %bb_42E, %bb_call_sub_then_ret, %bb_case3, %bb_compare3, %bb_setflagreturn
  ret i32 1
}