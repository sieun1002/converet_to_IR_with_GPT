; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043D0 = external global i8*
@off_1400043E0 = external global i8*
@off_1400043C0 = external global i8*

@aUnknownPseudoR = external global i8
@aDBitPseudoRelo = external global i8
@aUnknownPseudoR_0 = external global i8

declare i32 @sub_1400022D0()
declare void @sub_140002520()
declare void @sub_140001760(i8*)
declare void @sub_140001700(i8*)
declare i32 @sub_1400BF822()
declare void @loc_1400027B8(i8*, i8*, i32)

define void @sub_1400018D0() local_unnamed_addr {
entry:
  %g = load i32, i32* @dword_1400070A0, align 4
  %iszero = icmp eq i32 %g, 0
  br i1 %iszero, label %init, label %ret

init:                                             ; preds = %entry
  store i32 1, i32* @dword_1400070A0, align 4
  %c = call i32 @sub_1400022D0()
  %w = sext i32 %c to i64
  %mul5 = mul i64 %w, 5
  %mul8 = mul i64 %mul5, 8
  %add15 = add i64 %mul8, 15
  %size.aligned = and i64 %add15, -16
  call void @sub_140002520()
  %endp = load i8*, i8** @off_1400043D0, align 8
  %begp = load i8*, i8** @off_1400043E0, align 8
  store i32 0, i32* @dword_1400070A4, align 4
  %var50.ptr = alloca i8, i64 1, align 8
  store i8* %var50.ptr, i8** @qword_1400070A8, align 8
  %end.int = ptrtoint i8* %endp to i64
  %beg.int = ptrtoint i8* %begp to i64
  %diff = sub i64 %end.int, %beg.int
  %le7 = icmp sle i64 %diff, 7
  br i1 %le7, label %ret, label %check11

check11:                                          ; preds = %init
  %gt11 = icmp sgt i64 %diff, 11
  br i1 %gt11, label %path_v2, label %path_v1

path_v1:                                          ; preds = %check11
  br label %ret

path_v2:                                          ; preds = %check11
  br label %ret

ret:                                              ; preds = %path_v2, %path_v1, %init, %entry
  ret void
}