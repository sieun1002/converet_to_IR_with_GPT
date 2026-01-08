; ModuleID = 'sub_140001F80'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global %struct.Node*
@qword_140008258 = external global void (i8*)*
@qword_140008270 = external global void (i8*)*
@unk_140007100 = external global i8

declare void @sub_1400027F0()

define i32 @sub_140001F80(i32 %arg) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag.nz = icmp ne i32 %flag, 0
  br i1 %flag.nz, label %lock, label %ret0

ret0:
  ret i32 0

lock:
  %lock.fp = load void (i8*)*, void (i8*)** @qword_140008258, align 8
  %lock.obj = bitcast i8* @unk_140007100 to i8*
  call void %lock.fp(i8* nonnull %lock.obj)
  %head = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %head.null = icmp eq %struct.Node* %head, null
  br i1 %head.null, label %unlock, label %loop

loop:
  %cur.phi = phi %struct.Node* [ %head, %lock ], [ %next, %cont_loop ]
  %prev.phi = phi %struct.Node* [ null, %lock ], [ %cur.phi, %cont_loop ]
  %key.ptr = getelementptr inbounds %struct.Node, %struct.Node* %cur.phi, i32 0, i32 0
  %key = load i32, i32* %key.ptr, align 4
  %eq = icmp eq i32 %key, %arg
  %next.ptr = getelementptr inbounds %struct.Node, %struct.Node* %cur.phi, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %next.ptr, align 8
  br i1 %eq, label %found, label %cont

cont:
  %next.null = icmp eq %struct.Node* %next, null
  br i1 %next.null, label %unlock, label %cont_loop

cont_loop:
  br label %loop

found:
  %prev.null = icmp eq %struct.Node* %prev.phi, null
  br i1 %prev.null, label %remove_head, label %remove_inner

remove_inner:
  %prev.next.ptr = getelementptr inbounds %struct.Node, %struct.Node* %prev.phi, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prev.next.ptr, align 8
  br label %cleanup

remove_head:
  store %struct.Node* %next, %struct.Node** @qword_1400070E0, align 8
  br label %cleanup

cleanup:
  call void @sub_1400027F0()
  br label %unlock

unlock:
  %unlock.fp = load void (i8*)*, void (i8*)** @qword_140008270, align 8
  %unlock.obj = bitcast i8* @unk_140007100 to i8*
  call void %unlock.fp(i8* nonnull %unlock.obj)
  ret i32 0
}