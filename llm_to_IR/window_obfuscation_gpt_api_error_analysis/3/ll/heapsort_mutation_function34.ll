; ModuleID = 'stack_probe.ll'
target triple = "x86_64-pc-windows-msvc"

declare i8* @llvm.stacksave() nounwind

define void @sub_1400028E0(i64 %size) nounwind {
entry:
  %sp = call i8* @llvm.stacksave()
  %cmp0 = icmp ult i64 %size, 4096
  br i1 %cmp0, label %tail, label %prolog

prolog:
  br label %loop.header

loop.header:
  %ptr.h = phi i8* [ %sp, %prolog ], [ %ptr.next, %loop.header ]
  %rem.h = phi i64 [ %size, %prolog ], [ %rem.next, %loop.header ]
  %ptr.next = getelementptr i8, i8* %ptr.h, i64 -4096
  %old.byte = load i8, i8* %ptr.next, align 1, volatile
  %or.byte = or i8 %old.byte, 0
  store i8 %or.byte, i8* %ptr.next, align 1, volatile
  %rem.next = sub i64 %rem.h, 4096
  %cond1 = icmp ugt i64 %rem.next, 4096
  br i1 %cond1, label %loop.header, label %tail

tail:
  %ptr.tail = phi i8* [ %sp, %entry ], [ %ptr.next, %loop.header ]
  %rem.tail = phi i64 [ %size, %entry ], [ %rem.next, %loop.header ]
  %neg.rem = sub i64 0, %rem.tail
  %final.ptr = getelementptr i8, i8* %ptr.tail, i64 %neg.rem
  %old.byte.tail = load i8, i8* %final.ptr, align 1, volatile
  %or.byte.tail = or i8 %old.byte.tail, 0
  store i8 %or.byte.tail, i8* %final.ptr, align 1, volatile
  ret void
}