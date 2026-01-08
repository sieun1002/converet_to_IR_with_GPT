; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, void (i8*)*, %struct.Node* }

@unk_140007100 = external global i8
@qword_140008258 = external global void (i8*)*
@qword_1400070E0 = external global %struct.Node*
@qword_140008288 = external global i8* (i32)*
@qword_140008260 = external global i32 ()*
@qword_140008270 = external global void (i8*)*

define void @sub_140001E80() {
entry:
  %0 = load void (i8*)*, void (i8*)** @qword_140008258, align 8
  call void %0(i8* @unk_140007100)
  %1 = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %2 = icmp eq %struct.Node* %1, null
  br i1 %2, label %tail, label %init

init:
  %3 = load i8* (i32)*, i8* (i32)** @qword_140008288, align 8
  %4 = load i32 ()*, i32 ()** @qword_140008260, align 8
  br label %loop

loop:
  %5 = phi %struct.Node* [ %1, %init ], [ %16, %cont ]
  %6 = getelementptr inbounds %struct.Node, %struct.Node* %5, i32 0, i32 0
  %7 = load i32, i32* %6, align 4
  %8 = call i8* %3(i32 %7)
  %9 = call i32 %4()
  %10 = icmp ne i8* %8, null
  %11 = icmp eq i32 %9, 0
  %12 = and i1 %10, %11
  br i1 %12, label %do, label %cont

do:
  %13 = getelementptr inbounds %struct.Node, %struct.Node* %5, i32 0, i32 2
  %14 = load void (i8*)*, void (i8*)** %13, align 8
  call void %14(i8* %8)
  br label %cont

cont:
  %15 = getelementptr inbounds %struct.Node, %struct.Node* %5, i32 0, i32 3
  %16 = load %struct.Node*, %struct.Node** %15, align 8
  %17 = icmp ne %struct.Node* %16, null
  br i1 %17, label %loop, label %tail

tail:
  %18 = load void (i8*)*, void (i8*)** @qword_140008270, align 8
  tail call void %18(i8* @unk_140007100)
  ret void
}