; ModuleID = 'heapsort'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_140001450(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_nle1 = icmp ule i64 %n, 1
  br i1 %cmp_nle1, label %ret, label %build.pre

build.pre:
  %half = lshr i64 %n, 1
  br label %build.check

build.check:
  %prev = phi i64 [ %half, %build.pre ], [ %i, %build.outer.cont ]
  %cond = icmp ne i64 %prev, 0
  br i1 %cond, label %build.body, label %heap.built

build.body:
  %i = add i64 %prev, -1
  br label %sift.loop

sift.loop:
  %k = phi i64 [ %i, %build.body ], [ %k.next, %sift.cont ]
  %k2 = shl i64 %k, 1
  %left = add i64 %k2, 1
  %hasLeft = icmp ult i64 %left, %n
  br i1 %hasLeft, label %sift.childcheck, label %build.outer.cont

sift.childcheck:
  %right = add i64 %left, 1
  %hasRight = icmp ult i64 %right, %n
  br i1 %hasRight, label %sift.compareChildren, label %sift.noRight

sift.compareChildren:
  %lptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %lval = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %rval = load i32, i32* %rptr, align 4
  %rightGreater = icmp sgt i32 %rval, %lval
  %biggerIndex = select i1 %rightGreater, i64 %right, i64 %left
  br label %sift.haveChild

sift.noRight:
  br label %sift.haveChild

sift.haveChild:
  %childIndex = phi i64 [ %biggerIndex, %sift.compareChildren ], [ %left, %sift.noRight ]
  %pptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %pval = load i32, i32* %pptr, align 4
  %cptr = getelementptr inbounds i32, i32* %arr, i64 %childIndex
  %cval = load i32, i32* %cptr, align 4
  %lessThan = icmp slt i32 %pval, %cval
  br i1 %lessThan, label %sift.swap, label %build.outer.cont

sift.swap:
  store i32 %cval, i32* %pptr, align 4
  store i32 %pval, i32* %cptr, align 4
  br label %sift.cont

sift.cont:
  %k.next = phi i64 [ %childIndex, %sift.swap ]
  br label %sift.loop

build.outer.cont:
  br label %build.check

heap.built:
  %end0 = add i64 %n, -1
  br label %sort.check

sort.check:
  %end = phi i64 [ %end0, %heap.built ], [ %end.next, %sort.afterInner ]
  %isZeroEndTop = icmp eq i64 %end, 0
  br i1 %isZeroEndTop, label %ret, label %sort.outer

sort.outer:
  %rootPtr = getelementptr inbounds i32, i32* %arr, i64 0
  %rootVal = load i32, i32* %rootPtr, align 4
  %endPtr = getelementptr inbounds i32, i32* %arr, i64 %end
  %endVal = load i32, i32* %endPtr, align 4
  store i32 %endVal, i32* %rootPtr, align 4
  store i32 %rootVal, i32* %endPtr, align 4
  br label %sift2.loop

sift2.loop:
  %k2phi = phi i64 [ 0, %sort.outer ], [ %k2.next2, %sift2.cont ]
  %k2shl = shl i64 %k2phi, 1
  %left2 = add i64 %k2shl, 1
  %hasLeft2 = icmp ult i64 %left2, %end
  br i1 %hasLeft2, label %sift2.childcheck, label %sort.afterInner

sift2.childcheck:
  %right2 = add i64 %left2, 1
  %hasRight2 = icmp ult i64 %right2, %end
  br i1 %hasRight2, label %sift2.compareChildren, label %sift2.noRight

sift2.compareChildren:
  %lptr2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %lval2 = load i32, i32* %lptr2, align 4
  %rptr2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %rval2 = load i32, i32* %rptr2, align 4
  %rightGreater2 = icmp sgt i32 %rval2, %lval2
  %biggerIndex2 = select i1 %rightGreater2, i64 %right2, i64 %left2
  br label %sift2.haveChild

sift2.noRight:
  br label %sift2.haveChild

sift2.haveChild:
  %childIndex2 = phi i64 [ %biggerIndex2, %sift2.compareChildren ], [ %left2, %sift2.noRight ]
  %pptr2 = getelementptr inbounds i32, i32* %arr, i64 %k2phi
  %pval2 = load i32, i32* %pptr2, align 4
  %cptr2 = getelementptr inbounds i32, i32* %arr, i64 %childIndex2
  %cval2 = load i32, i32* %cptr2, align 4
  %lessThan2 = icmp slt i32 %pval2, %cval2
  br i1 %lessThan2, label %sift2.swap, label %sort.afterInner

sift2.swap:
  store i32 %cval2, i32* %pptr2, align 4
  store i32 %pval2, i32* %cptr2, align 4
  br label %sift2.cont

sift2.cont:
  %k2.next2 = phi i64 [ %childIndex2, %sift2.swap ]
  br label %sift2.loop

sort.afterInner:
  %end.next = add i64 %end, -1
  br label %sort.check

ret:
  ret void
}