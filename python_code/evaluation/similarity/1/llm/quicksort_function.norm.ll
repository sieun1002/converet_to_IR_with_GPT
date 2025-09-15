; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/quicksort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/quicksort_function.ll"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @quick_sort(i32* %arr, i64 %left, i64 %right) {
entry:
  br label %while.header

while.header:                                     ; preds = %skip.right, %skip.left, %entry
  %right.addr.0 = phi i64 [ %right, %entry ], [ %right.addr.0, %skip.left ], [ %j.addr.1, %skip.right ]
  %left.addr.0 = phi i64 [ %left, %entry ], [ %i.addr.0, %skip.left ], [ %left.addr.0, %skip.right ]
  %cmp = icmp sgt i64 %right.addr.0, %left.addr.0
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %while.header
  %diff = sub i64 %right.addr.0, %left.addr.0
  %sign = lshr i64 %diff, 63
  %sum = add i64 %diff, %sign
  %half = ashr i64 %sum, 1
  %mid = add i64 %left.addr.0, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot.val = load i32, i32* %pivot.ptr, align 4
  br label %part.l1

part.l1:                                          ; preds = %do.swap, %inc.i, %loop.body
  %i.addr.0 = phi i64 [ %left.addr.0, %loop.body ], [ %i.next, %inc.i ], [ %i.inc2, %do.swap ]
  %j.addr.0 = phi i64 [ %right.addr.0, %loop.body ], [ %j.addr.0, %inc.i ], [ %j.dec2, %do.swap ]
  %elem.ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i.addr.0
  %elem.i = load i32, i32* %elem.ptr.i, align 4
  %cmp.piv.gt = icmp sgt i32 %pivot.val, %elem.i
  br i1 %cmp.piv.gt, label %inc.i, label %part.l2

inc.i:                                            ; preds = %part.l1
  %i.next = add i64 %i.addr.0, 1
  br label %part.l1

part.l2:                                          ; preds = %dec.j, %part.l1
  %j.addr.1 = phi i64 [ %j.addr.0, %part.l1 ], [ %j.next, %dec.j ]
  %elem.ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.addr.1
  %elem.j = load i32, i32* %elem.ptr.j, align 4
  %cmp.piv.lt = icmp slt i32 %pivot.val, %elem.j
  br i1 %cmp.piv.lt, label %dec.j, label %part.compare

dec.j:                                            ; preds = %part.l2
  %j.next = add i64 %j.addr.1, -1
  br label %part.l2

part.compare:                                     ; preds = %part.l2
  %cmp.ilej.not = icmp sgt i64 %i.addr.0, %j.addr.1
  br i1 %cmp.ilej.not, label %part.done, label %do.swap

do.swap:                                          ; preds = %part.compare
  store i32 %elem.j, i32* %elem.ptr.i, align 4
  store i32 %elem.i, i32* %elem.ptr.j, align 4
  %i.inc2 = add i64 %i.addr.0, 1
  %j.dec2 = add i64 %j.addr.1, -1
  br label %part.l1

part.done:                                        ; preds = %part.compare
  %left.size = sub i64 %j.addr.1, %left.addr.0
  %right.size = sub i64 %right.addr.0, %i.addr.0
  %cmp.leftlt = icmp slt i64 %left.size, %right.size
  br i1 %cmp.leftlt, label %recurse.left, label %recurse.right

recurse.left:                                     ; preds = %part.done
  %need.left = icmp sgt i64 %j.addr.1, %left.addr.0
  br i1 %need.left, label %call.left, label %skip.left

call.left:                                        ; preds = %recurse.left
  call void @quick_sort(i32* %arr, i64 %left.addr.0, i64 %j.addr.1)
  br label %skip.left

skip.left:                                        ; preds = %call.left, %recurse.left
  br label %while.header

recurse.right:                                    ; preds = %part.done
  %need.right = icmp sgt i64 %right.addr.0, %i.addr.0
  br i1 %need.right, label %call.right, label %skip.right

call.right:                                       ; preds = %recurse.right
  call void @quick_sort(i32* %arr, i64 %i.addr.0, i64 %right.addr.0)
  br label %skip.right

skip.right:                                       ; preds = %call.right, %recurse.right
  br label %while.header

exit:                                             ; preds = %while.header
  ret void
}
