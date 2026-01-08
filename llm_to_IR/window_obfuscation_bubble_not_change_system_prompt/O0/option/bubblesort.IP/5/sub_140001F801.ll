; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare i8* @sub_1403E7BA3(i8*)
declare void @sub_1400DC8D7(i8*)
declare void @sub_1400027F0()

define i32 @sub_140001F80(i32 %0) {
entry:
  %1 = load i32, i32* @dword_1400070E8, align 4
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %ret0, label %lock

ret0:                                             ; preds = %entry
  ret i32 0

lock:                                             ; preds = %entry
  %3 = call i8* @sub_1403E7BA3(i8* @unk_140007100)
  %4 = icmp eq i8* %3, null
  br i1 %4, label %unlock, label %loop

loop:                                             ; preds = %cont, %lock
  %cur = phi i8* [ %3, %lock ], [ %next, %cont ]
  %prev = phi i8* [ null, %lock ], [ %cur, %cont ]
  %5 = bitcast i8* %cur to i32*
  %6 = load i32, i32* %5, align 4
  %7 = icmp ne i32 %6, %0
  %8 = getelementptr i8, i8* %cur, i64 16
  %9 = bitcast i8* %8 to i8**
  %next = load i8*, i8** %9, align 8
  br i1 %7, label %checknext, label %found

checknext:                                        ; preds = %loop
  %10 = icmp eq i8* %next, null
  br i1 %10, label %unlock, label %cont

cont:                                             ; preds = %checknext
  br label %loop

found:                                            ; preds = %loop
  %11 = icmp eq i8* %prev, null
  br i1 %11, label %sethead, label %link

sethead:                                          ; preds = %found
  store i8* %next, i8** @qword_1400070E0, align 8
  br label %free

link:                                             ; preds = %found
  %12 = getelementptr i8, i8* %prev, i64 16
  %13 = bitcast i8* %12 to i8**
  store i8* %next, i8** %13, align 8
  br label %free

free:                                             ; preds = %link, %sethead
  call void @sub_1400027F0()
  br label %unlock

unlock:                                           ; preds = %free, %checknext, %lock
  call void @sub_1400DC8D7(i8* @unk_140007100)
  ret i32 0
}