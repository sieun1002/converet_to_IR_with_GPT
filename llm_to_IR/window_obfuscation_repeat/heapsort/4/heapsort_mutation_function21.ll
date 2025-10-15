; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@lock_storage = global i64 0, align 8
@off_140004450 = global i64* @lock_storage, align 8

define i32 @sub_140001010() local_unnamed_addr {
entry:
  %p = load i64*, i64** @off_140004450, align 8
  br label %loop

loop:
  %cas = cmpxchg i64* %p, i64 0, i64 1 monotonic monotonic
  %ok = extractvalue { i64, i1 } %cas, 1
  br i1 %ok, label %locked, label %loop

locked:
  store atomic i64 0, i64* %p release, align 8
  ret i32 0
}