; ModuleID = 'heapsort_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define dso_local void @heap_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %build.prep

build.prep:
  %half = lshr i64 %n, 1
  %half_is_zero = icmp eq i64 %half, 0
  br i1 %half_is_zero, label %sort.init, label %build.loop.init

build.loop.init:
  %i0 = add i64 %half, -1
  br label %build.header

build.header:
  %next = phi i64 [ %i0, %build.loop.init ], [ %next.dec, %build.decrement ]
  br label %sift.header

sift.header:
  %i.cur = phi i64 [ %next, %build.header ], [ %i.next, %do.swap ]
  %child.mul = shl i64 %i.cur, 1
  %child = add i64 %child.mul, 1
  %child.inrange = icmp ult i64 %child, %n
  br i1 %child.inrange, label %choose_child, label %after.sift

choose_child:
  %child2 = add i64 %child, 1
  %child2.inrange = icmp ult i64 %child2, %n
  br i1 %child2.inrange, label %load.both, label %choose.use.child

load.both:
  %ptr.child2 = getelementptr inbounds i32, i32* %arr, i64 %child2
  %val.child2 = load i32, i32* %ptr.child2, align 4
  %ptr.child = getelementptr inbounds i32, i32* %arr, i64 %child
  %val.child = load i32, i32* %ptr.child, align 4
  %cmpKids = icmp sgt i32 %val.child2, %val.child
  br i1 %cmpKids, label %choose.use.child2, label %choose.use.child

choose.use.child2:
  br label %have.maxchild

choose.use.child:
  br label %have.maxchild

have.maxchild:
  %maxchild = phi i64 [ %child2, %choose.use.child2 ], [ %child, %choose.use.child ]
  %ptr.parent = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %val.parent = load i32, i32* %ptr.parent, align 4
  %ptr.maxchild = getelementptr inbounds i32, i32* %arr, i64 %maxchild
  %val.maxchild = load i32, i32* %ptr.maxchild, align 4
  %cmpParent = icmp slt i32 %val.parent, %val.maxchild
  br i1 %cmpParent, label %do.swap, label %after.sift

do.swap:
  %tmp.parent = add i32 %val.parent, 0
  store i32 %val.maxchild, i32* %ptr.parent, align 4
  store i32 %tmp.parent, i32* %ptr.maxchild, align 4
  %i.next = add i64 %maxchild, 0
  br label %sift.header

after.sift:
  %is_zero = icmp eq i64 %next, 0
  br i1 %is_zero, label %sort.init, label %build.decrement

build.decrement:
  %next.dec = add i64 %next, -1
  br label %build.header

sort.init:
  %end.init = add i64 %n, -1
  br label %sort.cond

sort.cond:
  %end.cur = phi i64 [ %end.init, %sort.init ], [ %end.dec, %sort.after.body ]
  %end.nonzero = icmp ne i64 %end.cur, 0
  br i1 %end.nonzero, label %sort.body, label %ret

sort.body:
  %ptr0 = getelementptr inbounds i32, i32* %arr, i64 0
  %val0 = load i32, i32* %ptr0, align 4
  %ptrEnd = getelementptr inbounds i32, i32* %arr, i64 %end.cur
  %valEnd = load i32, i32* %ptrEnd, align 4
  store i32 %valEnd, i32* %ptr0, align 4
  store i32 %val0, i32* %ptrEnd, align 4
  br label %sift2.header

sift2.header:
  %i2 = phi i64 [ 0, %sort.body ], [ %i2.next, %do.swap2 ]
  %child2.mul = shl i64 %i2, 1
  %childA = add i64 %child2.mul, 1
  %childA.inrange = icmp ult i64 %childA, %end.cur
  br i1 %childA.inrange, label %choose_child2, label %sort.after.body

choose_child2:
  %childB = add i64 %childA, 1
  %childB.inrange = icmp ult i64 %childB, %end.cur
  br i1 %childB.inrange, label %load.both2, label %choose.use.child2.2

load.both2:
  %ptr.childB = getelementptr inbounds i32, i32* %arr, i64 %childB
  %val.childB = load i32, i32* %ptr.childB, align 4
  %ptr.childA = getelementptr inbounds i32, i32* %arr, i64 %childA
  %val.childA = load i32, i32* %ptr.childA, align 4
  %cmpKids2 = icmp sgt i32 %val.childB, %val.childA
  br i1 %cmpKids2, label %choose.use.childB.2, label %choose.use.child2.2

choose.use.childB.2:
  br label %have.maxchild2

choose.use.child2.2:
  br label %have.maxchild2

have.maxchild2:
  %maxchild2 = phi i64 [ %childB, %choose.use.childB.2 ], [ %childA, %choose.use.child2.2 ]
  %ptr.parent2 = getelementptr inbounds i32, i32* %arr, i64 %i2
  %val.parent2 = load i32, i32* %ptr.parent2, align 4
  %ptr.maxchild2 = getelementptr inbounds i32, i32* %arr, i64 %maxchild2
  %val.maxchild2 = load i32, i32* %ptr.maxchild2, align 4
  %cmpParent2 = icmp slt i32 %val.parent2, %val.maxchild2
  br i1 %cmpParent2, label %do.swap2, label %sort.after.body

do.swap2:
  %tmp.parent2 = add i32 %val.parent2, 0
  store i32 %val.maxchild2, i32* %ptr.parent2, align 4
  store i32 %tmp.parent2, i32* %ptr.maxchild2, align 4
  %i2.next = add i64 %maxchild2, 0
  br label %sift2.header

sort.after.body:
  %end.dec = add i64 %end.cur, -1
  br label %sort.cond

ret:
  ret void
}