; ModuleID = 'sub_1400014A0'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external dso_local global i64*

declare dso_local i32 @j__crt_atexit(void ()*)
declare dso_local void @sub_140001450()

define dso_local i32 @sub_1400014A0() local_unnamed_addr {
entry:
  %baseptr = load i64*, i64** @off_1400043B0, align 8
  %first64 = load i64, i64* %baseptr, align 8
  %first32 = trunc i64 %first64 to i32
  %is_neg1 = icmp eq i32 %first32, -1
  br i1 %is_neg1, label %scan.loop, label %check_count

scan.loop:
  %i = phi i64 [ 0, %entry ], [ %i_plus1, %scan.loop ]
  %i_plus1 = add i64 %i, 1
  %eltptr = getelementptr inbounds i64, i64* %baseptr, i64 %i_plus1
  %elt = load i64, i64* %eltptr, align 8
  %nz = icmp ne i64 %elt, 0
  br i1 %nz, label %scan.loop, label %from_scan

from_scan:
  %count_from_scan32 = trunc i64 %i to i32
  br label %check_count_after

check_count:
  br label %check_count_after

check_count_after:
  %count = phi i32 [ %first32, %check_count ], [ %count_from_scan32, %from_scan ]
  %is_zero = icmp eq i32 %count, 0
  br i1 %is_zero, label %register_atexit, label %prep_loop

prep_loop:
  %count64 = zext i32 %count to i64
  br label %loop

loop:
  %idx = phi i64 [ %count64, %prep_loop ], [ %idx.dec, %loop ]
  %funptr.addr = getelementptr inbounds i64, i64* %baseptr, i64 %idx
  %funaddr64 = load i64, i64* %funptr.addr, align 8
  %funptr = inttoptr i64 %funaddr64 to void ()*
  call void %funptr()
  %idx.dec = add i64 %idx, -1
  %cont = icmp ne i64 %idx.dec, 0
  br i1 %cont, label %loop, label %register_atexit

register_atexit:
  %ret = tail call i32 @j__crt_atexit(void ()* @sub_140001450)
  ret i32 %ret
}