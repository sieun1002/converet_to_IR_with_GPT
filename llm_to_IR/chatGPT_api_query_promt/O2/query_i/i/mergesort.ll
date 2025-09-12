; ModuleID = 'mergesort_from_binary'
target triple = "x86_64-pc-linux-gnu"

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl  = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  ; local array with initial values: 9,1,5,3,7,2,8,6,4,0
  %arr = alloca [10 x i32], align 16
  store [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], [10 x i32]* %arr, align 16

  ; tmp buffer malloc(40)
  %tmp.raw = call i8* @malloc(i64 40)
  %tmp.ok = icmp ne i8* %tmp.raw, null
  br i1 %tmp.ok, label %sort.start, label %print

; -------- sorting (iterative bottom-up mergesort) ----------
sort.start:
  %tmp = bitcast i8* %tmp.raw to i32*
  %arr.base.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0

  ; initialize pass parameters
  br label %pass.loop

pass.loop:
  ; phis: run, src, dst, passes
  %run.phi   = phi i32 [ 1, %sort.start ], [ %run.next, %after.chunks ]
  %src.phi   = phi i32* [ %arr.base.ptr, %sort.start ], [ %src.next, %after.chunks ]
  %dst.phi   = phi i32* [ %tmp,          %sort.start ], [ %dst.next, %after.chunks ]
  %passes.phi = phi i32 [ 4, %sort.start ], [ %passes.next, %after.chunks ]

  ; chunk loop over i in 0..len step 2*run
  br label %chunk.loop

chunk.loop:
  %i.phi = phi i32 [ 0, %pass.loop ], [ %i.next, %after.merge ]
  %cmp.chunk = icmp ult i32 %i.phi, 10
  br i1 %cmp.chunk, label %merge.setup, label %after.chunks

merge.setup:
  ; compute mid = min(i+run, n), hi = min(i+2*run, n)
  %i.plus.run = add i32 %i.phi, %run.phi
  %mid = call i32 @llvm.umin.i32(i32 %i.plus.run, i32 10)
  %i.plus.2run = add i32 %i.phi, %run.phi
  %i.plus.2run.shl = shl i32 %run.phi, 1
  %i.plus.2run.real = add i32 %i.phi, %i.plus.2run.shl
  %hi = call i32 @llvm.umin.i32(i32 %i.plus.2run.real, i32 10)

  ; quick check: if hi <= i then skip (no elements)
  %hi.le.i = icmp ule i32 %hi, %i.phi
  br i1 %hi.le.i, label %after.merge.skip, label %merge.loop

merge.loop:
  ; p = i, l = i, r = mid
  br label %merge.body

merge.body:
  %p.phi  = phi i32 [ %i.phi, %merge.loop ], [ %p.next, %store.and.inc ]
  %l.phi  = phi i32 [ %i.phi, %merge.loop ], [ %l.next, %store.and.inc ]
  %r.phi  = phi i32 [ %mid,   %merge.loop ], [ %r.next, %store.and.inc ]

  ; while p < hi
  %p.lt.hi = icmp ult i32 %p.phi, %hi
  br i1 %p.lt.hi, label %select.side, label %after.merge

select.side:
  ; decide whether to take from right or left:
  ; takeRight if r < hi and (l >= mid or src[r] < src[l])
  %r.lt.hi = icmp ult i32 %r.phi, %hi
  %l.ge.mid = icmp uge i32 %l.phi, %mid

  ; load src[l] and src[r] guarded
  %l.idx64 = zext i32 %l.phi to i64
  %r.idx64 = zext i32 %r.phi to i64
  %src.l.ptr = getelementptr inbounds i32, i32* %src.phi, i64 %l.idx64
  %src.r.ptr = getelementptr inbounds i32, i32* %src.phi, i64 %r.idx64
  %l.val = load i32, i32* %src.l.ptr, align 4
  %r.val = load i32, i32* %src.r.ptr, align 4

  %r.lt.l = icmp slt i32 %r.val, %l.val
  %takeRight.pre = or i1 %l.ge.mid, %r.lt.l
  %takeRight = and i1 %r.lt.hi, %takeRight.pre

  br i1 %takeRight, label %take.right, label %take.left

