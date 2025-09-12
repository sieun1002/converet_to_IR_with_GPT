; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1080
; Intent: Insertion-sort a fixed 10-int array and print it (confidence=0.95). Evidence: inner shifting loop with 4-byte steps; printing with "%d ".
; Preconditions:
; Postconditions: Prints the sorted array followed by newline; returns 0.

; Only the necessary external declarations:
declare i32 @__printf_chk(i32, i8*, ...)

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %0, align 4
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %1, align 4
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %2, align 4
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %3, align 4
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %4, align 4
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %5, align 4
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %6, align 4
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %8, align 4
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %9, align 4
  br label %for.i

for.i:                                            ; outer loop over i = 1..9
  %i = phi i32 [ 1, %entry ], [ %i.next, %outer.latch ]
  %cond = icmp slt i32 %i, 10
  br i1 %cond, label %body, label %after.sort

body:
  %idxprom = sext i32 %i to i64
  %gep.cur = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom
  %key = load i32, i32* %gep.cur, align 4
  %j0 = add nsw i32 %i, -1
  br label %inner

inner:                                            ; while (j >= 0 && a[j] > key) { a[j+1]=a[j]; j--; }
  %j = phi i32 [ %j0, %body ], [ %j.next, %shift ]
  %j.ge0 = icmp sge i32 %j, 0
  br i1 %j.ge0, label %inner.check, label %inner.done

inner.check:
  %j.idx = sext i32 %j to i64
  %gep.j = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %j.idx
  %a_j = load i32, i32* %gep.j, align 4
  %cmp.gt = icmp sgt i32 %a_j, %key
  br i1 %cmp.gt, label %shift, label %inner.done

shift:
  %jp1 = add nsw i32 %j, 1
  %jp1.idx = sext i32 %jp1 to i64
  %gep.jp1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %jp1.idx
  store i32 %a_j, i32* %gep.jp1, align 4
  %j.next = add nsw i32 %j, -1
  br label %inner

inner.done:
  %jp1.done = add nsw i32 %j, 1
  %jp1.done.idx = sext i32 %jp1.done to i64
  %gep.place = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %jp1.done.idx
  store i32 %key, i32* %gep.place, align 4
  br label %outer.latch

outer.latch:
  %i.next = add nsw i32 %i, 1
  br label %for.i

after.sort:                                      ; print the sorted array
  br label %print.loop

print.loop:
  %k = phi i32 [ 0, %after.sort ], [ %k.next, %print.latch ]
  %k.cond = icmp slt i32 %k, 10
  br i1 %k.cond, label %print.body, label %print.done

print.body:
  %k.idx = sext i32 %k to i64
  %gep.k = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %k.idx
  %val = load i32, i32* %gep.k, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtptr, i32 %val)
  br label %print.latch

print.latch:
  %k.next = add nsw i32 %k, 1
  br label %print.loop

print.done:
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlptr)
  ret i32 0
}