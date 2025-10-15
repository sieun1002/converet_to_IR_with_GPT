; ModuleID = 'tls_callback.ll'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*, align 8
@unk_140004BE0 = external global i8*, align 8

declare void @sub_1400023D0(i8* nocapture readnone, i32, i8* nocapture readnone)

define dso_local void @TlsCallback_0(i8* %hModule, i32 %dwReason, i8* %reserved) local_unnamed_addr {
entry:
  %p_ptr = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %p_ptr, align 4
  %cmp.init = icmp eq i32 %val, 2
  br i1 %cmp.init, label %check_reason, label %set_two

set_two:
  store i32 2, i32* %p_ptr, align 4
  br label %check_reason

check_reason:
  %is_two = icmp eq i32 %dwReason, 2
  br i1 %is_two, label %on_two, label %check_one

check_one:
  %is_one = icmp eq i32 %dwReason, 1
  br i1 %is_one, label %tail, label %ret

ret:
  ret void

on_two:
  %rbx.ptr = getelementptr inbounds i8*, i8** @unk_140004BE0, i64 0
  %rsi.ptr = getelementptr inbounds i8*, i8** @unk_140004BE0, i64 0
  %eq.start.end = icmp eq i8** %rbx.ptr, %rsi.ptr
  br i1 %eq.start.end, label %ret, label %loop

loop:
  %it = phi i8** [ %rbx.ptr, %on_two ], [ %next, %loop_next ]
  %fp.raw = load i8*, i8** %it, align 8
  %isnull = icmp eq i8* %fp.raw, null
  br i1 %isnull, label %skip_call, label %do_call

do_call:
  %fp = bitcast i8* %fp.raw to void ()*
  call void %fp()
  br label %skip_call

skip_call:
  %next = getelementptr inbounds i8*, i8** %it, i64 1
  br label %loop_next

loop_next:
  %cont = icmp ne i8** %next, %rsi.ptr
  br i1 %cont, label %loop, label %ret2

ret2:
  ret void

tail:
  tail call void @sub_1400023D0(i8* %hModule, i32 %dwReason, i8* %reserved)
  ret void
}