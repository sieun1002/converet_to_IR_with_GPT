; ModuleID = 'sub_140001870_module'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i8*

declare i32 @j__crt_atexit(void ()*)
declare void @sub_140001820()

define dso_local i32 @sub_140001870() {
entry:
  %base_ptr = load i8*, i8** @off_140004390, align 8
  %base_as_i64 = bitcast i8* %base_ptr to i64*
  %raw0 = load i64, i64* %base_as_i64, align 8
  %count32 = trunc i64 %raw0 to i32
  %is_m1 = icmp eq i32 %count32, -1
  br i1 %is_m1, label %scan_init, label %have_count

scan_init:
  br label %scan_loop

scan_loop:
  %i = phi i32 [ 0, %scan_init ], [ %i_next, %scan_loop_tail ]
  %i_plus1 = add i32 %i, 1
  %i_plus1_ext = sext i32 %i_plus1 to i64
  %base_fnpp = bitcast i8* %base_ptr to void ()**
  %slot_ptr = getelementptr inbounds void ()*, void ()** %base_fnpp, i64 %i_plus1_ext
  %fptr_scan = load void ()*, void ()** %slot_ptr, align 8
  %nonnull = icmp ne void ()* %fptr_scan, null
  br i1 %nonnull, label %scan_loop_tail, label %scan_done

scan_loop_tail:
  %i_next = add i32 %i, 1
  br label %scan_loop

scan_done:
  br label %have_count

have_count:
  %count = phi i32 [ %count32, %entry ], [ %i, %scan_done ]
  %is_zero = icmp eq i32 %count, 0
  br i1 %is_zero, label %register, label %call_loop_entry

call_loop_entry:
  %base_fnpp2 = bitcast i8* %base_ptr to void ()**
  %count_ext = sext i32 %count to i64
  %cur_ptr = getelementptr inbounds void ()*, void ()** %base_fnpp2, i64 %count_ext
  %base0_ptr = getelementptr inbounds void ()*, void ()** %base_fnpp2, i64 0
  br label %call_loop

call_loop:
  %cur_phi = phi void ()** [ %cur_ptr, %call_loop_entry ], [ %cur_dec, %call_loop_tail ]
  %fptr = load void ()*, void ()** %cur_phi, align 8
  call void %fptr()
  %cur_dec = getelementptr inbounds void ()*, void ()** %cur_phi, i64 -1
  %neq_base = icmp ne void ()** %cur_dec, %base0_ptr
  br i1 %neq_base, label %call_loop_tail, label %register

call_loop_tail:
  br label %call_loop

register:
  %res = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %res
}