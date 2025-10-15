; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type { [40 x i8] }
%struct.BlockNode = type { [16 x i8], %struct.BlockNode* }

@dword_1400070E8 = global i32 0, align 4
@Block = global %struct.BlockNode* null, align 8
@CriticalSection = global %struct._RTL_CRITICAL_SECTION zeroinitializer, align 8

declare void @sub_140002240()
declare void @sub_1400024E0()
declare void @free(i8*)
declare void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION*)

define i32 @sub_1400023D0(i8* %hinst, i32 %reason, i8* %reserved) {
entry:
  %next.tmp = alloca %struct.BlockNode*, align 8
  %cmp_eq2 = icmp eq i32 %reason, 2
  br i1 %cmp_eq2, label %case2, label %not2

case2:                                            ; preds = %entry
  call void @sub_1400024E0()
  ret i32 1

not2:                                             ; preds = %entry
  %cmp_gt2 = icmp ugt i32 %reason, 2
  br i1 %cmp_gt2, label %gt2, label %le2

gt2:                                              ; preds = %not2
  %is3 = icmp eq i32 %reason, 3
  br i1 %is3, label %case3, label %ret1

case3:                                            ; preds = %gt2
  %g0 = load i32, i32* @dword_1400070E8, align 4
  %g0_is_zero = icmp eq i32 %g0, 0
  br i1 %g0_is_zero, label %ret1, label %call_2240_then_ret1

call_2240_then_ret1:                              ; preds = %case3
  call void @sub_140002240()
  br label %ret1

ret1:                                             ; preds = %gt2, %case3, %call_2240_then_ret1
  ret i32 1

le2:                                              ; preds = %not2
  %is_zero = icmp eq i32 %reason, 0
  br i1 %is_zero, label %case0_start, label %case1_start

case1_start:                                      ; preds = %le2
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_is_zero = icmp eq i32 %g1, 0
  br i1 %g1_is_zero, label %init_cs, label %set1_ret

init_cs:                                          ; preds = %case1_start
  call void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %set1_ret

set1_ret:                                         ; preds = %init_cs, %case1_start
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

case0_start:                                      ; preds = %le2
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_is_zero = icmp eq i32 %g2, 0
  br i1 %g2_is_zero, label %after_24B0, label %call_2240_then_42E

call_2240_then_42E:                               ; preds = %case0_start
  call void @sub_140002240()
  br label %after_24B0

after_24B0:                                       ; preds = %call_2240_then_42E, %case0_start
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %g3, 1
  br i1 %is_one, label %cleanup_blocks, label %ret1_case0

ret1_case0:                                       ; preds = %after_24B0
  ret i32 1

cleanup_blocks:                                   ; preds = %after_24B0
  %head = load %struct.BlockNode*, %struct.BlockNode** @Block, align 8
  %is_null = icmp eq %struct.BlockNode* %head, null
  br i1 %is_null, label %after_loop, label %loop

loop:                                             ; preds = %cleanup_blocks, %loop
  %cur = phi %struct.BlockNode* [ %head, %cleanup_blocks ], [ %next2, %loop ]
  %next_ptr = getelementptr inbounds %struct.BlockNode, %struct.BlockNode* %cur, i32 0, i32 1
  %next1 = load %struct.BlockNode*, %struct.BlockNode** %next_ptr, align 8
  store %struct.BlockNode* %next1, %struct.BlockNode** %next.tmp, align 8
  %cur_i8 = bitcast %struct.BlockNode* %cur to i8*
  call void @free(i8* %cur_i8)
  %next2 = load %struct.BlockNode*, %struct.BlockNode** %next.tmp, align 8
  %notnull = icmp ne %struct.BlockNode* %next2, null
  br i1 %notnull, label %loop, label %after_loop

after_loop:                                       ; preds = %loop, %cleanup_blocks
  store %struct.BlockNode* null, %struct.BlockNode** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 1
}