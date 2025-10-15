; ModuleID = 'tls_callback.ll'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*, align 8
@unk_140004BE0 = external global i8*, align 8

declare void @sub_1400023D0(i8* noundef, i32 noundef, i8* noundef)

define dso_local void @TlsCallback_1(i8* noundef %DllHandle, i32 noundef %Reason, i8* noundef %Reserved) {
entry:
  %gptr.p = load i32*, i32** @off_140004370, align 8
  %gval = load i32, i32* %gptr.p, align 4
  %is2.pre = icmp eq i32 %gval, 2
  br i1 %is2.pre, label %after_store, label %do_store

do_store:
  store i32 2, i32* %gptr.p, align 4
  br label %after_store

after_store:
  %cmp_reason_2 = icmp eq i32 %Reason, 2
  br i1 %cmp_reason_2, label %on_thread_attach, label %check_reason_1

check_reason_1:
  %cmp_reason_1 = icmp eq i32 %Reason, 1
  br i1 %cmp_reason_1, label %call_chain, label %ret

on_thread_attach:
  %start.ptr = getelementptr i8*, i8** @unk_140004BE0, i64 0
  %end.ptr = getelementptr i8*, i8** @unk_140004BE0, i64 0
  %empty = icmp eq i8** %start.ptr, %end.ptr
  br i1 %empty, label %ret, label %loop

loop:
  %it = phi i8** [ %start.ptr, %on_thread_attach ], [ %next, %after_iter ]
  %entry = load i8*, i8** %it, align 8
  %isnull = icmp eq i8* %entry, null
  br i1 %isnull, label %after_iter, label %do_call

do_call:
  %callee = bitcast i8* %entry to void ()*
  call void %callee()
  br label %after_iter

after_iter:
  %next = getelementptr i8*, i8** %it, i64 1
  %done = icmp eq i8** %next, %end.ptr
  br i1 %done, label %ret, label %loop

call_chain:
  tail call void @sub_1400023D0(i8* noundef %DllHandle, i32 noundef %Reason, i8* noundef %Reserved)
  ret void

ret:
  ret void
}