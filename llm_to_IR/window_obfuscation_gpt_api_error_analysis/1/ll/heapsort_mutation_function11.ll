; Target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

; Prototype assumed from TLS callback usage: void(PVOID, DWORD, PVOID)
declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp_is_3 = icmp eq i32 %Reason, 3
  br i1 %cmp_is_3, label %tailcall, label %check_zero

check_zero:
  %cmp_is_0 = icmp eq i32 %Reason, 0
  br i1 %cmp_is_0, label %tailcall, label %ret

tailcall:
  musttail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}