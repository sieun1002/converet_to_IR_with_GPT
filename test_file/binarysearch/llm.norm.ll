; ModuleID = 'cases/binarysearch/llm.ll'
source_filename = "cases/binarysearch/llm.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@.str_nf = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"
@arr = private unnamed_addr constant [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12]
@keys = private unnamed_addr constant [3 x i32] [i32 2, i32 5, i32 -5]

declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  br label %loop.hdr

loop.hdr:                                         ; preds = %loop.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %cmp = icmp slt i32 %i, 3
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop.hdr
  %i64 = sext i32 %i to i64
  %kptr = getelementptr inbounds [3 x i32], [3 x i32]* @keys, i64 0, i64 %i64
  %key = load i32, i32* %kptr, align 4
  br label %bs.head

bs.head:                                          ; preds = %bs.calc, %loop.body
  %lo = phi i64 [ 0, %loop.body ], [ %lo.next, %bs.calc ]
  %hi = phi i64 [ 9, %loop.body ], [ %hi.next, %bs.calc ]
  %cond = icmp ugt i64 %hi, %lo
  br i1 %cond, label %bs.calc, label %bs.done

bs.calc:                                          ; preds = %bs.head
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %half, %lo
  %aptr = getelementptr inbounds [9 x i32], [9 x i32]* @arr, i64 0, i64 %mid
  %aval = load i32, i32* %aptr, align 4
  %lt = icmp slt i32 %aval, %key
  %lo.inc = add i64 %mid, 1
  %lo.next = select i1 %lt, i64 %lo.inc, i64 %lo
  %hi.next = select i1 %lt, i64 %hi, i64 %mid
  br label %bs.head

bs.done:                                          ; preds = %bs.head
  %oob = icmp ugt i64 %lo, 8
  br i1 %oob, label %notfound, label %check.eq

check.eq:                                         ; preds = %bs.done
  %aptr2 = getelementptr inbounds [9 x i32], [9 x i32]* @arr, i64 0, i64 %lo
  %aval2 = load i32, i32* %aptr2, align 4
  %eq = icmp eq i32 %aval2, %key
  br i1 %eq, label %found, label %notfound

found:                                            ; preds = %check.eq
  %0 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str_found, i64 0, i64 0), i32 %key, i64 %lo)
  br label %loop.latch

notfound:                                         ; preds = %check.eq, %bs.done
  %1 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str_nf, i64 0, i64 0), i32 %key)
  br label %loop.latch

loop.latch:                                       ; preds = %notfound, %found
  %i.next = add i32 %i, 1
  br label %loop.hdr

exit:                                             ; preds = %loop.hdr
  ret i32 0
}
