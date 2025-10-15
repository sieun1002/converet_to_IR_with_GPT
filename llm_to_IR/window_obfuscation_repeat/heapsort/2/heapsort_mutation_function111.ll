; ModuleID = 'module'
source_filename = "module.ll"
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0(i8* noundef, i32 noundef, i8* noundef)

define void @TlsCallback_1(i8* noundef %DllHandle, i32 noundef %Reason, i8* noundef %Reserved) {
entry:
  %is_three = icmp eq i32 %Reason, 3
  %is_zero = icmp eq i32 %Reason, 0
  %should_jump = or i1 %is_three, %is_zero
  br i1 %should_jump, label %call_sub, label %ret_block

call_sub:
  tail call void @sub_1400023D0(i8* noundef %DllHandle, i32 noundef %Reason, i8* noundef %Reserved)
  ret void

ret_block:
  ret void
}