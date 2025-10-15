; ModuleID = 'tls_module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_2(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp3 = icmp eq i32 %Reason, 3
  br i1 %cmp3, label %loc_140001930, label %check0

check0:
  %is0 = icmp eq i32 %Reason, 0
  br i1 %is0, label %loc_140001930, label %ret

loc_140001930:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}