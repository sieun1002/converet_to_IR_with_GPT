; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external dso_local global i8*, align 8

declare dso_local void @loc_140001420(i8*)
declare dso_local void @sub_140001450()

define dso_local void @sub_1400014A0() local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043B0, align 8
  %base_i64p = bitcast i8* %baseptr to i64*
  %first64 = load i64, i64* %base_i64p, align 8
  %first32 = trunc i64 %first64 to i32
  %is_m1 = icmp eq i32 %first32, -1
  br i1 %is_m1, label %sentinel, label %test_count

sentinel:
  br label %scan_loop

scan_loop:
  %cur = phi i32 [ 0, %sentinel ], [ %next, %scan_cont ]
  %next = add i32 %cur, 1
  %next_zext = zext i32 %next to i64
  %p_next = getelementptr inbounds i64, i64* %base_i64p, i64 %next_zext
  %val = load i64, i64* %p_next, align 8
  %nz = icmp ne i64 %val, 0
  br i1 %nz, label %scan_cont, label %test_count

scan_cont:
  br label %scan_loop

test_count:
  %count = phi i32 [ %first32, %entry ], [ %cur, %scan_loop ]
  %is_zero = icmp eq i32 %count, 0
  br i1 %is_zero, label %tailcall, label %loop_prep

loop_prep:
  %count64 = zext i32 %count to i64
  %rbx_start = getelementptr inbounds i64, i64* %base_i64p, i64 %count64
  br label %call_loop

call_loop:
  %rbx.cur = phi i64* [ %rbx_start, %loop_prep ], [ %rbx.dec, %call_loop ]
  %fn64 = load i64, i64* %rbx.cur, align 8
  %fn = inttoptr i64 %fn64 to void ()*
  call void %fn()
  %rbx.dec = getelementptr inbounds i64, i64* %rbx.cur, i64 -1
  %cont = icmp ne i64* %rbx.dec, %base_i64p
  br i1 %cont, label %call_loop, label %tailcall

tailcall:
  %fptr = bitcast void ()* @sub_140001450 to i8*
  tail call void @loc_140001420(i8* %fptr)
  ret void
}