; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0()

define void @TlsCallback_2(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp3 = icmp eq i32 %Reason, 3
  br i1 %cmp3, label %call, label %checkzero

checkzero:
  %iszero = icmp eq i32 %Reason, 0
  br i1 %iszero, label %call, label %retblock

call:
  tail call void @sub_1400023D0()
  ret void

retblock:
  ret void
}