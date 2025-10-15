; ModuleID = 'sub_1400023D0_module'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }
%struct.Node = type { [16 x i8], %struct.Node* }

@dword_1400070E8 = dso_local global i32 0, align 4
@Block = dso_local global %struct.Node* null, align 8
@CriticalSection = dso_local global %struct._RTL_CRITICAL_SECTION { i8* null, i32 0, i32 0, i8* null, i8* null, i64 0 }, align 8

declare dso_local void @free(i8* noundef)
declare dso_local void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare dso_local void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare dso_local void @sub_140002240()
declare dso_local void @sub_1400024E0()

define dso_local i32 @sub_1400023D0(i8* noundef %hinst, i32 noundef %fdwReason, i8* noundef %reserved) local_unnamed_addr {
entry:
  %cmp_eq2 = icmp eq i32 %fdwReason, 2
  br i1 %cmp_eq2, label %thread_attach, label %not_eq2

thread_attach:
  call void @sub_1400024E0()
  ret i32 1

not_eq2:
  %cmp_ugt2 = icmp ugt i32 %fdwReason, 2
  br i1 %cmp_ugt2, label %check_eq3, label %lt2

check_eq3:
  %cmp_eq3 = icmp eq i32 %fdwReason, 3
  br i1 %cmp_eq3, label %thread_detach, label %ret1

thread_detach:
  %flag_td = load i32, i32* @dword_1400070E8, align 4
  %flag_td_nz = icmp ne i32 %flag_td, 0
  br i1 %flag_td_nz, label %call_sub240_then_ret1, label %ret1

call_sub240_then_ret1:
  call void @sub_140002240()
  br label %ret1

lt2:
  %is_zero = icmp eq i32 %fdwReason, 0
  br i1 %is_zero, label %process_detach_entry, label %process_attach

process_attach:
  %flag_pa = load i32, i32* @dword_1400070E8, align 4
  %flag_pa_nz = icmp ne i32 %flag_pa, 0
  br i1 %flag_pa_nz, label %set_flag1, label %init_cs

init_cs:
  call void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %set_flag1

set_flag1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

process_detach_entry:
  %flag_pd = load i32, i32* @dword_1400070E8, align 4
  %flag_pd_nz = icmp ne i32 %flag_pd, 0
  br i1 %flag_pd_nz, label %call_sub240_then_cont, label %cont_42E

call_sub240_then_cont:
  call void @sub_140002240()
  br label %cont_42E

cont_42E:
  %flag_read = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %flag_read, 1
  br i1 %is_one, label %cleanup_sequence, label %ret1

cleanup_sequence:
  %blk0 = load %struct.Node*, %struct.Node** @Block, align 8
  %blk0_isnull = icmp eq %struct.Node* %blk0, null
  br i1 %blk0_isnull, label %after_free, label %loop

loop:
  %cur = phi %struct.Node* [ %blk0, %cleanup_sequence ], [ %next1, %loop_body_end ]
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 1
  %next1 = load %struct.Node*, %struct.Node** %nextptr, align 8
  %cur_i8 = bitcast %struct.Node* %cur to i8*
  call void @free(i8* %cur_i8)
  %has_next = icmp ne %struct.Node* %next1, null
  br i1 %has_next, label %loop_body_end, label %after_free

loop_body_end:
  br label %loop

after_free:
  store %struct.Node* null, %struct.Node** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %ret1

ret1:
  ret i32 1
}