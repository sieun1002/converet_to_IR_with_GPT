; target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*, align 8
@unk_140004BE0 = external global void ()*, align 8

declare cc 64 void @sub_1400023D0(i8*, i32, i8*)

define cc 64 void @TlsCallback_0(i8* %hModule, i32 %dwReason, i8* %pReserved) {
entry:
  %ptrptr = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %ptrptr, align 4
  %is_two = icmp eq i32 %val, 2
  br i1 %is_two, label %after_store, label %store_two

store_two:
  store i32 2, i32* %ptrptr, align 4
  br label %after_store

after_store:
  %cmp_reason2 = icmp eq i32 %dwReason, 2
  br i1 %cmp_reason2, label %do_reason2, label %check_reason1

check_reason1:
  %cmp_reason1 = icmp eq i32 %dwReason, 1
  br i1 %cmp_reason1, label %do_reason1, label %ret

ret:
  ret void

do_reason2:
  %begin_ptr = getelementptr void ()*, void ()** @unk_140004BE0, i64 0
  %end_ptr = getelementptr void ()*, void ()** @unk_140004BE0, i64 0
  %beg_eq_end = icmp eq void ()** %begin_ptr, %end_ptr
  br i1 %beg_eq_end, label %ret, label %loop

loop:
  %it = phi void ()** [ %begin_ptr, %do_reason2 ], [ %next_it, %loop_latch ]
  %fn = load void ()*, void ()** %it, align 8
  %is_null = icmp eq void ()* %fn, null
  br i1 %is_null, label %skip_call, label %do_call

do_call:
  call cc 64 void %fn()
  br label %after_call

skip_call:
  br label %after_call

after_call:
  %next_it = getelementptr void ()*, void ()** %it, i64 1
  br label %loop_latch

loop_latch:
  %done = icmp eq void ()** %next_it, %end_ptr
  br i1 %done, label %ret, label %loop

do_reason1:
  tail call cc 64 void @sub_1400023D0(i8* %hModule, i32 %dwReason, i8* %pReserved)
  ret void
}