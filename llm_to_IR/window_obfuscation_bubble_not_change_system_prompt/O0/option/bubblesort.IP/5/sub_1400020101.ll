; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32
@qword_1400070E0 = external dso_local global i8*
@unk_140007100 = external dso_local global i8

declare dso_local void @sub_140001E80()
declare dso_local void @sub_1400027F0(i8*)
declare dso_local void @sub_1400CDFE0(i8*)
declare dso_local void @sub_140002120()
declare dso_local void @sub_1400E50C4(i8*, i32)

define dso_local i32 @sub_140002010(i32 %edx) {
entry:
  %cmp_eq2 = icmp eq i32 %edx, 2
  br i1 %cmp_eq2, label %loc_0D8, label %cmp_gt2

cmp_gt2:
  %ugt2 = icmp ugt i32 %edx, 2
  br i1 %ugt2, label %loc_48, label %loc_1F

loc_1F:
  %isZero = icmp eq i32 %edx, 0
  br i1 %isZero, label %loc_60, label %path_nonzero_non2

path_nonzero_non2:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %t1 = icmp eq i32 %g1, 0
  br i1 %t1, label %loc_0100, label %loc_31

loc_31:
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

loc_48:
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %loc_04d, label %loc_03B

loc_04d:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %t2 = icmp eq i32 %g2, 0
  br i1 %t2, label %loc_03B, label %call_e80

call_e80:
  call void @sub_140001E80()
  br label %loc_03B

loc_03B:
  ret i32 1

loc_60:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %t3 = icmp ne i32 %g3, 0
  br i1 %t3, label %loc_0F0, label %loc_06E

loc_0F0:
  call void @sub_140001E80()
  br label %loc_06E

loc_06E:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %cmp1 = icmp eq i32 %g4, 1
  br i1 %cmp1, label %loc_079, label %loc_03B

loc_079:
  %p0 = load i8*, i8** @qword_1400070E0, align 8
  %p0null = icmp eq i8* %p0, null
  br i1 %p0null, label %loc_0AB, label %loop_header

loop_header:
  %pcur = phi i8* [ %p0, %loc_079 ], [ %next, %loop_latch ]
  %next_gep = getelementptr i8, i8* %pcur, i64 16
  %next_ptr = bitcast i8* %next_gep to i8**
  %next = load i8*, i8** %next_ptr, align 8
  call void @sub_1400027F0(i8* %pcur)
  %has_next = icmp ne i8* %next, null
  br i1 %has_next, label %loop_latch, label %loc_0AB

loop_latch:
  br label %loop_header

loc_0AB:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @sub_1400CDFE0(i8* @unk_140007100)
  ret i32 1

loc_0D8:
  call void @sub_140002120()
  ret i32 1

loc_0100:
  call void @sub_1400E50C4(i8* @unk_140007100, i32 %edx)
  br label %loc_31
}