target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8
@qword_140008258 = external global void (i8*)*
@qword_140008270 = external global void (i8*)*

declare void @sub_1400027F0(i8*)

define i32 @sub_140001F80(i32 %arg) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %g_nonzero = icmp ne i32 %g, 0
  br i1 %g_nonzero, label %loc_140001F98, label %ret

ret:
  ret i32 0

loc_140001F98:
  %acq_fp_ptr = load void (i8*)*, void (i8*)** @qword_140008258, align 8
  call void %acq_fp_ptr(i8* @unk_140007100)
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_null = icmp eq i8* %head, null
  br i1 %head_null, label %release, label %loop

loop:
  %prev = phi i8* [ null, %loc_140001F98 ], [ %curr, %loop_latch ]
  %curr = phi i8* [ %head, %loc_140001F98 ], [ %next, %loop_latch ]
  %curr_key_ptr = bitcast i8* %curr to i32*
  %curr_key = load i32, i32* %curr_key_ptr, align 4
  %cmpkey = icmp eq i32 %curr_key, %arg
  %next_ptr_i8 = getelementptr i8, i8* %curr, i64 16
  %next_ptr = bitcast i8* %next_ptr_i8 to i8**
  %next = load i8*, i8** %next_ptr, align 8
  br i1 %cmpkey, label %found, label %advance

advance:
  %next_is_null = icmp eq i8* %next, null
  br i1 %next_is_null, label %release, label %loop_latch

loop_latch:
  br label %loop

found:
  %prev_is_null = icmp eq i8* %prev, null
  br i1 %prev_is_null, label %headcase, label %middlecase

headcase:
  store i8* %next, i8** @qword_1400070E0, align 8
  br label %unlink_done

middlecase:
  %prev_next_ptr_i8 = getelementptr i8, i8* %prev, i64 16
  %prev_next_ptr = bitcast i8* %prev_next_ptr_i8 to i8**
  store i8* %next, i8** %prev_next_ptr, align 8
  br label %unlink_done

unlink_done:
  call void @sub_1400027F0(i8* %curr)
  br label %release

release:
  %rel_fp_ptr = load void (i8*)*, void (i8*)** @qword_140008270, align 8
  call void %rel_fp_ptr(i8* @unk_140007100)
  br label %ret2

ret2:
  ret i32 0
}