; ModuleID = 'quicksort.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.base, align 4
  %idx1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 5, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 8, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %idx9, align 4
  %len = add i64 10, 0
  %cmp.len = icmp ule i64 %len, 1
  br i1 %cmp.len, label %skip.sort, label %do.sort

do.sort:                                          ; preds = %entry
  %high = add i64 %len, -1
  call void @quick_sort(i32* noundef %arr.base, i64 noundef 0, i64 noundef %high)
  br label %skip.sort

skip.sort:                                        ; preds = %do.sort, %entry
  br label %loop

loop:                                             ; preds = %loop.body.end, %skip.sort
  %i = phi i64 [ 0, %skip.sort ], [ %inc, %loop.body.end ]
  %cond = icmp ult i64 %i, %len
  br i1 %cond, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop
  %eltptr = getelementptr inbounds i32, i32* %arr.base, i64 %i
  %val = load i32, i32* %eltptr, align 4
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr, i32 noundef %val)
  br label %loop.body.end

loop.body.end:                                    ; preds = %loop.body
  %inc = add i64 %i, 1
  br label %loop

after.loop:                                       ; preds = %loop
  %call.putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define void @quick_sort(i32* nocapture %arr, i64 %lo, i64 %hi) {
entry:
  br label %outer

outer:                                            ; preds = %outer.cont, %entry
  %lo.cur = phi i64 [ %lo, %entry ], [ %lo.next, %outer.cont ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.next, %outer.cont ]
  %cmp.outer = icmp slt i64 %lo.cur, %hi.cur
  br i1 %cmp.outer, label %part.init, label %ret

part.init:                                        ; preds = %outer
  %i0 = add i64 %lo.cur, 0
  %j0 = add i64 %hi.cur, 0
  %delta = sub i64 %hi.cur, %lo.cur
  %neg = lshr i64 %delta, 63
  %biased = add i64 %delta, %neg
  %half = ashr i64 %biased, 1
  %mid = add i64 %lo.cur, %half
  %ptr.mid = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %ptr.mid, align 4
  br label %inc_i.check

inc_i.check:                                      ; preds = %swap.true, %inc_i.inc, %part.init
  %i.cur = phi i64 [ %i0, %part.init ], [ %i.next, %inc_i.inc ], [ %i.after.swap, %swap.true ]
  %j.pass = phi i64 [ %j0, %part.init ], [ %j.passthru, %inc_i.inc ], [ %j.after.swap, %swap.true ]
  %iptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %ival = load i32, i32* %iptr, align 4
  %cmp.i = icmp sgt i32 %pivot, %ival
  br i1 %cmp.i, label %inc_i.inc, label %dec_j.check

inc_i.inc:                                        ; preds = %inc_i.check
  %i.next = add i64 %i.cur, 1
  %j.passthru = add i64 %j.pass, 0
  br label %inc_i.check

dec_j.check:                                      ; preds = %dec_j.dec, %inc_i.check
  %i.fixed = phi i64 [ %i.cur, %inc_i.check ], [ %i.fwd, %dec_j.dec ]
  %j.cur = phi i64 [ %j.pass, %inc_i.check ], [ %j.next, %dec_j.dec ]
  %jptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %jval = load i32, i32* %jptr, align 4
  %cmp.j = icmp slt i32 %pivot, %jval
  br i1 %cmp.j, label %dec_j.dec, label %check.swap

dec_j.dec:                                        ; preds = %dec_j.check
  %j.next = add i64 %j.cur, -1
  %i.fwd = add i64 %i.fixed, 0
  br label %dec_j.check

check.swap:                                       ; preds = %dec_j.check
  %cmp.ij = icmp sle i64 %i.fixed, %j.cur
  br i1 %cmp.ij, label %swap.true, label %choose

swap.true:                                        ; preds = %check.swap
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i.fixed
  %val.i = load i32, i32* %ptr.i, align 4
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %val.j = load i32, i32* %ptr.j, align 4
  store i32 %val.j, i32* %ptr.i, align 4
  store i32 %val.i, i32* %ptr.j, align 4
  %i.after.swap = add i64 %i.fixed, 1
  %j.after.swap = add i64 %j.cur, -1
  br label %inc_i.check

choose:                                           ; preds = %check.swap
  %left.len = sub i64 %j.cur, %lo.cur
  %right.len = sub i64 %hi.cur, %i.fixed
  %left.smaller = icmp slt i64 %left.len, %right.len
  br i1 %left.smaller, label %do.left, label %do.right

do.left:                                          ; preds = %choose
  %need.left = icmp slt i64 %lo.cur, %j.cur
  br i1 %need.left, label %call.left, label %skip.left

call.left:                                        ; preds = %do.left
  call void @quick_sort(i32* %arr, i64 %lo.cur, i64 %j.cur)
  br label %skip.left

skip.left:                                        ; preds = %call.left, %do.left
  %lo.next.L = add i64 %i.fixed, 0
  %hi.next.L = add i64 %hi.cur, 0
  br label %outer.cont

do.right:                                         ; preds = %choose
  %need.right = icmp slt i64 %i.fixed, %hi.cur
  br i1 %need.right, label %call.right, label %skip.right

call.right:                                       ; preds = %do.right
  call void @quick_sort(i32* %arr, i64 %i.fixed, i64 %hi.cur)
  br label %skip.right

skip.right:                                       ; preds = %call.right, %do.right
  %lo.next.R = add i64 %lo.cur, 0
  %hi.next.R = add i64 %j.cur, 0
  br label %outer.cont

outer.cont:                                       ; preds = %skip.right, %skip.left
  %lo.next = phi i64 [ %lo.next.L, %skip.left ], [ %lo.next.R, %skip.right ]
  %hi.next = phi i64 [ %hi.next.L, %skip.left ], [ %hi.next.R, %skip.right ]
  br label %outer

ret:                                              ; preds = %outer
  ret void
}
