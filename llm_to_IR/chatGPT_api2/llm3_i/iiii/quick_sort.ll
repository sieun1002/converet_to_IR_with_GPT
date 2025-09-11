; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10C0
; Intent: Bottom-up mergesort of 10 integers and print them (confidence=0.95). Evidence: iterative merge loops with run doubling; prints with "%d ".
; Preconditions: None
; Postconditions: Prints ten integers followed by newline; returns 0

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arrp = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  ; initialize arr with {9,1,5,3,7,2,8,6,4,0}
  %e0 = getelementptr inbounds i32, i32* %arrp, i64 0
  store i32 9, i32* %e0, align 4
  %e1 = getelementptr inbounds i32, i32* %arrp, i64 1
  store i32 1, i32* %e1, align 4
  %e2 = getelementptr inbounds i32, i32* %arrp, i64 2
  store i32 5, i32* %e2, align 4
  %e3 = getelementptr inbounds i32, i32* %arrp, i64 3
  store i32 3, i32* %e3, align 4
  %e4 = getelementptr inbounds i32, i32* %arrp, i64 4
  store i32 7, i32* %e4, align 4
  %e5 = getelementptr inbounds i32, i32* %arrp, i64 5
  store i32 2, i32* %e5, align 4
  %e6 = getelementptr inbounds i32, i32* %arrp, i64 6
  store i32 8, i32* %e6, align 4
  %e7 = getelementptr inbounds i32, i32* %arrp, i64 7
  store i32 6, i32* %e7, align 4
  %e8 = getelementptr inbounds i32, i32* %arrp, i64 8
  store i32 4, i32* %e8, align 4
  %e9 = getelementptr inbounds i32, i32* %arrp, i64 9
  store i32 0, i32* %e9, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %nl = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %buf.i8 = call i8* @malloc(i64 40)
  %isnull = icmp eq i8* %buf.i8, null
  br i1 %isnull, label %nosort, label %sort

nosort:                                           ; preds = %entry
  br label %print

sort:                                             ; preds = %entry
  %buf.i32 = bitcast i8* %buf.i8 to i32*
  br label %outer

outer:                                            ; preds = %endpass, %sort
  %src.phi = phi i32* [ %arrp, %sort ], [ %src.next, %endpass ]
  %dst.phi = phi i32* [ %buf.i32, %sort ], [ %dst.next, %endpass ]
  %run.phi = phi i64 [ 1, %sort ], [ %run.next, %endpass ]
  %passes.phi = phi i32 [ 4, %sort ], [ %passes.next, %endpass ]
  %done.passes = icmp eq i32 %passes.phi, 0
  br i1 %done.passes, label %after.outer, label %inner.init

inner.init:                                       ; preds = %outer
  br label %inner

inner:                                            ; preds = %merge.done, %inner.init
  %start.phi = phi i64 [ 0, %inner.init ], [ %start.next, %merge.done ]
  %cmp.start = icmp ult i64 %start.phi, 10
  br i1 %cmp.start, label %prepare.merge, label %endpass

prepare.merge:                                    ; preds = %inner
  %run2 = shl i64 %run.phi, 1
  %mid.raw = add i64 %start.phi, %run.phi
  %mid.lt = icmp ult i64 %mid.raw, 10
  %mid = select i1 %mid.lt, i64 %mid.raw, i64 10
  %end.raw = add i64 %start.phi, %run2
  %end.lt = icmp ult i64 %end.raw, 10
  %end = select i1 %end.lt, i64 %end.raw, i64 10
  br label %merge

merge:                                            ; preds = %choose.right, %choose.left, %both, %prepare.merge
  %i.phi = phi i64 [ %start.phi, %prepare.merge ], [ %i.next.r, %choose.right ], [ %i.next.l, %choose.left ], [ %i.next.both, %both ]
  %j.phi = phi i64 [ %mid, %prepare.merge ], [ %j.next.r, %choose.right ], [ %j.next.l, %choose.left ], [ %j.next.both, %both ]
  %k.phi = phi i64 [ %start.phi, %prepare.merge ], [ %k.next.r, %choose.right ], [ %k.next.l, %choose.left ], [ %k.next.both, %both ]
  %k.ge.end = icmp uge i64 %k.phi, %end
  br i1 %k.ge.end, label %merge.done, label %check.left

check.left:                                       ; preds = %merge
  %haveLeft = icmp ult i64 %i.phi, %mid
  br i1 %haveLeft, label %check.right, label %only.right

check.right:                                      ; preds = %check.left
  %haveRight = icmp ult i64 %j.phi, %end
  br i1 %haveRight, label %both, label %only.left

