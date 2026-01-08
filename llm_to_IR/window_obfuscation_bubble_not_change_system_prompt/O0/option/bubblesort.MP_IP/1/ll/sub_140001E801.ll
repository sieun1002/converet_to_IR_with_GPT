; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070E0 = external dso_local global i8*, align 8
@unk_140007100 = external dso_local global i8, align 1

declare dso_local void @loc_140029C96(i8* noundef)
declare dso_local void @sub_1405A8911()
declare dso_local void @sub_1405F5A24(i8* noundef)

define dso_local void @sub_140001E80() {
entry:
  call void @loc_140029C96(i8* noundef @unk_140007100)
  %0 = load i8*, i8** @qword_1400070E0, align 8
  %1 = icmp eq i8* %0, null
  br i1 %1, label %bb.null, label %bb.nonnull

bb.nonnull:
  call void @sub_1405A8911()
  ret void

bb.null:
  call void @sub_1405F5A24(i8* noundef @unk_140007100)
  ret void
}