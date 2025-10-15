; ModuleID = 'binary_search_print'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@aKeyDIndexLd = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@aKeyDNotFound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

@xmmword_2030 = external constant [4 x i32], align 16
@xmmword_2040 = external constant [4 x i32], align 16
@qword_2050   = external constant i64, align 8

declare i32 @___printf_chk(i32, i8*, ...)

define i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 4

  %g0 = load [4 x i32], [4 x i32]* @xmmword_2030, align 16
  %arr0 = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %arr0.vec = bitcast i32* %arr0 to [4 x i32]*
  store [4 x i32] %g0, [4 x i32]* %arr0.vec, align 16

  %g1 = load [4 x i32], [4 x i32]* @xmmword_2040, align 16
  %arr4 = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  %arr4.vec = bitcast i32* %arr4 to [4 x i32]*
  store [4 x i32] %g1, [4 x i32]* %arr4.vec, align 16

  %arr8 = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8, align 4

  %q = load i64, i64* @qword_2050, align 8
  %k0.tr = trunc i64 %q to i32
  %q.sh = lshr i64 %q, 32
  %k1.tr = trunc i64 %q.sh to i32

  %keys0ptr = getelementptr [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 %k0.tr, i32* %keys0ptr, align 4
  %keys1ptr = getelementptr [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 %k1.tr, i32* %keys1ptr, align 4
  %keys2ptr = getelementptr [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2ptr, align 4

  br label %outer.header

outer.header:
  %i = phi i64 [ 0, %entry ], [ %i.next, %after.print ]
  %cmp.outer = icmp ult i64 %i, 3
  br i1 %cmp.outer, label %outer.body, label %outer.end

outer.body:
  %key.ptr = getelementptr [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key.val = load i32, i32* %key.ptr, align 4
  br label %bs.header

bs.header:
  %lo = phi i64 [ 0, %outer.body ], [ %lo.next, %bs.body ]
  %hi = phi i64 [ 9, %outer.body ], [ %hi.next, %bs.body ]
  %cmp = icmp ult i64 %lo, %hi
  br i1 %cmp, label %bs.body, label %bs.after

bs.body:
  %sub = sub i64 %hi, %lo
  %half = lshr i64 %sub, 1
  %mid = add i64 %lo, %half
  %midptr = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 %mid
  %midval = load i32, i32* %midptr, align 4
  %gt = icmp sgt i32 %key.val, %midval
  %mid.plus1 = add i64 %mid, 1
  %hi.next = select i1 %gt, i64 %hi, i64 %mid
  %lo.next = select i1 %gt, i64 %mid.plus1, i64 %lo
  br label %bs.header

bs.after:
  %lo.out = phi i64 [ %lo, %bs.header ]
  %inb = icmp ule i64 %lo.out, 8
  br i1 %inb, label %check.eq, label %notfound

check.eq:
  %cand.ptr = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 %lo.out
  %cand.val = load i32, i32* %cand.ptr, align 4
  %eq = icmp eq i32 %key.val, %cand.val
  br i1 %eq, label %found, label %notfound

found:
  %fmt.idx.ptr = getelementptr [21 x i8], [21 x i8]* @aKeyDIndexLd, i64 0, i64 0
  %print1 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.idx.ptr, i32 %key.val, i64 %lo.out)
  br label %after.print

notfound:
  %fmt.nf.ptr = getelementptr [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %print2 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.nf.ptr, i32 %key.val)
  br label %after.print

after.print:
  %i.next = add i64 %i, 1
  br label %outer.header

outer.end:
  ret i32 0
}