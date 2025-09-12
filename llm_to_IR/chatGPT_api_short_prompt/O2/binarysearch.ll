; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1080
; Intent: demonstrate lower_bound-style binary search over a static sorted array and print results for 3 keys (confidence=0.86). Evidence: mid computation and jl branch; array contents reconstructed from stacked 64-bit stores.

; Only the necessary external declarations:
declare i32 @__printf_chk(i32, i8*, ...)

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str_not_found = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

@arr = private unnamed_addr constant [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12], align 16
@keys = private unnamed_addr constant [3 x i32] [i32 2, i32 5, i32 -5], align 16

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  br label %keys_loop

keys_loop:                                         ; for (k = 0; k < 3; ++k)
  %k = phi i32 [ 0, %entry ], [ %k.next, %after_print ]
  %cmp.k = icmp slt i32 %k, 3
  br i1 %cmp.k, label %do_search, label %ret0

do_search:
  %k.i64 = sext i32 %k to i64
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* @keys, i64 0, i64 %k.i64
  %key = load i32, i32* %key.ptr, align 4

  ; lower_bound over arr[0..8], using hi initialized to 9 (exclusive upper bound)
  br label %lb.loop

lb.loop:
  %lo = phi i64 [ 0, %do_search ], [ %lo.next, %lb.inc ]
  %hi = phi i64 [ 9, %do_search ], [ %hi.next, %lb.inc ]
  %cond = icmp ugt i64 %hi, %lo
  br i1 %cond, label %lb.body, label %lb.end

lb.body:
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %mid.ptr = getelementptr inbounds [9 x i32], [9 x i32]* @arr, i64 0, i64 %mid
  %mid.val = load i32, i32* %mid.ptr, align 4
  %cmp.mid = icmp slt i32 %mid.val, %key
  br i1 %cmp.mid, label %set.lo, label %set.hi

set.lo:
  %mid.plus = add i64 %mid, 1
  br label %lb.inc

set.hi:
  br label %lb.inc

lb.inc:
  %hi.next = phi i64 [ %hi, %set.lo ], [ %mid, %set.hi ]
  %lo.next = phi i64 [ %mid.plus, %set.lo ], [ %lo, %set.hi ]
  br label %lb.loop

lb.end:
  ; lo is lower_bound index. Check lo <= 8 and arr[lo] == key
  %lo.le.8 = icmp ule i64 %lo, 8
  br i1 %lo.le.8, label %chk.eq, label %print_not_found

chk.eq:
  %val.ptr = getelementptr inbounds [9 x i32], [9 x i32]* @arr, i64 0, i64 %lo
  %val = load i32, i32* %val.ptr, align 4
  %eq = icmp eq i32 %val, %key
  br i1 %eq, label %print_found, label %print_not_found

print_found:
  %fmt.found = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  %idx64 = sext i64 %lo to i64
  call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.found, i32 %key, i64 %idx64)
  br label %after_print

print_not_found:
  %fmt.nf = getelementptr inbounds [21 x i8], [21 x i8]* @.str_not_found, i64 0, i64 0
  call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.nf, i32 %key)
  br label %after_print

after_print:
  %k.next = add nsw i32 %k, 1
  br label %keys_loop

ret0:
  ret i32 0
}