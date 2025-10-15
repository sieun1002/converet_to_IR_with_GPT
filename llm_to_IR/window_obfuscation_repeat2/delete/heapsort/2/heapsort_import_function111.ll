; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare void @loc_1400D766D(i8*)
declare i8* @sub_1400E1987(i8*)
declare void @sub_140002BB0() noreturn

define i32 @sub_140002340(i32 %arg) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cmp = icmp ne i32 %g, 0
  br i1 %cmp, label %if.nonzero, label %earlyret

earlyret:                                         ; preds = %entry
  ret i32 0

if.nonzero:                                       ; preds = %entry
  call void @loc_1400D766D(i8* @unk_140007100)
  %head = load i8*, i8** @qword_1400070E0, align 8
  %isnull = icmp eq i8* %head, null
  br i1 %isnull, label %A3, label %loop

loop:                                             ; preds = %advance, %if.nonzero
  %cur = phi i8* [ %head, %if.nonzero ], [ %next, %advance ]
  %prev = phi i8* [ null, %if.nonzero ], [ %cur, %advance ]
  %keyptr = bitcast i8* %cur to i32*
  %key = load i32, i32* %keyptr, align 4
  %nextptr.i8 = getelementptr i8, i8* %cur, i64 16
  %nextptr = bitcast i8* %nextptr.i8 to i8**
  %next = load i8*, i8** %nextptr, align 8
  %eq = icmp eq i32 %key, %arg
  br i1 %eq, label %found, label %advance_check

advance_check:                                    ; preds = %loop
  %next_is_null = icmp eq i8* %next, null
  br i1 %next_is_null, label %A3, label %advance

advance:                                          ; preds = %advance_check
  br label %loop

found:                                            ; preds = %loop
  %prev_is_null = icmp eq i8* %prev, null
  br i1 %prev_is_null, label %headcase, label %unlink

headcase:                                         ; preds = %found
  store i8* %next, i8** @qword_1400070E0, align 8
  br label %callBB

unlink:                                           ; preds = %found
  %prev_next_i8 = getelementptr i8, i8* %prev, i64 16
  %prev_next_ptr = bitcast i8* %prev_next_i8 to i8**
  store i8* %next, i8** %prev_next_ptr, align 8
  br label %callBB

A3:                                               ; preds = %advance_check, %if.nonzero
  %newhead = call i8* @sub_1400E1987(i8* @unk_140007100)
  store i8* %newhead, i8** @qword_1400070E0, align 8
  br label %callBB

callBB:                                           ; preds = %A3, %unlink, %headcase
  call void @sub_140002BB0()
  unreachable
}