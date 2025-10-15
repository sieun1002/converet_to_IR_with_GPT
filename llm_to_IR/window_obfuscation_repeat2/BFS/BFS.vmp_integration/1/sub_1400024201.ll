; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @loc_1400459DD(i8*)
declare void @loc_1400E51A7(i8*)
declare void @sub_140002C90()

define i32 @sub_140002420(i32 %arg) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %iszero = icmp eq i32 %flag, 0
  br i1 %iszero, label %ret0, label %start

ret0:
  ret i32 0

start:
  call void @loc_1400459DD(i8* @unk_140007100)
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %after, label %loop.header

loop.header:
  br label %loop

loop:
  %prev = phi i8* [ null, %loop.header ], [ %cur, %notmatch ]
  %cur = phi i8* [ %head, %loop.header ], [ %next, %notmatch ]
  %keyptr = bitcast i8* %cur to i32*
  %key = load i32, i32* %keyptr, align 4
  %next_gep = getelementptr i8, i8* %cur, i64 16
  %nextptr = bitcast i8* %next_gep to i8**
  %next = load i8*, i8** %nextptr, align 8
  %eq = icmp eq i32 %key, %arg
  br i1 %eq, label %found, label %notmatch

notmatch:
  %next_is_null = icmp eq i8* %next, null
  br i1 %next_is_null, label %after, label %loop

found:
  %hasprev = icmp ne i8* %prev, null
  br i1 %hasprev, label %found_with_prev, label %found_no_prev

found_no_prev:
  store i8* %next, i8** @qword_1400070E0, align 8
  br label %remove_call

found_with_prev:
  %pnext_gep = getelementptr i8, i8* %prev, i64 16
  %pnextptr = bitcast i8* %pnext_gep to i8**
  store i8* %next, i8** %pnextptr, align 8
  br label %remove_call

remove_call:
  call void @sub_140002C90()
  br label %after

after:
  call void @loc_1400E51A7(i8* @unk_140007100)
  ret i32 0
}