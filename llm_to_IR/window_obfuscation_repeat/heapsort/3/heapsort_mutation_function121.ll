; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@g_tls_state = internal global i32 0, align 4

declare void @sub_1400023D0()

define void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cur = load i32, i32* @g_tls_state, align 4
  %isne = icmp ne i32 %cur, 2
  br i1 %isne, label %setval, label %afterSet

setval:
  store i32 2, i32* @g_tls_state, align 4
  br label %afterSet

afterSet:
  switch i32 %Reason, label %ret [
    i32 2, label %process_attach
    i32 1, label %process_detach
  ]

process_attach:
  br label %ret

process_detach:
  tail call void @sub_1400023D0()
  br label %ret

ret:
  ret void
}