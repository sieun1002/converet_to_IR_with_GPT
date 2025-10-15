; ModuleID = 'sub_140002340.ll'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, [12 x i8], %struct.Node* }
%struct.Lock = type opaque

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global %struct.Node*
@unk_140007100 = external global %struct.Lock

declare void @loc_1400D766D(%struct.Lock* nocapture)
declare void @sub_140002BB0(%struct.Node* nocapture)
declare void @sub_1400E1987(%struct.Lock* nocapture)

define dso_local i32 @sub_140002340(i32 %arg) local_unnamed_addr {
entry:
  %flag.ld = load i32, i32* @dword_1400070E8, align 4
  %flag.nz = icmp ne i32 %flag.ld, 0
  br i1 %flag.nz, label %locked, label %ret0

ret0:
  ret i32 0

locked:
  call void @loc_1400D766D(%struct.Lock* @unk_140007100)
  %head.ld = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %head.null = icmp eq %struct.Node* %head.ld, null
  br i1 %head.null, label %unlock_notfound, label %loop

loop:
  %cur.phi = phi %struct.Node* [ %head.ld, %locked ], [ %next.ld, %iter_cont ]
  %prev.phi = phi %struct.Node* [ null, %locked ], [ %cur.phi, %iter_cont ]
  %key.ptr = getelementptr inbounds %struct.Node, %struct.Node* %cur.phi, i32 0, i32 0
  %key.ld = load i32, i32* %key.ptr, align 4
  %next.ptr = getelementptr inbounds %struct.Node, %struct.Node* %cur.phi, i32 0, i32 2
  %next.ld = load %struct.Node*, %struct.Node** %next.ptr, align 8
  %cmp.eq = icmp eq i32 %key.ld, %arg
  br i1 %cmp.eq, label %found, label %iter_check

iter_check:
  %next.null = icmp eq %struct.Node* %next.ld, null
  br i1 %next.null, label %unlock_notfound, label %iter_cont

iter_cont:
  br label %loop

found:
  %prev.null = icmp eq %struct.Node* %prev.phi, null
  br i1 %prev.null, label %remove_head, label %remove_middle

remove_middle:
  %prev.next.ptr = getelementptr inbounds %struct.Node, %struct.Node* %prev.phi, i32 0, i32 2
  store %struct.Node* %next.ld, %struct.Node** %prev.next.ptr, align 8
  call void @sub_140002BB0(%struct.Node* %cur.phi)
  call void @sub_1400E1987(%struct.Lock* @unk_140007100)
  ret i32 1

remove_head:
  store %struct.Node* %next.ld, %struct.Node** @qword_1400070E0, align 8
  call void @sub_140002BB0(%struct.Node* %cur.phi)
  call void @sub_1400E1987(%struct.Lock* @unk_140007100)
  ret i32 1

unlock_notfound:
  call void @sub_1400E1987(%struct.Lock* @unk_140007100)
  ret i32 0
}