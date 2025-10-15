; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i8** 

declare i32 @j__crt_atexit(void ()*)

define i32 @sub_140001870() local_unnamed_addr nounwind {
entry:
  %base_ptr_ptr = load i8**, i8*** @off_140004390
  %elem0_ptr = load i8*, i8** %base_ptr_ptr
  %elem0_i64 = ptrtoint i8* %elem0_ptr to i64
  %elem0_i32 = trunc i64 %elem0_i64 to i32
  %is_minus1 = icmp eq i32 %elem0_i32, -1
  br i1 %is_minus1, label %scan_entry, label %use_elem

use_elem:
  br label %compute

scan_entry:
  br label %scan_loop

scan_loop:
  %idx = phi i64 [ 1, %scan_entry ], [ %next_idx, %scan_loop ]
  %gep_scan = getelementptr inbounds i8*, i8** %base_ptr_ptr, i64 %idx
  %val_scan = load i8*, i8** %gep_scan
  %not_null = icmp ne i8* %val_scan, null
  %next_idx = add i64 %idx, 1
  br i1 %not_null, label %scan_loop, label %scan_done

scan_done:
  %count64_scan = add i64 %idx, -1
  %count32_scan = trunc i64 %count64_scan to i32
  br label %compute

compute:
  %count = phi i32 [ %elem0_i32, %use_elem ], [ %count32_scan, %scan_done ]
  %is_zero = icmp eq i32 %count, 0
  br i1 %is_zero, label %after_calls, label %loop_entry

loop_entry:
  %i_start = sext i32 %count to i64
  br label %loop_body

loop_body:
  %i = phi i64 [ %i_start, %loop_entry ], [ %i_dec, %loop_body ]
  %gep_call = getelementptr inbounds i8*, i8** %base_ptr_ptr, i64 %i
  %fn_i8 = load i8*, i8** %gep_call
  %fn = bitcast i8* %fn_i8 to void ()*
  call void %fn()
  %i_dec = add i64 %i, -1
  %cont = icmp ne i64 %i_dec, 0
  br i1 %cont, label %loop_body, label %after_calls

after_calls:
  %ret = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %ret
}

define void @sub_140001820() local_unnamed_addr nounwind {
entry:
  ret void
}