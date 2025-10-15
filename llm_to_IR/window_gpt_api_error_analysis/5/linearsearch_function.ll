; ModuleID = 'linear_search'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %val) #0 {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %cmpbound = icmp slt i32 %i, %n
  br i1 %cmpbound, label %inloop, label %retneg

inloop:
  %idx.ext = sext i32 %i to i64
  %gep = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %val.i = load i32, i32* %gep, align 4
  %eq = icmp eq i32 %val.i, %val
  br i1 %eq, label %retidx, label %cont

cont:
  %i.next = add nsw i32 %i, 1
  br label %loop

retidx:
  ret i32 %i

retneg:
  ret i32 -1
}

attributes #0 = { nounwind uwtable }