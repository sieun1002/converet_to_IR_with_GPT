; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x00000000000010C0
; Intent: bottom-up mergesort of 10 ints and print them (confidence=0.93). Evidence: iterative merge passes (run doubling, 4 passes), malloc temp buffer and rep movsd back, printing with "%d ".
; Preconditions: none
; Postconditions: prints 10 integers followed by newline; returns 0

; Only the necessary external declarations:
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  ; initialize array: 9,1,5,3,7,2,8,6,4,0
  %e0 = getelementptr inbounds i32, i32* %arr.base, i64 0
  store i32 9, i32* %e0, align 4
  %e1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1, i32* %e1, align 4
  %e2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 5, i32* %e2, align 4
  %e3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 3, i32* %e3, align 4
  %e4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7, i32* %e4, align 4
  %e5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 2, i32* %e5, align 4
  %e6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 8, i32* %e6, align 4
  %e7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %e7, align 4
  %e8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %e8, align 4
  %e9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %e9, align 4

  %buf.i8 = call i8* @malloc(i64 40)
  %buf.null = icmp eq i8* %buf.i8, null
  br i1 %buf.null, label %print_setup, label %sort_init

sort_init:
  %buf.i32 = bitcast i8* %buf.i8 to i32*
  br label %outer

outer:
  ; phis for outer pass state
  %passes.phi = phi i32 [ 4, %sort_init ], [ %passes.next, %after_pass ]
  %src.phi = phi i32* [ %arr.base, %sort_init ], [ %src.next, %after_pass ]
  %dst.phi = phi i32* [ %buf.i32, %sort_init ], [ %dst.next, %after_pass ]
  %run.phi = phi i64 [ 1, %sort_init ], [ %run.next, %after_pass ]
  %outer.done = icmp eq i32 %passes.phi, 0
  br i1 %outer.done, label %after_outer, label %inner_init

inner_init:
  %start.phi = phi i64 [ 0, %outer ], [ %start.next, %after_merge ]
  %cont.inner = icmp ule i64 %start.phi, 9
  br i1 %cont.inner, label %merge_prep, label %after_pass

merge_prep:
  %t.mid = add i64 %start.phi, %run.phi
  %mid.cmp = icmp ult i64 %t.mid, 10
  %mid = select i1 %mid.cmp, i64 %t.mid, i64 10
  %two.run = shl i64 %run.phi, 1
  %t.end = add i64 %start.phi, %two.run
  %end.cmp = icmp ult i64 %t.end, 10
  %end = select i1 %end.cmp, i64 %t.end, i64 10
  %has.range = icmp ugt i64 %end, %start.phi
  br i1 %has.range, label %merge.entry, label %after_merge

merge.entry:
  br label %merge.check

merge.check:
  %i = phi i64 [ %start.phi, %merge.entry ], [ %i.next2, %merge.loop.after ]
  %j = phi i64 [ %mid, %merge.entry ], [ %j.next2, %merge.loop.after ]
  %k = phi i64 [ %start.phi, %merge.entry ], [ %k.next2, %merge.loop.after ]
  %k.lt.end = icmp ult i64 %k, %end
  br i1 %k.lt.end, label %merge.loop, label %after_merge

merge.loop:
  %i.lt.mid = icmp ult i64 %i, %mid
  %j.ge.end = icmp uge i64 %j, %end
  br i1 %i.lt.mid, label %have.left, label %take.right.direct

have.left:
  %src.i.ptr = getelementptr inbounds i32, i32* %src.phi, i64 %i
  %left.val = load i32, i32* %src.i.ptr, align 4
  br i1 %j.ge.end, label %take.left, label %cmp.both

cmp.both:
  %src.j.ptr = getelementptr inbounds i32, i32* %src.phi, i64 %j
  %right.val = load i32, i32* %src.j.ptr, align 4
  %right.lt.left = icmp slt i32 %right.val, %left.val
  br i1 %right.lt.left, label %take.right.loaded, label %take.left

