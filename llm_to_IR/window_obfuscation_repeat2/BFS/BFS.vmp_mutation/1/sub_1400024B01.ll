; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = global i32 0, align 4
@Block = global i8* null, align 8
@CriticalSection = global [40 x i8] zeroinitializer, align 8

declare void @sub_140002320()
declare void @sub_1400025C0()
declare void @free(i8*)
declare void @InitializeCriticalSection(i8*)
declare void @DeleteCriticalSection(i8*)

define i32 @sub_1400024B0(i32 %arg1, i32 %arg2) {
entry:
  %cmp_edx_2 = icmp eq i32 %arg2, 2
  br i1 %cmp_edx_2, label %case2, label %cmp_after1

case2:                                             ; edx == 2
  call void @sub_1400025C0()
  ret i32 1

cmp_after1:
  %gt2 = icmp ugt i32 %arg2, 2
  br i1 %gt2, label %gt_block, label %le2_block

le2_block:
  %isZero = icmp eq i32 %arg2, 0
  br i1 %isZero, label %case0, label %case1

case1:                                             ; edx == 1
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %flag1_is0 = icmp eq i32 %flag1, 0
  br i1 %flag1_is0, label %init_crit, label %set_flag_and_return

init_crit:
  %cs_ptr = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @InitializeCriticalSection(i8* %cs_ptr)
  br label %after_init

after_init:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %return1

set_flag_and_return:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %return1

gt_block:
  %is3 = icmp eq i32 %arg2, 3
  br i1 %is3, label %case3, label %return1

case3:
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %flag3_is0 = icmp eq i32 %flag3, 0
  br i1 %flag3_is0, label %return1, label %call_2320

call_2320:
  call void @sub_140002320()
  br label %return1

case0:                                             ; edx == 0
  %flag0 = load i32, i32* @dword_1400070E8, align 4
  %flag0_not0 = icmp ne i32 %flag0, 0
  br i1 %flag0_not0, label %call_then_check_flag1, label %check_flag1

call_then_check_flag1:
  call void @sub_140002320()
  br label %check_flag1

check_flag1:
  %flag_after = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %flag_after, 1
  br i1 %is_one, label %cleanup_block, label %return1

cleanup_block:
  %block = load i8*, i8** @Block, align 8
  br label %loop_check

loop_check:
  %cur = phi i8* [ %block, %cleanup_block ], [ %next, %after_free ]
  %cond = icmp eq i8* %cur, null
  br i1 %cond, label %after_loop, label %loop_body

loop_body:
  %cur_plus16 = getelementptr i8, i8* %cur, i64 16
  %next_ptr = bitcast i8* %cur_plus16 to i8**
  %next = load i8*, i8** %next_ptr, align 8
  call void @free(i8* %cur)
  br label %after_free

after_free:
  br label %loop_check

after_loop:
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %cs_ptr2 = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @DeleteCriticalSection(i8* %cs_ptr2)
  br label %return1

return1:
  ret i32 1
}