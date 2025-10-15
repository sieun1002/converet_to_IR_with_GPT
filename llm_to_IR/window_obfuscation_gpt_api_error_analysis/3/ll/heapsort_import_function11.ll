; ModuleID = 'sub_140002340.ll'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare void @loc_1400D766D(i8* noundef)
declare void @sub_1400E1987(i8* noundef)
declare void @sub_140002BB0(i8* noundef)

define void @sub_140002340(i32 noundef %arg) local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag.nz = icmp ne i32 %flag, 0
  br i1 %flag.nz, label %lock_acquire, label %ret_void

lock_acquire:
  %lock.ptr = getelementptr inbounds i8, i8* @unk_140007100, i64 0
  call void @loc_1400D766D(i8* noundef %lock.ptr)
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head.isnull = icmp eq i8* %head, null
  br i1 %head.isnull, label %unlock_and_ret, label %loop

loop:
  %prev = phi i8* [ null, %lock_acquire ], [ %curr, %loop_iter ]
  %curr = phi i8* [ %head, %lock_acquire ], [ %next, %loop_iter ]
  %key.ptr = bitcast i8* %curr to i32*
  %key = load i32, i32* %key.ptr, align 4
  %next.field.i8 = getelementptr inbounds i8, i8* %curr, i64 16
  %next.ptr = bitcast i8* %next.field.i8 to i8**
  %next = load i8*, i8** %next.ptr, align 8
  %key.eq = icmp eq i32 %key, %arg
  br i1 %key.eq, label %found, label %loop_iter

loop_iter:
  %next.isnull = icmp eq i8* %next, null
  br i1 %next.isnull, label %unlock_and_ret, label %loop

found:
  %prev.isnull = icmp eq i8* %prev, null
  br i1 %prev.isnull, label %set_head, label %set_link

set_head:
  store i8* %next, i8** @qword_1400070E0, align 8
  br label %free_node

set_link:
  %prev.next.i8 = getelementptr inbounds i8, i8* %prev, i64 16
  %prev.next.ptr = bitcast i8* %prev.next.i8 to i8**
  store i8* %next, i8** %prev.next.ptr, align 8
  br label %free_node

free_node:
  call void @sub_140002BB0(i8* noundef %curr)
  br label %unlock_and_ret

unlock_and_ret:
  %lock.ptr2 = getelementptr inbounds i8, i8* @unk_140007100, i64 0
  call void @sub_1400E1987(i8* noundef %lock.ptr2)
  br label %ret_void

ret_void:
  ret void
}