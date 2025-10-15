; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i64*

declare i32 @j__crt_atexit(void ()*)
declare void @sub_140001820()

define i32 @sub_140001870() {
entry:
  %rdx.ptr = load i64*, i64** @off_140004390, align 8
  %first64 = load i64, i64* %rdx.ptr, align 8
  %first32 = trunc i64 %first64 to i32
  %isneg1 = icmp eq i32 %first32, -1
  br i1 %isneg1, label %count_unknown, label %after_count

count_unknown:
  br label %loop

loop:
  %idx = phi i64 [ 0, %count_unknown ], [ %next, %loop_body ]
  %next = add i64 %idx, 1
  %eltptr = getelementptr inbounds i64, i64* %rdx.ptr, i64 %next
  %elt = load i64, i64* %eltptr, align 8
  %nz = icmp ne i64 %elt, 0
  br i1 %nz, label %loop_body, label %after_count_from_unknown

loop_body:
  br label %loop

after_count_from_unknown:
  %count32_from_unknown = trunc i64 %idx to i32
  br label %after_count

after_count:
  %count32_phi = phi i32 [ %first32, %entry ], [ %count32_from_unknown, %after_count_from_unknown ]
  %iszero = icmp eq i32 %count32_phi, 0
  br i1 %iszero, label %register, label %prepare_loop

prepare_loop:
  %count64 = sext i32 %count32_phi to i64
  br label %call_loop

call_loop:
  %i = phi i64 [ %count64, %prepare_loop ], [ %i.dec, %call_loop_body ]
  %fptr.addr = getelementptr inbounds i64, i64* %rdx.ptr, i64 %i
  %f64 = load i64, i64* %fptr.addr, align 8
  %fptr = inttoptr i64 %f64 to void ()*
  call void %fptr()
  %i.dec = add i64 %i, -1
  %cont = icmp ne i64 %i.dec, 0
  br i1 %cont, label %call_loop_body, label %register

call_loop_body:
  br label %call_loop

register:
  %ret = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %ret
}