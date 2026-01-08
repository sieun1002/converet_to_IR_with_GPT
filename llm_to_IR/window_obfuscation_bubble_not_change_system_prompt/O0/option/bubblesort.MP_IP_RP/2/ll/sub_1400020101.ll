; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @sub_140001E80()
declare void @sub_140002120()
declare void @"loc_1400027ED+3"(i8*)
declare void @"loc_140015626"(i8*)
declare void @"loc_1405DBE11+2"(i8*)

define i32 @sub_140002010(i32 %arg1, i32 %arg2) {
entry:
  %var10 = alloca i8*, align 8
  %cmp2 = icmp eq i32 %arg2, 2
  br i1 %cmp2, label %case2, label %not2

case2:
  call void @sub_140002120()
  ret i32 1

not2:
  %ugt2 = icmp ugt i32 %arg2, 2
  br i1 %ugt2, label %gt2blk, label %le2blk

le2blk:
  %iszero = icmp eq i32 %arg2, 0
  br i1 %iszero, label %label2060, label %label2023

label2023:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %t1 = icmp eq i32 %g1, 0
  br i1 %t1, label %label2100, label %set1ret

set1ret:
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

gt2blk:
  %is3 = icmp eq i32 %arg2, 3
  br i1 %is3, label %case3, label %ret1

ret1:
  ret i32 1

case3:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %t2 = icmp eq i32 %g2, 0
  br i1 %t2, label %ret1, label %callE80_then2060

callE80_then2060:
  call void @sub_140001E80()
  br label %label2060

label2060:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %nonzero = icmp ne i32 %g3, 0
  br i1 %nonzero, label %label20f0, label %label206e

label20f0:
  call void @sub_140001E80()
  br label %label2100

label206e:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %g4, 1
  br i1 %is1, label %label2079, label %ret1

label2079:
  %p0 = load i8*, i8** @qword_1400070E0, align 8
  %isnull0 = icmp eq i8* %p0, null
  br i1 %isnull0, label %label20ab, label %loop_head

loop_head:
  %cur = phi i8* [ %p0, %label2079 ], [ %next2, %loop_body_end ]
  %nextaddr = getelementptr i8, i8* %cur, i64 16
  %nextptrptr = bitcast i8* %nextaddr to i8**
  %next = load i8*, i8** %nextptrptr, align 8
  store i8* %next, i8** %var10, align 8
  call void @"loc_1400027ED+3"(i8* %cur)
  %next2 = load i8*, i8** %var10, align 8
  %nz = icmp ne i8* %next2, null
  br i1 %nz, label %loop_body_end, label %label20ab

loop_body_end:
  br label %loop_head

label20ab:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @"loc_1405DBE11+2"(i8* @unk_140007100)
  ret i32 1

label2100:
  call void @"loc_140015626"(i8* @unk_140007100)
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1
}