; ModuleID = 'sub_140001E80'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, void (i8*)*, %struct.Node* }

@qword_140008258 = external global void (i8*)*
@qword_140008260 = external global i32 ()*
@qword_140008270 = external global void (i8*)*
@qword_140008288 = external global i8* (i32)*
@qword_1400070E0 = external global %struct.Node*
@unk_140007100 = external global i8

define dso_local void @sub_140001E80() {
entry:
  %acq.fp.ptr = load void (i8*)*, void (i8*)** @qword_140008258, align 8
  call void %acq.fp.ptr(i8* @unk_140007100)
  %head = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %isnull.head = icmp eq %struct.Node* %head, null
  br i1 %isnull.head, label %exit, label %preloop

preloop:
  %pred.fp = load i8* (i32)*, i8* (i32)** @qword_140008288, align 8
  %check.fp = load i32 ()*, i32 ()** @qword_140008260, align 8
  br label %loop

loop:
  %node = phi %struct.Node* [ %head, %preloop ], [ %next, %cont ]
  %id.ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  %id = load i32, i32* %id.ptr, align 4
  %pred.res = call i8* %pred.fp(i32 %id)
  %check.res = call i32 %check.fp()
  %pred.nz = icmp ne i8* %pred.res, null
  %check.zero = icmp eq i32 %check.res, 0
  %do.call = and i1 %pred.nz, %check.zero
  br i1 %do.call, label %callcb, label %cont

callcb:
  %cb.ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  %cb = load void (i8*)*, void (i8*)** %cb.ptr, align 8
  call void %cb(i8* %pred.res)
  br label %cont

cont:
  %next.ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  %next = load %struct.Node*, %struct.Node** %next.ptr, align 8
  %has.next = icmp ne %struct.Node* %next, null
  br i1 %has.next, label %loop, label %exit

exit:
  %rel.fp = load void (i8*)*, void (i8*)** @qword_140008270, align 8
  tail call void %rel.fp(i8* @unk_140007100)
  ret void
}