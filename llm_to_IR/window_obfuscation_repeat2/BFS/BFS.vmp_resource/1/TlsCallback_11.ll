; ModuleID = 'tls_module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400024B0(i8* noundef, i32 noundef, i8* noundef)

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp3 = icmp eq i32 %Reason, 3
  br i1 %cmp3, label %jmp, label %checkZero

checkZero:
  %isZero = icmp eq i32 %Reason, 0
  br i1 %isZero, label %jmp, label %retbb

jmp:
  musttail call void @sub_1400024B0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

retbb:
  ret void
}