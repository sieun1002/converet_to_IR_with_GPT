; target
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

; external globals
@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1
@qword_140008258 = external global void (i8*)*, align 8
@qword_140008270 = external global void (i8*)*, align 8

; external function
declare void @sub_1400027F0(i8*)

; function body
define i32 @sub_140001F80(i32 %arg0) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %t = icmp ne i32 %g, 0
  br i1 %t, label %lock_acquire, label %ret_zero

ret_zero:
  ret i32 0

lock_acquire:
  %fp_lock = load void (i8*)*, void (i8*)** @qword_140008258, align 8
  call void %fp_lock(i8* @unk_140007100)
  %head = load i8*, i8** @qword_1400070E0, align 8
  %headnull = icmp eq i8* %head, null
  br i1 %headnull, label %lock_release, label %loop

loop:
  %curr = phi i8* [ %head, %lock_acquire ], [ %next, %advance ]
  %prev = phi i8* [ null, %lock_acquire ], [ %curr, %advance ]
  %keyptr = bitcast i8* %curr to i32*
  %key = load i32, i32* %keyptr, align 4
  %next_field_i8 = getelementptr i8, i8* %curr, i64 16
  %next_field = bitcast i8* %next_field_i8 to i8**
  %next = load i8*, i8** %next_field, align 8
  %eq = icmp eq i32 %key, %arg0
  br i1 %eq, label %found, label %not_equal

not_equal:
  %isnull = icmp eq i8* %next, null
  br i1 %isnull, label %lock_release, label %advance

advance:
  br label %loop

found:
  %prev_is_null = icmp eq i8* %prev, null
  br i1 %prev_is_null, label %update_head, label %update_link

update_link:
  %prev_next_i8 = getelementptr i8, i8* %prev, i64 16
  %prev_next = bitcast i8* %prev_next_i8 to i8**
  store i8* %next, i8** %prev_next, align 8
  call void @sub_1400027F0(i8* %curr)
  br label %lock_release

update_head:
  store i8* %next, i8** @qword_1400070E0, align 8
  call void @sub_1400027F0(i8* %curr)
  br label %lock_release

lock_release:
  %fp_unlock = load void (i8*)*, void (i8*)** @qword_140008270, align 8
  call void %fp_unlock(i8* @unk_140007100)
  ret i32 0
}