; ModuleID = 'sub_140002010.ll'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070E0 = external global i8*
@dword_1400070E8 = external global i32
@unk_140007100 = external global i8
@qword_140008250 = external global void (i8*)*
@qword_140008268 = external global void (i8*)*

declare void @sub_140001E80()
declare void @sub_140002120()
declare void @sub_1400027F0(i8*)

define i32 @sub_140002010(i8* %rcx, i32 %edx, i8* %r8) {
entry:
  %var10 = alloca i8*, align 8
  %cmp_eq_2 = icmp eq i32 %edx, 2
  br i1 %cmp_eq_2, label %loc_20D8, label %after_cmp2

after_cmp2:                                           ; edx != 2
  %cmp_ugt_2 = icmp ugt i32 %edx, 2
  br i1 %cmp_ugt_2, label %loc_2048, label %loc_201f

loc_201f:                                             ; edx <= 2 and != 2
  %is_zero = icmp eq i32 %edx, 0
  br i1 %is_zero, label %loc_2060, label %loc_2023

loc_2023:                                             ; edx == 1
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_is_zero = icmp eq i32 %g1, 0
  br i1 %g1_is_zero, label %loc_2100, label %loc_2031

loc_2031:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %loc_203b

loc_203b:
  ret i32 1

loc_2048:                                             ; edx > 2
  %is_three = icmp eq i32 %edx, 3
  br i1 %is_three, label %loc_204d_true, label %loc_203b

loc_204d_true:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_is_zero = icmp eq i32 %g2, 0
  br i1 %g2_is_zero, label %loc_203b, label %loc_2057

loc_2057:
  call void @sub_140001E80()
  br label %loc_203b

loc_2060:                                             ; edx == 0
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_nz = icmp ne i32 %g3, 0
  br i1 %g3_nz, label %loc_20F0, label %loc_206e

loc_20F0:
  call void @sub_140001E80()
  br label %loc_206e

loc_206e:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %g4_is_one = icmp eq i32 %g4, 1
  br i1 %g4_is_one, label %loc_2079, label %loc_203b

loc_2079:
  %p = load i8*, i8** @qword_1400070E0, align 8
  %p_is_null = icmp eq i8* %p, null
  br i1 %p_is_null, label %loc_20ab, label %loc_2090

loc_2090:
  br label %loop

loop:
  %cur = phi i8* [ %p, %loc_2090 ], [ %next_loaded, %after_call ]
  %field_off = getelementptr i8, i8* %cur, i64 16
  %field_ptrptr = bitcast i8* %field_off to i8**
  %next0 = load i8*, i8** %field_ptrptr, align 8
  store i8* %next0, i8** %var10, align 8
  call void @sub_1400027F0(i8* %cur)
  br label %after_call

after_call:
  %next_loaded = load i8*, i8** %var10, align 8
  %has_next = icmp ne i8* %next_loaded, null
  br i1 %has_next, label %loop, label %loc_20ab

loc_20ab:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %fp1 = load void (i8*)*, void (i8*)** @qword_140008250, align 8
  call void %fp1(i8* @unk_140007100)
  br label %loc_203b

loc_20D8:
  call void @sub_140002120()
  ret i32 1

loc_2100:
  %fp2 = load void (i8*)*, void (i8*)** @qword_140008268, align 8
  call void %fp2(i8* @unk_140007100)
  br label %loc_2031
}