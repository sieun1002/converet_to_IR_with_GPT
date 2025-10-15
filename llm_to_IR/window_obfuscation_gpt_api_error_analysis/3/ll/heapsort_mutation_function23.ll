; ModuleID = 'sub_1400023D0_module'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }
%struct.Block = type { [16 x i8], %struct.Block* }

@dword_1400070E8 = internal global i32 0, align 4
@Block = internal global %struct.Block* null, align 8
@CriticalSection = internal global %struct._RTL_CRITICAL_SECTION zeroinitializer, align 8

declare void @free(i8* noundef)
declare void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare void @sub_140002240()
declare void @sub_1400024E0()

define dso_local i32 @sub_1400023D0(i8* noundef %hinstDLL, i32 noundef %fdwReason, i8* noundef %lpvReserved) {
entry:
  %cmp_eq2 = icmp eq i32 %fdwReason, 2
  br i1 %cmp_eq2, label %thread_attach, label %check_gt2

check_gt2:
  %cmp_gt2 = icmp ugt i32 %fdwReason, 2
  br i1 %cmp_gt2, label %maybe_thread_detach, label %attach_or_detach0

maybe_thread_detach:
  %cmp_eq3 = icmp eq i32 %fdwReason, 3
  br i1 %cmp_eq3, label %thread_detach, label %ret1

thread_detach:
  %flag_td = load i32, i32* @dword_1400070E8, align 4
  %flag_td_nz = icmp ne i32 %flag_td, 0
  br i1 %flag_td_nz, label %call_cleanup_td, label %ret1

call_cleanup_td:
  call void @sub_140002240()
  br label %ret1

attach_or_detach0:
  %is_zero = icmp eq i32 %fdwReason, 0
  br i1 %is_zero, label %process_detach, label %process_attach

process_attach:
  %flag_pa = load i32, i32* @dword_1400070E8, align 4
  %flag_pa_z = icmp eq i32 %flag_pa, 0
  br i1 %flag_pa_z, label %init_cs, label %set_flag1

init_cs:
  call void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  br label %set_flag1

set_flag1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

process_detach:
  %flag_pd = load i32, i32* @dword_1400070E8, align 4
  %flag_pd_nz = icmp ne i32 %flag_pd, 0
  br i1 %flag_pd_nz, label %call_cleanup_pd, label %after_cleanup_pd

call_cleanup_pd:
  call void @sub_140002240()
  br label %after_cleanup_pd

after_cleanup_pd:
  %flag_after = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %flag_after, 1
  br i1 %is_one, label %free_loop_entry, label %ret1

free_loop_entry:
  %head0 = load %struct.Block*, %struct.Block** @Block, align 8
  %head_is_null = icmp eq %struct.Block* %head0, null
  br i1 %head_is_null, label %after_free, label %free_loop

free_loop:
  %cur = phi %struct.Block* [ %head0, %free_loop_entry ], [ %next, %free_loop_continue ]
  %nextptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 1
  %next = load %struct.Block*, %struct.Block** %nextptr, align 8
  %cur_i8 = bitcast %struct.Block* %cur to i8*
  call void @free(i8* noundef %cur_i8)
  %has_next = icmp ne %struct.Block* %next, null
  br i1 %has_next, label %free_loop_continue, label %after_free

free_loop_continue:
  br label %free_loop

after_free:
  store %struct.Block* null, %struct.Block** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  br label %ret1

thread_attach:
  call void @sub_1400024E0()
  br label %ret1

ret1:
  ret i32 1
}