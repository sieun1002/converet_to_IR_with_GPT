; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i8*

declare void @sub_140001450()
declare void @loc_140001420(void ()*)

define void @sub_1400014A0() {
entry:
  %rdx_load = load i8*, i8** @off_1400043B0, align 8
  %first_ptr = bitcast i8* %rdx_load to i64*
  %first_q = load i64, i64* %first_ptr, align 8
  %first32 = trunc i64 %first_q to i32
  %cmp_minus1 = icmp eq i32 %first32, -1
  br i1 %cmp_minus1, label %scan_init, label %have_count

scan_init:                                           ; preds = %entry
  br label %scan_loop

scan_loop:                                           ; preds = %scan_loop_cont, %scan_init
  %eax_phi = phi i64 [ 0, %scan_init ], [ %r8_val, %scan_loop_cont ]
  %r8_val = add i64 %eax_phi, 1
  %mul = shl i64 %r8_val, 3
  %ptr_r8 = getelementptr i8, i8* %rdx_load, i64 %mul
  %slot_r8 = bitcast i8* %ptr_r8 to void ()**
  %fn_r8 = load void ()*, void ()** %slot_r8, align 8
  %cmp_nonzero = icmp ne void ()* %fn_r8, null
  br i1 %cmp_nonzero, label %scan_loop_cont, label %to_have_count

scan_loop_cont:                                      ; preds = %scan_loop
  br label %scan_loop

to_have_count:                                       ; preds = %scan_loop
  %ecx_from_scan = trunc i64 %eax_phi to i32
  br label %have_count

have_count:                                          ; preds = %to_have_count, %entry
  %ecx_phi = phi i32 [ %first32, %entry ], [ %ecx_from_scan, %to_have_count ]
  %test_zero = icmp eq i32 %ecx_phi, 0
  br i1 %test_zero, label %after_calls, label %prep_loop

prep_loop:                                           ; preds = %have_count
  %n64 = zext i32 %ecx_phi to i64
  %mul_n = shl i64 %n64, 3
  %rbx0 = getelementptr i8, i8* %rdx_load, i64 %mul_n
  br label %call_loop

call_loop:                                           ; preds = %call_loop_body, %prep_loop
  %rbx_phi = phi i8* [ %rbx0, %prep_loop ], [ %rbx_next, %call_loop_body ]
  %slot = bitcast i8* %rbx_phi to void ()**
  %fn = load void ()*, void ()** %slot, align 8
  call void %fn()
  %rbx_next = getelementptr i8, i8* %rbx_phi, i64 -8
  %cmp_cont = icmp ne i8* %rbx_next, %rdx_load
  br i1 %cmp_cont, label %call_loop_body, label %after_calls

call_loop_body:                                      ; preds = %call_loop
  br label %call_loop

after_calls:                                         ; preds = %call_loop, %have_count
  tail call void @loc_140001420(void ()* @sub_140001450)
  ret void
}