; ModuleID = 'tls_callback_module'
source_filename = "tls_callback_module.ll"
target triple = "x86_64-pc-windows-msvc"

declare dso_local void @sub_1400023D0(i8*, i32, i8*)

define dso_local void @TlsCallback_2(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %is_three = icmp eq i32 %Reason, 3
  %is_zero = icmp eq i32 %Reason, 0
  %cond = or i1 %is_three, %is_zero
  br i1 %cond, label %call_target, label %ret_block

call_target:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret_block:
  ret void
}