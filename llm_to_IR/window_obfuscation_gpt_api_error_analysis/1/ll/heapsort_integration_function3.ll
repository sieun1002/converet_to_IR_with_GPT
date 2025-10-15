; ModuleID = 'tls_callback_module'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external dso_local global i32*, align 8
@unk_140004BE0 = external dso_local global i8*, align 8

declare dso_local void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)

define dso_local void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) local_unnamed_addr {
entry:
  %p_ptrptr.ptr = load i32*, i32** @off_140004370, align 8
  %old.val = load i32, i32* %p_ptrptr.ptr, align 4
  %cmp.eq2 = icmp eq i32 %old.val, 2
  br i1 %cmp.eq2, label %check_reason, label %store_two

store_two:
  store i32 2, i32* %p_ptrptr.ptr, align 4
  br label %check_reason

check_reason:
  %cmp.reason2 = icmp eq i32 %Reason, 2
  br i1 %cmp.reason2, label %reason2, label %check_reason1

check_reason1:
  %cmp.reason1 = icmp eq i32 %Reason, 1
  br i1 %cmp.reason1, label %reason1, label %ret

ret:
  ret void

reason2:
  %start.addr = getelementptr i8*, i8** @unk_140004BE0, i64 0
  %end.addr = getelementptr i8*, i8** @unk_140004BE0, i64 0
  %cmp.empty = icmp eq i8** %start.addr, %end.addr
  br i1 %cmp.empty, label %ret, label %loop

loop:
  %cur = phi i8** [ %start.addr, %reason2 ], [ %next, %advance ]
  %fnptr.raw = load i8*, i8** %cur, align 8
  %isnull.fn = icmp eq i8* %fnptr.raw, null
  br i1 %isnull.fn, label %advance, label %do_call

do_call:
  %fn.typed = bitcast i8* %fnptr.raw to void ()*
  call void %fn.typed()
  br label %advance

advance:
  %next = getelementptr i8*, i8** %cur, i64 1
  %done = icmp eq i8** %next, %end.addr
  br i1 %done, label %ret, label %loop

reason1:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void
}