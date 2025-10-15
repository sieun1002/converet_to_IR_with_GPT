; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.Block = type { [16 x i8], %struct.Block* }

@dword_1400070E8 = dso_local global i32 0, align 4
@Block = dso_local global %struct.Block* null, align 8
@CriticalSection = dso_local global [40 x i8] zeroinitializer, align 8

declare dso_local void @free(i8* noundef)
declare dso_local void @DeleteCriticalSection(i8* noundef)
declare dso_local void @InitializeCriticalSection(i8* noundef)
declare dso_local void @sub_140002240()
declare dso_local void @sub_1400024E0()

define dso_local i32 @sub_1400023D0(i8* noundef %hinstDLL, i32 noundef %fdwReason, i8* noundef %lpvReserved) local_unnamed_addr {
entry:
  %cmp_fdwReason_eq2 = icmp eq i32 %fdwReason, 2
  br i1 %cmp_fdwReason_eq2, label %thread_attach, label %check_gt2

check_gt2:                                         ; preds = %entry
  %cmp_gt2 = icmp ugt i32 %fdwReason, 2
  br i1 %cmp_gt2, label %check_eq3, label %check_zero

check_eq3:                                         ; preds = %check_gt2
  %cmp_eq3 = icmp eq i32 %fdwReason, 3
  br i1 %cmp_eq3, label %thread_detach, label %ret1

check_zero:                                        ; preds = %check_gt2
  %is_zero = icmp eq i32 %fdwReason, 0
  br i1 %is_zero, label %process_detach, label %process_attach

process_attach:                                    ; preds = %check_zero
  %flag0 = load i32, i32* @dword_1400070E8, align 4
  %flag_zero = icmp eq i32 %flag0, 0
  br i1 %flag_zero, label %init_cs, label %set_flag_and_ret

init_cs:                                           ; preds = %process_attach
  %cs_ptr = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @InitializeCriticalSection(i8* %cs_ptr)
  br label %set_flag_and_ret

set_flag_and_ret:                                  ; preds = %init_cs, %process_attach
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

thread_attach:                                     ; preds = %entry
  call void @sub_1400024E0()
  br label %ret1

thread_detach:                                     ; preds = %check_eq3
  %flag_td = load i32, i32* @dword_1400070E8, align 4
  %flag_td_zero = icmp eq i32 %flag_td, 0
  br i1 %flag_td_zero, label %ret1, label %call_sub_240_and_ret

call_sub_240_and_ret:                              ; preds = %thread_detach
  call void @sub_140002240()
  br label %ret1

process_detach:                                    ; preds = %check_zero
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag_nonzero = icmp ne i32 %flag, 0
  br i1 %flag_nonzero, label %call_sub_240, label %after_maybe_cleanup

call_sub_240:                                      ; preds = %process_detach
  call void @sub_140002240()
  br label %after_maybe_cleanup

after_maybe_cleanup:                               ; preds = %call_sub_240, %process_detach
  %flag2 = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %flag2, 1
  br i1 %is_one, label %free_blocks_and_delete_cs, label %ret1

free_blocks_and_delete_cs:                         ; preds = %after_maybe_cleanup
  %blk0 = load %struct.Block*, %struct.Block** @Block, align 8
  br label %free_loop

free_loop:                                         ; preds = %free_loop_body, %free_blocks_and_delete_cs
  %cur = phi %struct.Block* [ %blk0, %free_blocks_and_delete_cs ], [ %next2, %free_loop_body ]
  %cur_isnull = icmp eq %struct.Block* %cur, null
  br i1 %cur_isnull, label %after_free_loop, label %free_loop_body

free_loop_body:                                    ; preds = %free_loop
  %next_ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i64 0, i32 1
  %next2 = load %struct.Block*, %struct.Block** %next_ptr, align 8
  %cur_i8 = bitcast %struct.Block* %cur to i8*
  call void @free(i8* %cur_i8)
  br label %free_loop

after_free_loop:                                   ; preds = %free_loop
  store %struct.Block* null, %struct.Block** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %cs_ptr2 = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @DeleteCriticalSection(i8* %cs_ptr2)
  br label %ret1

ret1:                                              ; preds = %after_free_loop, %after_maybe_cleanup, %call_sub_240_and_ret, %thread_detach, %thread_attach, %set_flag_and_ret, %check_eq3
  ret i32 1
}