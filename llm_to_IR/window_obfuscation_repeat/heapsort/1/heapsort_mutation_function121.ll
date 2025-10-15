; ModuleID = 'tls_callback_module'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@unk_140004BE0 = external global i8*

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %offptr.addr = load i32*, i32** @off_140004370
  %oldval = load i32, i32* %offptr.addr
  %is2 = icmp eq i32 %oldval, 2
  br i1 %is2, label %check_reason, label %store_two

store_two:
  store i32 2, i32* %offptr.addr
  br label %check_reason

check_reason:
  switch i32 %Reason, label %ret [
    i32 2, label %attach
    i32 1, label %detach
  ]

ret:
  ret void

attach:
  %startptr.raw = bitcast i8** @unk_140004BE0 to i8*
  %endptr.raw = bitcast i8** @unk_140004BE0 to i8*
  %same = icmp eq i8* %startptr.raw, %endptr.raw
  br i1 %same, label %ret, label %loop

loop:
  %rbx.cur = phi i8* [ %startptr.raw, %attach ], [ %rbx.next, %loop_tail ]
  %slot = bitcast i8* %rbx.cur to i8**
  %funcptr.i8 = load i8*, i8** %slot
  %isnull = icmp eq i8* %funcptr.i8, null
  br i1 %isnull, label %loop_tail, label %do_call

do_call:
  %func = bitcast i8* %funcptr.i8 to void ()*
  call void %func()
  br label %loop_tail

loop_tail:
  %rbx.next = getelementptr i8, i8* %rbx.cur, i64 8
  %done = icmp eq i8* %rbx.next, %endptr.raw
  br i1 %done, label %ret, label %loop

detach:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void
}