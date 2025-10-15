; ModuleID = 'sub_1400023D0'
target triple = "x86_64-pc-windows-msvc"

%struct.CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }
%struct.BlockNode = type { [16 x i8], %struct.BlockNode* }

@dword_1400070E8 = dso_local global i32 0, align 4
@Block = dso_local global %struct.BlockNode* null, align 8
@CriticalSection = dso_local global %struct.CRITICAL_SECTION zeroinitializer, align 8

declare dso_local void @free(i8* noundef)
declare dso_local void @DeleteCriticalSection(%struct.CRITICAL_SECTION* noundef)
declare dso_local void @InitializeCriticalSection(%struct.CRITICAL_SECTION* noundef)
declare dso_local void @sub_140002240()
declare dso_local void @sub_1400024E0()

define dso_local i32 @sub_1400023D0(i32 noundef %arg_edx) local_unnamed_addr {
entry:
  %cmp_edx_2 = icmp eq i32 %arg_edx, 2
  br i1 %cmp_edx_2, label %case2, label %not2

case2:                                            ; edx == 2
  call void @sub_1400024E0()
  ret i32 1

not2:
  %ugt2 = icmp ugt i32 %arg_edx, 2
  br i1 %ugt2, label %gt2, label %le2

gt2:                                              ; edx > 2
  %eq3 = icmp eq i32 %arg_edx, 3
  br i1 %eq3, label %edx3, label %ret1

edx3:                                             ; edx == 3
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %flag1_is_zero = icmp eq i32 %flag1, 0
  br i1 %flag1_is_zero, label %ret1, label %call_sub_240_then_ret

call_sub_240_then_ret:
  call void @sub_140002240()
  br label %ret1

le2:                                              ; edx <= 2
  %is_zero = icmp eq i32 %arg_edx, 0
  br i1 %is_zero, label %edx0, label %edx1

edx1:                                             ; edx == 1
  %flag2 = load i32, i32* @dword_1400070E8, align 4
  %flag2_zero = icmp eq i32 %flag2, 0
  br i1 %flag2_zero, label %init_cs, label %set_flag1

init_cs:
  call void @InitializeCriticalSection(%struct.CRITICAL_SECTION* noundef @CriticalSection)
  br label %set_flag1

set_flag1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

edx0:                                             ; edx == 0
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %flag3_nonzero = icmp ne i32 %flag3, 0
  br i1 %flag3_nonzero, label %call_sub_240_then_check, label %check_after

call_sub_240_then_check:
  call void @sub_140002240()
  br label %check_after

check_after:
  %flag4 = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %flag4, 1
  br i1 %is_one, label %cleanup, label %ret1

cleanup:
  %first_node = load %struct.BlockNode*, %struct.BlockNode** @Block, align 8
  %is_null = icmp eq %struct.BlockNode* %first_node, null
  br i1 %is_null, label %after_free, label %loop

loop:
  %cur = phi %struct.BlockNode* [ %first_node, %cleanup ], [ %next, %loop ]
  %nextptrptr = getelementptr inbounds %struct.BlockNode, %struct.BlockNode* %cur, i32 0, i32 1
  %next = load %struct.BlockNode*, %struct.BlockNode** %nextptrptr, align 8
  %cur_i8 = bitcast %struct.BlockNode* %cur to i8*
  call void @free(i8* noundef %cur_i8)
  %next_is_null = icmp eq %struct.BlockNode* %next, null
  br i1 %next_is_null, label %after_free, label %loop

after_free:
  store %struct.BlockNode* null, %struct.BlockNode** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(%struct.CRITICAL_SECTION* noundef @CriticalSection)
  br label %ret1

ret1:
  ret i32 1
}