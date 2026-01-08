; ModuleID = 'sub_1400018D0_module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

declare i32 @sub_1400022D0()
declare i64 @sub_140002520(i64 noundef)

define void @sub_1400018D0() {
entry:
  %initflag.load = load i32, i32* @dword_1400070A0, align 4
  %initflag.cmp = icmp ne i32 %initflag.load, 0
  br i1 %initflag.cmp, label %retblk, label %initblk

initblk:
  store i32 1, i32* @dword_1400070A0, align 4
  %cnt.call = call i32 @sub_1400022D0()
  %cnt.sext = sext i32 %cnt.call to i64
  %mul5 = mul i64 %cnt.sext, 5
  %mul40 = mul i64 %mul5, 8
  %add15 = add i64 %mul40, 15
  %align16 = and i64 %add15, -16
  %probed = call i64 @sub_140002520(i64 noundef %align16)
  %buf = alloca i8, i64 %probed, align 16
  %zero = add i32 0, 0
  store i32 %zero, i32* @dword_1400070A4, align 4
  store i8* %buf, i8** @qword_1400070A8, align 8
  br label %retblk

retblk:
  ret void
}