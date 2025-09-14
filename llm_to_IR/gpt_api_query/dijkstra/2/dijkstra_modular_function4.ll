; ModuleID = 'min_index_module'
source_filename = "min_index.c"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @min_index(i32* %a, i32* %b, i32 %n) {
entry:
  %best = alloca i32, align 4
  %min = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 -1, i32* %best, align 4
  store i32 2147483647, i32* %min, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp sge i32 %i.val, %n
  br i1 %cmp, label %exit, label %body

body:
  %i.ext = sext i32 %i.val to i64
  %b.ptr = getelementptr inbounds i32, i32* %b, i64 %i.ext
  %b.val = load i32, i32* %b.ptr, align 4
  %iszero = icmp eq i32 %b.val, 0
  br i1 %iszero, label %checkA, label %inc

checkA:
  %a.ptr = getelementptr inbounds i32, i32* %a, i64 %i.ext
  %a.val = load i32, i32* %a.ptr, align 4
  %min.cur = load i32, i32* %min, align 4
  %lt = icmp slt i32 %a.val, %min.cur
  br i1 %lt, label %update, label %inc

update:
  store i32 %a.val, i32* %min, align 4
  store i32 %i.val, i32* %best, align 4
  br label %inc

inc:
  %i.next = add i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

exit:
  %ret = load i32, i32* %best, align 4
  ret i32 %ret
}