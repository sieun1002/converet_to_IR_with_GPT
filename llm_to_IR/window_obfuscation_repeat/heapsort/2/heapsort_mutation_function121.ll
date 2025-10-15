; ModuleID = 'tls_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@guard = internal global i32 0, align 4
@off_140004370 = global i32* @guard, align 8
@unk_140004BE0 = internal global [0 x void (i8*, i32, i8*)*] zeroinitializer, align 8

declare void @sub_1400023D0(i8*, i32, i8*)

define dso_local void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) local_unnamed_addr #0 {
entry:
  %pGuardPtr = load i32*, i32** @off_140004370, align 8
  %guardVal = load i32, i32* %pGuardPtr, align 4
  %cmp2 = icmp eq i32 %guardVal, 2
  br i1 %cmp2, label %checkreason, label %set2

set2:
  store i32 2, i32* %pGuardPtr, align 4
  br label %checkreason

checkreason:
  switch i32 %Reason, label %ret [
    i32 2, label %call_tls_vec
    i32 1, label %call_sub
  ]

call_tls_vec:
  %begin = getelementptr inbounds [0 x void (i8*, i32, i8*)*], [0 x void (i8*, i32, i8*)*]* @unk_140004BE0, i64 0, i64 0
  %end = getelementptr inbounds [0 x void (i8*, i32, i8*)*], [0 x void (i8*, i32, i8*)*]* @unk_140004BE0, i64 0, i64 0
  br label %loop.cond

loop.cond:
  %p.cur = phi void (i8*, i32, i8*)** [ %begin, %call_tls_vec ], [ %p.next, %loop.inc ]
  %atend = icmp eq void (i8*, i32, i8*)** %p.cur, %end
  br i1 %atend, label %ret, label %loop.body

loop.body:
  %fnptr = load void (i8*, i32, i8*)*, void (i8*, i32, i8*)** %p.cur, align 8
  %isnull = icmp eq void (i8*, i32, i8*)* %fnptr, null
  br i1 %isnull, label %loop.inc, label %invoke

invoke:
  call void %fnptr(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  br label %loop.inc

loop.inc:
  %p.next = getelementptr inbounds void (i8*, i32, i8*)*, void (i8*, i32, i8*)** %p.cur, i64 1
  br label %loop.cond

call_sub:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}

attributes #0 = { nounwind }