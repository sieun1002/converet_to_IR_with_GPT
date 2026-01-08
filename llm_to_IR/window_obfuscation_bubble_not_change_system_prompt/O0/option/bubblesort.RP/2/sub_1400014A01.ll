; ModuleID = 'sub_1400014A0.ll'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i64*

declare i32 @j__crt_atexit(void ()*)
declare void @sub_140001450()

define dso_local i32 @sub_1400014A0() {
entry:
  %base = load i64*, i64** @off_1400043B0, align 8
  %firstq = load i64, i64* %base, align 8
  %ecx0 = trunc i64 %firstq to i32
  %isneg1 = icmp eq i32 %ecx0, -1
  br i1 %isneg1, label %scan.init, label %test_count

scan.init:
  br label %scan.loop

scan.loop:
  %idx = phi i64 [ 0, %scan.init ], [ %next, %scan.loop.body ]
  %next = add i64 %idx, 1
  %slotptr = getelementptr inbounds i64, i64* %base, i64 %next
  %slotval = load i64, i64* %slotptr, align 8
  %nonzero = icmp ne i64 %slotval, 0
  br i1 %nonzero, label %scan.loop.body, label %after_scan

scan.loop.body:
  br label %scan.loop

after_scan:
  %scan_ecx = trunc i64 %idx to i32
  br label %test_count

test_count:
  %ecx_val = phi i32 [ %ecx0, %entry ], [ %scan_ecx, %after_scan ]
  %iszero = icmp eq i32 %ecx_val, 0
  br i1 %iszero, label %atexit, label %loop_setup

loop_setup:
  %raxInit = zext i32 %ecx_val to i64
  %ecxDec = add i32 %ecx_val, -1
  %rbx.init = getelementptr inbounds i64, i64* %base, i64 %raxInit
  %ecxDec.z = zext i32 %ecxDec to i64
  %subdiff = sub i64 %raxInit, %ecxDec.z
  %rsi.tmp = getelementptr inbounds i64, i64* %base, i64 %subdiff
  %rsi = getelementptr inbounds i64, i64* %rsi.tmp, i64 -1
  br label %loop

loop:
  %rbx.phi = phi i64* [ %rbx.init, %loop_setup ], [ %rbx.next, %loop.body ]
  %fpi64 = load i64, i64* %rbx.phi, align 8
  %fp = inttoptr i64 %fpi64 to void ()*
  call void %fp()
  %rbx.next = getelementptr inbounds i64, i64* %rbx.phi, i64 -1
  %cmp.p = icmp ne i64* %rbx.next, %rsi
  br i1 %cmp.p, label %loop.body, label %atexit

loop.body:
  br label %loop

atexit:
  %res = tail call i32 @j__crt_atexit(void ()* @sub_140001450)
  ret i32 %res
}