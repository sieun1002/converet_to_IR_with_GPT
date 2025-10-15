; ModuleID = 'binsearch_keys'
target triple = "x86_64-unknown-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@__stack_chk_guard = external global i64
@xmmword_2030 = external constant [4 x i32], align 16
@xmmword_2040 = external constant [4 x i32], align 16
@qword_2050   = external constant [2 x i32], align 8

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str_nf    = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary.slot, align 8
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0

  %g0.e0.ptr = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_2030, i64 0, i64 0
  %g0.e0 = load i32, i32* %g0.e0.ptr, align 16
  store i32 %g0.e0, i32* %arr.base, align 16

  %arr.e1.ptr = getelementptr inbounds i32, i32* %arr.base, i64 1
  %g0.e1.ptr = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_2030, i64 0, i64 1
  %g0.e1 = load i32, i32* %g0.e1.ptr, align 4
  store i32 %g0.e1, i32* %arr.e1.ptr, align 4

  %arr.e2.ptr = getelementptr inbounds i32, i32* %arr.base, i64 2
  %g0.e2.ptr = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_2030, i64 0, i64 2
  %g0.e2 = load i32, i32* %g0.e2.ptr, align 8
  store i32 %g0.e2, i32* %arr.e2.ptr, align 8

  %arr.e3.ptr = getelementptr inbounds i32, i32* %arr.base, i64 3
  %g0.e3.ptr = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_2030, i64 0, i64 3
  %g0.e3 = load i32, i32* %g0.e3.ptr, align 4
  store i32 %g0.e3, i32* %arr.e3.ptr, align 4

  %arr.e4.ptr = getelementptr inbounds i32, i32* %arr.base, i64 4
  %g1.e0.ptr = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_2040, i64 0, i64 0
  %g1.e0 = load i32, i32* %g1.e0.ptr, align 16
  store i32 %g1.e0, i32* %arr.e4.ptr, align 16

  %arr.e5.ptr = getelementptr inbounds i32, i32* %arr.base, i64 5
  %g1.e1.ptr = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_2040, i64 0, i64 1
  %g1.e1 = load i32, i32* %g1.e1.ptr, align 4
  store i32 %g1.e1, i32* %arr.e5.ptr, align 4

  %arr.e6.ptr = getelementptr inbounds i32, i32* %arr.base, i64 6
  %g1.e2.ptr = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_2040, i64 0, i64 2
  %g1.e2 = load i32, i32* %g1.e2.ptr, align 8
  store i32 %g1.e2, i32* %arr.e6.ptr, align 8

  %arr.e7.ptr = getelementptr inbounds i32, i32* %arr.base, i64 7
  %g1.e3.ptr = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_2040, i64 0, i64 3
  %g1.e3 = load i32, i32* %g1.e3.ptr, align 4
  store i32 %g1.e3, i32* %arr.e7.ptr, align 4

  %arr.e8.ptr = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 12, i32* %arr.e8.ptr, align 4

  %i.init = alloca i32, align 4
  store i32 0, i32* %i.init, align 4
  br label %outer.loop

outer.loop:
  %i.cur = load i32, i32* %i.init, align 4
  %i.cmp = icmp slt i32 %i.cur, 3
  br i1 %i.cmp, label %select.key, label %epilogue

select.key:
  %is.first2 = icmp slt i32 %i.cur, 2
  br i1 %is.first2, label %load.from.qword, label %load.negfive

load.from.qword:
  %i.ext = sext i32 %i.cur to i64
  %q.base = getelementptr inbounds [2 x i32], [2 x i32]* @qword_2050, i64 0, i64 %i.ext
  %key.from.q = load i32, i32* %q.base, align 4
  br label %key.ready

load.negfive:
  %key.neg = add nsw i32 0, -5
  br label %key.ready

key.ready:
  %key.sel = phi i32 [ %key.from.q, %load.from.qword ], [ %key.neg, %load.negfive ]
  br label %bs.init

bs.init:
  %low.init = phi i64 [ 0, %key.ready ]
  %high.init = phi i64 [ 9, %key.ready ]
  br label %bs.check

bs.check:
  %low.cur = phi i64 [ %low.init, %bs.init ], [ %low.merge, %bs.iter ]
  %high.cur = phi i64 [ %high.init, %bs.init ], [ %high.merge, %bs.iter ]
  %cmp.range = icmp ult i64 %low.cur, %high.cur
  br i1 %cmp.range, label %bs.body, label %bs.exit

bs.body:
  %diff = sub i64 %high.cur, %low.cur
  %half = lshr i64 %diff, 1
  %mid = add i64 %low.cur, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %mid
  %elem.val = load i32, i32* %elem.ptr, align 4
  %cmp.sg = icmp sgt i32 %key.sel, %elem.val
  br i1 %cmp.sg, label %bs.update.low, label %bs.update.high

bs.update.low:
  %mid.plus = add i64 %mid, 1
  br label %bs.iter

bs.update.high:
  br label %bs.iter

bs.iter:
  %low.merge = phi i64 [ %mid.plus, %bs.update.low ], [ %low.cur, %bs.update.high ]
  %high.merge = phi i64 [ %high.cur, %bs.update.low ], [ %mid, %bs.update.high ]
  br label %bs.check

bs.exit:
  %index = phi i64 [ %low.cur, %bs.check ]
  %in.bounds = icmp ule i64 %index, 8
  br i1 %in.bounds, label %check.equal, label %print.notfound

check.equal:
  %idx.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %index
  %idx.val = load i32, i32* %idx.ptr, align 4
  %is.eq = icmp eq i32 %idx.val, %key.sel
  br i1 %is.eq, label %print.found, label %print.notfound

print.found:
  %fmt.found.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  %call.found = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.found.ptr, i32 %key.sel, i64 %index)
  br label %loop.inc

print.notfound:
  %fmt.nf.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_nf, i64 0, i64 0
  %call.nf = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.nf.ptr, i32 %key.sel)
  br label %loop.inc

loop.inc:
  %i.next = add nsw i32 %i.cur, 1
  store i32 %i.next, i32* %i.init, align 4
  br label %outer.loop

epilogue:
  %canary.load = load i64, i64* %canary.slot, align 8
  %guard.reload = load i64, i64* @__stack_chk_guard, align 8
  %canary.diff = icmp ne i64 %canary.load, %guard.reload
  br i1 %canary.diff, label %stackfail, label %retok

stackfail:
  call void @__stack_chk_fail()
  unreachable

retok:
  ret i32 0
}