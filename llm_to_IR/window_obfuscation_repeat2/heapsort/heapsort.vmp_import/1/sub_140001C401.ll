; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = dso_local global i32 0, align 4
@dword_1400070A4 = dso_local global i32 0, align 4
@qword_1400070A8 = dso_local global i8* null, align 8
@off_1400043B0 = dso_local global i8* null, align 8
@off_1400043C0 = dso_local global i8* null, align 8
@off_1400043A0 = dso_local global i8* null, align 8

declare dso_local i32 @sub_140002630()
declare dso_local i64 @sub_140002880()

define dso_local void @sub_140001C40() {
entry:
  %g0 = load i32, i32* @dword_1400070A0, align 4
  %z = icmp eq i32 %g0, 0
  br i1 %z, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %c1 = call i32 @sub_140002630()
  %c2 = call i64 @sub_140002880()
  %var50 = alloca [8 x i8], align 8
  %var50ptr = bitcast [8 x i8]* %var50 to i8*
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %var50ptr, i8** @qword_1400070A8, align 8
  %beg = load i8*, i8** @off_1400043C0, align 8
  %end = load i8*, i8** @off_1400043B0, align 8
  %beg_i = ptrtoint i8* %beg to i64
  %end_i = ptrtoint i8* %end to i64
  %diff = sub i64 %end_i, %beg_i
  %gt7 = icmp sgt i64 %diff, 7
  br i1 %gt7, label %more, label %ret

more:
  %gt11 = icmp sgt i64 %diff, 11
  br i1 %gt11, label %ret, label %ret

ret:
  ret void
}