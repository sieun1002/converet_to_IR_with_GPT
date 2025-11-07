; ModuleID = 'main'
target triple = "x86_64-pc-linux-gnu"

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl  = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  store [10 x i32] [i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 3, i32 2, i32 4, i32 1], [10 x i32]* %arr, align 16
  br label %outer

outer:
  %bound = phi i32 [ 10, %entry ], [ %bound.next, %outerContinue ]
  br label %inner

inner:
  %i = phi i32 [ 1, %outer ], [ %i.next, %inner_latch ]
  %last = phi i32 [ 0, %outer ], [ %last.next, %inner_latch ]
  %iMinus1 = add nsw i32 %i, -1
  %idxA64 = sext i32 %iMinus1 to i64
  %idxB64 = sext i32 %i to i64
  %aPtr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxA64
  %bPtr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxB64
  %aVal = load i32, i32* %aPtr, align 4
  %bVal = load i32, i32* %bPtr, align 4
  %cmp = icmp sgt i32 %aVal, %bVal
  br i1 %cmp, label %doSwap, label %noSwap

doSwap:
  store i32 %bVal, i32* %aPtr, align 4
  store i32 %aVal, i32* %bPtr, align 4
  br label %inner_latch

noSwap:
  br label %inner_latch

inner_latch:
  %last.next = phi i32 [ %i, %doSwap ], [ %last, %noSwap ]
  %i.next = add nuw nsw i32 %i, 1
  %cmp.cont = icmp slt i32 %i.next, %bound
  br i1 %cmp.cont, label %inner, label %afterInner

afterInner:
  %cond.done = icmp ule i32 %last.next, 1
  br i1 %cond.done, label %print.loop, label %outerContinue

outerContinue:
  %bound.next = phi i32 [ %last.next, %afterInner ]
  br label %outer

print.loop:
  %p = phi i32 [ 0, %afterInner ], [ %p.next, %print.latch ]
  %p64 = sext i32 %p to i64
  %elemPtr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %p64
  %elem = load i32, i32* %elemPtr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmtptr, i32 %elem)
  br label %print.latch

print.latch:
  %p.next = add nuw nsw i32 %p, 1
  %cmp.print = icmp ult i32 %p.next, 10
  br i1 %cmp.print, label %print.loop, label %print.end

print.end:
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nlptr)
  ret i32 0
}