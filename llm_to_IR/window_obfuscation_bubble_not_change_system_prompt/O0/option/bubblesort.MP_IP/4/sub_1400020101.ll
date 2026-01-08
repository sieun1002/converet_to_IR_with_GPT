; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32
@qword_1400070E0 = external dso_local global i8*
@"unk_140007100" = external dso_local global i8

declare dso_local void @sub_140001E80()
declare dso_local void @sub_140002120()
declare dso_local void @sub_1404EFA12(i8*)
declare dso_local void @"loc_1405C002E"(i8*)
declare dso_local void @"loc_1400027ED+3"(i8*)

define dso_local i32 @sub_140002010(i32 %arg1, i32 %edx) {
entry:
  %next.save = alloca i8*, align 8
  %cmp_edx_2 = icmp eq i32 %edx, 2
  br i1 %cmp_edx_2, label %case2, label %after_cmp2

after_cmp2:                                      ; edx != 2
  %ugt2 = icmp ugt i32 %edx, 2
  br i1 %ugt2, label %gt2, label %le2

le2:                                             ; edx is 0 or 1
  %is_zero = icmp eq i32 %edx, 0
  br i1 %is_zero, label %case0, label %case1like

; edx == 2
case2:
  call void @sub_140002120()
  br label %ret1

; edx > 2
gt2:
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %edx_is_3, label %ret1

edx_is_3:
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %flag3_zero = icmp eq i32 %flag3, 0
  br i1 %flag3_zero, label %ret1, label %do_call_e80_gt2

do_call_e80_gt2:
  call void @sub_140001E80()
  br label %ret1

; edx == 1 path
case1like:
  %f1 = load i32, i32* @dword_1400070E8, align 4
  %f1_zero = icmp eq i32 %f1, 0
  br i1 %f1_zero, label %init_then_set1, label %set_flag1

init_then_set1:
  %unk_ptr1 = bitcast i8* @"unk_140007100" to i8*
  call void @sub_1404EFA12(i8* %unk_ptr1)
  br label %set_flag1

set_flag1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

; edx == 0 path
case0:
  %f0 = load i32, i32* @dword_1400070E8, align 4
  %f0_nz = icmp ne i32 %f0, 0
  br i1 %f0_nz, label %call_e80_then_06E, label %at_06E

call_e80_then_06E:
  call void @sub_140001E80()
  br label %at_06E

at_06E:
  %f2 = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %f2, 1
  br i1 %is_one, label %list_proc, label %ret1

list_proc:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %cleanup_call, label %loop

loop:
  %cur = phi i8* [ %head, %list_proc ], [ %next_after, %loop ]
  %next_ptr_i8 = getelementptr i8, i8* %cur, i64 16
  %next_ptr = bitcast i8* %next_ptr_i8 to i8**
  %next_val = load i8*, i8** %next_ptr, align 8
  store i8* %next_val, i8** %next.save, align 8
  call void @"loc_1400027ED+3"(i8* %cur)
  %next_after = load i8*, i8** %next.save, align 8
  %cont = icmp ne i8* %next_after, null
  br i1 %cont, label %loop, label %cleanup_call

cleanup_call:
  %unk_ptr2 = bitcast i8* @"unk_140007100" to i8*
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @"loc_1405C002E"(i8* %unk_ptr2)
  br label %ret1

ret1:
  ret i32 1
}