; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @loc_1400EC4EB(i8*)
declare void @loc_1400027F0(i8*)
declare void @sub_1400F1710(i8*)

define i32 @sub_140001F80(i32 %arg0) {
entry:
  %g = load i32, i32* @dword_1400070E8
  %cond = icmp ne i32 %g, 0
  br i1 %cond, label %body, label %ret0

ret0:                                              ; preds = %entry
  ret i32 0

body:                                              ; preds = %entry
  %unkptr = bitcast i8* @unk_140007100 to i8*
  call void @loc_1400EC4EB(i8* %unkptr)
  %headptr = load i8*, i8** @qword_1400070E0
  %headnull = icmp eq i8* %headptr, null
  br i1 %headnull, label %cleanup, label %loop

loop:                                              ; preds = %body, %loop_continue
  %curr = phi i8* [ %headptr, %body ], [ %next, %loop_continue ]
  %prev = phi i8* [ null, %body ], [ %curr, %loop_continue ]
  %keyptr = bitcast i8* %curr to i32*
  %key = load i32, i32* %keyptr
  %cmp = icmp eq i32 %key, %arg0
  %off16 = getelementptr i8, i8* %curr, i64 16
  %nextptr = bitcast i8* %off16 to i8**
  %next = load i8*, i8** %nextptr
  br i1 %cmp, label %found, label %notfound

notfound:                                          ; preds = %loop
  %nextnull = icmp eq i8* %next, null
  br i1 %nextnull, label %cleanup, label %loop_continue

loop_continue:                                     ; preds = %notfound
  br label %loop

found:                                             ; preds = %loop
  %prevnull = icmp eq i8* %prev, null
  br i1 %prevnull, label %update_head, label %update_link

update_head:                                       ; preds = %found
  store i8* %next, i8** @qword_1400070E0
  br label %unlink_done

update_link:                                       ; preds = %found
  %poff16 = getelementptr i8, i8* %prev, i64 16
  %pnextptr = bitcast i8* %poff16 to i8**
  store i8* %next, i8** %pnextptr
  br label %unlink_done

unlink_done:                                       ; preds = %update_link, %update_head
  call void @loc_1400027F0(i8* %curr)
  br label %cleanup

cleanup:                                           ; preds = %notfound, %unlink_done, %body
  %unkptr2 = bitcast i8* @unk_140007100 to i8*
  call void @sub_1400F1710(i8* %unkptr2)
  ret i32 0
}