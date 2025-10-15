; ModuleID = 'TlsCallback_1.ll'
source_filename = "TlsCallback_1.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare x86_64_win64cc void @sub_1400023D0(i8*, i32, i8*)

define x86_64_win64cc void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp3 = icmp eq i32 %Reason, 3
  br i1 %cmp3, label %tailcall, label %checkZero

checkZero:
  %isZero = icmp eq i32 %Reason, 0
  br i1 %isZero, label %tailcall, label %retblk

retblk:
  ret void

tailcall:
  tail call x86_64_win64cc void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void
}