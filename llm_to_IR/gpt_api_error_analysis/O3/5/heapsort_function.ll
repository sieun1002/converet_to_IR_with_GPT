target triple = "x86_64-pc-linux-gnu"

define dso_local void @heap_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %build.init

build.init:
  %half = lshr i64 %n, 1
  %half_is_zero = icmp eq i64 %half, 0
  br i1 %half_is_zero, label %after_build, label %build.loop.preheader

build.loop.preheader:
  %i.start = add i64 %half, -1
  br label %build.loop

build.loop:
  %i.phi = phi i64 [ %i.start, %build.loop.preheader ], [ %i.next, %build.inc ]
  br label %sift.entry

sift.entry:
  %k0 = phi i64 [ %i.phi, %build.loop ], [ %k.next, %sift.continue ]
  %ltemp = shl i64 %k0, 1
  %left = add i64 %ltemp, 1
  %left_cmp = icmp uge i64 %left, %n
  br i1 %left_cmp, label %build.inc, label %choose.child

choose.child:
  %right = add i64 %left, 1
  %rt_in = icmp ult i64 %right, %n
  br i1 %rt_in, label %right.exists, label %child.chosen

right.exists:
  %ptr_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %ptr_right, align 4
  %ptr_left = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %ptr_left, align 4
  %gt = icmp sgt i32 %val_right, %val_left
  %selected = select i1 %gt, i64 %right, i64 %left
  br label %child.chosen

child.chosen:
  %child_idx = phi i64 [ %left, %choose.child ], [ %selected, %right.exists ]
  %ptr_k = getelementptr inbounds i32, i32* %arr, i64 %k0
  %val_k = load i32, i32* %ptr_k, align 4
  %ptr_c = getelementptr inbounds i32, i32* %arr, i64 %child_idx
  %val_c = load i32, i32* %ptr_c, align 4
  %ge = icmp sge i32 %val_k, %val_c
  br i1 %ge, label %build.inc, label %do.swap

do.swap:
  store i32 %val_c, i32* %ptr_k, align 4
  store i32 %val_k, i32* %ptr_c, align 4
  %k.next = add i64 %child_idx, 0
  br label %sift.continue

sift.continue:
  br label %sift.entry

build.inc:
  %i.is.zero = icmp eq i64 %i.phi, 0
  %i.next = add i64 %i.phi, -1
  br i1 %i.is.zero, label %after_build, label %build.loop

after_build:
  %end.start = add i64 %n, -1
  br label %outer.cond

outer.cond:
  %end.phi = phi i64 [ %end.start, %after_build ], [ %end.next, %outer.decrement ]
  %end.ne0 = icmp ne i64 %end.phi, 0
  br i1 %end.ne0, label %outer.body, label %ret

outer.body:
  %ptr0 = getelementptr inbounds i32, i32* %arr, i64 0
  %val0 = load i32, i32* %ptr0, align 4
  %ptrE = getelementptr inbounds i32, i32* %arr, i64 %end.phi
  %valE = load i32, i32* %ptrE, align 4
  store i32 %valE, i32* %ptr0, align 4
  store i32 %val0, i32* %ptrE, align 4
  br label %sift2.entry

sift2.entry:
  %k2 = phi i64 [ 0, %outer.body ], [ %k2.next, %sift2.continue ]
  %l2temp = shl i64 %k2, 1
  %left2 = add i64 %l2temp, 1
  %left2_cmp = icmp uge i64 %left2, %end.phi
  br i1 %left2_cmp, label %outer.decrement, label %choose2.child

choose2.child:
  %right2 = add i64 %left2, 1
  %rt2_in = icmp ult i64 %right2, %end.phi
  br i1 %rt2_in, label %cmp2.right, label %child2.chosen

cmp2.right:
  %ptr2r = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val2r = load i32, i32* %ptr2r, align 4
  %ptr2l = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val2l = load i32, i32* %ptr2l, align 4
  %gt2 = icmp sgt i32 %val2r, %val2l
  %sel2 = select i1 %gt2, i64 %right2, i64 %left2
  br label %child2.chosen

child2.chosen:
  %child2 = phi i64 [ %left2, %choose2.child ], [ %sel2, %cmp2.right ]
  %ptr2k = getelementptr inbounds i32, i32* %arr, i64 %k2
  %v2k = load i32, i32* %ptr2k, align 4
  %ptr2c = getelementptr inbounds i32, i32* %arr, i64 %child2
  %v2c = load i32, i32* %ptr2c, align 4
  %ge2 = icmp sge i32 %v2k, %v2c
  br i1 %ge2, label %outer.decrement, label %swap2

swap2:
  store i32 %v2c, i32* %ptr2k, align 4
  store i32 %v2k, i32* %ptr2c, align 4
  %k2.next = add i64 %child2, 0
  br label %sift2.continue

sift2.continue:
  br label %sift2.entry

outer.decrement:
  %end.next = add i64 %end.phi, -1
  br label %outer.cond

ret:
  ret void
}