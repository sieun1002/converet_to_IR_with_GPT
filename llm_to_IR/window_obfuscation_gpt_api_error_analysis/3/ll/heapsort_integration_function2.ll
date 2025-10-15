; External tail target
declare void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)

; Function: TlsCallback_2
define void @TlsCallback_2(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp_reason_3 = icmp eq i32 %Reason, 3
  br i1 %cmp_reason_3, label %call, label %check

check:
  %cmp_reason_0 = icmp eq i32 %Reason, 0
  br i1 %cmp_reason_0, label %call, label %ret

call:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}