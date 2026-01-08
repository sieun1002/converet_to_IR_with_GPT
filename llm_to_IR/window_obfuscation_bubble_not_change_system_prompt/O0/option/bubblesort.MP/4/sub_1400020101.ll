; ModuleID = 'sub_140002010'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32
@qword_1400070E0 = external dso_local global i8*
@unk_140007100 = external dso_local global i8
@qword_140008250 = external dso_local global void (i8*)*
@qword_140008268 = external dso_local global void (i8*)*

declare dso_local void @sub_140001E80()
declare dso_local void @sub_140002120()
declare dso_local void @sub_1400027F0(i8*)

define dso_local i32 @sub_140002010(i32 %param0, i32 %param1) {
entry:
  %var_next = alloca i8*, align 8
  %cmp_edx_2 = icmp eq i32 %param1, 2
  br i1 %cmp_edx_2, label %case_edx_2, label %after_cmp2

case_edx_2:                                     ; loc_1400020D8
  call void @sub_140002120()
  br label %ret1

after_cmp2:
  %edx_gt_2 = icmp ugt i32 %param1, 2
  br i1 %edx_gt_2, label %case_gt2, label %check_zero

check_zero:                                     ; edx == 0 or 1
  %edx_is_zero = icmp eq i32 %param1, 0
  br i1 %edx_is_zero, label %case_edx_0, label %case_edx_1

case_edx_1:                                     ; edx == 1
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_is_zero = icmp eq i32 %g1, 0
  br i1 %g1_is_zero, label %loc_140002100, label %set_one_and_ret

loc_140002100:
  %fp268 = load void (i8*)*, void (i8*)** @qword_140008268, align 8
  call void %fp268(i8* @unk_140007100)
  br label %set_one_and_ret

set_one_and_ret:                                ; loc_140002031
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

case_gt2:                                       ; edx > 2
  %edx_is_3 = icmp eq i32 %param1, 3
  br i1 %edx_is_3, label %case_edx_3, label %ret1

case_edx_3:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_is_zero = icmp eq i32 %g2, 0
  br i1 %g2_is_zero, label %ret1, label %call_E80_then_ret

call_E80_then_ret:
  call void @sub_140001E80()
  br label %ret1

case_edx_0:                                     ; edx == 0
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_nonzero = icmp ne i32 %g3, 0
  br i1 %g3_nonzero, label %loc_1400020F0, label %loc_14000206E

loc_1400020F0:
  call void @sub_140001E80()
  br label %loc_14000206E

loc_14000206E:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %g4_is_one = icmp eq i32 %g4, 1
  br i1 %g4_is_one, label %cleanup_loop_start, label %ret1

cleanup_loop_start:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %after_loop, label %loop

loop:
  %cur = phi i8* [ %head, %cleanup_loop_start ], [ %loaded_next, %loop_continue ]
  %next_addr = getelementptr i8, i8* %cur, i64 16
  %next_slot = bitcast i8* %next_addr to i8**
  %next = load i8*, i8** %next_slot, align 8
  store i8* %next, i8** %var_next, align 8
  call void @sub_1400027F0(i8* %cur)
  %loaded_next = load i8*, i8** %var_next, align 8
  %has_next = icmp ne i8* %loaded_next, null
  br i1 %has_next, label %loop_continue, label %after_loop

loop_continue:
  br label %loop

after_loop:                                     ; loc_1400020AB and following
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %fp250 = load void (i8*)*, void (i8*)** @qword_140008250, align 8
  call void %fp250(i8* @unk_140007100)
  br label %ret1

ret1:                                           ; unified return (mov eax, 1; ret)
  ret i32 1
}