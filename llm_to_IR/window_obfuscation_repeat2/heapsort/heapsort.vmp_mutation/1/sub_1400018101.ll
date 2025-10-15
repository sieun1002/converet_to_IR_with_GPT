; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_140004390 = external global i8, align 8

declare i32 @j__crt_atexit(void ()*)
declare void @sub_1400017C0()

define i32 @sub_140001810() {
entry:
  %base_as_i8ptrptr = bitcast i8* @off_140004390 to i8**
  %first_ptr = load i8*, i8** %base_as_i8ptrptr, align 8
  %first_int = ptrtoint i8* %first_ptr to i64
  %first32 = trunc i64 %first_int to i32
  %is_m1 = icmp eq i32 %first32, -1
  br i1 %is_m1, label %scan_init, label %check_nonzero

check_nonzero:                                    ; when first32 != -1
  %is_zero = icmp eq i32 %first32, 0
  br i1 %is_zero, label %after_loop, label %setup_loop_from_known

scan_init:
  br label %scan_loop

scan_loop:
  %i = phi i64 [ 1, %scan_init ], [ %i.next, %scan_iter ]
  %elem_ptrptr = getelementptr i8*, i8** %base_as_i8ptrptr, i64 %i
  %elem = load i8*, i8** %elem_ptrptr, align 8
  %is_nonzero = icmp ne i8* %elem, null
  br i1 %is_nonzero, label %scan_iter, label %scan_end

scan_iter:
  %i.next = add i64 %i, 1
  br label %scan_loop

scan_end:
  %i_minus1 = add i64 %i, -1
  %count32 = trunc i64 %i_minus1 to i32
  br label %setup_loop_from_scan

setup_loop_from_known:
  br label %setup_loop

setup_loop_from_scan:
  br label %setup_loop

setup_loop:
  %ecx = phi i32 [ %first32, %setup_loop_from_known ], [ %count32, %setup_loop_from_scan ]
  %ecx_is_zero = icmp eq i32 %ecx, 0
  br i1 %ecx_is_zero, label %after_loop, label %loop_prep

loop_prep:
  %ecx_zext = zext i32 %ecx to i64
  %rbx_init = getelementptr i8*, i8** %base_as_i8ptrptr, i64 %ecx_zext
  br label %loop_header

loop_header:
  %rbx_phi = phi i8** [ %rbx_init, %loop_prep ], [ %rbx_next, %loop_iter2 ]
  %callee_ptr = load i8*, i8** %rbx_phi, align 8
  %fn = bitcast i8* %callee_ptr to void ()*
  call void %fn()
  %rbx_next = getelementptr i8*, i8** %rbx_phi, i64 -1
  %done = icmp eq i8** %rbx_next, %base_as_i8ptrptr
  br i1 %done, label %after_loop, label %loop_iter2

loop_iter2:
  br label %loop_header

after_loop:
  %ret = call i32 @j__crt_atexit(void ()* @sub_1400017C0)
  ret i32 %ret
}