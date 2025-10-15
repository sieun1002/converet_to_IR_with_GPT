; ModuleID = 'main.ll'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.nl  = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail() noreturn

define i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %canary.save = alloca i64, align 8

  %canary.init = call i64 asm "movq %fs:0x28, $0", "=r"()
  store i64 %canary.init, ptr %canary.save, align 8

  %arr.base = getelementptr inbounds [10 x i32], ptr %arr, i64 0, i64 0
  store i32 9, ptr %arr.base, align 16
  %p1 = getelementptr inbounds i32, ptr %arr.base, i64 1
  store i32 0, ptr %p1, align 4
  %p2 = getelementptr inbounds i32, ptr %arr.base, i64 2
  store i32 8, ptr %p2, align 8
  %p3 = getelementptr inbounds i32, ptr %arr.base, i64 3
  store i32 1, ptr %p3, align 4
  %p4 = getelementptr inbounds i32, ptr %arr.base, i64 4
  store i32 7, ptr %p4, align 16
  %p5 = getelementptr inbounds i32, ptr %arr.base, i64 5
  store i32 2, ptr %p5, align 4
  %p6 = getelementptr inbounds i32, ptr %arr.base, i64 6
  store i32 6, ptr %p6, align 8
  %p7 = getelementptr inbounds i32, ptr %arr.base, i64 7
  store i32 3, ptr %p7, align 4
  %p8 = getelementptr inbounds i32, ptr %arr.base, i64 8
  store i32 4, ptr %p8, align 16
  %p9 = getelementptr inbounds i32, ptr %arr.base, i64 9
  store i32 5, ptr %p9, align 4

  br label %outer

outer:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %cont = icmp slt i32 %i, 9
  br i1 %cont, label %body, label %sort.done

body:
  %idx.i64 = sext i32 %i to i64
  %pi = getelementptr inbounds [10 x i32], ptr %arr, i64 0, i64 %idx.i64
  %pi1 = getelementptr inbounds i32, ptr %pi, i64 1
  %ai = load i32, ptr %pi, align 4
  %ai1 = load i32, ptr %pi1, align 4
  %le = icmp sle i32 %ai, %ai1
  br i1 %le, label %outer.latch, label %insert

insert:
  %temp = load i32, ptr %pi1, align 4
  br label %inner

inner:
  %j = phi i32 [ %i, %insert ], [ %j.dec, %shift ]
  %j.i64 = sext i32 %j to i64
  %pj = getelementptr inbounds [10 x i32], ptr %arr, i64 0, i64 %j.i64
  %aj = load i32, ptr %pj, align 4
  %gt = icmp sgt i32 %aj, %temp
  br i1 %gt, label %shift, label %place

shift:
  %pj1 = getelementptr inbounds i32, ptr %pj, i64 1
  store i32 %aj, ptr %pj1, align 4
  %j.dec = add nsw i32 %j, -1
  %ge0 = icmp sge i32 %j.dec, 0
  br i1 %ge0, label %inner, label %place.at.neg

place.at.neg:
  %p0 = getelementptr inbounds [10 x i32], ptr %arr, i64 0, i64 0
  store i32 %temp, ptr %p0, align 16
  br label %outer.latch

place:
  %dest.idx = add nsw i32 %j, 1
  %dest.idx64 = sext i32 %dest.idx to i64
  %pd = getelementptr inbounds [10 x i32], ptr %arr, i64 0, i64 %dest.idx64
  store i32 %temp, ptr %pd, align 4
  br label %outer.latch

outer.latch:
  %i.next = add nuw nsw i32 %i, 1
  br label %outer

sort.done:
  %start = getelementptr inbounds [10 x i32], ptr %arr, i64 0, i64 0
  %end = getelementptr inbounds [10 x i32], ptr %arr, i64 0, i64 10
  br label %print.loop

print.loop:
  %pcur = phi ptr [ %start, %sort.done ], [ %pnext, %print.body ]
  %more = icmp ne ptr %pcur, %end
  br i1 %more, label %print.body, label %after.print

print.body:
  %val = load i32, ptr %pcur, align 4
  %fmt = getelementptr inbounds [4 x i8], ptr @.str.fmt, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt, i32 %val)
  %pnext = getelementptr inbounds i32, ptr %pcur, i64 1
  br label %print.loop

after.print:
  %nl = getelementptr inbounds [2 x i8], ptr @.str.nl, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl)

  %canary.cur = call i64 asm "movq %fs:0x28, $0", "=r"()
  %canary.saved = load i64, ptr %canary.save, align 8
  %ok = icmp eq i64 %canary.cur, %canary.saved
  br i1 %ok, label %ret, label %stkfail

stkfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}