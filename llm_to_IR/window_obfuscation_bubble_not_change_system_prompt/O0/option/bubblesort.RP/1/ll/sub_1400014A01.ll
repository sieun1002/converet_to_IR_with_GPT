; ModuleID = 'sub_1400014A0'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i64*

declare i32 @j__crt_atexit(void ()*)
declare void @sub_140001450()

define i32 @sub_1400014A0() {
entry:
  %baseptr = load i64*, i64** @off_1400043B0, align 8
  %first64 = load i64, i64* %baseptr, align 8
  %first32 = trunc i64 %first64 to i32
  %cmp_neg1 = icmp eq i32 %first32, -1
  br i1 %cmp_neg1, label %scan.loop, label %haveCount.pre

haveCount.pre:
  br label %haveCount

scan.loop:
  %r8_phi = phi i64 [ 1, %entry ], [ %rax_plus1, %scan.body ]
  %rax_phi = phi i64 [ 1, %entry ], [ %r8_phi, %scan.body ]
  %ecx_phi = phi i32 [ 0, %entry ], [ %ecx_trunc, %scan.body ]
  %gep_ptr = getelementptr inbounds i64, i64* %baseptr, i64 %r8_phi
  %val = load i64, i64* %gep_ptr, align 8
  %cond = icmp ne i64 %val, 0
  br i1 %cond, label %scan.body, label %scan.exit

scan.body:
  %rax_plus1 = add i64 %rax_phi, 1
  %ecx_trunc = trunc i64 %rax_phi to i32
  br label %scan.loop

scan.exit:
  br label %haveCount

haveCount:
  %ecx_final = phi i32 [ %first32, %haveCount.pre ], [ %ecx_phi, %scan.exit ]
  %isZero = icmp eq i32 %ecx_final, 0
  br i1 %isZero, label %done, label %setupLoop

setupLoop:
  %ecx_zext = zext i32 %ecx_final to i64
  %rbx_init = getelementptr inbounds i64, i64* %baseptr, i64 %ecx_zext
  br label %loop

loop:
  %curptr = phi i64* [ %rbx_init, %setupLoop ], [ %prevptr, %loop.cont ]
  %funcptr_slot = bitcast i64* %curptr to void ()**
  %funcptr = load void ()*, void ()** %funcptr_slot, align 8
  call void %funcptr()
  %prevptr = getelementptr inbounds i64, i64* %curptr, i64 -1
  %reached_base = icmp eq i64* %prevptr, %baseptr
  br i1 %reached_base, label %done, label %loop.cont

loop.cont:
  br label %loop

done:
  %ret_call = tail call i32 @j__crt_atexit(void ()* @sub_140001450)
  ret i32 %ret_call
}