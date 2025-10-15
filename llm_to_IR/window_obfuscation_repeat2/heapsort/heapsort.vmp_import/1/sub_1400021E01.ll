; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@unk_140007100 = external global i8, align 1
@qword_140008258 = external global i8*, align 8

declare void @loc_14000B5E5(i8*)
declare void @loc_14001668F(i8*)
declare void @loc_1403BD625()

define void @sub_1400021E0() {
entry:
  call void @loc_14000B5E5(i8* @unk_140007100)
  call void @loc_14001668F(i8* @unk_140007100)
  ret void
}