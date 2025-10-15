; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i8*, align 8

declare i32 @j__crt_atexit(void ()*)
declare void @sub_140001820()

define i32 @sub_140001870() {
entry:
  %base_ptr_raw = load i8*, i8** @off_140004390, align 8
  %base_i64 = bitcast i8* %base_ptr_raw to i64*
  %first_qword = load i64, i64* %base_i64, align 8
  %cnt32 = trunc i64 %first_qword to i32
  %is_minus1 = icmp eq i32 %cnt32, -1
  br i1 %is_minus1, label %scan_init, label %check_count

scan_init:
  br label %scan_loop

scan_loop:
  %idx = phi i32 [ 0, %scan_init ], [ %next, %scan_loop ]
  %next = add i32 %idx, 1
  %next64 = zext i32 %next to i64
  %ptr_next = getelementptr inbounds i64, i64* %base_i64, i64 %next64
  %val = load i64, i64* %ptr_next, align 8
  %nz = icmp ne i64 %val, 0
  br i1 %nz, label %scan_loop, label %check_count

check_count:
  %ecx = phi i32 [ %cnt32, %entry ], [ %idx, %scan_loop ]
  %is_zero = icmp eq i32 %ecx, 0
  br i1 %is_zero, label %register, label %call_loop_pre

call_loop_pre:
  br label %call_loop

call_loop:
  %i = phi i32 [ %ecx, %call_loop_pre ], [ %i_dec, %call_loop ]
  %i64 = zext i32 %i to i64
  %base_funpp = bitcast i8* %base_ptr_raw to void ()**
  %fun_ptr_loc = getelementptr inbounds void ()*, void ()** %base_funpp, i64 %i64
  %fun = load void ()*, void ()** %fun_ptr_loc, align 8
  call void %fun()
  %i_dec = add i32 %i, -1
  %cont = icmp ne i32 %i_dec, 0
  br i1 %cont, label %call_loop, label %register

register:
  %call = tail call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %call
}