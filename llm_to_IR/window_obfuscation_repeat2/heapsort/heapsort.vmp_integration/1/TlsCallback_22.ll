; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140002370(i8*, i32, i8*)

define void @TlsCallback_2(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp3 = icmp eq i32 %Reason, 3
  br i1 %cmp3, label %tail, label %checkzero

checkzero:
  %iszero = icmp eq i32 %Reason, 0
  br i1 %iszero, label %tail, label %ret

ret:
  ret void

tail:
  musttail call void @sub_140002370(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void
}