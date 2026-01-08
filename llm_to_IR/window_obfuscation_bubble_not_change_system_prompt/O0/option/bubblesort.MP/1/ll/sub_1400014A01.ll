target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i8*, align 8

declare void @sub_140001420(i8*)
declare void @sub_140001450()

define void @sub_1400014A0() {
entry:
  %baseptr = load i8*, i8** @off_1400043B0, align 8
  %base_i32p = bitcast i8* %baseptr to i32*
  %val32 = load i32, i32* %base_i32p, align 4
  %is_m1 = icmp eq i32 %val32, -1
  br i1 %is_m1, label %scan, label %test_count

scan:
  br label %scan_loop

scan_loop:
  %curr = phi i64 [ 0, %scan ], [ %next_curr, %scan_loop_latch ]
  %idx = phi i64 [ 1, %scan ], [ %next_idx, %scan_loop_latch ]
  %idx_off = mul i64 %idx, 8
  %addr = getelementptr i8, i8* %baseptr, i64 %idx_off
  %slot = bitcast i8* %addr to i8**
  %fp_ptr = load i8*, i8** %slot, align 8
  %nz = icmp ne i8* %fp_ptr, null
  br i1 %nz, label %scan_loop_latch, label %scan_done

scan_loop_latch:
  %next_curr = add i64 %idx, 0
  %next_idx = add i64 %idx, 1
  br label %scan_loop

scan_done:
  %curr_trunc = trunc i64 %curr to i32
  br label %test_count

test_count:
  %count = phi i32 [ %val32, %entry ], [ %curr_trunc, %scan_done ]
  %cmp_zero = icmp eq i32 %count, 0
  br i1 %cmp_zero, label %call_atexit, label %setup_loop

setup_loop:
  %count64 = zext i32 %count to i64
  %count64_mul8 = mul i64 %count64, 8
  %rbx0 = getelementptr i8, i8* %baseptr, i64 %count64_mul8
  br label %loop

loop:
  %rbx_phi = phi i8* [ %rbx0, %setup_loop ], [ %rbx_next, %loop_latch ]
  %slot2 = bitcast i8* %rbx_phi to i8**
  %fp_val = load i8*, i8** %slot2, align 8
  %fp_callee = bitcast i8* %fp_val to void ()*
  call void %fp_callee()
  %rbx_next = getelementptr i8, i8* %rbx_phi, i64 -8
  %cont = icmp ne i8* %rbx_next, %baseptr
  br i1 %cont, label %loop_latch, label %call_atexit

loop_latch:
  br label %loop

call_atexit:
  %cb = bitcast void ()* @sub_140001450 to i8*
  tail call void @sub_140001420(i8* %cb)
  ret void
}