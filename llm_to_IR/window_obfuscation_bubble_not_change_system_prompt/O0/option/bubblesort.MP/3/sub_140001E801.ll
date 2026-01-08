; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, void (i8*)*, %struct.Node* }

@qword_1400070E0 = external global %struct.Node*
@unk_140007100 = external global i8
@qword_140008258 = external global void (i8*)*
@qword_140008270 = external global void (i8*)*
@qword_140008260 = external global i32 ()*
@qword_140008288 = external global i8* (i32)*

define void @sub_140001E80() {
entry:
  %f_enter_ptr = load void (i8*)*, void (i8*)** @qword_140008258, align 8
  call void %f_enter_ptr(i8* @unk_140007100)
  %head = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %nullhead = icmp eq %struct.Node* %head, null
  br i1 %nullhead, label %tail, label %preloop

preloop:
  %f_rbp = load i8* (i32)*, i8* (i32)** @qword_140008288, align 8
  %f_rdi = load i32 ()*, i32 ()** @qword_140008260, align 8
  br label %loop

loop:
  %cur = phi %struct.Node* [ %head, %preloop ], [ %next, %loop_end_prep ]
  %idptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %id = load i32, i32* %idptr, align 4
  %rsi = call i8* %f_rbp(i32 %id)
  %eax = call i32 %f_rdi()
  %cond1 = icmp ne i8* %rsi, null
  %cond2 = icmp eq i32 %eax, 0
  %both = and i1 %cond1, %cond2
  br i1 %both, label %do_call, label %loop_end_prep

do_call:
  %cbptrptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %cb = load void (i8*)*, void (i8*)** %cbptrptr, align 8
  call void %cb(i8* %rsi)
  br label %loop_end_prep

loop_end_prep:
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 3
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  %cont = icmp ne %struct.Node* %next, null
  br i1 %cont, label %loop, label %tail

tail:
  %f_leave_ptr = load void (i8*)*, void (i8*)** @qword_140008270, align 8
  tail call void %f_leave_ptr(i8* @unk_140007100)
  ret void
}