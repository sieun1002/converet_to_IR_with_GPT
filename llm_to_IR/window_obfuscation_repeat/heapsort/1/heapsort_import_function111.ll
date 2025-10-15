; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct.Node = type { i32, i32, i64, %struct.Node* }

@dword_1400070E8 = global i32 0, align 4
@qword_1400070E0 = global %struct.Node* null, align 8
@unk_140007100 = global [1 x i8] zeroinitializer, align 1

declare void @loc_1400D766D(i8*)
declare %struct.Node* @sub_1400E1987(i8*)
declare void @sub_140002BB0()

define i32 @sub_140002340(i32 %arg) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %is0 = icmp eq i32 %g, 0
  br i1 %is0, label %ret0, label %cont

ret0:
  ret i32 0

cont:
  %unkp = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void @loc_1400D766D(i8* %unkp)
  %head = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %headnull = icmp eq %struct.Node* %head, null
  br i1 %headnull, label %callA3, label %loop

loop:
  %cur = phi %struct.Node* [ %head, %cont ], [ %next, %loop_next ]
  %prev = phi %struct.Node* [ null, %cont ], [ %cur, %loop_next ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %eq = icmp eq i32 %key, %arg
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 3
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  br i1 %eq, label %found, label %checknext

checknext:
  %nextnull = icmp eq %struct.Node* %next, null
  br i1 %nextnull, label %callA3, label %loop_next

loop_next:
  br label %loop

found:
  %prevnull = icmp eq %struct.Node* %prev, null
  br i1 %prevnull, label %update_head, label %update_link

update_head:
  store %struct.Node* %next, %struct.Node** @qword_1400070E0, align 8
  br label %callBB

update_link:
  %prev_next_ptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 3
  store %struct.Node* %next, %struct.Node** %prev_next_ptr, align 8
  br label %callBB

callA3:
  %unkp2 = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  %newhead = call %struct.Node* @sub_1400E1987(i8* %unkp2)
  store %struct.Node* %newhead, %struct.Node** @qword_1400070E0, align 8
  br label %callBB

callBB:
  call void @sub_140002BB0()
  ret i32 0
}