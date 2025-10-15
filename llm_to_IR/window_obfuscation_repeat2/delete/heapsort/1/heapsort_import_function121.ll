; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @sub_140002240()
declare void @sub_140002BB0(i8*)
declare void @sub_1403DDA29(i8*)
declare void @sub_1400024E0()
declare i32 @sub_1400E06D5(i8*)

define i32 @sub_1400023D0(i8* %rcx, i32 %edx) {
entry:
  %edx_cmp2 = icmp eq i32 %edx, 2
  br i1 %edx_cmp2, label %loc_140002498, label %cmp_gt_2

cmp_gt_2:                                           ; edx != 2
  %ugt2 = icmp ugt i32 %edx, 2
  br i1 %ugt2, label %loc_140002408, label %check_zero_or_one

check_zero_or_one:                                  ; edx <= 2 and edx != 2 => edx is 0 or 1
  %is_zero = icmp eq i32 %edx, 0
  br i1 %is_zero, label %loc_140002420, label %edx_is_one

edx_is_one:                                         ; edx == 1
  %v1 = load i32, i32* @dword_1400070E8, align 4
  %v1_is_zero = icmp eq i32 %v1, 0
  br i1 %v1_is_zero, label %loc_1400024C0, label %set_flag_and_ret

set_flag_and_ret:
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

loc_140002408:                                      ; edx > 2
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %edx_eq_3, label %ret1

edx_eq_3:
  %v2 = load i32, i32* @dword_1400070E8, align 4
  %v2_is_zero = icmp eq i32 %v2, 0
  br i1 %v2_is_zero, label %ret1, label %call_240_then_420

call_240_then_420:
  call void @sub_140002240()
  br label %loc_140002420

ret1:
  ret i32 1

loc_140002420:
  %v3 = load i32, i32* @dword_1400070E8, align 4
  %v3_nonzero = icmp ne i32 %v3, 0
  br i1 %v3_nonzero, label %loc_1400024B0, label %check_eq_one

check_eq_one:
  %v4 = load i32, i32* @dword_1400070E8, align 4
  %v4_is_one = icmp eq i32 %v4, 1
  br i1 %v4_is_one, label %teardown_head_check, label %ret1_b

ret1_b:
  ret i32 1

teardown_head_check:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %after_loop, label %loop_preheader

loop_preheader:
  br label %loop

loop:
  %p = phi i8* [ %head, %loop_preheader ], [ %next_val, %loop_back ]
  %fieldptr_i8 = getelementptr i8, i8* %p, i64 16
  %fieldptr = bitcast i8* %fieldptr_i8 to i8**
  %next_val = load i8*, i8** %fieldptr, align 8
  call void @sub_140002BB0(i8* %p)
  %has_next = icmp ne i8* %next_val, null
  br i1 %has_next, label %loop_back, label %after_loop

loop_back:
  br label %loop

after_loop:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @sub_1403DDA29(i8* @unk_140007100)
  ret i32 1

loc_140002498:
  call void @sub_1400024E0()
  ret i32 1

loc_1400024B0:
  call void @sub_140002240()
  br label %loc_1400024C0

loc_1400024C0:
  %ret_e06d5 = call i32 @sub_1400E06D5(i8* @unk_140007100)
  %sub_eax = sub i32 %ret_e06d5, 4294907625
  %sub_eax_zext = zext i32 %sub_eax to i64
  %addr = sub i64 %sub_eax_zext, 1869770784
  %fpptr = inttoptr i64 %addr to void ()**
  %fp = load void ()*, void ()** %fpptr, align 8
  call void %fp()
  unreachable
}