; ModuleID = 'heap_sort_module'
source_filename = "heap_sort.ll"

define dso_local void @heap_sort(i32* nocapture %arr, i64 %n) nounwind {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build.init

build.init:                                        ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build.cond

build.cond:                                        ; preds = %build.after_sift, %build.init
  %i = phi i64 [ %half, %build.init ], [ %i.next, %build.after_sift ]
  %i.notzero = icmp ne i64 %i, 0
  br i1 %i.notzero, label %build.body, label %extract.init

build.body:                                        ; preds = %build.cond
  %i.dec = add i64 %i, -1
  br label %sift1.loop

sift1.loop:                                        ; preds = %sift1.swap, %build.body
  %j = phi i64 [ %i.dec, %build.body ], [ %j.next, %sift1.swap ]
  %j2 = shl i64 %j, 1
  %left = add i64 %j2, 1
  %left.cmp = icmp uge i64 %left, %n
  br i1 %left.cmp, label %build.after_sift, label %sift1.haveLeft

sift1.haveLeft:                                    ; preds = %sift1.loop
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  %right = add i64 %left, 1
  %right.inrange = icmp ult i64 %right, %n
  br i1 %right.inrange, label %compare.children1, label %k.isLeft1

compare.children1:                                 ; preds = %sift1.haveLeft
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %cmpRgtGtLft = icmp sgt i32 %right.val, %left.val
  br i1 %cmpRgtGtLft, label %k.isRight1, label %k.isLeft1

k.isRight1:                                        ; preds = %compare.children1
  br label %k.merge1

k.isLeft1:                                         ; preds = %compare.children1, %sift1.haveLeft
  br label %k.merge1

k.merge1:                                          ; preds = %k.isLeft1, %k.isRight1
  %k = phi i64 [ %right, %k.isRight1 ], [ %left, %k.isLeft1 ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j.val = load i32, i32* %j.ptr, align 4
  %k.ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k.val = load i32, i32* %k.ptr, align 4
  %cmp_j_ge_k = icmp sge i32 %j.val, %k.val
  br i1 %cmp_j_ge_k, label %build.after_sift, label %sift1.swap

sift1.swap:                                        ; preds = %k.merge1
  store i32 %k.val, i32* %j.ptr, align 4
  store i32 %j.val, i32* %k.ptr, align 4
  %j.next = %k
  br label %sift1.loop

build.after_sift:                                  ; preds = %k.merge1, %sift1.loop
  %i.next = phi i64 [ %i.dec, %sift1.loop ], [ %i.dec, %k.merge1 ]
  br label %build.cond

extract.init:                                      ; preds = %build.cond
  %i2.init = add i64 %n, -1
  br label %extract.cond

extract.cond:                                      ; preds = %extract.after_sift, %extract.init
  %i2 = phi i64 [ %i2.init, %extract.init ], [ %i2.next, %extract.after_sift ]
  %cond2 = icmp ne i64 %i2, 0
  br i1 %cond2, label %extract.body, label %ret

extract.body:                                      ; preds = %extract.cond
  %p0 = getelementptr inbounds i32, i32* %arr, i64 0
  %v0 = load i32, i32* %p0, align 4
  %pi = getelementptr inbounds i32, i32* %arr, i64 %i2
  %vi = load i32, i32* %pi, align 4
  store i32 %vi, i32* %p0, align 4
  store i32 %v0, i32* %pi, align 4
  br label %sift2.loop

sift2.loop:                                        ; preds = %sift2.swap, %extract.body
  %j2 = phi i64 [ 0, %extract.body ], [ %j2.next, %sift2.swap ]
  %j2d = shl i64 %j2, 1
  %left2 = add i64 %j2d, 1
  %left2.cmp = icmp uge i64 %left2, %i2
  br i1 %left2.cmp, label %extract.after_sift, label %sift2.haveLeft

sift2.haveLeft:                                    ; preds = %sift2.loop
  %left2.ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2.val = load i32, i32* %left2.ptr, align 4
  %right2 = add i64 %left2, 1
  %right2.inrange = icmp ult i64 %right2, %i2
  br i1 %right2.inrange, label %compare.children2, label %k.isLeft2

compare.children2:                                 ; preds = %sift2.haveLeft
  %right2.ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2.val = load i32, i32* %right2.ptr, align 4
  %cmpRgtGtLft2 = icmp sgt i32 %right2.val, %left2.val
  br i1 %cmpRgtGtLft2, label %k.isRight2, label %k.isLeft2

k.isRight2:                                        ; preds = %compare.children2
  br label %k.merge2

k.isLeft2:                                         ; preds = %compare.children2, %sift2.haveLeft
  br label %k.merge2

k.merge2:                                          ; preds = %k.isLeft2, %k.isRight2
  %k2 = phi i64 [ %right2, %k.isRight2 ], [ %left2, %k.isLeft2 ]
  %j2.ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %j2.val = load i32, i32* %j2.ptr, align 4
  %k2.ptr = getelementptr inbounds i32, i32* %arr, i64 %k2
  %k2.val = load i32, i32* %k2.ptr, align 4
  %cmp_j_ge_k2 = icmp sge i32 %j2.val, %k2.val
  br i1 %cmp_j_ge_k2, label %extract.after_sift, label %sift2.swap

sift2.swap:                                        ; preds = %k.merge2
  store i32 %k2.val, i32* %j2.ptr, align 4
  store i32 %j2.val, i32* %k2.ptr, align 4
  %j2.next = %k2
  br label %sift2.loop

extract.after_sift:                                ; preds = %k.merge2, %sift2.loop
  %i2.next = add i64 %i2, -1
  br label %extract.cond

ret:                                               ; preds = %extract.cond, %entry
  ret void
}