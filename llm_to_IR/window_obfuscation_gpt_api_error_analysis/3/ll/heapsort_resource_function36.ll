; target: Windows x86-64 MSVC
target triple = "x86_64-pc-windows-msvc"

; Semantics: probe stack pages from base downward by size bytes,
; touching each 0x1000 boundary and the final remainder.
define void @sub_1400028E0(i64 %size, i8* %base) nounwind {
entry:
  %cmp.initial = icmp ult i64 %size, 4096
  br i1 %cmp.initial, label %tail.entry, label %loop

loop:
  %p.cur = phi i8* [ %base, %entry ], [ %p.next, %loop ]
  %sz.cur = phi i64 [ %size, %entry ], [ %sz.next, %loop ]
  %p.next = getelementptr i8, i8* %p.cur, i64 -4096
  %q1 = bitcast i8* %p.next to i64*
  %v1 = load volatile i64, i64* %q1, align 1
  store volatile i64 %v1, i64* %q1, align 1
  %sz.next = sub i64 %sz.cur, 4096
  %cont = icmp ugt i64 %sz.next, 4096
  br i1 %cont, label %loop, label %tail.fromloop

tail.entry:
  br label %tail

tail.fromloop:
  br label %tail

tail:
  %p.base = phi i8* [ %base, %tail.entry ], [ %p.next, %tail.fromloop ]
  %sz.rem = phi i64 [ %size, %tail.entry ], [ %sz.next, %tail.fromloop ]
  %neg.rem = sub i64 0, %sz.rem
  %p.final = getelementptr i8, i8* %p.base, i64 %neg.rem
  %q2 = bitcast i8* %p.final to i64*
  %v2 = load volatile i64, i64* %q2, align 1
  store volatile i64 %v2, i64* %q2, align 1
  ret void
}