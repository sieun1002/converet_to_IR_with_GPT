; ModuleID = 'sub_140002010_module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @sub_140002120()
declare void @sub_140001E80()
declare void @loc_1400027ED_plus_3(i8*)
declare void @loc_1405DBE11_plus_2(i8*)
declare void @loc_140015626(i8*)

define dso_local i32 @sub_140002010(i32 %edx) {
entry:
  %var10 = alloca i8*, align 8
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %case2, label %after_cmp2

case2:
  call void @sub_140002120()
  br label %ret1

after_cmp2:
  %ugt2 = icmp ugt i32 %edx, 2
  br i1 %ugt2, label %label_140002048, label %label_test_edx0

label_test_edx0:
  %iszero = icmp eq i32 %edx, 0
  br i1 %iszero, label %label_140002060, label %label_140002023

label_140002023:
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %flag1_zero = icmp eq i32 %flag1, 0
  br i1 %flag1_zero, label %label_140002100, label %label_140002031

label_140002031:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

label_140002048:
  %is_three = icmp eq i32 %edx, 3
  br i1 %is_three, label %label_14000204d, label %ret1

label_14000204d:
  %flag2 = load i32, i32* @dword_1400070E8, align 4
  %flag2_zero = icmp eq i32 %flag2, 0
  br i1 %flag2_zero, label %ret1, label %call_sub_140001E80_then_to_060

call_sub_140001E80_then_to_060:
  call void @sub_140001E80()
  br label %label_140002060

label_140002060:
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %flag3_nz = icmp ne i32 %flag3, 0
  br i1 %flag3_nz, label %label_1400020F0, label %label_14000206e

label_1400020F0:
  call void @sub_140001E80()
  br label %label_140002100

label_140002100:
  call void @loc_140015626(i8* @unk_140007100)
  br label %label_140002031

label_14000206e:
  %flag4 = load i32, i32* @dword_1400070E8, align 4
  %flag4_is1 = icmp eq i32 %flag4, 1
  br i1 %flag4_is1, label %label_140002079, label %ret1

label_140002079:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_null = icmp eq i8* %head, null
  br i1 %head_null, label %label_1400020ab, label %loop_140002090

loop_140002090:
  %cur = phi i8* [ %head, %label_140002079 ], [ %reloaded_next, %loop_body_end ]
  %tmp_gep = getelementptr i8, i8* %cur, i64 16
  %nextptr = bitcast i8* %tmp_gep to i8**
  %next = load i8*, i8** %nextptr, align 8
  store i8* %next, i8** %var10, align 8
  call void @loc_1400027ED_plus_3(i8* %cur)
  %reloaded_next = load i8*, i8** %var10, align 8
  %hasnext = icmp ne i8* %reloaded_next, null
  br i1 %hasnext, label %loop_body_end, label %label_1400020ab

loop_body_end:
  br label %loop_140002090

label_1400020ab:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @loc_1405DBE11_plus_2(i8* @unk_140007100)
  br label %ret1

ret1:
  ret i32 1
}