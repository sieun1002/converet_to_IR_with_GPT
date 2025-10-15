; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@lock = internal global i64 0, align 8

declare void @Sleep(i32)

define i32 @sub_140001010() {
entry:
  br label %try_acquire

try_acquire:
  %cmpx = cmpxchg i64* @lock, i64 0, i64 1 monotonic monotonic
  %succ = extractvalue { i64, i1 } %cmpx, 1
  br i1 %succ, label %locked, label %wait

wait:
  call void @Sleep(i32 1000)
  br label %try_acquire

locked:
  store i64 0, i64* @lock, align 8
  ret i32 0
}