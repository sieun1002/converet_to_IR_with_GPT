; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32, align 4
@qword_1400070E0 = external dso_local global i8*, align 8
@unk_140007100 = external dso_local global i8, align 1

declare dso_local void @sub_140001E80()
declare dso_local void @sub_140002120()
declare dso_local void @loc_1405C002E(i8*)
declare dso_local void @sub_1404EFA12(i8*)
declare dso_local void @sub_1400027F0(i8*)

define dso_local i32 @sub_140002010(i8* %rcx_arg, i32 %edx) local_unnamed_addr {
entry:
  %var10 = alloca i8*, align 8
  %cmp_eq_2 = icmp eq i32 %edx, 2
  br i1 %cmp_eq_2, label %case2, label %cmp_gt2

case2:                                            ; edx == 2
  call void @sub_140002120()
  ret i32 1

cmp_gt2:
  %ugt2 = icmp ugt i32 %edx, 2
  br i1 %ugt2, label %lbl_140002048, label %lbl_14000201f

lbl_14000201f:
  %is_zero = icmp eq i32 %edx, 0
  br i1 %is_zero, label %lbl_140002060, label %lbl_140002023

lbl_140002023:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1z = icmp eq i32 %g1, 0
  br i1 %g1z, label %lbl_140002100, label %lbl_140002031

lbl_140002031:
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

lbl_140002048:
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %lbl_14000204d, label %ret_1

lbl_14000204d:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2z = icmp eq i32 %g2, 0
  br i1 %g2z, label %ret_1, label %lbl_140002057

lbl_140002057:
  call void @sub_140001E80()
  br label %ret_1

ret_1:
  ret i32 1

lbl_140002060:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3nz = icmp ne i32 %g3, 0
  br i1 %g3nz, label %lbl_1400020f0, label %lbl_14000206e

lbl_1400020f0:
  call void @sub_140001E80()
  br label %lbl_14000206e

lbl_14000206e:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %g4eq1 = icmp eq i32 %g4, 1
  br i1 %g4eq1, label %lbl_140002079, label %ret_1

lbl_140002079:
  %p0 = load i8*, i8** @qword_1400070E0, align 8
  %p0_is_null = icmp eq i8* %p0, null
  br i1 %p0_is_null, label %lbl_1400020ab, label %loop

loop:
  %curr = phi i8* [ %p0, %lbl_140002079 ], [ %next_after, %after_call ]
  %addr16 = getelementptr i8, i8* %curr, i64 16
  %addr16pp = bitcast i8* %addr16 to i8**
  %next = load i8*, i8** %addr16pp, align 8
  store i8* %next, i8** %var10, align 8
  call void @sub_1400027F0(i8* %curr)
  %next_after = load i8*, i8** %var10, align 8
  %cond = icmp ne i8* %next_after, null
  br i1 %cond, label %after_call, label %lbl_1400020ab

after_call:
  br label %loop

lbl_1400020ab:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @loc_1405C002E(i8* @unk_140007100)
  br label %ret_1

lbl_140002100:
  call void @sub_1404EFA12(i8* @unk_140007100)
  br label %lbl_140002031
}