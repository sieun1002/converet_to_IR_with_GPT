; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare void @sub_140001E80()
declare void @sub_140002120()
declare void @loc_1400027F0(i8* noundef)
declare i32 @sub_1400FEC71(i8* noundef)
declare void @loc_1400E441D(i8* noundef)

define i32 @sub_140002010(i32 %edx) local_unnamed_addr {
entry:
  %cmp_eq2 = icmp eq i32 %edx, 2
  br i1 %cmp_eq2, label %case2, label %not2

not2:
  %cmp_ugt2 = icmp ugt i32 %edx, 2
  br i1 %cmp_ugt2, label %gt2, label %le2

gt2:
  %cmp_ne3 = icmp ne i32 %edx, 3
  br i1 %cmp_ne3, label %ret1, label %eq3

eq3:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %iszero_g1 = icmp eq i32 %g1, 0
  br i1 %iszero_g1, label %ret1, label %call_e80_then_case0

call_e80_then_case0:
  call void @sub_140001E80()
  br label %case0

le2:
  %iszero_edx = icmp eq i32 %edx, 0
  br i1 %iszero_edx, label %case0, label %case1

case1:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_is_zero = icmp eq i32 %g2, 0
  br i1 %g2_is_zero, label %do_call_e441d, label %after_call_e441d

do_call_e441d:
  call void @loc_1400E441D(i8* @unk_140007100)
  br label %after_call_e441d

after_call_e441d:
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

case0:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_nonzero = icmp ne i32 %g3, 0
  br i1 %g3_nonzero, label %loc_20f0, label %check_eq1

loc_20f0:
  call void @sub_140001E80()
  br label %loc_2100

loc_2100:
  call void @loc_1400E441D(i8* @unk_140007100)
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

check_eq1:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %g4, 1
  br i1 %is_one, label %list_start, label %ret1

list_start:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %after_loop, label %loop_header

loop_header:
  %curr = phi i8* [ %head, %list_start ], [ %next, %loop_body ]
  %curr_next_gep = getelementptr i8, i8* %curr, i64 16
  %next_ptr = bitcast i8* %curr_next_gep to i8**
  %next = load i8*, i8** %next_ptr, align 8
  call void @loc_1400027F0(i8* %curr)
  %has_next = icmp ne i8* %next, null
  br i1 %has_next, label %loop_body, label %after_loop

loop_body:
  br label %loop_header

after_loop:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %r = call i32 @sub_1400FEC71(i8* @unk_140007100)
  br label %case2

case2:
  call void @sub_140002120()
  ret i32 1

ret1:
  ret i32 1
}