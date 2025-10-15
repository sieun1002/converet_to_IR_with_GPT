; ModuleID = 'tls_callback_module'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@unk_140004BE0 = external global [0 x void ()*]

declare void @sub_140002370(i8*, i32, i8*)

define void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %p_ptr = load i32*, i32** @off_140004370, align 8
  %old = load i32, i32* %p_ptr, align 4
  %is2 = icmp eq i32 %old, 2
  br i1 %is2, label %after_store, label %do_store

do_store:
  store i32 2, i32* %p_ptr, align 4
  br label %after_store

after_store:
  %cmp_detach = icmp eq i32 %Reason, 2
  br i1 %cmp_detach, label %detach, label %check_attach

check_attach:
  %cmp_attach = icmp eq i32 %Reason, 1
  br i1 %cmp_attach, label %attach, label %ret

ret:
  ret void

detach:
  %start = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %end = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %eq = icmp eq void ()** %start, %end
  br i1 %eq, label %ret2, label %loop

loop:
  %cur = phi void ()** [ %start, %detach ], [ %nextptr, %loop_end ]
  %fptr = load void ()*, void ()** %cur, align 8
  %isnull = icmp eq void ()* %fptr, null
  br i1 %isnull, label %skip_call, label %do_call

do_call:
  call void %fptr()
  br label %after_call

skip_call:
  br label %after_call

after_call:
  %nextptr = getelementptr inbounds void ()*, void ()** %cur, i64 1
  %cont = icmp ne void ()** %nextptr, %end
  br i1 %cont, label %loop_end, label %ret2

loop_end:
  br label %loop

ret2:
  ret void

attach:
  tail call void @sub_140002370(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void
}