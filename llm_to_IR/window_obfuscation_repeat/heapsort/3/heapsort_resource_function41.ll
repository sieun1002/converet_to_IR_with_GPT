; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

%struct._EXCEPTION_RECORD = type { i32, i32, i8*, i8*, i32 }
%struct._EXCEPTION_POINTERS = type { %struct._EXCEPTION_RECORD*, i8* }

@off_140004400 = global i32* null, align 8
@qword_1400070D0 = global i32 (%struct._EXCEPTION_POINTERS*)* null, align 8

declare void (i32)* @signal(i32, void (i32)*)

declare void @sub_140001010()
declare void @sub_1400024E0()

define i32 @start() {
entry:
  %p0 = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %p0, align 4
  call void @sub_140001010()
  ret i32 0
}

define i32 @TopLevelExceptionFilter(%struct._EXCEPTION_POINTERS* %p) {
entry:
  %h = load i32 (%struct._EXCEPTION_POINTERS*)*, i32 (%struct._EXCEPTION_POINTERS*)** @qword_1400070D0, align 8
  %cmp = icmp eq i32 (%struct._EXCEPTION_POINTERS*)* %h, null
  br i1 %cmp, label %retzero, label %callh

callh:
  %res = call i32 %h(%struct._EXCEPTION_POINTERS* %p)
  ret i32 %res

retzero:
  ret i32 0
}

define void @sub_140001010() {
entry:
  ret void
}

define void @sub_1400024E0() {
entry:
  ret void
}