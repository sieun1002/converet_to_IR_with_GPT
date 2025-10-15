; ModuleID = 'sub_140002340.ll'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global %struct.Node*, align 8
@unk_140007100 = external global i8, align 1

declare void @loc_1400D766D(i8*)
declare void @sub_1400E1987(i8*)
declare void @sub_140002BB0()

define i32 @sub_140002340(i32 %arg) {
entry:
  %flag.ld = load i32, i32* @dword_1400070E8, align 4
  %flag.zero = icmp eq i32 %flag.ld, 0
  br i1 %flag.zero, label %ret.zero, label %lock.acquire

ret.zero:
  ret i32 0

lock.acquire:
  %lock.ptr = getelementptr inbounds i8, i8* @unk_140007100, i64 0
  call void @loc_1400D766D(i8* %lock.ptr)
  %head.ld = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %head.null = icmp eq %struct.Node* %head.ld, null
  br i1 %head.null, label %release.only, label %loop

loop:
  %cur = phi %struct.Node* [ %head.ld, %lock.acquire ], [ %next, %l.back ]
  %prev = phi %struct.Node* [ null, %lock.acquire ], [ %cur, %l.back ]
  %key.ptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %key.ld = load i32, i32* %key.ptr, align 4
  %cmp.eq = icmp eq i32 %key.ld, %arg
  %next.ptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %next.ptr, align 8
  br i1 %cmp.eq, label %found, label %l.not.equal

l.not.equal:
  %next.isnull = icmp eq %struct.Node* %next, null
  br i1 %next.isnull, label %release.only, label %l.back

l.back:
  br label %loop

found:
  %prev.isnull = icmp eq %struct.Node* %prev, null
  br i1 %prev.isnull, label %do.head, label %do.mid

do.head:
  store %struct.Node* %next, %struct.Node** @qword_1400070E0, align 8
  br label %do.call

do.mid:
  %prev.next.ptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prev.next.ptr, align 8
  br label %do.call

do.call:
  call void @sub_140002BB0()
  %lock.ptr2 = getelementptr inbounds i8, i8* @unk_140007100, i64 0
  call void @sub_1400E1987(i8* %lock.ptr2)
  ret i32 0

release.only:
  %lock.ptr3 = getelementptr inbounds i8, i8* @unk_140007100, i64 0
  call void @sub_1400E1987(i8* %lock.ptr3)
  ret i32 0
}