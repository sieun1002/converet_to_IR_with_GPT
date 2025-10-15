; ModuleID = 'tls_callback'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_140004370 = external global i32*, align 8
@unk_140004BE0 = external global i8, align 1

declare void @sub_1400023D0()

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %p.addr = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %p.addr, align 4
  %cmp2 = icmp eq i32 %val, 2
  br i1 %cmp2, label %after_set, label %set_two

set_two:
  store i32 2, i32* %p.addr, align 4
  br label %after_set

after_set:
  %is_thread_attach = icmp eq i32 %Reason, 2
  br i1 %is_thread_attach, label %thread_attach, label %check_process

check_process:
  %is_process_attach = icmp eq i32 %Reason, 1
  br i1 %is_process_attach, label %process_attach, label %ret

process_attach:
  call void @sub_1400023D0()
  ret void

thread_attach:
  %begin = getelementptr inbounds i8, i8* @unk_140004BE0, i64 0
  %end = getelementptr inbounds i8, i8* @unk_140004BE0, i64 0
  %empty = icmp eq i8* %begin, %end
  br i1 %empty, label %ret, label %loop

loop:
  %cur = phi i8* [ %begin, %thread_attach ], [ %next, %cont ]
  %pp = bitcast i8* %cur to void ()**
  %fp = load void ()*, void ()** %pp, align 8
  %isnull = icmp eq void ()* %fp, null
  br i1 %isnull, label %cont, label %do_call

do_call:
  call void %fp()
  br label %cont

cont:
  %next = getelementptr inbounds i8, i8* %cur, i64 8
  %done = icmp eq i8* %next, %end
  br i1 %done, label %ret, label %loop

ret:
  ret void
}