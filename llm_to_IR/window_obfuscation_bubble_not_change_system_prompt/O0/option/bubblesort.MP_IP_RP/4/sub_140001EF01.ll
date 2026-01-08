; ModuleID = 'sub_140001EF0_mod'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare i8* @sub_1400027E8(i32, i32)
declare void @loc_1405F6BA6(i8*)
declare void @sub_140024080(i8*)

define dso_local i32 @sub_140001EF0(i32 %arg0, i8* %arg1) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %t = icmp ne i32 %g, 0
  br i1 %t, label %if.then, label %ret.zero

ret.zero:
  ret i32 0

if.then:
  %p = call i8* @sub_1400027E8(i32 1, i32 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %ret.m1, label %cont

cont:
  %pi32 = bitcast i8* %p to i32*
  store i32 %arg0, i32* %pi32, align 4
  %p8 = getelementptr i8, i8* %p, i64 8
  %pp = bitcast i8* %p8 to i8**
  store i8* %arg1, i8** %pp, align 8
  call void @loc_1405F6BA6(i8* @unk_140007100)
  %old = load i8*, i8** @qword_1400070E0, align 8
  %p16 = getelementptr i8, i8* %p, i64 16
  %pnext = bitcast i8* %p16 to i8**
  store i8* %old, i8** %pnext, align 8
  store i8* %p, i8** @qword_1400070E0, align 8
  call void @sub_140024080(i8* @unk_140007100)
  br label %ret.m1

ret.m1:
  ret i32 -1
}