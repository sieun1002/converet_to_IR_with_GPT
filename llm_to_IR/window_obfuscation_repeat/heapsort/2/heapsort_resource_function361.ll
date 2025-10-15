; ModuleID = 'stack_probe_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @llvm.stacksave() nounwind

define void @sub_1400028E0(i64 %size) nounwind {
entry:
  %sp = call i8* @llvm.stacksave()
  %gt = icmp ugt i64 %size, 4096
  br i1 %gt, label %loop, label %after

loop:
  %p.loop = phi i8* [ %sp, %entry ], [ %p.next, %loop ]
  %s.loop = phi i64 [ %size, %entry ], [ %s.dec, %loop ]
  %p.next = getelementptr i8, i8* %p.loop, i64 -4096
  %touch1 = load volatile i8, i8* %p.next, align 1
  %s.dec = sub i64 %s.loop, 4096
  %gt2 = icmp ugt i64 %s.dec, 4096
  br i1 %gt2, label %loop, label %after

after:
  %p.cur = phi i8* [ %sp, %entry ], [ %p.next, %loop ]
  %rem = phi i64 [ %size, %entry ], [ %s.dec, %loop ]
  %neg = sub i64 0, %rem
  %p.touch = getelementptr i8, i8* %p.cur, i64 %neg
  %touch2 = load volatile i8, i8* %p.touch, align 1
  ret void
}