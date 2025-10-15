; ModuleID = 'recovered'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { [16 x i8], %struct.Node* }

@dword_1400070E8 = internal global i32 0, align 4
@Block = internal global %struct.Node* null, align 8
@CriticalSection = internal global [40 x i8] zeroinitializer, align 8

declare void @InitializeCriticalSection(i8* noundef)
declare void @DeleteCriticalSection(i8* noundef)
declare void @free(i8* noundef)
declare void @sub_140002240()
declare void @sub_1400024E0()

define dso_local i32 @sub_1400023D0(i8* noundef %param1, i32 noundef %edx) local_unnamed_addr {
entry:
  %cmp_edx_2 = icmp eq i32 %edx, 2
  br i1 %cmp_edx_2, label %case2, label %not2

not2:                                             ; edx != 2
  %ugt2 = icmp ugt i32 %edx, 2
  br i1 %ugt2, label %check3, label %le2path

le2path:                                          ; edx == 0 or 1
  %isZero = icmp eq i32 %edx, 0
  br i1 %isZero, label %case0, label %case1

case1:                                            ; edx == 1
  %flag_load1 = load i32, i32* @dword_1400070E8, align 4
  %flag_is_zero1 = icmp eq i32 %flag_load1, 0
  br i1 %flag_is_zero1, label %init_cs, label %set_flag1

init_cs:
  %cs_ptr0 = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @InitializeCriticalSection(i8* %cs_ptr0)
  br label %set_flag1

set_flag1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

check3:                                           ; edx > 2
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %case3, label %ret1

case3:                                            ; edx == 3
  %flag_load3 = load i32, i32* @dword_1400070E8, align 4
  %flag_is_zero3 = icmp eq i32 %flag_load3, 0
  br i1 %flag_is_zero3, label %ret1, label %call_2240_then_ret

call_2240_then_ret:
  call void @sub_140002240()
  br label %ret1

case0:                                            ; edx == 0
  %flag_load0 = load i32, i32* @dword_1400070E8, align 4
  %flag_nz0 = icmp ne i32 %flag_load0, 0
  br i1 %flag_nz0, label %call_2240_then_cont, label %after_42E

call_2240_then_cont:
  call void @sub_140002240()
  br label %after_42E

after_42E:
  %flag_again = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %flag_again, 1
  br i1 %is_one, label %cleanup, label %ret1

cleanup:
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %has_block = icmp ne %struct.Node* %head, null
  br i1 %has_block, label %loop, label %after_free

loop:
  %cur = phi %struct.Node* [ %head, %cleanup ], [ %next, %loop_cont ]
  %cur_next_ptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 1
  %next = load %struct.Node*, %struct.Node** %cur_next_ptr, align 8
  %cur_i8 = bitcast %struct.Node* %cur to i8*
  call void @free(i8* %cur_i8)
  %has_next = icmp ne %struct.Node* %next, null
  br i1 %has_next, label %loop_cont, label %after_free

loop_cont:
  br label %loop

after_free:
  store %struct.Node* null, %struct.Node** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %cs_ptr1 = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @DeleteCriticalSection(i8* %cs_ptr1)
  br label %ret1

case2:                                            ; edx == 2
  call void @sub_1400024E0()
  br label %ret1

ret1:
  ret i32 1
}