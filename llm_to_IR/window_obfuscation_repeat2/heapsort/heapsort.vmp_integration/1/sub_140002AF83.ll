; ModuleID = 'module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i64 @loc_1400EE995()
declare void @sub_1400F7E6E(i64)

define void @sub_140002AF8() {
entry:
  %r = call i64 @loc_1400EE995()
  call void @sub_1400F7E6E(i64 %r)
  ret void
}