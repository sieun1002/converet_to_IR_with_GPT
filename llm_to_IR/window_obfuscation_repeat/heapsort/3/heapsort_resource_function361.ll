; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

define void @sub_1400028E0(i8* %base, i64 %size) local_unnamed_addr nounwind {
entry:
  br label %header

header:
  %base.ph = phi i8* [ %base, %entry ], [ %base.dec, %body ]
  %size.ph = phi i64 [ %size, %entry ], [ %size.next, %body ]
  %cmp = icmp ugt i64 %size.ph, 4096
  br i1 %cmp, label %body, label %final

body:
  %base.dec = getelementptr i8, i8* %base.ph, i64 -4096
  %p64 = bitcast i8* %base.dec to i64*
  %v = load volatile i64, i64* %p64, align 1
  store volatile i64 %v, i64* %p64, align 1
  %size.next = sub i64 %size.ph, 4096
  br label %header

final:
  %negsize = sub i64 0, %size.ph
  %rem.ptr = getelementptr i8, i8* %base.ph, i64 %negsize
  %p64f = bitcast i8* %rem.ptr to i64*
  %vf = load volatile i64, i64* %p64f, align 1
  store volatile i64 %vf, i64* %p64f, align 1
  ret void
}