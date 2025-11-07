target triple = "x86_64-unknown-linux-gnu"

define i32 @linear_search(i32* %arr, i32 %n, i32 %target) {
entry:
  %cmp = icmp sgt i32 %n, 0
  br i1 %cmp, label %loop.prep, label %ret.neg1

loop.prep:
  %n64 = sext i32 %n to i64
  br label %loop.header

loop.header:
  %i = phi i64 [ 0, %loop.prep ], [ %i.next, %loop.inc ]
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %target
  br i1 %eq, label %found, label %loop.inc

loop.inc:
  %i.next = add i64 %i, 1
  %done = icmp eq i64 %i.next, %n64
  br i1 %done, label %ret.neg1, label %loop.header

found:
  %retidx = trunc i64 %i to i32
  ret i32 %retidx

ret.neg1:
  ret i32 -1
}