take.left:
  %dst.k.ptr.l = getelementptr inbounds i32, i32* %dst.phi, i64 %k
  store i32 %left.val, i32* %dst.k.ptr.l, align 4
  %i.next = add i64 %i, 1
  %k.next.l = add i64 %k, 1
  br label %merge.loop.after

take.right.direct:
  %src.j.ptr2 = getelementptr inbounds i32, i32* %src.phi, i64 %j
  %right.val2 = load i32, i32* %src.j.ptr2, align 4
  br label %do.take.right

take.right.loaded:
  br label %do.take.right

do.take.right:
  %right.merge = phi i32 [ %right.val2, %take.right.direct ], [ %right.val, %take.right.loaded ]
  %dst.k.ptr.r = getelementptr inbounds i32, i32* %dst.phi, i64 %k
  store i32 %right.merge, i32* %dst.k.ptr.r, align 4
  %j.next = add i64 %j, 1
  %k.next.r = add i64 %k, 1
  br label %merge.loop.after

merge.loop.after:
  %i.next2 = phi i64 [ %i.next, %take.left ], [ %i, %do.take.right ]
  %j.next2 = phi i64 [ %j, %take.left ], [ %j.next, %do.take.right ]
  %k.next2 = phi i64 [ %k.next.l, %take.left ], [ %k.next.r, %do.take.right ]
  br label %merge.check

after_merge:
  ; next start = end (saturated)
  %start.next = add i64 %start.phi, %two.run
  ; ensure we don't loop infinitely: use saturated end for correctness
  %start.next.sel.cmp = icmp ult i64 %start.next, %end
  %start.next.sel = select i1 %start.next.sel.cmp, i64 %end, i64 %start.next
  br label %inner_init

after_pass:
  %passes.next = add nsw i32 %passes.phi, -1
  %done.after = icmp eq i32 %passes.next, 0
  ; if not done, swap src/dst and double run; if done, keep as-is
  %src.next = select i1 %done.after, i32* %src.phi, i32* %dst.phi
  %dst.next = select i1 %done.after, i32* %dst.phi, i32* %src.phi
  %run.next = select i1 %done.after, i64 %run.phi, i64 %two.run
  br label %outer

after_outer:
  ; passes.phi == 0 here; dst.phi points to last destination buffer
  ; if last destination is not stack array, copy back
  %dst.is.arr = icmp eq i32* %dst.phi, %arr.base
  br i1 %dst.is.arr, label %skip.copy, label %do.copy

do.copy:
  ; copy 10 elements from dst.phi to arr.base
  br label %cpy.loop

cpy.loop:
  %ci = phi i64 [ 0, %do.copy ], [ %ci.next, %cpy.loop ]
  %ci.cmp = icmp ult i64 %ci, 10
  br i1 %ci.cmp, label %cpy.body, label %cpy.done

cpy.body:
  %src.cp.ptr = getelementptr inbounds i32, i32* %dst.phi, i64 %ci
  %val.cp = load i32, i32* %src.cp.ptr, align 4
  %dst.cp.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %ci
  store i32 %val.cp, i32* %dst.cp.ptr, align 4
  %ci.next = add i64 %ci, 1
  br label %cpy.loop

cpy.done:
  br label %skip.copy

skip.copy:
  ; free the original malloc buffer
  call void @free(i8* %buf.i8)
  br label %print_setup

print_setup:
  ; print the array
  br label %print.loop

print.loop:
  %pi = phi i64 [ 0, %print_setup ], [ %pi.next, %print.loop ]
  %pi.cmp = icmp ult i64 %pi, 10
  br i1 %pi.cmp, label %print.body, label %print.end

print.body:
  %p.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %pi
  %p.val = load i32, i32* %p.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %p.val)
  %pi.next = add i64 %pi, 1
  br label %print.loop

print.end:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}