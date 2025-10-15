; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

define void @sub_140002880(i64 %size) {
entry:
  %is_zero = icmp eq i64 %size, 0
  br i1 %is_zero, label %ret, label %alloc

alloc:
  %buf = alloca i8, i64 %size, align 16
  %lt4096 = icmp ult i64 %size, 4096
  br i1 %lt4096, label %small, label %loop.prep

loop.prep:
  %upper = sub i64 %size, 4096
  br label %loop

loop:
  %idx = phi i64 [ 0, %loop.prep ], [ %idx.next, %loop ]
  %ptr = getelementptr inbounds i8, i8* %buf, i64 %idx
  %ld = load volatile i8, i8* %ptr, align 1
  store volatile i8 %ld, i8* %ptr, align 1
  %idx.next = add i64 %idx, 4096
  %continue = icmp ule i64 %idx.next, %upper
  br i1 %continue, label %loop, label %final

small:
  %ptrs = getelementptr inbounds i8, i8* %buf, i64 0
  %lds = load volatile i8, i8* %ptrs, align 1
  store volatile i8 %lds, i8* %ptrs, align 1
  br label %ret

final:
  %lastoff = sub i64 %size, 1
  %ptrlast = getelementptr inbounds i8, i8* %buf, i64 %lastoff
  %ldl = load volatile i8, i8* %ptrlast, align 1
  store volatile i8 %ldl, i8* %ptrlast, align 1
  br label %ret

ret:
  ret void
}