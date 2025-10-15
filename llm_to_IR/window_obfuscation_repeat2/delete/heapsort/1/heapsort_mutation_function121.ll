; ModuleID: tls_callback_module
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*, align 8
@unk_140004BE0 = external global i8, align 1

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %p_ptr.addr = load i32*, i32** @off_140004370, align 8
  %curval = load i32, i32* %p_ptr.addr, align 4
  %is2 = icmp eq i32 %curval, 2
  br i1 %is2, label %after_init, label %do_set

do_set:
  store i32 2, i32* %p_ptr.addr, align 4
  br label %after_init

after_init:
  switch i32 %Reason, label %ret [
    i32 2, label %on_reason_2
    i32 1, label %on_reason_1
  ]

on_reason_2:
  %start = bitcast i8* @unk_140004BE0 to i8*
  %end = bitcast i8* @unk_140004BE0 to i8*
  %cmpstartend = icmp eq i8* %start, %end
  br i1 %cmpstartend, label %ret, label %loop_head

loop_head:
  %cur = phi i8* [ %start, %on_reason_2 ], [ %next, %loop_tail ]
  %ptr_to_fnptr = bitcast i8* %cur to void ()**
  %fn = load void ()*, void ()** %ptr_to_fnptr, align 8
  %isnull = icmp eq void ()* %fn, null
  br i1 %isnull, label %skipcall, label %docall

docall:
  call void %fn()
  br label %skipcall

skipcall:
  %next = getelementptr i8, i8* %cur, i64 8
  %cont = icmp ne i8* %next, %end
  br i1 %cont, label %loop_tail, label %ret

loop_tail:
  br label %loop_head

on_reason_1:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}