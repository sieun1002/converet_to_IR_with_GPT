; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400024B0(i8*, i32, i8*)

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp = icmp eq i32 %Reason, 3
  br i1 %cmp, label %call, label %checkzero

checkzero:                                        ; preds = %entry
  %iszero = icmp eq i32 %Reason, 0
  br i1 %iszero, label %call, label %ret

call:                                             ; preds = %entry, %checkzero
  tail call void @sub_1400024B0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:                                              ; preds = %checkzero
  ret void
}