take.right:
  ; dst[p] = src[r]; r++
  %dst.p.ptr.r = getelementptr inbounds i32, i32* %dst.phi, i64 (zext i32 %p.phi to i64)
  store i32 %r.val, i32* %dst.p.ptr.r, align 4
  %p.next.r = add i32 %p.phi, 1
  %r.next.r = add i32 %r.phi, 1
  br label %store.and.inc

take.left:
  ; dst[p] = src[l]; l++
  %dst.p.ptr.l = getelementptr inbounds i32, i32* %dst.phi, i64 (zext i32 %p.phi to i64)
  store i32 %l.val, i32* %dst.p.ptr.l, align 4
  %p.next.l = add i32 %p.phi, 1
  %l.next.l = add i32 %l.phi, 1
  br label %store.and.inc

store.and.inc:
  ; join increments
  %p.next = phi i32 [ %p.next.r, %take.right ], [ %p.next.l, %take.left ]
  %l.next = phi i32 [ %l.phi,    %take.right ], [ %l.next.l,  %take.left ]
  %r.next = phi i32 [ %r.next.r, %take.right ], [ %r.phi,     %take.left ]
  br label %merge.body

after.merge:
  ; next chunk i += 2*run
  %two.run = shl i32 %run.phi, 1
  %i.next = add i32 %i.phi, %two.run
  br label %chunk.loop

after.merge.skip:
  ; skip this chunk, i += 2*run
  %two.run.skip = shl i32 %run.phi, 1
  %i.next.skip = add i32 %i.phi, %two.run.skip
  br label %after.merge

after.chunks:
  ; decrement passes; if zero, finish without swapping; else swap src/dst and continue
  %passes.next = add i32 %passes.phi, -1
  %done = icmp eq i32 %passes.next, 0
  br i1 %done, label %finish.sort, label %swap.and.next

swap.and.next:
  ; swap src/dst, double run
  %run.next = shl i32 %run.phi, 1
  %src.next = %dst.phi
  %dst.next = %src.phi
  br label %pass.loop

finish.sort:
  ; if final results are not in arr, copy 10 ints from dst to arr
  %arr.base2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %dst.is.arr = icmp eq i32* %dst.phi, %arr.base2
  br i1 %dst.is.arr, label %free.tmp, label %copy.back

copy.back:
  br label %copy.loop

copy.loop:
  %ci = phi i32 [ 0, %copy.back ], [ %ci.next, %copy.loop ]
  %ci.cmp = icmp ult i32 %ci, 10
  br i1 %ci.cmp, label %copy.body, label %free.tmp

copy.body:
  %ci64 = zext i32 %ci to i64
  %src.cpy.ptr = getelementptr inbounds i32, i32* %dst.phi, i64 %ci64
  %val.cpy = load i32, i32* %src.cpy.ptr, align 4
  %dst.cpy.ptr = getelementptr inbounds i32, i32* %arr.base2, i64 %ci64
  store i32 %val.cpy, i32* %dst.cpy.ptr, align 4
  %ci.next = add i32 %ci, 1
  br label %copy.loop

free.tmp:
  call void @free(i8* %tmp.raw)
  br label %print

; -------- printing ----------
print:
  ; base pointer for printing is the stack array
  %arr.base.print = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  br label %pr.loop

pr.loop:
  %pi = phi i32 [ 0, %print ], [ %pi.next, %pr.loop ]
  %pi.cmp = icmp ult i32 %pi, 10
  br i1 %pi.cmp, label %pr.body, label %pr.newline

pr.body:
  %pi64 = zext i32 %pi to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr.base.print, i64 %pi64
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %elem)
  %pi.next = add i32 %pi, 1
  br label %pr.loop

pr.newline:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}

; min for unsigned i32
declare i32 @llvm.umin.i32(i32, i32) nounwind readnone willreturn intrinsic

; NOTE:
; - This IR mirrors the observed binary behavior:
;   * Initializes array [9,1,5,3,7,2,8,6,4,0] on stack
;   * Allocates 40-byte tmp buffer; if allocation fails, skips sorting
;   * Performs 4 bottom-up mergesort passes (run sizes 1,2,4,8), swapping src/dst each pass
;   * Copies back to the stack array if the final result is in the tmp buffer
;   * Frees tmp buffer (if allocated)
;   * Prints the 10 integers with __printf_chk(1, "%d ") followed by a newline
; - Stack protector and CRT init/fini stubs are omitted in IR (not required for semantics).