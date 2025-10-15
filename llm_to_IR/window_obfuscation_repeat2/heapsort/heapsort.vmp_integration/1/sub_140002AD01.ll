; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_14000D4E4()

define void @sub_140002AD0(i32 %edx) {
entry:
  %call = call i64 @sub_14000D4E4()
  %addr_int = add i64 %call, 1488199312
  %addr_ptr = inttoptr i64 %addr_int to i32*
  %old = load i32, i32* %addr_ptr, align 1
  %xor = xor i32 %old, %edx
  store i32 %xor, i32* %addr_ptr, align 1
  ret void
}