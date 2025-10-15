; ModuleID = 'linear_search_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define dso_local i32 @linear_search(i32* %array, i32 %n, i32 %key) {
entry:
  br label %loop.cond

loop.cond:                                           ; preds = %entry, %loop.inc
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmpBound = icmp slt i32 %i, %n
  br i1 %cmpBound, label %loop.body, label %ret.notfound

loop.body:                                           ; preds = %loop.cond
  %idx64 = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %array, i64 %idx64
  %elem = load i32, i32* %elem.ptr, align 4
  %cmp = icmp eq i32 %elem, %key
  br i1 %cmp, label %ret.found, label %loop.inc

loop.inc:                                            ; preds = %loop.body
  %i.next = add i32 %i, 1
  br label %loop.cond

ret.found:                                           ; preds = %loop.body
  ret i32 %i

ret.notfound:                                        ; preds = %loop.cond
  ret i32 -1
}