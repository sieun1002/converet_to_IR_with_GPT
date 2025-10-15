; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_2(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp = icmp eq i32 %Reason, 3
  br i1 %cmp, label %dispatch, label %checkzero

checkzero:
  %iszero = icmp eq i32 %Reason, 0
  br i1 %iszero, label %dispatch, label %ret

ret:
  ret void

dispatch:
  musttail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void
}