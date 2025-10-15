target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = external global i32, align 4

declare void @sub_140001870()

define void @sub_1400018F0() {
entry:
  %val = load i32, i32* @dword_140007030, align 4
  %iszero = icmp eq i32 %val, 0
  br i1 %iszero, label %then, label %ret

then:
  store i32 1, i32* @dword_140007030, align 4
  tail call void @sub_140001870()
  ret void

ret:
  ret void
}