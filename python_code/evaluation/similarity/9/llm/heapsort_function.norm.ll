; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/heapsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/heapsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind
define void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr #0 {
entry:
  %cmp.n.le1 = icmp ult i64 %n, 2
  br i1 %cmp.n.le1, label %ret, label %build.init

build.init:                                       ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build.dec.test

build.dec.test:                                   ; preds = %build.sift.done, %build.init
  %i_old = phi i64 [ %half, %build.init ], [ %i0, %build.sift.done ]
  %i_old.nz.not = icmp eq i64 %i_old, 0
  br i1 %i_old.nz.not, label %phase2.cond, label %build.body.prep

build.body.prep:                                  ; preds = %build.dec.test
  %i0 = add i64 %i_old, -1
  br label %sift1.header

sift1.header:                                     ; preds = %sift1.swap, %build.body.prep
  %k = phi i64 [ %i0, %build.body.prep ], [ %m, %sift1.swap ]
  %k.twice = shl i64 %k, 1
  %left = or i64 %k.twice, 1
  %left.lt.n = icmp ult i64 %left, %n
  br i1 %left.lt.n, label %sift1.has.left, label %build.sift.done

sift1.has.left:                                   ; preds = %sift1.header
  %right = add i64 %k.twice, 2
  %right.lt.n = icmp ult i64 %right, %n
  br i1 %right.lt.n, label %sift1.both.children, label %sift1.have.m

sift1.both.children:                              ; preds = %sift1.has.left
  %ptr.r = getelementptr inbounds i32, i32* %arr, i64 %right
  %val.r = load i32, i32* %ptr.r, align 4
  %ptr.l = getelementptr inbounds i32, i32* %arr, i64 %left
  %val.l = load i32, i32* %ptr.l, align 4
  %r.gt.l = icmp sgt i32 %val.r, %val.l
  %m.idx = select i1 %r.gt.l, i64 %right, i64 %left
  br label %sift1.have.m

sift1.have.m:                                     ; preds = %sift1.has.left, %sift1.both.children
  %m = phi i64 [ %m.idx, %sift1.both.children ], [ %left, %sift1.has.left ]
  %ptr.k = getelementptr inbounds i32, i32* %arr, i64 %k
  %val.k = load i32, i32* %ptr.k, align 4
  %ptr.m = getelementptr inbounds i32, i32* %arr, i64 %m
  %val.m = load i32, i32* %ptr.m, align 4
  %k.ge.m.not = icmp slt i32 %val.k, %val.m
  br i1 %k.ge.m.not, label %sift1.swap, label %build.sift.done

sift1.swap:                                       ; preds = %sift1.have.m
  store i32 %val.m, i32* %ptr.k, align 4
  store i32 %val.k, i32* %ptr.m, align 4
  br label %sift1.header

build.sift.done:                                  ; preds = %sift1.have.m, %sift1.header
  br label %build.dec.test

phase2.cond:                                      ; preds = %build.dec.test, %phase2.sift.done
  %end.in = phi i64 [ %end, %phase2.sift.done ], [ %n, %build.dec.test ]
  %end = add i64 %end.in, -1
  %end.nz.not = icmp eq i64 %end, 0
  br i1 %end.nz.not, label %ret, label %phase2.swap.root

phase2.swap.root:                                 ; preds = %phase2.cond
  %v0 = load i32, i32* %arr, align 4
  %ptr.end = getelementptr inbounds i32, i32* %arr, i64 %end
  %vend = load i32, i32* %ptr.end, align 4
  store i32 %vend, i32* %arr, align 4
  store i32 %v0, i32* %ptr.end, align 4
  br label %sift2.header

sift2.header:                                     ; preds = %sift2.swap, %phase2.swap.root
  %k2 = phi i64 [ 0, %phase2.swap.root ], [ %m2, %sift2.swap ]
  %k2.twice = shl i64 %k2, 1
  %left2 = or i64 %k2.twice, 1
  %left2.lt.end = icmp ult i64 %left2, %end
  br i1 %left2.lt.end, label %sift2.has.left, label %phase2.sift.done

sift2.has.left:                                   ; preds = %sift2.header
  %right2 = add i64 %k2.twice, 2
  %right2.lt.end = icmp ult i64 %right2, %end
  br i1 %right2.lt.end, label %sift2.both.children, label %sift2.have.m

sift2.both.children:                              ; preds = %sift2.has.left
  %ptr.r2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val.r2 = load i32, i32* %ptr.r2, align 4
  %ptr.l2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val.l2 = load i32, i32* %ptr.l2, align 4
  %r2.gt.l2 = icmp sgt i32 %val.r2, %val.l2
  %m2.idx = select i1 %r2.gt.l2, i64 %right2, i64 %left2
  br label %sift2.have.m

sift2.have.m:                                     ; preds = %sift2.has.left, %sift2.both.children
  %m2 = phi i64 [ %m2.idx, %sift2.both.children ], [ %left2, %sift2.has.left ]
  %ptr.k2 = getelementptr inbounds i32, i32* %arr, i64 %k2
  %val.k2 = load i32, i32* %ptr.k2, align 4
  %ptr.m2 = getelementptr inbounds i32, i32* %arr, i64 %m2
  %val.m2 = load i32, i32* %ptr.m2, align 4
  %k2.ge.m2.not = icmp slt i32 %val.k2, %val.m2
  br i1 %k2.ge.m2.not, label %sift2.swap, label %phase2.sift.done

sift2.swap:                                       ; preds = %sift2.have.m
  store i32 %val.m2, i32* %ptr.k2, align 4
  store i32 %val.k2, i32* %ptr.m2, align 4
  br label %sift2.header

phase2.sift.done:                                 ; preds = %sift2.have.m, %sift2.header
  br label %phase2.cond

ret:                                              ; preds = %phase2.cond, %entry
  ret void
}

attributes #0 = { nounwind }
