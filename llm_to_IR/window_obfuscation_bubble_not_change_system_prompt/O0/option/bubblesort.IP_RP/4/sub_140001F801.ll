; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare void @loc_1400EC4EB(i8*)
declare void @sub_1400F1710(i8*)
declare void @loc_1400027F0(i8*)

define i32 @sub_140001F80(i32 %arg) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag.nz = icmp ne i32 %flag, 0
  br i1 %flag.nz, label %locked_entry, label %ret0

ret0:                                             ; preds = %entry
  ret i32 0

locked_entry:                                     ; preds = %entry
  call void @loc_1400EC4EB(i8* @unk_140007100)
  %head = load i8*, i8** @qword_1400070E0, align 8
  %hashead = icmp ne i8* %head, null
  br i1 %hashead, label %loop, label %unlock

loop:                                             ; preds = %locked_entry, %cont
  %prev = phi i8* [ null, %locked_entry ], [ %curr, %cont ]
  %curr = phi i8* [ %head, %locked_entry ], [ %next, %cont ]
  %val.ptr = bitcast i8* %curr to i32*
  %val = load i32, i32* %val.ptr, align 4
  %next.addr.i8 = getelementptr i8, i8* %curr, i64 16
  %next.addr = bitcast i8* %next.addr.i8 to i8**
  %next = load i8*, i8** %next.addr, align 8
  %eq = icmp eq i32 %val, %arg
  br i1 %eq, label %found, label %not_equal

not_equal:                                        ; preds = %loop
  %hasnext = icmp ne i8* %next, null
  br i1 %hasnext, label %cont, label %unlock

cont:                                             ; preds = %not_equal
  br label %loop

found:                                            ; preds = %loop
  %prev.is.null = icmp eq i8* %prev, null
  br i1 %prev.is.null, label %update_head, label %update_prev

update_prev:                                      ; preds = %found
  %prev.next.addr.i8 = getelementptr i8, i8* %prev, i64 16
  %prev.next.addr = bitcast i8* %prev.next.addr.i8 to i8**
  store i8* %next, i8** %prev.next.addr, align 8
  call void @loc_1400027F0(i8* %curr)
  br label %unlock

update_head:                                      ; preds = %found
  store i8* %next, i8** @qword_1400070E0, align 8
  call void @loc_1400027F0(i8* %curr)
  br label %unlock

unlock:                                           ; preds = %not_equal, %update_head, %update_prev, %locked_entry
  call void @sub_1400F1710(i8* @unk_140007100)
  br label %ret0_locked

ret0_locked:                                      ; preds = %unlock
  ret i32 0
}