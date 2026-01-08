; ModuleID = 'sub_140001F80'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32, align 4
@qword_1400070E0 = external dso_local global i8*, align 8
@unk_140007100 = external dso_local global i8, align 1

declare dso_local void @loc_1400EC4EB(i8* noundef)
declare dso_local void @loc_1400027F0()
declare dso_local void @sub_1400F1710(i8* noundef)

define dso_local i32 @sub_140001F80(i32 noundef %arg) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %t = icmp ne i32 %g, 0
  br i1 %t, label %lock, label %ret0

ret0:                                             ; preds = %entry
  ret i32 0

lock:                                             ; preds = %entry
  call void @loc_1400EC4EB(i8* @unk_140007100)
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %unlock, label %loop

loop:                                             ; preds = %lock, %cont
  %cur = phi i8* [ %head, %lock ], [ %next, %cont ]
  %prev = phi i8* [ null, %lock ], [ %cur, %cont ]
  %valptr = bitcast i8* %cur to i32*
  %val = load i32, i32* %valptr, align 4
  %cmpeq = icmp eq i32 %val, %arg
  %nextptr_i8 = getelementptr i8, i8* %cur, i64 16
  %nextptr = bitcast i8* %nextptr_i8 to i8**
  %next = load i8*, i8** %nextptr, align 8
  br i1 %cmpeq, label %found, label %cont

cont:                                             ; preds = %loop
  %next_is_null = icmp eq i8* %next, null
  br i1 %next_is_null, label %unlock, label %loop

found:                                            ; preds = %loop
  %prev_is_null = icmp eq i8* %prev, null
  br i1 %prev_is_null, label %del_head, label %del_mid

del_head:                                         ; preds = %found
  store i8* %next, i8** @qword_1400070E0, align 8
  br label %after_delete

del_mid:                                          ; preds = %found
  %prev_next_i8 = getelementptr i8, i8* %prev, i64 16
  %prev_next_ptr = bitcast i8* %prev_next_i8 to i8**
  store i8* %next, i8** %prev_next_ptr, align 8
  br label %after_delete

after_delete:                                     ; preds = %del_mid, %del_head
  call void @loc_1400027F0()
  br label %unlock

unlock:                                           ; preds = %cont, %after_delete, %lock
  call void @sub_1400F1710(i8* @unk_140007100)
  ret i32 0
}