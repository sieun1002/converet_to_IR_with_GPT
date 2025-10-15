; ModuleID = 'sub_140001870.ll'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external dso_local global i64*, align 8

declare dso_local i32 @j__crt_atexit(void ()*) local_unnamed_addr
declare dso_local void @sub_140001820() local_unnamed_addr

define dso_local i32 @sub_140001870() local_unnamed_addr {
entry:
  %baseptr_ptr = load i64*, i64** @off_140004390, align 8
  %first_qword = load i64, i64* %baseptr_ptr, align 8
  %first_i32 = trunc i64 %first_qword to i32
  %is_minus1 = icmp eq i32 %first_i32, -1
  br i1 %is_minus1, label %scan_init, label %use_count

scan_init:
  br label %scan_loop

scan_loop:
  %i_phi = phi i64 [ 0, %scan_init ], [ %next_i, %scan_loop_continue ]
  %next_i = add i64 %i_phi, 1
  %gep_next = getelementptr inbounds i64, i64* %baseptr_ptr, i64 %next_i
  %val_next = load i64, i64* %gep_next, align 8
  %nonzero = icmp ne i64 %val_next, 0
  br i1 %nonzero, label %scan_loop_continue, label %scan_done

scan_loop_continue:
  br label %scan_loop

scan_done:
  br label %merge_count

use_count:
  %count_zext = zext i32 %first_i32 to i64
  br label %merge_count

merge_count:
  %count_phi = phi i64 [ %i_phi, %scan_done ], [ %count_zext, %use_count ]
  %is_zero = icmp eq i64 %count_phi, 0
  br i1 %is_zero, label %register, label %call_loop_pre

call_loop_pre:
  br label %call_loop

call_loop:
  %idx_phi = phi i64 [ %count_phi, %call_loop_pre ], [ %idx_next, %call_loop_iter ]
  %gep_call = getelementptr inbounds i64, i64* %baseptr_ptr, i64 %idx_phi
  %func_addr64 = load i64, i64* %gep_call, align 8
  %func_ptr = inttoptr i64 %func_addr64 to void ()*
  call void %func_ptr()
  %idx_next = add i64 %idx_phi, -1
  %cmp_continue = icmp eq i64 %idx_next, 0
  br i1 %cmp_continue, label %register, label %call_loop_iter

call_loop_iter:
  br label %call_loop

register:
  %call_atexit = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %call_atexit
}