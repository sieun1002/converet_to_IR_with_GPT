; ModuleID = 'sub_140001E80_ir'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare void @loc_140029C96(i8* noundef)
declare void @sub_1405A8911()
declare void @sub_1405F5A24(i8* noundef)

define void @sub_140001E80() {
entry:
  call void @loc_140029C96(i8* @unk_140007100)
  %g = load i8*, i8** @qword_1400070E0, align 8
  %isnull = icmp eq i8* %g, null
  br i1 %isnull, label %zero, label %nonzero

nonzero:
  call void @sub_1405A8911()
  ret void

zero:
  call void @sub_1405F5A24(i8* @unk_140007100)
  unreachable
}