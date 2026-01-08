; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32
@qword_1400070E0 = external dso_local global i64
@unk_140007100 = external dso_local global i8

declare dso_local i8* @sub_140015A7A(i8*)
declare dso_local i64 @sub_140027826(i8*)
declare dso_local void @loc_1400027ED(i8*)

define dso_local i64 @sub_140001F80(i32 %ecx, i32 %edx) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag_is_zero = icmp eq i32 %flag, 0
  br i1 %flag_is_zero, label %early_ret, label %cond_true

early_ret:
  ret i64 0

cond_true:
  %tbl = getelementptr i8, i8* bitcast (i8* @unk_140007100 to i8*), i64 0
  %head = call i8* @sub_140015A7A(i8* %tbl)
  br label %loop_check

loop_check:
  %curr_phi = phi i8* [ %head, %cond_true ], [ %next_val, %loop_continue ]
  %prev_phi = phi i8* [ null, %cond_true ], [ %curr_saved, %loop_continue ]
  %curr_is_null = icmp eq i8* %curr_phi, null
  br i1 %curr_is_null, label %unlock, label %process

process:
  %keyptr = bitcast i8* %curr_phi to i32*
  %key = load i32, i32* %keyptr, align 4
  %eq = icmp eq i32 %key, %edx
  %next_ptr_byte = getelementptr i8, i8* %curr_phi, i64 16
  %next_ptr = bitcast i8* %next_ptr_byte to i8**
  %next_val = load i8*, i8** %next_ptr, align 8
  br i1 %eq, label %found, label %loop_continue

loop_continue:
  %curr_saved = %curr_phi
  br label %loop_check

found:
  %prev_is_null = icmp eq i8* %prev_phi, null
  br i1 %prev_is_null, label %remove_head, label %remove_link

remove_link:
  %prev_next_ptr_byte = getelementptr i8, i8* %prev_phi, i64 16
  %prev_next_ptr = bitcast i8* %prev_next_ptr_byte to i8**
  store i8* %next_val, i8** %prev_next_ptr, align 8
  br label %call_destructor

remove_head:
  %next_i64 = ptrtoint i8* %next_val to i64
  store i64 %next_i64, i64* @qword_1400070E0, align 8
  br label %call_destructor

call_destructor:
  %fn_base = ptrtoint void (i8*)* @loc_1400027ED to i64
  %fn_addr = add i64 %fn_base, 3
  %callee = inttoptr i64 %fn_addr to void (i8*)*
  call void %callee(i8* %curr_phi)
  br label %unlock

unlock:
  %tbl2 = getelementptr i8, i8* bitcast (i8* @unk_140007100 to i8*), i64 0
  %retv = call i64 @sub_140027826(i8* %tbl2)
  ret i64 %retv
}