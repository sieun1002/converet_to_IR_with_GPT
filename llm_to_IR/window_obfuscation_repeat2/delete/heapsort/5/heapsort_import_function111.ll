; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070E8 = external dso_local global i32
@qword_1400070E0 = external dso_local global i8*
@unk_140007100 = external dso_local global [1 x i8]

declare dso_local void @loc_1400D766D(i8*)
declare dso_local void @sub_1400E1987(i8*)
declare dso_local void @sub_140002BB0(i8*)

define dso_local i32 @sub_140002340(i32 %0) {
entry:
  %1 = load i32, i32* @dword_1400070E8, align 4
  %2 = icmp ne i32 %1, 0
  br i1 %2, label %cont, label %ret0

ret0:                                             ; preds = %entry
  ret i32 0

cont:                                             ; preds = %entry
  %3 = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void @loc_1400D766D(i8* %3)
  %4 = load i8*, i8** @qword_1400070E0, align 8
  %5 = icmp ne i8* %4, null
  br i1 %5, label %loop.prep, label %unlock

loop.prep:                                        ; preds = %cont
  br label %loop.header

loop.header:                                      ; preds = %advance, %loop.prep
  %curr = phi i8* [ %4, %loop.prep ], [ %next2, %advance ]
  %prev = phi i8* [ null, %loop.prep ], [ %curr2, %advance ]
  %keyptr = bitcast i8* %curr to i32*
  %key = load i32, i32* %keyptr, align 4
  %nextptr.i8 = getelementptr inbounds i8, i8* %curr, i64 16
  %nextptr = bitcast i8* %nextptr.i8 to i8**
  %next = load i8*, i8** %nextptr, align 8
  %cmp = icmp eq i32 %key, %0
  br i1 %cmp, label %found, label %not_equal

not_equal:                                        ; preds = %loop.header
  %nextnull = icmp eq i8* %next, null
  br i1 %nextnull, label %unlock, label %advance

advance:                                          ; preds = %not_equal
  %curr2 = phi i8* [ %curr, %not_equal ]
  %next2 = phi i8* [ %next, %not_equal ]
  br label %loop.header

found:                                            ; preds = %loop.header
  %prevnull = icmp eq i8* %prev, null
  br i1 %prevnull, label %remove_head, label %remove_middle

remove_head:                                      ; preds = %found
  store i8* %next, i8** @qword_1400070E0, align 8
  br label %do_free

remove_middle:                                    ; preds = %found
  %prev_nextptr.i8 = getelementptr inbounds i8, i8* %prev, i64 16
  %prev_nextptr = bitcast i8* %prev_nextptr.i8 to i8**
  store i8* %next, i8** %prev_nextptr, align 8
  br label %do_free

do_free:                                          ; preds = %remove_middle, %remove_head
  call void @sub_140002BB0(i8* %curr)
  br label %unlock

unlock:                                           ; preds = %do_free, %not_equal, %cont
  %6 = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void @sub_1400E1987(i8* %6)
  ret i32 0
}