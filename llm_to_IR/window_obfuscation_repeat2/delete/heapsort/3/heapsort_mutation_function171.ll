; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043B0 = external global i8*
@off_1400043C0 = external global i8*
@off_1400043A0 = external global i8*
@__imp_VirtualProtect = external global i8*
@aUnknownPseudoR = external global i8
@aDBitPseudoRelo = external global i8
@aUnknownPseudoR_0 = external global i8

declare i32 @sub_140002690()
declare void @sub_1400028E0()
declare void @sub_140001B30(...)
declare void @sub_140001AD0(...)
declare i8* @memcpy(i8* noalias, i8* noalias, i64)

define void @sub_140001CA0() {
entry:
  %Src = alloca i64, align 8
  %g0 = load i32, i32* @dword_1400070A0, align 4
  %cmp0 = icmp eq i32 %g0, 0
  br i1 %cmp0, label %init, label %ret

init:                                             ; preds = %entry
  store i32 1, i32* @dword_1400070A0, align 4
  %e = call i32 @sub_140002690()
  %e64 = sext i32 %e to i64
  %mul5 = mul i64 %e64, 5
  %mul40 = mul i64 %mul5, 8
  %add15 = add i64 %mul40, 15
  %aligned = and i64 %add15, -16
  call void @sub_1400028E0()
  %dyn = alloca i8, i64 %aligned, align 16
  %endptr.load = load i8*, i8** @off_1400043B0, align 8
  %startptr.load = load i8*, i8** @off_1400043C0, align 8
  %endint = ptrtoint i8* %endptr.load to i64
  %startint = ptrtoint i8* %startptr.load to i64
  %diff = sub i64 %endint, %startint
  store i32 0, i32* @dword_1400070A4, align 4
  %src.as.i8 = bitcast i64* %Src to i8*
  store i8* %src.as.i8, i8** @qword_1400070A8, align 8
  %cmp7 = icmp sle i64 %diff, 7
  br i1 %cmp7, label %ret, label %cmp11

cmp11:                                            ; preds = %init
  %cmpgt11 = icmp sgt i64 %diff, 11
  br i1 %cmpgt11, label %ret, label %finalcheck

finalcheck:                                       ; preds = %cmp11
  %a4 = load i32, i32* @dword_1400070A4, align 4
  %a4pos = icmp sgt i32 %a4, 0
  br i1 %a4pos, label %ret, label %ret

ret:                                              ; preds = %finalcheck, %cmp11, %init, %entry
  ret void
}