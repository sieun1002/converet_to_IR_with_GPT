; target triple and (optional) datalayout for x86_64 Linux
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl  = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; externs from libc/glibc
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail() nounwind

; stack protector guard (provided by libc)
@__stack_chk_guard = external global i64

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %canary = alloca i64, align 8
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary, align 8

  ; initialize array: 10 integers
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.base, align 4
  %elt1.ptr = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1, i32* %elt1.ptr, align 4
  %elt2.ptr = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 8, i32* %elt2.ptr, align 4
  %elt3.ptr = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 2, i32* %elt3.ptr, align 4
  %elt4.ptr = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7, i32* %elt4.ptr, align 4
  %elt5.ptr = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 3, i32* %elt5.ptr, align 4
  %elt6.ptr = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 6, i32* %elt6.ptr, align 4
  %elt7.ptr = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 5, i32* %elt7.ptr, align 4
  %elt8.ptr = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %elt8.ptr, align 4
  %elt9.ptr = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %elt9.ptr, align 4

  br label %outer.loop

outer.loop:
  %n.phi = phi i32 [ 10, %entry ], [ %lastSwap.out, %outer.tail ]
  br label %inner.header

inner.header:
  %i.phi = phi i32 [ 1, %outer.loop ], [ %i.next, %inner.tail ]
  %lastSwap.phi = phi i32 [ 0, %outer.loop ], [ %lastSwap.next, %inner.tail ]
  %cmp.inner = icmp slt i32 %i.phi, %n.phi
  br i1 %cmp.inner, label %inner.body, label %inner.exit

inner.body:
  %i.minus1 = add nsw i32 %i.phi, -1
  %i.m1.sext = sext i32 %i.minus1 to i64
  %i.sext = sext i32 %i.phi to i64
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.m1.sext
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.sext
  %v0 = load i32, i32* %p0, align 4
  %v1 = load i32, i32* %p1, align 4
  %need.swap = icmp sgt i32 %v0, %v1
  br i1 %need.swap, label %do.swap, label %no.swap

do.swap:
  store i32 %v1, i32* %p0, align 4
  store i32 %v0, i32* %p1, align 4
  br label %inner.tail

no.swap:
  br label %inner.tail

inner.tail:
  %lastSwap.next = phi i32 [ %i.phi, %do.swap ], [ %lastSwap.phi, %no.swap ]
  %i.next = add nuw nsw i32 %i.phi, 1
  br label %inner.header

inner.exit:
  %lastSwap.out = phi i32 [ %lastSwap.phi, %inner.header ]
  %done.outer = icmp ule i32 %lastSwap.out, 1
  br i1 %done.outer, label %print.start, label %outer.tail

outer.tail:
  br label %outer.loop

print.start:
  %begin.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %end.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 10
  br label %print.loop

print.loop:
  %cur.ptr = phi i32* [ %begin.ptr, %print.start ], [ %next.ptr, %print.cont ]
  %done.print = icmp eq i32* %cur.ptr, %end.ptr
  br i1 %done.print, label %print.done, label %print.body

print.body:
  %val.load = load i32, i32* %cur.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i32 %val.load)
  %next.ptr = getelementptr inbounds i32, i32* %cur.ptr, i64 1
  br label %print.cont

print.cont:
  br label %print.loop

print.done:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  %guard.check = load i64, i64* @__stack_chk_guard, align 8
  %canary.load = load i64, i64* %canary, align 8
  %canary.ok = icmp eq i64 %guard.check, %canary.load
  br i1 %canary.ok, label %ret.ok, label %stack.fail

stack.fail:
  call void @__stack_chk_fail()
  unreachable

ret.ok:
  ret i32 0
}