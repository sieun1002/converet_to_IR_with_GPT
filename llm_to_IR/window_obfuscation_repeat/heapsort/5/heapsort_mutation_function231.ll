; ModuleID = 'fixed_module'
source_filename = "fixed_module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { [16 x i8], %struct.Node* }

@dword_1400070E8 = global i32 0, align 4
@Block = global %struct.Node* null, align 8
@CriticalSection = global [40 x i8] zeroinitializer, align 8

declare dllimport void @free(i8* noundef)
declare dllimport void @InitializeCriticalSection(i8* noundef)
declare dllimport void @DeleteCriticalSection(i8* noundef)

declare void @sub_140002240()
declare void @sub_1400024E0()

define i32 @sub_1400023D0(i32 noundef %mode) {
entry:
  %cmp2 = icmp eq i32 %mode, 2
  br i1 %cmp2, label %case2, label %check_gt2

check_gt2:                                        ; preds = %entry
  %cmpgt = icmp ugt i32 %mode, 2
  br i1 %cmpgt, label %gt2, label %check_zero

gt2:                                              ; preds = %check_gt2
  %cmpneq3 = icmp ne i32 %mode, 3
  br i1 %cmpneq3, label %ret1, label %gt2_eq3

gt2_eq3:                                          ; preds = %gt2
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %iszero1 = icmp eq i32 %flag1, 0
  br i1 %iszero1, label %ret1, label %call_sub_240_then_ret

call_sub_240_then_ret:                            ; preds = %gt2_eq3
  call void @sub_140002240()
  br label %ret1

check_zero:                                       ; preds = %check_gt2
  %iszero_mode = icmp eq i32 %mode, 0
  br i1 %iszero_mode, label %mode0, label %mode1_path

mode1_path:                                       ; preds = %check_zero
  %f2 = load i32, i32* @dword_1400070E8, align 4
  %f2_iszero = icmp eq i32 %f2, 0
  br i1 %f2_iszero, label %init_cs_then_set, label %set_flag_and_ret

init_cs_then_set:                                 ; preds = %mode1_path
  %cs_ptr = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @InitializeCriticalSection(i8* %cs_ptr)
  br label %set_flag_store

set_flag_and_ret:                                 ; preds = %mode1_path
  br label %set_flag_store

set_flag_store:                                   ; preds = %set_flag_and_ret, %init_cs_then_set
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

mode0:                                            ; preds = %check_zero
  %f3 = load i32, i32* @dword_1400070E8, align 4
  %f3_nz = icmp ne i32 %f3, 0
  br i1 %f3_nz, label %call240_in_mode0, label %after_call240

call240_in_mode0:                                 ; preds = %mode0
  call void @sub_140002240()
  br label %after_call240

after_call240:                                    ; preds = %call240_in_mode0, %mode0
  %f4 = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %f4, 1
  br i1 %is_one, label %cleanup, label %ret1

cleanup:                                          ; preds = %after_call240
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %head_isnull = icmp eq %struct.Node* %head, null
  br i1 %head_isnull, label %after_free_loop, label %free_loop

free_loop:                                        ; preds = %free_loop, %cleanup
  %curr = phi %struct.Node* [ %head, %cleanup ], [ %next, %free_loop ]
  %next_ptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i64 0, i32 1
  %next = load %struct.Node*, %struct.Node** %next_ptr, align 8
  %curr_i8 = bitcast %struct.Node* %curr to i8*
  call void @free(i8* %curr_i8)
  %has_next = icmp ne %struct.Node* %next, null
  br i1 %has_next, label %free_loop, label %after_free_loop

after_free_loop:                                  ; preds = %free_loop, %cleanup
  %cs_ptr2 = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  store %struct.Node* null, %struct.Node** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(i8* %cs_ptr2)
  br label %ret1

case2:                                            ; preds = %entry
  call void @sub_1400024E0()
  br label %ret1

ret1:                                             ; preds = %case2, %after_free_loop, %after_call240, %set_flag_store, %gt2_eq3, %call_sub_240_then_ret, %gt2
  ret i32 1
}