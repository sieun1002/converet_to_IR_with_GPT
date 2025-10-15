; target: Windows x64 PE (MSVC ABI)
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = external dso_local global i32, align 4

declare dso_local i32 @sub_140001870()

define dso_local i32 @sub_1400018F0() {
entry:
  %g = load i32, i32* @dword_140007030, align 4
  %iszero = icmp eq i32 %g, 0
  br i1 %iszero, label %init, label %retpath

retpath:
  ret i32 %g

init:
  store i32 1, i32* @dword_140007030, align 4
  %t = tail call i32 @sub_140001870()
  ret i32 %t
}