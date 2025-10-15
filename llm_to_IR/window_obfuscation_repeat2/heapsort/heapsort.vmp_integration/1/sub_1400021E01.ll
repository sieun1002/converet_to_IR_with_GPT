; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@unk_140007100 = external global i8
@qword_1400070E0 = external global i64

declare i8* @loc_1400347E0(i8*)
declare void @sub_1400FAC93(i8*)
declare void @sub_14002B4DB(i8*) noreturn

define void @sub_1400021E0() noreturn {
entry:
  %call1 = call i8* @loc_1400347E0(i8* @unk_140007100)
  %g = load i64, i64* @qword_1400070E0, align 8
  %iszero = icmp eq i64 %g, 0
  br i1 %iszero, label %cont, label %do_call

do_call:
  call void @sub_1400FAC93(i8* %call1)
  br label %cont

cont:
  call void @sub_14002B4DB(i8* @unk_140007100)
  unreachable
}