; ModuleID = 'sub_140001E80_module'
target triple = "x86_64-pc-windows-msvc"

@unk_140007100 = external global i8
@qword_1400070E0 = external global i8*

declare void @loc_140029C96(i8*)
declare void @sub_1405A8911()
declare void @sub_1405F5A24(i8*)

define void @sub_140001E80() {
entry:
  %0 = getelementptr inbounds i8, i8* @unk_140007100, i64 0
  call void @loc_140029C96(i8* %0)
  %1 = load i8*, i8** @qword_1400070E0, align 8
  %2 = icmp eq i8* %1, null
  br i1 %2, label %bb.zero, label %bb.nonzero

bb.nonzero:
  call void @sub_1405A8911()
  ret void

bb.zero:
  %3 = getelementptr inbounds i8, i8* @unk_140007100, i64 0
  call void @sub_1405F5A24(i8* %3)
  ret void
}