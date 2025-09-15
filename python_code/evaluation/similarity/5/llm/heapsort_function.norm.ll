; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/heapsort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/heapsort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n = icmp ult i64 %n, 2
  br i1 %cmp_n, label %ret, label %build.init

build.init:                                       ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build.loop.check

build.loop.check:                                 ; preds = %build.loop.body.end, %build.init
  %i.phi = phi i64 [ %half, %build.init ], [ %start, %build.loop.body.end ]
  %old_nonzero.not = icmp eq i64 %i.phi, 0
  br i1 %old_nonzero.not, label %outer.check, label %build.loop.body.start

build.loop.body.start:                            ; preds = %build.loop.check
  %start = add i64 %i.phi, -1
  br label %sift1.header

sift1.header:                                     ; preds = %sift1.do.swap, %build.loop.body.start
  %root1.phi = phi i64 [ %start, %build.loop.body.start ], [ %maxChild1, %sift1.do.swap ]
  %twice1 = shl i64 %root1.phi, 1
  %child1 = or i64 %twice1, 1
  %child_in1 = icmp ult i64 %child1, %n
  br i1 %child_in1, label %sift1.child.check, label %build.loop.body.end

sift1.child.check:                                ; preds = %sift1.header
  %right1 = add i64 %twice1, 2
  %has_right1 = icmp ult i64 %right1, %n
  br i1 %has_right1, label %sift1.lr, label %sift1.after.select

sift1.lr:                                         ; preds = %sift1.child.check
  %ptr_right1 = getelementptr inbounds i32, i32* %arr, i64 %right1
  %val_right1 = load i32, i32* %ptr_right1, align 4
  %ptr_child1 = getelementptr inbounds i32, i32* %arr, i64 %child1
  %val_child1 = load i32, i32* %ptr_child1, align 4
  %right_gt1 = icmp sgt i32 %val_right1, %val_child1
  %maxIdx_lr1 = select i1 %right_gt1, i64 %right1, i64 %child1
  br label %sift1.after.select

sift1.after.select:                               ; preds = %sift1.child.check, %sift1.lr
  %maxChild1 = phi i64 [ %maxIdx_lr1, %sift1.lr ], [ %child1, %sift1.child.check ]
  %ptr_root1 = getelementptr inbounds i32, i32* %arr, i64 %root1.phi
  %val_root1 = load i32, i32* %ptr_root1, align 4
  %ptr_max1 = getelementptr inbounds i32, i32* %arr, i64 %maxChild1
  %val_max1 = load i32, i32* %ptr_max1, align 4
  %ge1.not = icmp slt i32 %val_root1, %val_max1
  br i1 %ge1.not, label %sift1.do.swap, label %build.loop.body.end

sift1.do.swap:                                    ; preds = %sift1.after.select
  store i32 %val_max1, i32* %ptr_root1, align 4
  store i32 %val_root1, i32* %ptr_max1, align 4
  br label %sift1.header

build.loop.body.end:                              ; preds = %sift1.header, %sift1.after.select
  br label %build.loop.check

outer.check:                                      ; preds = %build.loop.check, %after.inner
  %end.phi.in = phi i64 [ %end.phi, %after.inner ], [ %n, %build.loop.check ]
  %end.phi = add i64 %end.phi.in, -1
  %cond2.not = icmp eq i64 %end.phi, 0
  br i1 %cond2.not, label %ret, label %outer.body

outer.body:                                       ; preds = %outer.check
  %v0 = load i32, i32* %arr, align 4
  %pend = getelementptr inbounds i32, i32* %arr, i64 %end.phi
  %vend = load i32, i32* %pend, align 4
  store i32 %vend, i32* %arr, align 4
  store i32 %v0, i32* %pend, align 4
  br label %sift2.header

sift2.header:                                     ; preds = %sift2.do.swap, %outer.body
  %root2.phi = phi i64 [ 0, %outer.body ], [ %maxChild2, %sift2.do.swap ]
  %twice2 = shl i64 %root2.phi, 1
  %child2 = or i64 %twice2, 1
  %child_in2 = icmp ult i64 %child2, %end.phi
  br i1 %child_in2, label %sift2.child.check, label %after.inner

sift2.child.check:                                ; preds = %sift2.header
  %right2 = add i64 %twice2, 2
  %has_right2 = icmp ult i64 %right2, %end.phi
  br i1 %has_right2, label %sift2.lr, label %sift2.after.select

sift2.lr:                                         ; preds = %sift2.child.check
  %ptr_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %ptr_child2 = getelementptr inbounds i32, i32* %arr, i64 %child2
  %val_child2 = load i32, i32* %ptr_child2, align 4
  %right_gt2 = icmp sgt i32 %val_right2, %val_child2
  %maxIdx_lr2 = select i1 %right_gt2, i64 %right2, i64 %child2
  br label %sift2.after.select

sift2.after.select:                               ; preds = %sift2.child.check, %sift2.lr
  %maxChild2 = phi i64 [ %maxIdx_lr2, %sift2.lr ], [ %child2, %sift2.child.check ]
  %ptr_root2 = getelementptr inbounds i32, i32* %arr, i64 %root2.phi
  %val_root2 = load i32, i32* %ptr_root2, align 4
  %ptr_max2 = getelementptr inbounds i32, i32* %arr, i64 %maxChild2
  %val_max2 = load i32, i32* %ptr_max2, align 4
  %ge2.not = icmp slt i32 %val_root2, %val_max2
  br i1 %ge2.not, label %sift2.do.swap, label %after.inner

sift2.do.swap:                                    ; preds = %sift2.after.select
  store i32 %val_max2, i32* %ptr_root2, align 4
  store i32 %val_root2, i32* %ptr_max2, align 4
  br label %sift2.header

after.inner:                                      ; preds = %sift2.after.select, %sift2.header
  br label %outer.check

ret:                                              ; preds = %outer.check, %entry
  ret void
}
