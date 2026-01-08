; ModuleID = 'sub_1400014A0'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i64*

declare void @loc_140001420(i8*)
declare void @sub_140001450()

define void @sub_1400014A0() {
entry:
  %tblptr = load i64*, i64** @off_1400043B0, align 8
  %firstq = load i64, i64* %tblptr, align 8
  %firstq_trunc = trunc i64 %firstq to i32
  %is_neg1 = icmp eq i32 %firstq_trunc, -1
  br i1 %is_neg1, label %scan.init, label %check_zero

scan.init:
  %i_init = add i64 0, 1
  br label %scan.loop

scan.loop:
  %i_cur = phi i64 [ %i_init, %scan.init ], [ %i_next, %scan.cont ]
  %elem_ptr = getelementptr inbounds i64, i64* %tblptr, i64 %i_cur
  %elem_val = load i64, i64* %elem_ptr, align 8
  %nz = icmp ne i64 %elem_val, 0
  br i1 %nz, label %scan.cont, label %after_scan

scan.cont:
  %i_next = add i64 %i_cur, 1
  br label %scan.loop

after_scan:
  %i_before_zero = add i64 %i_cur, -1
  %cnt_from_scan = trunc i64 %i_before_zero to i32
  br label %check_zero

check_zero:
  %count = phi i32 [ %firstq_trunc, %entry ], [ %cnt_from_scan, %after_scan ]
  %is_zero = icmp eq i32 %count, 0
  br i1 %is_zero, label %tail, label %loop_setup

loop_setup:
  %count_z = zext i32 %count to i64
  br label %call_loop

call_loop:
  %idx = phi i64 [ %count_z, %loop_setup ], [ %idx_dec, %call_next ]
  %call_ptr_slot = getelementptr inbounds i64, i64* %tblptr, i64 %idx
  %call_ptr_int = load i64, i64* %call_ptr_slot, align 8
  %call_ptr = inttoptr i64 %call_ptr_int to void ()*
  call void %call_ptr()
  %idx_dec = add i64 %idx, -1
  %cont = icmp ne i64 %idx_dec, 0
  br i1 %cont, label %call_next, label %tail

call_next:
  br label %call_loop

tail:
  %fnptr = bitcast void ()* @sub_140001450 to i8*
  tail call void @loc_140001420(i8* %fnptr)
  ret void
}