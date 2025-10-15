; ModuleID = 'linear_search_module'
source_filename = "linear_search.ll"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %count, i32 %value) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %cmp = icmp slt i32 %i, %count
  br i1 %cmp, label %body, label %notfound

body:
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %value
  br i1 %eq, label %found, label %cont

cont:
  %i.next = add nsw i32 %i, 1
  br label %loop

found:
  ret i32 %i

notfound:
  ret i32 -1
}