; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct._RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }

@dword_1400070E8 = internal global i32 0, align 4
@Block = internal global i8* null, align 8
@CriticalSection = internal global %struct._RTL_CRITICAL_SECTION zeroinitializer, align 8

declare void @free(i8* noundef)
declare void @sub_140002240()
declare void @sub_1400024E0()
declare void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)

define i32 @sub_1400023D0(i8* %hinstDLL, i32 %fdwReason, i8* %lpvReserved) {
entry:
  %cmp_reason_2 = icmp eq i32 %fdwReason, 2
  br i1 %cmp_reason_2, label %case_thread_attach, label %not_2

case_thread_attach:
  call void @sub_1400024E0()
  ret i32 1

not_2:
  %gt_2 = icmp ugt i32 %fdwReason, 2
  br i1 %gt_2, label %gt2block, label %le2block

gt2block:
  %is_3 = icmp eq i32 %fdwReason, 3
  br i1 %is_3, label %case_thread_detach, label %ret1_a

case_thread_detach:
  %val_tdetach = load i32, i32* @dword_1400070E8, align 4
  %cond_tdetach = icmp ne i32 %val_tdetach, 0
  br i1 %cond_tdetach, label %call_2240_then_ret, label %ret1_a

call_2240_then_ret:
  call void @sub_140002240()
  br label %ret1_a

ret1_a:
  ret i32 1

le2block:
  %is_0 = icmp eq i32 %fdwReason, 0
  br i1 %is_0, label %case_process_detach, label %case_process_attach

case_process_attach:
  %cur_init = load i32, i32* @dword_1400070E8, align 4
  %need_init = icmp eq i32 %cur_init, 0
  br i1 %need_init, label %do_initcs, label %set1_ret

do_initcs:
  call void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %set1_ret

set1_ret:
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

case_process_detach:
  %cur_val = load i32, i32* @dword_1400070E8, align 4
  %was_inited = icmp ne i32 %cur_val, 0
  br i1 %was_inited, label %call_2240_then_cont, label %cont_after_call

call_2240_then_cont:
  call void @sub_140002240()
  br label %cont_after_call

cont_after_call:
  %chk_one = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %chk_one, 1
  br i1 %is_one, label %do_cleanup, label %ret1_b

ret1_b:
  ret i32 1

do_cleanup:
  %head = load i8*, i8** @Block, align 8
  br label %loop

loop:
  %curr = phi i8* [ %head, %do_cleanup ], [ %next, %after_free ]
  %is_null = icmp eq i8* %curr, null
  br i1 %is_null, label %after_loop, label %body

body:
  %ptr16 = getelementptr i8, i8* %curr, i64 16
  %nextptr = bitcast i8* %ptr16 to i8**
  %next = load i8*, i8** %nextptr, align 8
  call void @free(i8* %curr)
  br label %after_free

after_free:
  br label %loop

after_loop:
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 1
}