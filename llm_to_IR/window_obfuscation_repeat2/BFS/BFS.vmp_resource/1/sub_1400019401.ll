; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i8*

declare i32 @j__crt_atexit(void ()*)
declare void @sub_1400018F0()

define i32 @sub_140001940() {
entry:
  %baseptr = load i8*, i8** @off_1400043B0, align 8
  %count64ptr = bitcast i8* %baseptr to i64*
  %count64 = load i64, i64* %count64ptr, align 8
  %ecx_init = trunc i64 %count64 to i32
  %isneg1 = icmp eq i32 %ecx_init, -1
  br i1 %isneg1, label %scan.init, label %test

scan.init:
  br label %scan

scan:
  %rax_phi = phi i64 [ 0, %scan.init ], [ %r8, %scan ]
  %r8 = add i64 %rax_phi, 1
  %offset_bytes = mul i64 %r8, 8
  %addr_next = getelementptr i8, i8* %baseptr, i64 %offset_bytes
  %pp = bitcast i8* %addr_next to i8**
  %p = load i8*, i8** %pp, align 8
  %cond_nonzero = icmp ne i8* %p, null
  br i1 %cond_nonzero, label %scan, label %to_test_from_scan

to_test_from_scan:
  %ecx_from_scan = trunc i64 %rax_phi to i32
  br label %test

test:
  %ecx_phi = phi i32 [ %ecx_init, %entry ], [ %ecx_from_scan, %to_test_from_scan ]
  %iszero = icmp eq i32 %ecx_phi, 0
  br i1 %iszero, label %register, label %loop_setup

loop_setup:
  %eax_zext = zext i32 %ecx_phi to i64
  %ecx_minus1 = add nsw i32 %ecx_phi, -1
  %idx_bytes2 = mul i64 %eax_zext, 8
  %rbx_init = getelementptr i8, i8* %baseptr, i64 %idx_bytes2
  %ecx_minus1_zext = zext i32 %ecx_minus1 to i64
  %rax_minus_rcx = sub i64 %eax_zext, %ecx_minus1_zext
  %tmp_bytes = mul i64 %rax_minus_rcx, 8
  %rsi_pre = getelementptr i8, i8* %baseptr, i64 %tmp_bytes
  %rsi = getelementptr i8, i8* %rsi_pre, i64 -8
  br label %loop

loop:
  %rbx_phi = phi i8* [ %rbx_init, %loop_setup ], [ %rbx_next, %loop ]
  %funcptrptr = bitcast i8* %rbx_phi to void ()**
  %func_to_call = load void ()*, void ()** %funcptrptr, align 8
  call void %func_to_call()
  %rbx_next = getelementptr i8, i8* %rbx_phi, i64 -8
  %cmp = icmp ne i8* %rbx_next, %rsi
  br i1 %cmp, label %loop, label %register

register:
  %ret = call i32 @j__crt_atexit(void ()* @sub_1400018F0)
  ret i32 %ret
}