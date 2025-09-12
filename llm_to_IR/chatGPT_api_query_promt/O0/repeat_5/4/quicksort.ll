; ModuleID = 'quick_sort.ll'
source_filename = "quick_sort"

define void @quick_sort(i32* %arr, i64 %left, i64 %right) {
entry:
  br label %while.check

while.check:                                      ; preds = %after.recurse.right, %after.recurse.left, %entry
  %L = phi i64 [ %left, %entry ], [ %L.afterLeft, %after.recurse.left ], [ %L.afterRight, %after.recurse.right ]
  %R = phi i64 [ %right, %entry ], [ %R.afterLeft, %after.recurse.left ], [ %R.afterRight, %after.recurse.right ]
  %cmpLR = icmp slt i64 %L, %R
  br i1 %cmpLR, label %outer.body, label %return

outer.body:                                       ; preds = %while.check
  %i.init = %L
  %j.init = %R
  %delta = sub i64 %R, %L
  %sign = lshr i64 %delta, 63
  %sum = add i64 %delta, %sign
  %half = ashr i64 %sum, 1
  %mid = add i64 %L, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %part.loop

part.loop:                                        ; preds = %swap_then_continue, %outer.body
  %i.ph = phi i64 [ %i.init, %outer.body ], [ %i.afterSwap, %swap_then_continue ]
  %j.ph = phi i64 [ %j.init, %outer.body ], [ %j.afterSwap, %swap_then_continue ]
  br label %inc_i

inc_i:                                            ; preds = %inc_i.step, %part.loop
  %i.iter = phi i64 [ %i.ph, %part.loop ], [ %i.iter.next, %inc_i.step ]
  %ai.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.iter
  %ai = load i32, i32* %ai.ptr, align 4
  %cmpi = icmp slt i32 %ai, %pivot
  br i1 %cmpi, label %inc_i.step, label %dec_j

inc_i.step:                                       ; preds = %inc_i
  %i.iter.next = add i64 %i.iter, 1
  br label %inc_i

dec_j:                                            ; preds = %inc_i
  %j.iter = phi i64 [ %j.ph, %inc_i ], [ %j.iter.prev, %dec_j.step ]
  %aj.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.iter
  %aj = load i32, i32* %aj.ptr, align 4
  %cmpj = icmp sgt i32 %aj, %pivot
  br i1 %cmpj, label %dec_j.step, label %after_adjust

dec_j.step:                                       ; preds = %dec_j
  %j.iter.prev = add i64 %j.iter, -1
  br label %dec_j

after_adjust:                                     ; preds = %dec_j
  %break = icmp sgt i64 %i.iter, %j.iter
  br i1 %break, label %after_partition, label %swap_then_continue

swap_then_continue:                               ; preds = %after_adjust
  %pi = getelementptr inbounds i32, i32* %arr, i64 %i.iter
  %vi = load i32, i32* %pi, align 4
  %pj = getelementptr inbounds i32, i32* %arr, i64 %j.iter
  %vj = load i32, i32* %pj, align 4
  store i32 %vj, i32* %pi, align 4
  store i32 %vi, i32* %pj, align 4
  %i.afterSwap = add i64 %i.iter, 1
  %j.afterSwap = add i64 %j.iter, -1
  br label %part.loop

after_partition:                                  ; preds = %after_adjust
  %leftLen = sub i64 %j.iter, %L
  %rightLen = sub i64 %R, %i.iter
  %cmpLens = icmp sge i64 %leftLen, %rightLen
  br i1 %cmpLens, label %caseRightSmall, label %caseLeftSmall

caseLeftSmall:                                    ; preds = %after_partition
  %needLeft = icmp slt i64 %L, %j.iter
  br i1 %needLeft, label %callLeft, label %afterCallLeft

callLeft:                                         ; preds = %caseLeftSmall
  call void @quick_sort(i32* %arr, i64 %L, i64 %j.iter)
  br label %afterCallLeft

afterCallLeft:                                    ; preds = %callLeft, %caseLeftSmall
  %L.afterLeft = %i.iter
  %R.afterLeft = %R
  br label %after.recurse.left

caseRightSmall:                                   ; preds = %after_partition
  %needRight = icmp slt i64 %i.iter, %R
  br i1 %needRight, label %callRight, label %afterCallRight

callRight:                                        ; preds = %caseRightSmall
  call void @quick_sort(i32* %arr, i64 %i.iter, i64 %R)
  br label %afterCallRight

afterCallRight:                                   ; preds = %callRight, %caseRightSmall
  %L.afterRight = %L
  %R.afterRight = %j.iter
  br label %after.recurse.right

after.recurse.left:                               ; preds = %afterCallLeft
  br label %while.check

after.recurse.right:                              ; preds = %afterCallRight
  br label %while.check

return:                                           ; preds = %while.check
  ret void
}