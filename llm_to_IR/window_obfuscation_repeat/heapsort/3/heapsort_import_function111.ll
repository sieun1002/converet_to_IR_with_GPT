; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-n8:16:32:64-S128"

%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = global i32 0, align 4
@qword_1400070E0 = global %struct.Node* null, align 8
@unk_140007100 = global [1 x i8] zeroinitializer, align 1

declare void @loc_1400D766D(i8* noundef)
declare void @sub_1400E1987(i8* noundef)
declare void @sub_140002BB0()

define i32 @sub_140002340(i32 noundef %0) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag_is_zero = icmp eq i32 %flag, 0
  br i1 %flag_is_zero, label %ret0, label %locked

ret0:
  ret i32 0

locked:
  %lockptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void @loc_1400D766D(i8* noundef %lockptr)
  %head = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %head_is_null = icmp eq %struct.Node* %head, null
  br i1 %head_is_null, label %unlock_ret0, label %loop.header

loop.header:
  %curr = phi %struct.Node* [ %head, %locked ], [ %next, %advance ]
  %prev = phi %struct.Node* [ null, %locked ], [ %curr, %advance ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i64 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %eq = icmp eq i32 %key, %0
  br i1 %eq, label %found, label %advance

advance:
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i64 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  %next_is_null = icmp eq %struct.Node* %next, null
  br i1 %next_is_null, label %unlock_ret0, label %loop.header

found:
  %nextptr2 = getelementptr inbounds %struct.Node, %struct.Node* %curr, i64 0, i32 2
  %next2 = load %struct.Node*, %struct.Node** %nextptr2, align 8
  %is_head = icmp eq %struct.Node* %prev, null
  br i1 %is_head, label %update_head, label %update_link

update_head:
  store %struct.Node* %next2, %struct.Node** @qword_1400070E0, align 8
  br label %callfree

update_link:
  %prev_nextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i64 0, i32 2
  store %struct.Node* %next2, %struct.Node** %prev_nextptr, align 8
  br label %callfree

callfree:
  call void @sub_140002BB0()
  br label %unlock_ret1

unlock_ret0:
  call void @sub_1400E1987(i8* noundef %lockptr)
  ret i32 0

unlock_ret1:
  call void @sub_1400E1987(i8* noundef %lockptr)
  ret i32 1
}