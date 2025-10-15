; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct.Node = type { i32, i32, i64, %struct.Node* }

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global %struct.Node*, align 8
@unk_140007100 = global i8 0, align 8

declare void @loc_1400D766D(i8*)
declare void @sub_1400E1987(i8*)
declare void @sub_140002BB0(%struct.Node*)

define i32 @sub_140002340(i32 %arg) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %g_is_zero = icmp eq i32 %g, 0
  br i1 %g_is_zero, label %ret_zero, label %lock_acquire

ret_zero:
  ret i32 0

lock_acquire:
  call void @loc_1400D766D(i8* @unk_140007100)
  %head0 = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %head_is_null = icmp eq %struct.Node* %head0, null
  br i1 %head_is_null, label %unlock_ret0, label %loop

loop:
  %prev = phi %struct.Node* [ null, %lock_acquire ], [ %cur, %cont_not_match ]
  %cur = phi %struct.Node* [ %head0, %lock_acquire ], [ %next, %cont_not_match ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 3
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  %match = icmp eq i32 %key, %arg
  br i1 %match, label %found, label %cont_not_match

cont_not_match:
  %next_is_null = icmp eq %struct.Node* %next, null
  br i1 %next_is_null, label %unlock_ret0, label %loop

found:
  %prev_is_null = icmp eq %struct.Node* %prev, null
  br i1 %prev_is_null, label %set_head, label %bypass

set_head:
  store %struct.Node* %next, %struct.Node** @qword_1400070E0, align 8
  br label %after_update

bypass:
  %prev_nextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 3
  store %struct.Node* %next, %struct.Node** %prev_nextptr, align 8
  br label %after_update

after_update:
  call void @sub_140002BB0(%struct.Node* %cur)
  call void @sub_1400E1987(i8* @unk_140007100)
  ret i32 1

unlock_ret0:
  call void @sub_1400E1987(i8* @unk_140007100)
  ret i32 0
}