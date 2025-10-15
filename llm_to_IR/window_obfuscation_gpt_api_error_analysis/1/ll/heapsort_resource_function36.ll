target triple = "x86_64-pc-windows-msvc"

declare i8* @llvm.stacksave()

define void @sub_1400028E0(i64 %size) nounwind {
entry:
  %sp = call i8* @llvm.stacksave()
  %cmp = icmp ult i64 %size, 4096
  br i1 %cmp, label %tail, label %loop

loop:
  %p = phi i8* [ %sp, %entry ], [ %p.next, %loop ]
  %s = phi i64 [ %size, %entry ], [ %s.next, %loop ]
  %p.int = ptrtoint i8* %p to i64
  %p.sub = sub i64 %p.int, 4096
  %p.next = inttoptr i64 %p.sub to i8*
  %qptr = bitcast i8* %p.next to i64*
  %old = load i64, i64* %qptr, volatile
  store i64 %old, i64* %qptr, volatile
  %s.next = sub i64 %s, 4096
  %cond = icmp ugt i64 %s.next, 4096
  br i1 %cond, label %loop, label %tail

tail:
  %base = phi i8* [ %sp, %entry ], [ %p.next, %loop ]
  %rem = phi i64 [ %size, %entry ], [ %s.next, %loop ]
  %base.int = ptrtoint i8* %base to i64
  %addr.int = sub i64 %base.int, %rem
  %addr = inttoptr i64 %addr.int to i8*
  %qptr2 = bitcast i8* %addr to i64*
  %old2 = load i64, i64* %qptr2, volatile
  store i64 %old2, i64* %qptr2, volatile
  ret void
}