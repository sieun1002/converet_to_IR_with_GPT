; ModuleID = 'sub_140002010_module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare void @sub_140001E80()
declare void @sub_140002120()
declare void @"loc_1400027ED+3"(i8*)
declare void @"loc_1405DBE11+2"(i8*)
declare void @loc_140015626(i8*)

define dso_local i32 @sub_140002010(i8* %this, i32 %edx) {
entry:
  %var10 = alloca i8*, align 8
  %cmp_edx_eq_2 = icmp eq i32 %edx, 2
  br i1 %cmp_edx_eq_2, label %case2, label %check_above2

check_above2:                                       ; preds = %entry
  %edx_gt_2 = icmp ugt i32 %edx, 2
  br i1 %edx_gt_2, label %case_gt2, label %case_le2

case_le2:                                           ; preds = %check_above2
  %edx_is_zero = icmp eq i32 %edx, 0
  br i1 %edx_is_zero, label %loc_2060, label %edx_one_path

edx_one_path:                                       ; preds = %case_le2
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_is_zero = icmp eq i32 %g1, 0
  br i1 %g1_is_zero, label %loc_2100, label %set_flag_and_ret

case_gt2:                                           ; preds = %check_above2
  %edx_eq_3 = icmp eq i32 %edx, 3
  br i1 %edx_eq_3, label %edx3, label %return1

edx3:                                               ; preds = %case_gt2
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_is_zero = icmp eq i32 %g2, 0
  br i1 %g2_is_zero, label %return1, label %call_e80_then_2060

call_e80_then_2060:                                 ; preds = %edx3
  call void @sub_140001E80()
  br label %loc_2060

case2:                                              ; preds = %entry
  call void @sub_140002120()
  br label %return1

loc_2060:                                           ; preds = %call_e80_then_2060, %case_le2
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_nonzero = icmp ne i32 %g3, 0
  br i1 %g3_nonzero, label %loc_20F0, label %check_eq1

loc_20F0:                                           ; preds = %loc_2060
  call void @sub_140001E80()
  br label %loc_2100

check_eq1:                                          ; preds = %loc_2060
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %g4_is_one = icmp eq i32 %g4, 1
  br i1 %g4_is_one, label %traverse_entry, label %return1

traverse_entry:                                     ; preds = %check_eq1
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %cleanup_and_call_E11, label %loop_header

loop_header:                                        ; preds = %loop_latch, %traverse_entry
  %current = phi i8* [ %head, %traverse_entry ], [ %next_after, %loop_latch ]
  %next_ptr_i8 = getelementptr i8, i8* %current, i64 16
  %next_ptr = bitcast i8* %next_ptr_i8 to i8**
  %next = load i8*, i8** %next_ptr, align 8
  store i8* %next, i8** %var10, align 8
  call void @"loc_1400027ED+3"(i8* %current)
  %next_after = load i8*, i8** %var10, align 8
  %has_next = icmp ne i8* %next_after, null
  br i1 %has_next, label %loop_latch, label %cleanup_and_call_E11

loop_latch:                                         ; preds = %loop_header
  br label %loop_header

cleanup_and_call_E11:                               ; preds = %loop_header, %traverse_entry
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @"loc_1405DBE11+2"(i8* @unk_140007100)
  br label %return1

loc_2100:                                           ; preds = %loc_20F0, %edx_one_path
  call void @loc_140015626(i8* @unk_140007100)
  br label %set_flag_and_ret

set_flag_and_ret:                                   ; preds = %loc_2100, %edx_one_path
  store i32 1, i32* @dword_1400070E8, align 4
  br label %return1

return1:                                            ; preds = %cleanup_and_call_E11, %check_eq1, %case2, %edx3, %case_gt2, %set_flag_and_ret
  ret i32 1
}