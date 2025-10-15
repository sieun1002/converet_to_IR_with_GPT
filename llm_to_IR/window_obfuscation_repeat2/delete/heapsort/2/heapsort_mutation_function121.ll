; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*, align 8
@unk_140004BE0 = external global i8*, align 8

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %pAddr = load i32*, i32** @off_140004370, align 8
  %val = load i32, i32* %pAddr, align 4
  %is2 = icmp eq i32 %val, 2
  br i1 %is2, label %check_reason, label %set_cookie

set_cookie:
  store i32 2, i32* %pAddr, align 4
  br label %check_reason

check_reason:
  %cmp_reason_2 = icmp eq i32 %Reason, 2
  br i1 %cmp_reason_2, label %reason2, label %check_reason_1

check_reason_1:
  %cmp_reason_1 = icmp eq i32 %Reason, 1
  br i1 %cmp_reason_1, label %reason1, label %exit

reason1:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

reason2:
  %begin_ptr = getelementptr i8*, i8** @unk_140004BE0, i64 0
  %end_ptr = getelementptr i8*, i8** @unk_140004BE0, i64 0
  %beg_eq_end = icmp eq i8** %begin_ptr, %end_ptr
  br i1 %beg_eq_end, label %exit, label %loop_preheader

loop_preheader:
  br label %loop_body

loop_body:
  %cur.ptr = phi i8** [ %begin_ptr, %loop_preheader ], [ %next.ptr, %loop_cont ]
  %fn.raw = load i8*, i8** %cur.ptr, align 8
  %fn.notnull = icmp ne i8* %fn.raw, null
  br i1 %fn.notnull, label %do_call, label %no_call

do_call:
  %fn.cb = bitcast i8* %fn.raw to void (i8*, i32, i8*)*
  call void %fn.cb(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  br label %loop_cont

no_call:
  br label %loop_cont

loop_cont:
  %next.ptr = getelementptr i8*, i8** %cur.ptr, i64 1
  %done = icmp eq i8** %next.ptr, %end_ptr
  br i1 %done, label %exit, label %loop_body

exit:
  ret void
}