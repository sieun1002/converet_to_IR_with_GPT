; ModuleID = 'module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare x86_64_win64cc i64 @loc_1400EE995()
declare x86_64_win64cc void @sub_1400F7E6E(...)

define x86_64_win64cc void @sub_140002AF8() {
entry:
  %r = call x86_64_win64cc i64 @loc_1400EE995()
  call x86_64_win64cc void @sub_1400F7E6E(i64 %r)
  ret void
}