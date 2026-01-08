; ModuleID = 'sub_140002010'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @sub_140001E80()
declare void @sub_1400027F0(i8*)
declare void @sub_1400CDFE0(i8*)
declare void @sub_140002120()
declare void @sub_1400E50C4(i8*)

define i32 @sub_140002010(i32 %ecx, i32 %edx) {
entry:
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %loc_1400020D8, label %after_cmp2

after_cmp2:
  %ugt2 = icmp ugt i32 %edx, 2
  br i1 %ugt2, label %loc_140002048, label %loc_14000201F

loc_14000201F:
  %iszero = icmp eq i32 %edx, 0
  br i1 %iszero, label %loc_140002060, label %loc_140002023

loc_140002023:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1zero = icmp eq i32 %g1, 0
  br i1 %g1zero, label %loc_140002100, label %loc_140002031

loc_140002100:
  call void @sub_1400E50C4(i8* @unk_140007100)
  br label %loc_140002031

loc_140002031:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

loc_140002048:
  %eq3 = icmp eq i32 %edx, 3
  br i1 %eq3, label %loc_14000204D, label %ret1

loc_14000204D:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2zero = icmp eq i32 %g2, 0
  br i1 %g2zero, label %ret1, label %loc_140002057

loc_140002057:
  call void @sub_140001E80()
  br label %ret1

loc_140002060:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3zero = icmp eq i32 %g3, 0
  br i1 %g3zero, label %loc_14000206E, label %loc_1400020F0

loc_1400020F0:
  call void @sub_140001E80()
  br label %loc_14000206E

loc_14000206E:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %g4, 1
  br i1 %is1, label %loc_140002079, label %ret1

loc_140002079:
  %p = load i8*, i8** @qword_1400070E0, align 8
  %pnull = icmp eq i8* %p, null
  br i1 %pnull, label %loc_1400020AB, label %loc_140002090

loc_140002090:
  %cur = phi i8* [ %p, %loc_140002079 ], [ %next, %loc_140002090 ]
  %nextptr = getelementptr i8, i8* %cur, i64 16
  %nextptr_cast = bitcast i8* %nextptr to i8**
  %next = load i8*, i8** %nextptr_cast, align 8
  call void @sub_1400027F0(i8* %cur)
  %hasnext = icmp ne i8* %next, null
  br i1 %hasnext, label %loc_140002090, label %loc_1400020AB

loc_1400020AB:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @sub_1400CDFE0(i8* @unk_140007100)
  br label %loc_1400020D8

loc_1400020D8:
  call void @sub_140002120()
  br label %ret1

ret1:
  ret i32 1
}