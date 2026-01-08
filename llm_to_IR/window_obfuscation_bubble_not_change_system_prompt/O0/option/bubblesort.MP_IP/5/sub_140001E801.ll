; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070E0 = external global i64
@unk_140007100 = external global i8

declare void @loc_140029C96(i8*)
declare void @sub_1405A8911()
declare void @sub_1405F5A24(i8*)

define void @sub_140001E80() {
entry:
  call void @loc_140029C96(i8* @unk_140007100)
  %g = load i64, i64* @qword_1400070E0, align 8
  %iszero = icmp eq i64 %g, 0
  br i1 %iszero, label %zero, label %nonzero

nonzero:
  call void @sub_1405A8911()
  ret void

zero:
  call void @sub_1405F5A24(i8* @unk_140007100)
  ret void
}