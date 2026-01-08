; ModuleID = 'sub_140001E80.ll'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @loc_140029C96(i8*)
declare void @sub_1405A8911()
declare void @sub_1405F5A24(i8*)

define void @sub_140001E80() {
entry:
  call void @loc_140029C96(i8* @unk_140007100)
  %ptr = load i8*, i8** @qword_1400070E0, align 8
  %isnull = icmp eq i8* %ptr, null
  br i1 %isnull, label %bb_zero, label %bb_nonzero

bb_nonzero:
  call void @sub_1405A8911()
  ret void

bb_zero:
  call void @sub_1405F5A24(i8* @unk_140007100)
  ret void
}