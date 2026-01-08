; ModuleID = 'sub_1400014A0'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i8*, align 8

declare void @sub_140001420(i8*)
declare void @sub_140001450()

define void @sub_1400014A0() {
entry:
  %base_raw = load i8*, i8** @off_1400043B0, align 8
  %base_i64 = bitcast i8* %base_raw to i64*
  %first64 = load i64, i64* %base_i64, align 8
  %first32 = trunc i64 %first64 to i32
  %is_minus1 = icmp eq i32 %first32, -1
  br i1 %is_minus1, label %scan_init, label %check_zero

check_zero:
  %is_zero = icmp eq i32 %first32, 0
  br i1 %is_zero, label %after_callbacks, label %loop_init

loop_init:
  %count64 = zext i32 %first32 to i64
  %offset_bytes = shl i64 %count64, 3
  %rbx_init = getelementptr i8, i8* %base_raw, i64 %offset_bytes
  br label %loop

loop:
  %rbx_cur = phi i8* [ %rbx_init, %loop_init ], [ %rbx_next, %loop ]
  %slot_ptr = bitcast i8* %rbx_cur to i8**
  %fn_raw = load i8*, i8** %slot_ptr, align 8
  %fn_typed = bitcast i8* %fn_raw to void ()*
  call void %fn_typed()
  %rbx_next = getelementptr i8, i8* %rbx_cur, i64 -8
  %cont = icmp ne i8* %rbx_next, %base_raw
  br i1 %cont, label %loop, label %after_callbacks

scan_init:
  br label %scan

scan:
  %idx = phi i64 [ 1, %scan_init ], [ %idx_next, %scan ]
  %off2 = shl i64 %idx, 3
  %slot2 = getelementptr i8, i8* %base_raw, i64 %off2
  %slot2p = bitcast i8* %slot2 to i8**
  %val = load i8*, i8** %slot2p, align 8
  %nonzero = icmp ne i8* %val, null
  %idx_next = add i64 %idx, 1
  br i1 %nonzero, label %scan, label %after_callbacks

after_callbacks:
  %func_i8 = bitcast void ()* @sub_140001450 to i8*
  musttail call void @sub_140001420(i8* %func_i8)
  ret void
}