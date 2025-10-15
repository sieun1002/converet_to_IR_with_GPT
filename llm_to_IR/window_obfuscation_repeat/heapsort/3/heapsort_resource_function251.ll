; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.Block = type { [16 x i8], %struct.Block* }
%RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }

@dword_1400070E8 = dso_local global i32 0, align 4
@Block = dso_local global %struct.Block* null, align 8
@CriticalSection = dso_local global %RTL_CRITICAL_SECTION zeroinitializer, align 8

declare dso_local void @free(i8* noundef)
declare dso_local void @DeleteCriticalSection(%RTL_CRITICAL_SECTION* noundef)
declare dso_local void @InitializeCriticalSection(%RTL_CRITICAL_SECTION* noundef)
declare dso_local void @sub_140002240()
declare dso_local void @sub_1400024E0()

define dso_local i32 @sub_1400023D0(i32 noundef %edx) local_unnamed_addr {
entry:
  %cmp_eq2 = icmp eq i32 %edx, 2
  br i1 %cmp_eq2, label %block_eq2, label %entry_not2

entry_not2:                                       ; preds = %entry
  %cmp_gt2 = icmp ugt i32 %edx, 2
  br i1 %cmp_gt2, label %case_gt2_dispatch, label %case_lt2

case_gt2_dispatch:                                ; preds = %entry_not2
  %cmp_eq3 = icmp eq i32 %edx, 3
  br i1 %cmp_eq3, label %case_eq3_checkflag, label %return1

case_eq3_checkflag:                               ; preds = %case_gt2_dispatch
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %iszero = icmp eq i32 %flag1, 0
  br i1 %iszero, label %return1, label %call_2240_then_return1

call_2240_then_return1:                           ; preds = %case_eq3_checkflag
  call void @sub_140002240()
  br label %return1

case_lt2:                                         ; preds = %entry_not2
  %is_zero = icmp eq i32 %edx, 0
  br i1 %is_zero, label %edx0_path_entry, label %edx1_path

edx1_path:                                        ; preds = %case_lt2
  %flag2 = load i32, i32* @dword_1400070E8, align 4
  %flag2_zero = icmp eq i32 %flag2, 0
  br i1 %flag2_zero, label %init_cs_then_setflag_return, label %setflag_return

init_cs_then_setflag_return:                      ; preds = %edx1_path
  call void @InitializeCriticalSection(%RTL_CRITICAL_SECTION* noundef @CriticalSection)
  br label %setflag_return

setflag_return:                                   ; preds = %init_cs_then_setflag_return, %edx1_path
  store i32 1, i32* @dword_1400070E8, align 4
  br label %return1

edx0_path_entry:                                  ; preds = %case_lt2
  %flag0 = load i32, i32* @dword_1400070E8, align 4
  %flag0_notzero = icmp ne i32 %flag0, 0
  br i1 %flag0_notzero, label %call_2240_then_cont_42E, label %cont_42E

call_2240_then_cont_42E:                          ; preds = %edx0_path_entry
  call void @sub_140002240()
  br label %cont_42E

cont_42E:                                         ; preds = %call_2240_then_cont_42E, %edx0_path_entry
  %flag_after = load i32, i32* @dword_1400070E8, align 4
  %cmp_is1 = icmp eq i32 %flag_after, 1
  br i1 %cmp_is1, label %cleanup_path, label %return1

cleanup_path:                                     ; preds = %cont_42E
  %head = load %struct.Block*, %struct.Block** @Block, align 8
  br label %loop_check

loop_check:                                       ; preds = %loop_free_continue, %cleanup_path
  %curr = phi %struct.Block* [ %head, %cleanup_path ], [ %next, %loop_free_continue ]
  %curr_isnull = icmp eq %struct.Block* %curr, null
  br i1 %curr_isnull, label %after_free, label %loop_free

loop_free:                                        ; preds = %loop_check
  %next_ptr_ptr = getelementptr inbounds %struct.Block, %struct.Block* %curr, i32 0, i32 1
  %next = load %struct.Block*, %struct.Block** %next_ptr_ptr, align 8
  %curr_i8 = bitcast %struct.Block* %curr to i8*
  call void @free(i8* noundef %curr_i8)
  br label %loop_free_continue

loop_free_continue:                               ; preds = %loop_free
  br label %loop_check

after_free:                                       ; preds = %loop_check
  store %struct.Block* null, %struct.Block** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(%RTL_CRITICAL_SECTION* noundef @CriticalSection)
  br label %return1

block_eq2:                                        ; preds = %entry
  call void @sub_1400024E0()
  br label %return1

return1:                                          ; preds = %block_eq2, %after_free, %cont_42E, %setflag_return, %call_2240_then_return1, %case_eq3_checkflag, %case_gt2_dispatch
  ret i32 1
}