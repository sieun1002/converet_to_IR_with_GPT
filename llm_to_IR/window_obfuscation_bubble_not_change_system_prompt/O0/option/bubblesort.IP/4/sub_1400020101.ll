; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070E0 = external global i8*
@dword_1400070E8 = external global i32
@unk_140007100 = external global i8

declare void @sub_140001E80()
declare void @sub_1400027F0(i8*)
declare void @sub_1400CDFE0(i8*)
declare void @sub_140002120()
declare void @sub_1400E50C4(i8*)

define i32 @sub_140002010(i8* %rcx, i32 %edx) {
entry:
  %cmp_edx_2 = icmp eq i32 %edx, 2
  br i1 %cmp_edx_2, label %case2, label %after_cmp2

case2:                                            ; edx == 2
  call void @sub_140002120()
  br label %ret1

after_cmp2:
  %ugt2 = icmp ugt i32 %edx, 2
  br i1 %ugt2, label %gt2_block, label %le2_block

gt2_block:                                        ; edx > 2
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %case3, label %ret1

case3:                                            ; edx == 3
  %g_case3 = load i32, i32* @dword_1400070E8, align 4
  %g_case3_nz = icmp ne i32 %g_case3, 0
  br i1 %g_case3_nz, label %call_e80_case3, label %ret1

call_e80_case3:
  call void @sub_140001E80()
  br label %ret1

le2_block:                                        ; edx <= 2 and edx != 2 -> edx == 0 or 1 (or other <=2 but not 0 handled like 1 by test)
  %isZero = icmp eq i32 %edx, 0
  br i1 %isZero, label %case0, label %case1

case1:                                            ; edx == 1
  %g_case1 = load i32, i32* @dword_1400070E8, align 4
  %g_case1_z = icmp eq i32 %g_case1, 0
  br i1 %g_case1_z, label %call_e50c4, label %set_flag1

call_e50c4:
  call void @sub_1400E50C4(i8* @unk_140007100)
  br label %set_flag1

set_flag1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

case0:                                            ; edx == 0
  %g_case0 = load i32, i32* @dword_1400070E8, align 4
  %g_case0_nz = icmp ne i32 %g_case0, 0
  br i1 %g_case0_nz, label %call_e80_case0, label %check_state_after

call_e80_case0:
  call void @sub_140001E80()
  br label %check_state_after

check_state_after:
  %g_after = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %g_after, 1
  br i1 %is_one, label %do_cleanup, label %ret1

do_cleanup:
  %head = load i8*, i8** @qword_1400070E0, align 8
  br label %loop_check

loop_check:
  %cur = phi i8* [ %head, %do_cleanup ], [ %next, %loop_body ]
  %isnull = icmp eq i8* %cur, null
  br i1 %isnull, label %after_loop, label %loop_body

loop_body:
  %next_addr_i8 = getelementptr i8, i8* %cur, i64 16
  %next_addr = bitcast i8* %next_addr_i8 to i8**
  %next = load i8*, i8** %next_addr, align 8
  call void @sub_1400027F0(i8* %cur)
  br label %loop_check

after_loop:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @sub_1400CDFE0(i8* @unk_140007100)
  br label %ret1

ret1:
  ret i32 1
}