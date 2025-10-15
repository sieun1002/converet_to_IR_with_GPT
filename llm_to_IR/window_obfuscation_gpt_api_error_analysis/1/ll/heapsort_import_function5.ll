; ModuleID = 'tls_callback.ll'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@unk_140004BE0 = external global i8*

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) local_unnamed_addr {
entry:
  %p.addr = load i32*, i32** @off_140004370, align 8
  %p.val = load i32, i32* %p.addr, align 4
  %cmp.init = icmp eq i32 %p.val, 2
  br i1 %cmp.init, label %after_init, label %set_init

set_init:
  store i32 2, i32* %p.addr, align 4
  br label %after_init

after_init:
  %is_thread_attach = icmp eq i32 %Reason, 2
  br i1 %is_thread_attach, label %thread_attach, label %check_process_attach

check_process_attach:
  %is_process_attach = icmp eq i32 %Reason, 1
  br i1 %is_process_attach, label %process_attach, label %ret

thread_attach:
  %beginptr = getelementptr i8*, i8** @unk_140004BE0, i64 0
  %endptr = getelementptr i8*, i8** @unk_140004BE0, i64 0
  %cmp_be = icmp eq i8** %beginptr, %endptr
  br i1 %cmp_be, label %ret, label %loop

loop:
  %curptr = phi i8** [ %beginptr, %thread_attach ], [ %nextptr, %after_call ]
  %cur = load i8*, i8** %curptr, align 8
  %isnull = icmp eq i8* %cur, null
  br i1 %isnull, label %after_call, label %do_call

do_call:
  %fp = bitcast i8* %cur to void ()*
  call void %fp()
  br label %after_call

after_call:
  %nextptr = getelementptr i8*, i8** %curptr, i64 1
  %cont = icmp ne i8** %nextptr, %endptr
  br i1 %cont, label %loop, label %ret

process_attach:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}