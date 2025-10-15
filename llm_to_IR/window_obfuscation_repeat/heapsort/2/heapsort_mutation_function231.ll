; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct.RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }
%struct.Node = type { [16 x i8], %struct.Node* }

@dword_1400070E8 = internal global i32 0, align 4
@Block = internal global %struct.Node* null, align 8
@CriticalSection = internal global %struct.RTL_CRITICAL_SECTION zeroinitializer, align 8

declare dllimport void @InitializeCriticalSection(%struct.RTL_CRITICAL_SECTION*)
declare dllimport void @DeleteCriticalSection(%struct.RTL_CRITICAL_SECTION*)
declare dllimport void @free(i8*)
declare void @sub_140002240()
declare void @sub_1400024E0()

define i32 @sub_1400023D0(i8* %hinst, i32 %fdwReason, i8* %reserved) {
entry:
  %cmp2 = icmp eq i32 %fdwReason, 2
  br i1 %cmp2, label %case_thr_attach, label %not2

case_thr_attach:
  call void @sub_1400024E0()
  ret i32 1

not2:
  %gt2 = icmp ugt i32 %fdwReason, 2
  br i1 %gt2, label %gt2_block, label %le2_block

gt2_block:
  %is3 = icmp eq i32 %fdwReason, 3
  br i1 %is3, label %case_thr_detach, label %ret1

case_thr_detach:
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %flag1nz = icmp ne i32 %flag1, 0
  br i1 %flag1nz, label %call_2240_then_ret, label %ret1

call_2240_then_ret:
  call void @sub_140002240()
  br label %ret1

ret1:
  ret i32 1

le2_block:
  %is0 = icmp eq i32 %fdwReason, 0
  br i1 %is0, label %case_proc_detach, label %case_proc_attach

case_proc_attach:
  %flag2 = load i32, i32* @dword_1400070E8, align 4
  %flag2_is0 = icmp eq i32 %flag2, 0
  br i1 %flag2_is0, label %init_cs, label %set_flag1

init_cs:
  call void @InitializeCriticalSection(%struct.RTL_CRITICAL_SECTION* @CriticalSection)
  br label %set_flag1

set_flag1:
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

case_proc_detach:
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %flag3nz = icmp ne i32 %flag3, 0
  br i1 %flag3nz, label %call_2240_then_flow, label %after_2240_flow

call_2240_then_flow:
  call void @sub_140002240()
  br label %after_2240_flow

after_2240_flow:
  %flag4 = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %flag4, 1
  br i1 %is1, label %free_list, label %ret1

free_list:
  %p0 = load %struct.Node*, %struct.Node** @Block, align 8
  br label %free_loop_check

free_loop_check:
  %p = phi %struct.Node* [ %p0, %free_list ], [ %next, %after_free ]
  %cond = icmp ne %struct.Node* %p, null
  br i1 %cond, label %free_body, label %after_free_loop

free_body:
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %p, i32 0, i32 1
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  %pcast = bitcast %struct.Node* %p to i8*
  call void @free(i8* %pcast)
  br label %after_free

after_free:
  br label %free_loop_check

after_free_loop:
  store %struct.Node* null, %struct.Node** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(%struct.RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 1
}