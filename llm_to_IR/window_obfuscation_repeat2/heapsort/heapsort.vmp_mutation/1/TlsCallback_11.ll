; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140002370(i8*, i32, i8*)

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp3 = icmp eq i32 %Reason, 3
  br i1 %cmp3, label %do_call, label %check_zero

check_zero:
  %cmp0 = icmp eq i32 %Reason, 0
  br i1 %cmp0, label %do_call, label %ret

do_call:
  musttail call void @sub_140002370(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}