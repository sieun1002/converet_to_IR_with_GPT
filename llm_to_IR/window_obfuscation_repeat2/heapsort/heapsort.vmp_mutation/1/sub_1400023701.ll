; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@Block = external global i8*
@CriticalSection = global [64 x i8] zeroinitializer, align 8

declare void @sub_1400021E0()
declare void @sub_140002480()
declare void @free(i8*)
declare void @DeleteCriticalSection(i8*)
declare void @InitializeCriticalSection(i8*)

define i32 @sub_140002370(i32 %a, i32 %b) {
entry:
  %cmp_eq2 = icmp eq i32 %b, 2
  br i1 %cmp_eq2, label %case2, label %not2

not2:                                              ; preds = %entry
  %cmp_gt2 = icmp ugt i32 %b, 2
  br i1 %cmp_gt2, label %gt2, label %le2

le2:                                               ; preds = %not2
  %is_zero = icmp eq i32 %b, 0
  br i1 %is_zero, label %case0, label %case1

case1:                                             ; preds = %le2
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %flag1_is_zero = icmp eq i32 %flag1, 0
  br i1 %flag1_is_zero, label %initCrit, label %setFlag1

initCrit:                                          ; preds = %case1
  %cs_ptr0 = getelementptr inbounds [64 x i8], [64 x i8]* @CriticalSection, i64 0, i64 0
  call void @InitializeCriticalSection(i8* %cs_ptr0)
  br label %setFlag1

setFlag1:                                          ; preds = %initCrit, %case1
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

gt2:                                               ; preds = %not2
  %cmp_eq3 = icmp eq i32 %b, 3
  br i1 %cmp_eq3, label %eq3, label %ret1

eq3:                                               ; preds = %gt2
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %flag3_zero = icmp eq i32 %flag3, 0
  br i1 %flag3_zero, label %ret1, label %call1E0_then_ret1

call1E0_then_ret1:                                 ; preds = %eq3
  call void @sub_1400021E0()
  br label %ret1

case0:                                             ; preds = %le2
  %flag0 = load i32, i32* @dword_1400070E8, align 4
  %flag0_nonzero = icmp ne i32 %flag0, 0
  br i1 %flag0_nonzero, label %call1E0_then_check, label %check

call1E0_then_check:                                ; preds = %case0
  call void @sub_1400021E0()
  br label %check

check:                                             ; preds = %call1E0_then_check, %case0
  %flag_after = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %flag_after, 1
  br i1 %is_one, label %destroy, label %ret1

destroy:                                           ; preds = %check
  %blk0 = load i8*, i8** @Block, align 8
  %blk_is_null = icmp eq i8* %blk0, null
  br i1 %blk_is_null, label %after_loop, label %loop

loop:                                              ; preds = %loop_cont, %destroy
  %cur = phi i8* [ %blk0, %destroy ], [ %nextptr2, %loop_cont ]
  %next_addr = getelementptr inbounds i8, i8* %cur, i64 16
  %next_ptrptr = bitcast i8* %next_addr to i8**
  %nextptr2 = load i8*, i8** %next_ptrptr, align 8
  call void @free(i8* %cur)
  %has_next = icmp ne i8* %nextptr2, null
  br i1 %has_next, label %loop_cont, label %after_loop

loop_cont:                                         ; preds = %loop
  br label %loop

after_loop:                                        ; preds = %loop, %destroy
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %cs_ptr1 = getelementptr inbounds [64 x i8], [64 x i8]* @CriticalSection, i64 0, i64 0
  call void @DeleteCriticalSection(i8* %cs_ptr1)
  br label %ret1

case2:                                             ; preds = %entry
  call void @sub_140002480()
  br label %ret1

ret1:                                              ; preds = %case2, %after_loop, %eq3, %gt2, %setFlag1, %check
  ret i32 1
}