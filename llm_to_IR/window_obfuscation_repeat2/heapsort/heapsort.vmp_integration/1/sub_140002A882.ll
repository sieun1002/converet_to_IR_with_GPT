; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare i32 @loc_140028911(...)

define i32 @sub_140002A88() {
entry:
  %call = call i32 (...) @loc_140028911()
  %ptr = inttoptr i64 350614962999440 to i32*
  %val = load i32, i32* %ptr, align 4
  ret i32 %val
}