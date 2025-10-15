; ModuleID = 'linear_search'
source_filename = "linear_search.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define i32 @linear_search(i32* %arr, i32 %n, i32 %value) local_unnamed_addr {
entry:
  %cmp.n.pos = icmp sgt i32 %n, 0
  br i1 %cmp.n.pos, label %preloop, label %notfound

preloop:
  %n.ext = sext i32 %n to i64
  br label %loop

loop:
  %i = phi i64 [ 0, %preloop ], [ %i.next, %inc ]
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %value
  br i1 %eq, label %found, label %inc

inc:
  %i.next = add i64 %i, 1
  %done = icmp eq i64 %i.next, %n.ext
  br i1 %done, label %notfound, label %loop

found:
  %retidx = trunc i64 %i to i32
  ret i32 %retidx

notfound:
  ret i32 -1
}