; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @sub_140001E80()
declare void @sub_140002120()
declare void @"loc_140015626"(i8*)
declare void @"loc_1405DBE11+2"(i8*)
declare void @"loc_1400027ED+3"(i8*)

define i32 @sub_140002010(i32 %ecx, i32 %edx) {
entry:
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %block_d8, label %check_gt2

check_gt2:                                         ; edx > 2?
  %gt2 = icmp ugt i32 %edx, 2
  br i1 %gt2, label %block_048, label %lt2_path

lt2_path:                                          ; edx <= 2
  %iszero = icmp eq i32 %edx, 0
  br i1 %iszero, label %block_060, label %edx_eq1_path

edx_eq1_path:                                      ; edx == 1
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_is_zero = icmp eq i32 %g1, 0
  br i1 %g1_is_zero, label %block_100, label %set_one_and_ret

set_one_and_ret:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

block_048:                                         ; edx > 2 path
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %block_04d, label %ret1

block_04d:                                         ; edx == 3
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_is_zero = icmp eq i32 %g2, 0
  br i1 %g2_is_zero, label %ret1, label %call_e80_then_060

call_e80_then_060:
  call void @sub_140001E80()
  br label %block_060

block_060:                                         ; edx == 0 path
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_nz = icmp ne i32 %g3, 0
  br i1 %g3_nz, label %block_0f0, label %block_06e

block_06e:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %g4, 1
  br i1 %is_one, label %block_079, label %ret1

block_079:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %block_0ab, label %loop

loop:
  %curr = phi i8* [ %head, %block_079 ], [ %next, %loop ]
  %next_field_addr = getelementptr i8, i8* %curr, i64 16
  %next_ptrptr = bitcast i8* %next_field_addr to i8**
  %next = load i8*, i8** %next_ptrptr, align 8
  call void @"loc_1400027ED+3"(i8* %curr)
  %has_next = icmp ne i8* %next, null
  br i1 %has_next, label %loop, label %block_0ab

block_0ab:
  call void @"loc_1405DBE11+2"(i8* @unk_140007100)
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  br label %ret1

block_d8:                                           ; edx == 2
  call void @sub_140002120()
  br label %ret1

block_0f0:
  call void @sub_140001E80()
  br label %ret1

block_100:
  call void @"loc_140015626"(i8* @unk_140007100)
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

ret1:
  ret i32 1
}