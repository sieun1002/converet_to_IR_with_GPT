; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @sub_140002690()
declare i64 @sub_1400028E0(i64)

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043B0 = external global i8*
@off_1400043C0 = external global i8*
@off_1400043A0 = external global i8*

define void @sub_140001CA0() {
entry:
  %g0 = load i32, i32* @dword_1400070A0, align 4
  %cmp = icmp ne i32 %g0, 0
  br i1 %cmp, label %ret, label %init

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %c1 = call i32 @sub_140002690()
  %c1ext = sext i32 %c1 to i64
  %m5 = mul i64 %c1ext, 5
  %m8 = shl i64 %m5, 3
  %add = add i64 %m8, 15
  %and = and i64 %add, -16
  %sz = call i64 @sub_1400028E0(i64 %and)
  %buf = alloca i8, i64 %sz, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %buf, i8** @qword_1400070A8, align 8
  %endp_val = load i8*, i8** @off_1400043B0, align 8
  %startp_val = load i8*, i8** @off_1400043C0, align 8
  %endpi = ptrtoint i8* %endp_val to i64
  %startpi = ptrtoint i8* %startp_val to i64
  %diff = sub i64 %endpi, %startpi
  %le = icmp sle i64 %diff, 7
  br i1 %le, label %ret, label %ret

ret:
  ret void
}