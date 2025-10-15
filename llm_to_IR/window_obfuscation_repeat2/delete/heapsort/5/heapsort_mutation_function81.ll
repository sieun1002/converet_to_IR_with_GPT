; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i8*

declare i32 @j__crt_atexit(void ()*)
declare void @sub_140001820()

define i32 @sub_140001870() {
entry:
  %rdx = load i8*, i8** @off_140004390
  %base_i64 = bitcast i8* %rdx to i64*
  %firstq = load i64, i64* %base_i64, align 8
  %first32 = trunc i64 %firstq to i32
  %isneg1 = icmp eq i32 %first32, -1
  br i1 %isneg1, label %scan, label %notneg

scan:
  %base_fnpp0 = bitcast i8* %rdx to void ()**
  br label %scan_loop

scan_loop:
  %i_phi = phi i64 [ 0, %scan ], [ %r8_val, %scan_body ]
  %r8_val = add i64 %i_phi, 1
  %gep_r8 = getelementptr inbounds void ()*, void ()** %base_fnpp0, i64 %r8_val
  %fnptr_r8 = load void ()*, void ()** %gep_r8, align 8
  %is_nonnull = icmp ne void ()* %fnptr_r8, null
  br i1 %is_nonnull, label %scan_body, label %scan_end

scan_body:
  br label %scan_loop

scan_end:
  %count_from_scan = trunc i64 %i_phi to i32
  br label %cont

notneg:
  br label %cont

cont:
  %count_phi = phi i32 [ %count_from_scan, %scan_end ], [ %first32, %notneg ]
  %iszero = icmp eq i32 %count_phi, 0
  br i1 %iszero, label %after_loop, label %loop_prep

loop_prep:
  %count64 = sext i32 %count_phi to i64
  %base_fnpp = bitcast i8* %rdx to void ()**
  br label %call_loop

call_loop:
  %i_idx = phi i64 [ %count64, %loop_prep ], [ %i_next, %call_next ]
  %gep_i = getelementptr inbounds void ()*, void ()** %base_fnpp, i64 %i_idx
  %fnptr_i = load void ()*, void ()** %gep_i, align 8
  call void %fnptr_i()
  %i_next = add i64 %i_idx, -1
  %cond = icmp ne i64 %i_next, 0
  br i1 %cond, label %call_next, label %after_loop

call_next:
  br label %call_loop

after_loop:
  %res = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %res
}