only.right:                                       ; preds = %check.left
  ; take from right
  %src.j.ptr.r = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %val.r = load i32, i32* %src.j.ptr.r, align 4
  %dst.k.ptr.r = getelementptr inbounds i32, i32* %dst.phi, i64 %k.phi
  store i32 %val.r, i32* %dst.k.ptr.r, align 4
  %j.next.r = add i64 %j.phi, 1
  %i.next.r = %i.phi
  %k.next.r = add i64 %k.phi, 1
  br label %merge

only.left:                                        ; preds = %check.right
  ; take from left
  %src.i.ptr.l = getelementptr inbounds i32, i32* %src.phi, i64 %i.phi
  %val.l = load i32, i32* %src.i.ptr.l, align 4
  %dst.k.ptr.l = getelementptr inbounds i32, i32* %dst.phi, i64 %k.phi
  store i32 %val.l, i32* %dst.k.ptr.l, align 4
  %i.next.l = add i64 %i.phi, 1
  %j.next.l = %j.phi
  %k.next.l = add i64 %k.phi, 1
  br label %merge

both:                                             ; preds = %check.right
  %src.i.ptr = getelementptr inbounds i32, i32* %src.phi, i64 %i.phi
  %src.j.ptr = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %lv = load i32, i32* %src.i.ptr, align 4
  %rv = load i32, i32* %src.j.ptr, align 4
  %le = icmp sle i32 %lv, %rv
  br i1 %le, label %choose.left, label %choose.right

choose.left:                                      ; preds = %both
  %dst.k.ptr.cl = getelementptr inbounds i32, i32* %dst.phi, i64 %k.phi
  store i32 %lv, i32* %dst.k.ptr.cl, align 4
  %i.next.both = add i64 %i.phi, 1
  %j.next.both = %j.phi
  %k.next.both = add i64 %k.phi, 1
  br label %merge

choose.right:                                     ; preds = %both
  %dst.k.ptr.cr = getelementptr inbounds i32, i32* %dst.phi, i64 %k.phi
  store i32 %rv, i32* %dst.k.ptr.cr, align 4
  %j.next.both = add i64 %j.phi, 1
  %i.next.both2 = %i.phi
  %k.next.both2 = add i64 %k.phi, 1
  ; connect to merge phis
  %i.next.r2 = %i.next.both2
  %j.next.r2 = %j.next.both
  %k.next.r2 = %k.next.both2
  br label %merge

merge.done:                                       ; preds = %merge
  %start.next = add i64 %start.phi, %run2
  br label %inner

endpass:                                          ; preds = %inner
  ; swap src/dst, double run, decrement passes
  %src.next = %dst.phi
  %dst.next = %src.phi
  %run.next = shl i64 %run.phi, 1
  %passes.next = add i32 %passes.phi, -1
  br label %outer

after.outer:                                      ; preds = %outer
  ; if final src != arrp, copy back
  %final.is.arr = icmp eq i32* %src.phi, %arrp
  br i1 %final.is.arr, label %after.copy, label %copy.back

copy.back:                                        ; preds = %after.outer
  br label %cpy.loop

cpy.loop:                                         ; preds = %cpy.loop, %copy.back
  %ci = phi i64 [ 0, %copy.back ], [ %ci.next, %cpy.loop ]
  %src.ci = getelementptr inbounds i32, i32* %src.phi, i64 %ci
  %val.ci = load i32, i32* %src.ci, align 4
  %dst.ci = getelementptr inbounds i32, i32* %arrp, i64 %ci
  store i32 %val.ci, i32* %dst.ci, align 4
  %ci.next = add i64 %ci, 1
  %done.ci = icmp eq i64 %ci.next, 10
  br i1 %done.ci, label %after.copy, label %cpy.loop

after.copy:                                       ; preds = %cpy.loop, %after.outer
  call void @free(i8* %buf.i8)
  br label %print

print:                                            ; preds = %after.copy, %nosort
  br label %print.loop

print.loop:                                       ; preds = %print.loop, %print
  %pi = phi i64 [ 0, %print ], [ %pi.next, %print.loop ]
  %aptr = getelementptr inbounds i32, i32* %arrp, i64 %pi
  %aval = load i32, i32* %aptr, align 4
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt, i32 %aval)
  %pi.next = add i64 %pi, 1
  %done.print = icmp eq i64 %pi.next, 10
  br i1 %done.print, label %print.nl, label %print.loop

print.nl:                                         ; preds = %print.loop
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl)
  ret i32 0
}