; ModuleID = 'linear_search'
source_filename = "linear_search"
target triple = "x86_64-pc-linux-gnu"

define i32 @linear_search(i32* nocapture readonly %arr, i32 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %check, label %notfound

check:
  %idxext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idxext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %key
  br i1 %eq, label %found, label %inc

inc:
  %i.next = add nsw i32 %i, 1
  br label %loop

found:
  ret i32 %i

notfound:
  ret i32 -1
}