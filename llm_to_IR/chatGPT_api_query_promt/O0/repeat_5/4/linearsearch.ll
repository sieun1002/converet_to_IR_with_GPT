; ModuleID = 'linear_search_module'
source_filename = "linear_search"
target triple = "x86_64-pc-linux-gnu"

define i32 @linear_search(i32* %arr, i32 %n, i32 %target) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %retneg1

body:
  %idxptr = getelementptr i32, i32* %arr, i32 %i
  %val = load i32, i32* %idxptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %retidx, label %cont

retidx:
  ret i32 %i

cont:
  %i.next = add i32 %i, 1
  br label %loop

retneg1:
  ret i32 -1
}