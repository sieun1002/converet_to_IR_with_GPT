; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32
@unk_140007100 = external dso_local global i8

declare dso_local i8* @sub_1400027E8(i32, i32)
declare dso_local i32 @loc_140023D27(i8*)

define dso_local i32 @sub_140001EF0(i32 %arg0, i8* %arg1) {
entry:
  %0 = load i32, i32* @dword_1400070E8, align 4
  %1 = icmp ne i32 %0, 0
  br i1 %1, label %if.then, label %ret.zero

ret.zero:
  ret i32 0

if.then:
  %2 = call i8* @sub_1400027E8(i32 1, i32 24)
  %3 = icmp eq i8* %2, null
  br i1 %3, label %fail, label %cont

fail:
  ret i32 -1

cont:
  %4 = bitcast i8* %2 to i32*
  store i32 %arg0, i32* %4, align 4
  %5 = getelementptr inbounds i8, i8* %2, i64 8
  %6 = bitcast i8* %5 to i8**
  store i8* %arg1, i8** %6, align 8
  %7 = call i32 @loc_140023D27(i8* @unk_140007100)
  ret i32 %7
}