; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*, align 8
@qword_1400070D0 = external global i8*, align 8

declare void @sub_140001010()
declare i32 @sub_1400024E0()
declare dllimport void (i32)* @signal(i32, void (i32)*)

define void @start() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %p, align 4
  call void @sub_140001010()
  ret void
}

define i32 @TopLevelExceptionFilter(i8* %excptrs) {
entry:
  %h = load i8*, i8** @qword_1400070D0, align 8
  %isnull = icmp eq i8* %h, null
  br i1 %isnull, label %nohandler, label %havehandler

havehandler:
  %fn = bitcast i8* %h to i32 (i8*)*
  %res = call i32 %fn(i8* %excptrs)
  ret i32 %res

nohandler:
  ret i32 0
}