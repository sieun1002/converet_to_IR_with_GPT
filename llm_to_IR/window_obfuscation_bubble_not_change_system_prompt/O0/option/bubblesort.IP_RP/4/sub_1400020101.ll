; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare void @sub_140001E80()
declare void @loc_1400027F0(i8*)
declare i32 @sub_1400FEC71(i8*)
declare void @loc_1400E441D(i8*)
declare void @sub_140002120()

define i32 @sub_140002010(i8* %rcx.arg, i32 %edx.arg) {
entry:
  %cmp_eq2 = icmp eq i32 %edx.arg, 2
  br i1 %cmp_eq2, label %bb_d8, label %bb_after_cmp2

bb_after_cmp2:                                     ; edx != 2
  %cmp_ugt2 = icmp ugt i32 %edx.arg, 2
  br i1 %cmp_ugt2, label %bb_048, label %bb_01f

bb_01f:                                           ; edx == 0 or 1
  %is_zero = icmp eq i32 %edx.arg, 0
  br i1 %is_zero, label %bb_060, label %bb_023

bb_023:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_is_zero = icmp eq i32 %g1, 0
  br i1 %g1_is_zero, label %bb_100, label %bb_031

bb_031:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret_one

ret_one:
  ret i32 1

bb_048:
  %cmp_eq3 = icmp eq i32 %edx.arg, 3
  br i1 %cmp_eq3, label %bb_04d, label %ret_one

bb_04d:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_is_zero = icmp eq i32 %g2, 0
  br i1 %g2_is_zero, label %ret_one, label %bb_057

bb_057:
  call void @sub_140001E80()
  br label %bb_060

bb_060:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_nz = icmp ne i32 %g3, 0
  br i1 %g3_nz, label %bb_0f0, label %bb_06e

bb_06e:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %g4_is1 = icmp eq i32 %g4, 1
  br i1 %g4_is1, label %bb_079, label %ret_one

bb_079:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %bb_0ab, label %bb_090

bb_090:
  %cur = phi i8* [ %head, %bb_079 ], [ %next_loaded, %bb_0a9_back ]
  %next_addr = getelementptr i8, i8* %cur, i64 16
  %next_addr_pp = bitcast i8* %next_addr to i8**
  %next_loaded = load i8*, i8** %next_addr_pp, align 8
  call void @loc_1400027F0(i8* %cur)
  %next_nz = icmp ne i8* %next_loaded, null
  br i1 %next_nz, label %bb_0a9_back, label %bb_0ab

bb_0a9_back:
  br label %bb_090

bb_0ab:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %ret_c7 = call i32 @sub_1400FEC71(i8* @unk_140007100)
  %le_zero = icmp sle i32 %ret_c7, 0
  br i1 %le_zero, label %bb_after_c7, label %bb_0ce

bb_0ce:
  br label %bb_after_c7

bb_after_c7:
  br label %bb_d8

bb_d8:
  call void @sub_140002120()
  br label %ret_one

bb_0f0:
  call void @sub_140001E80()
  br label %bb_100

bb_100:
  call void @loc_1400E441D(i8* @unk_140007100)
  br label %bb_031
}