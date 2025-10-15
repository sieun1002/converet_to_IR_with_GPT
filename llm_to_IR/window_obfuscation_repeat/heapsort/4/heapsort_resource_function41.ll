; ModuleID = 'fixed'
source_filename = "fixed"
target triple = "x86_64-pc-windows-msvc"

@g_dw = dso_local global i32 123, align 4
@off_140004400 = dso_local global i32* @g_dw, align 8
@qword_1400070D0 = dso_local global i32 (i8*)* null, align 8

declare dso_local void (i32)* @signal(i32, void (i32)*)

define dso_local void @sub_140001010() {
entry:
  ret void
}

define dso_local void @sub_1400024E0() {
entry:
  ret void
}

define dso_local void @start() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %p, align 4
  call void @sub_140001010()
  ret void
}

define dso_local i32 @TopLevelExceptionFilter(i8* %ctx) {
entry:
  %fp = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %hasfp = icmp ne i32 (i8*)* %fp, null
  br i1 %hasfp, label %call, label %ret0

call:
  %res = call i32 %fp(i8* %ctx)
  ret i32 %res

ret0:
  ret i32 0
}