; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @sub_1403C91CD(i8*)
declare i8* @loc_1403D9CA6(i8*)
declare void @sub_140002C90()

define i32 @sub_140002420(i32 %arg0) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag_nonzero = icmp ne i32 %flag, 0
  br i1 %flag_nonzero, label %cont, label %ret0

ret0:
  ret i32 0

cont:
  call void @sub_1403C91CD(i8* @unk_140007100)
  %head0 = load i8*, i8** @qword_1400070E0, align 8
  %headnull = icmp eq i8* %head0, null
  br i1 %headnull, label %L483, label %loop_header

loop_header:
  %curr = phi i8* [ %head0, %cont ], [ %next, %loop_continue ]
  %prev = phi i8* [ null, %cont ], [ %curr, %loop_continue ]
  %keyptr = bitcast i8* %curr to i32*
  %key = load i32, i32* %keyptr, align 4
  %nextptr_base = getelementptr inbounds i8, i8* %curr, i64 16
  %nextptr = bitcast i8* %nextptr_base to i8**
  %next = load i8*, i8** %nextptr, align 8
  %found_cmp = icmp eq i32 %key, %arg0
  br i1 %found_cmp, label %found, label %notmatch

notmatch:
  %next_is_null = icmp eq i8* %next, null
  br i1 %next_is_null, label %L483, label %loop_continue

loop_continue:
  br label %loop_header

found:
  %prev_is_null = icmp eq i8* %prev, null
  br i1 %prev_is_null, label %L4A0_path, label %has_prev

has_prev:
  %prev_next_base = getelementptr inbounds i8, i8* %prev, i64 16
  %prev_next = bitcast i8* %prev_next_base to i8**
  store i8* %next, i8** %prev_next, align 8
  call void @sub_140002C90()
  br label %L483

L483:
  %newhead = call i8* @loc_1403D9CA6(i8* @unk_140007100)
  br label %L4A0_common

L4A0_path:
  store i8* %next, i8** @qword_1400070E0, align 8
  br label %L47E

L4A0_common:
  store i8* %newhead, i8** @qword_1400070E0, align 8
  br label %L47E

L47E:
  call void @sub_140002C90()
  br label %L483
}