; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, void (i8*)*, %struct.Node* }

@qword_1400070E0 = external global %struct.Node*
@dword_140008260 = external global i32 ()*
@unk_140007100 = external global i8

declare void @loc_1403EA426(i8*)
declare i32 @loc_1403D8BD8()
declare void @sub_14000A65E(i8*)

define void @sub_140002320(i8* (i32)* %cb) {
entry:
  call void @loc_1403EA426(i8* @unk_140007100)
  %head0 = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %head_isnull = icmp eq %struct.Node* %head0, null
  br i1 %head_isnull, label %after, label %cont

cont:
  %st = call i32 @loc_1403D8BD8()
  %neg = icmp slt i32 %st, 0
  br i1 %neg, label %after, label %loop

loop:
  %node = phi %struct.Node* [ %head0, %cont ], [ %next, %loop_latch ]
  %field0ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  %val = load i32, i32* %field0ptr, align 4
  %res = call i8* %cb(i32 %val)
  %cbres_nonnull = icmp ne i8* %res, null
  %fptrptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  %callee = load void (i8*)*, void (i8*)** %fptrptr, align 8
  %fnegptr = load i32 ()*, i32 ()** @dword_140008260, align 8
  %flagret = call i32 %fnegptr()
  %flag_zero = icmp eq i32 %flagret, 0
  %cond = and i1 %cbres_nonnull, %flag_zero
  br i1 %cond, label %do_call, label %after_call

do_call:
  call void %callee(i8* %res)
  br label %after_call

after_call:
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  %hasnext = icmp ne %struct.Node* %next, null
  br i1 %hasnext, label %loop_latch, label %after

loop_latch:
  br label %loop

after:
  call void @sub_14000A65E(i8* @unk_140007100)
  ret void
}