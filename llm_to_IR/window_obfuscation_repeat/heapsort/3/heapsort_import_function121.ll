; ModuleID: 'fixed_module'
source_filename = "fixed_module.ll"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct.Node = type { [16 x i8], %struct.Node* }

@qword_1400070E0 = global %struct.Node* null
@dword_1400070E8 = global i32 0
@unk_140007100 = global [1 x i8] zeroinitializer, align 1

declare void @sub_140002240()
declare void @sub_140002BB0(%struct.Node*)
declare void @sub_1403DDA29(i8*)
declare void @sub_1400024E0()
declare i32 @sub_1400E06D5(i8*)

define i32 @sub_1400023D0(i32 %edx) {
entry:
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %case2, label %check_gt2

check_gt2:                                        ; preds = %entry
  %gt2 = icmp ugt i32 %edx, 2
  br i1 %gt2, label %case_gt2, label %check_zero

check_zero:                                       ; preds = %check_gt2
  %iszero = icmp eq i32 %edx, 0
  br i1 %iszero, label %case0, label %case1

case1:                                            ; preds = %check_zero
  %d0 = load i32, i32* @dword_1400070E8, align 4
  %t0 = icmp eq i32 %d0, 0
  br i1 %t0, label %loc_24C0, label %set1

set1:                                             ; preds = %case1
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

case_gt2:                                         ; preds = %check_gt2
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %case3, label %ret1

case3:                                            ; preds = %case_gt2
  %d3 = load i32, i32* @dword_1400070E8, align 4
  %nz3 = icmp ne i32 %d3, 0
  br i1 %nz3, label %call_240_then_case0, label %ret1

call_240_then_case0:                              ; preds = %case3
  call void @sub_140002240()
  br label %case0

case0:                                            ; preds = %call_240_then_case0, %check_zero
  %dA = load i32, i32* @dword_1400070E8, align 4
  %nzA = icmp ne i32 %dA, 0
  br i1 %nzA, label %call_240_then_24C0, label %check_eq1

check_eq1:                                        ; preds = %case0
  %dB = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %dB, 1
  br i1 %is1, label %process_list, label %ret1

process_list:                                     ; preds = %check_eq1
  %head = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  br label %loop_check

loop_check:                                       ; preds = %loop_body, %process_list
  %cur = phi %struct.Node* [ %head, %process_list ], [ %next, %loop_body ]
  %has = icmp ne %struct.Node* %cur, null
  br i1 %has, label %loop_body, label %after_loop

loop_body:                                        ; preds = %loop_check
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 1
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  call void @sub_140002BB0(%struct.Node* %cur)
  br label %loop_check

after_loop:                                       ; preds = %loop_check
  store %struct.Node* null, %struct.Node** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %unkptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i32 0, i32 0
  call void @sub_1403DDA29(i8* %unkptr)
  br label %ret1

case2:                                            ; preds = %entry
  call void @sub_1400024E0()
  br label %ret1

call_240_then_24C0:                               ; preds = %case0
  call void @sub_140002240()
  br label %loc_24C0

loc_24C0:                                          ; preds = %call_240_then_24C0, %case1
  %unkptr2 = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i32 0, i32 0
  %eax = call i32 @sub_1400E06D5(i8* %unkptr2)
  br label %ret1

ret1:                                             ; preds = %loc_24C0, %case2, %after_loop, %check_eq1, %case3, %case_gt2, %set1
  ret i32 1
}