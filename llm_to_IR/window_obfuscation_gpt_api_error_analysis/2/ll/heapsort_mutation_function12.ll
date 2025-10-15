target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@__tls_cb_start = external global void (i8*, i32, i8*)*
@__tls_cb_end = external global void (i8*, i32, i8*)*

declare void @sub_1400023D0()

define void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) #0 {
entry:
  %flag_ptr_ptr = load i32*, i32** @off_140004370, align 8
  %flag_val = load i32, i32* %flag_ptr_ptr, align 4
  %cmp_flag = icmp eq i32 %flag_val, 2
  br i1 %cmp_flag, label %check_reason, label %set_flag

set_flag:
  store i32 2, i32* %flag_ptr_ptr, align 4
  br label %check_reason

check_reason:
  %is_two = icmp eq i32 %Reason, 2
  br i1 %is_two, label %attach_branch, label %check_one

check_one:
  %is_one = icmp eq i32 %Reason, 1
  br i1 %is_one, label %call_sub, label %ret

attach_branch:
  %empty_range = icmp eq void (i8*, i32, i8*)** @__tls_cb_start, @__tls_cb_end
  br i1 %empty_range, label %ret, label %loop

loop:
  %cur_ptr = phi void (i8*, i32, i8*)** [ @__tls_cb_start, %attach_branch ], [ %next_ptr, %after_iter ]
  %fp = load void (i8*, i32, i8*)*, void (i8*, i32, i8*)** %cur_ptr, align 8
  %is_null_fp = icmp eq void (i8*, i32, i8*)* %fp, null
  br i1 %is_null_fp, label %after_iter, label %invoke

invoke:
  call void %fp(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  br label %after_iter

after_iter:
  %next_ptr = getelementptr inbounds void (i8*, i32, i8*)*, void (i8*, i32, i8*)** %cur_ptr, i64 1
  %cont = icmp ne void (i8*, i32, i8*)** %next_ptr, @__tls_cb_end
  br i1 %cont, label %loop, label %ret

call_sub:
  tail call void @sub_1400023D0()
  ret void

ret:
  ret void
}

attributes #0 = { nounwind "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="0" "target-cpu"="x86-64" }