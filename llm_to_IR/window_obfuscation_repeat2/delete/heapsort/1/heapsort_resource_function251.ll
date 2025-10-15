; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }

@dword_1400070E8 = global i32 0, align 4
@Block = global i8* null, align 8
@CriticalSection = global %struct._RTL_CRITICAL_SECTION zeroinitializer, align 8

declare dllimport void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @free(i8*)
declare void @sub_140002240()
declare void @sub_1400024E0()

define i32 @sub_1400023D0(i32 %edx) local_unnamed_addr {
entry:
  %cmp_eq_2 = icmp eq i32 %edx, 2
  br i1 %cmp_eq_2, label %case2, label %check_gt2

check_gt2:                                         ; preds = %entry
  %cmp_gt_2 = icmp ugt i32 %edx, 2
  br i1 %cmp_gt_2, label %gt2_block, label %check_zero

case2:                                             ; preds = %entry
  call void @sub_1400024E0()
  ret i32 1

gt2_block:                                         ; preds = %check_gt2
  %cmp_eq_3 = icmp eq i32 %edx, 3
  br i1 %cmp_eq_3, label %case3, label %ret1

case3:                                             ; preds = %gt2_block
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %flag3_nz = icmp ne i32 %flag3, 0
  br i1 %flag3_nz, label %call_sub240_case3, label %ret1

call_sub240_case3:                                 ; preds = %case3
  call void @sub_140002240()
  br label %ret1

check_zero:                                        ; preds = %check_gt2
  %is_zero = icmp eq i32 %edx, 0
  br i1 %is_zero, label %case0, label %case1

case1:                                             ; preds = %check_zero
  %curflag = load i32, i32* @dword_1400070E8, align 4
  %curflag_zero = icmp eq i32 %curflag, 0
  br i1 %curflag_zero, label %initcs_then_set1, label %set1

initcs_then_set1:                                  ; preds = %case1
  call void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %set1

set1:                                              ; preds = %initcs_then_set1, %case1
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

case0:                                             ; preds = %check_zero
  %f0 = load i32, i32* @dword_1400070E8, align 4
  %f0_nz = icmp ne i32 %f0, 0
  br i1 %f0_nz, label %call240_and_continue, label %after240

call240_and_continue:                              ; preds = %case0
  call void @sub_140002240()
  br label %after240

after240:                                          ; preds = %call240_and_continue, %case0
  %f1 = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %f1, 1
  br i1 %is_one, label %maybe_free, label %ret1

maybe_free:                                        ; preds = %after240
  %head = load i8*, i8** @Block, align 8
  %head_isnull = icmp eq i8* %head, null
  br i1 %head_isnull, label %cleanup_cs, label %free_loop

free_loop:                                         ; preds = %free_loop_latch, %maybe_free
  %curr = phi i8* [ %head, %maybe_free ], [ %next, %free_loop_latch ]
  %nextaddr_i8 = getelementptr i8, i8* %curr, i64 16
  %nextaddr = bitcast i8* %nextaddr_i8 to i8**
  %next = load i8*, i8** %nextaddr, align 8
  call void @free(i8* %curr)
  %has_next = icmp ne i8* %next, null
  br i1 %has_next, label %free_loop_latch, label %cleanup_cs

free_loop_latch:                                   ; preds = %free_loop
  br label %free_loop

cleanup_cs:                                        ; preds = %free_loop, %maybe_free
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  br label %ret1

ret1:                                              ; preds = %cleanup_cs, %after240, %set1, %case3, %call_sub240_case3, %gt2_block
  ret i32 1
}