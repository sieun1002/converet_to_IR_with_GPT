target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i64*

declare i32 @j__crt_atexit(void ()*)
declare void @sub_140001450()

define i32 @sub_1400014A0() {
entry:
  %baseptr.ptr = load i64*, i64** @off_1400043B0
  %first64 = load i64, i64* %baseptr.ptr, align 8
  %first32 = trunc i64 %first64 to i32
  %isneg1 = icmp eq i32 %first32, -1
  br i1 %isneg1, label %f0_init, label %b7_from_entry

b7_from_entry:
  br label %b7_common

f0_init:
  br label %f0_loop

f0_loop:
  %raxPhi = phi i64 [ 0, %f0_init ], [ %raxNext, %f0_loop ]
  %r8 = add i64 %raxPhi, 1
  %ecxFromRax = trunc i64 %raxPhi to i32
  %raxNext = add i64 %raxPhi, 1
  %idxptr = getelementptr inbounds i64, i64* %baseptr.ptr, i64 %r8
  %val = load i64, i64* %idxptr, align 8
  %nonzero = icmp ne i64 %val, 0
  br i1 %nonzero, label %f0_loop, label %b7_from_f0

b7_from_f0:
  br label %b7_common

b7_common:
  %ecxPhi = phi i32 [ %first32, %b7_from_entry ], [ %ecxFromRax, %b7_from_f0 ]
  %isZero = icmp eq i32 %ecxPhi, 0
  br i1 %isZero, label %ldb, label %call_prep

call_prep:
  %N64 = zext i32 %ecxPhi to i64
  %startptr = getelementptr inbounds i64, i64* %baseptr.ptr, i64 %N64
  br label %loop_call

loop_call:
  %curptr = phi i64* [ %startptr, %call_prep ], [ %nextptr, %loop_call ]
  %faddr = load i64, i64* %curptr, align 8
  %fn = inttoptr i64 %faddr to void ()*
  call void %fn()
  %nextptr = getelementptr inbounds i64, i64* %curptr, i64 -1
  %cmp = icmp ne i64* %nextptr, %baseptr.ptr
  br i1 %cmp, label %loop_call, label %ldb

ldb:
  %res = call i32 @j__crt_atexit(void ()* @sub_140001450)
  ret i32 %res
}