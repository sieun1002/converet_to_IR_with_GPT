; ModuleID = 'stack_probe_module'
source_filename = "stack_probe_module"
target triple = "x86_64-pc-windows-msvc"

define void @sub_1400028E0(i8* %base, i64 %size) nounwind {
entry:
  %cmp = icmp ugt i64 %size, 4096
  br i1 %cmp, label %loop, label %final

loop:
  %base.phi = phi i8* [ %base, %entry ], [ %base.dec, %loop ]
  %size.phi = phi i64 [ %size, %entry ], [ %size.sub, %loop ]
  %base.dec = getelementptr i8, i8* %base.phi, i64 -4096
  %v = load volatile i8, i8* %base.dec, align 1
  store volatile i8 %v, i8* %base.dec, align 1
  %size.sub = sub i64 %size.phi, 4096
  %cmp.cont = icmp ugt i64 %size.sub, 4096
  br i1 %cmp.cont, label %loop, label %final

final:
  %final.base = phi i8* [ %base, %entry ], [ %base.dec, %loop ]
  %final.size = phi i64 [ %size, %entry ], [ %size.sub, %loop ]
  %neg = sub i64 0, %final.size
  %final.ptr = getelementptr i8, i8* %final.base, i64 %neg
  %v2 = load volatile i8, i8* %final.ptr, align 1
  store volatile i8 %v2, i8* %final.ptr, align 1
  ret void
}