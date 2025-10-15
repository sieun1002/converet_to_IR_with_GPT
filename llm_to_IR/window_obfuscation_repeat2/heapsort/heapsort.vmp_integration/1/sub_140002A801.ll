; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_14002ECD9()

define void @sub_140002A80() {
entry:
  call void @sub_14002ECD9()
  ret void
}