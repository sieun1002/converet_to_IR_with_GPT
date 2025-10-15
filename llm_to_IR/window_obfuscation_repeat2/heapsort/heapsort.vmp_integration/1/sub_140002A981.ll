; ModuleID = 'lifted'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_1400287CB()

define void @sub_140002A98(i8 %dl) {
entry:
  %p = call i8* @sub_1400287CB()
  %addr = getelementptr inbounds i8, i8* %p, i64 -1830268528
  %val = load i8, i8* %addr, align 1
  %tmp = sub i8 %val, %dl
  ret void
}