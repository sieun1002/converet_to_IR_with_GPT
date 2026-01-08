target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external dso_local global i8*, align 8

declare dso_local i32 @loc_140001420(i8*) local_unnamed_addr
declare dso_local void @sub_140001450() local_unnamed_addr

define dso_local i32 @sub_1400014A0() local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043B0, align 8
  %base_i64p = bitcast i8* %baseptr to i64*
  %first64 = load i64, i64* %base_i64p, align 8
  %first32 = trunc i64 %first64 to i32
  %is_m1 = icmp eq i32 %first32, -1
  br i1 %is_m1, label %scan_init, label %b7

scan_init:
  br label %scan_loop

scan_loop:
  %i = phi i64 [ 1, %scan_init ], [ %i_next, %scan_loop_body ]
  %prev = phi i32 [ 0, %scan_init ], [ %prev_next, %scan_loop_body ]
  %base_pp = bitcast i8* %baseptr to i8**
  %elem_ptr = getelementptr inbounds i8*, i8** %base_pp, i64 %i
  %elem = load i8*, i8** %elem_ptr, align 8
  %nz = icmp ne i8* %elem, null
  br i1 %nz, label %scan_loop_body, label %b7_from_scan

scan_loop_body:
  %prev_next = trunc i64 %i to i32
  %i_next = add i64 %i, 1
  br label %scan_loop

b7_from_scan:
  br label %b7

b7:
  %ecx = phi i32 [ %first32, %entry ], [ %prev, %b7_from_scan ]
  %iszero = icmp eq i32 %ecx, 0
  br i1 %iszero, label %tail, label %call_loop_init

call_loop_init:
  %idx0 = sext i32 %ecx to i64
  br label %call_loop

call_loop:
  %idx = phi i64 [ %idx0, %call_loop_init ], [ %idx_dec, %call_loop_body ]
  %base_pp2 = bitcast i8* %baseptr to i8**
  %fptr_ptr = getelementptr inbounds i8*, i8** %base_pp2, i64 %idx
  %fptr_i8 = load i8*, i8** %fptr_ptr, align 8
  %fptr = bitcast i8* %fptr_i8 to void ()*
  call void %fptr()
  br label %call_loop_body

call_loop_body:
  %idx_dec = add i64 %idx, -1
  %cont = icmp ne i64 %idx_dec, 0
  br i1 %cont, label %call_loop, label %tail

tail:
  %arg = bitcast void ()* @sub_140001450 to i8*
  %ret = tail call i32 @loc_140001420(i8* %arg)
  ret i32 %ret
}