; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1080
; Intent: Binary search two keys (2 and 5) in a sorted int array, print index or not-found (confidence=0.83). Evidence: lower_bound loop (r=9,l=0), jl update, post-check arr[l]==key with l<=8; prints via __printf_chk with two formats.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
declare i32 @__printf_chk(i32, i8*, ...)

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@.str_nf    = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  ; build local sorted array: {-5, -1, 0, 2, 2, 3, 7, 9, 12}
  %arr = alloca [9 x i32], align 16
  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %p0, align 4
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %p2, align 4
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %p4, align 4
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %p6, align 4
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %p8, align 4

  ; search for key = 2
  %k1 = add nsw i32 0, 2
  br label %bs.loop1

bs.loop1:                                         ; pred: %bs.update1, %entry
  %l1 = phi i64 [ 0, %entry ], [ %l1.next, %bs.update1 ]
  %r1 = phi i64 [ 9, %entry ], [ %r1.next, %bs.update1 ]
  %cmprgl1 = icmp ugt i64 %r1, %l1
  br i1 %cmprgl1, label %bs.body1, label %bs.exit1

bs.body1:                                         ; pred: %bs.loop1
  %diff1 = sub i64 %r1, %l1
  %half1 = lshr i64 %diff1, 1
  %mid1 = add i64 %l1, %half1
  %mid1.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %mid1
  %mid1.val = load i32, i32* %mid1.ptr, align 4
  %lt1 = icmp slt i32 %mid1.val, %k1
  %mid1.plus1 = add i64 %mid1, 1
  %l1.next = select i1 %lt1, i64 %mid1.plus1, i64 %l1
  %r1.next = select i1 %lt1, i64 %r1, i64 %mid1
  br label %bs.loop1

bs.exit1:                                         ; pred: %bs.loop1
  %inrange1 = icmp ule i64 %l1, 8
  br i1 %inrange1, label %check.eq1, label %notfound1

check.eq1:                                        ; pred: %bs.exit1
  %ptrl1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %l1
  %vall1 = load i32, i32* %ptrl1, align 4
  %eq1 = icmp eq i32 %vall1, %k1
  br i1 %eq1, label %found1, label %notfound1

found1:                                           ; pred: %check.eq1
  %fmtf1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  %l1.i64 = sext i64 %l1 to i64
  %callf1 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtf1, i32 %k1, i64 %l1.i64)
  br label %after1

notfound1:                                        ; pred: %check.eq1, %bs.exit1
  %fmtn1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_nf, i64 0, i64 0
  %calln1 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtn1, i32 %k1)
  br label %after1

after1:                                           ; pred: %notfound1, %found1
  ; search for key = 5
  %k2 = add nsw i32 0, 5
  br label %bs.loop2

bs.loop2:                                         ; pred: %bs.update2, %after1
  %l2 = phi i64 [ 0, %after1 ], [ %l2.next, %bs.update2 ]
  %r2 = phi i64 [ 9, %after1 ], [ %r2.next, %bs.update2 ]
  %cmprgl2 = icmp ugt i64 %r2, %l2
  br i1 %cmprgl2, label %bs.body2, label %bs.exit2

bs.body2:                                         ; pred: %bs.loop2
  %diff2 = sub i64 %r2, %l2
  %half2 = lshr i64 %diff2, 1
  %mid2 = add i64 %l2, %half2
  %mid2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %mid2
  %mid2.val = load i32, i32* %mid2.ptr, align 4
  %lt2 = icmp slt i32 %mid2.val, %k2
  %mid2.plus1 = add i64 %mid2, 1
  %l2.next = select i1 %lt2, i64 %mid2.plus1, i64 %l2
  %r2.next = select i1 %lt2, i64 %r2, i64 %mid2
  br label %bs.loop2

bs.exit2:                                         ; pred: %bs.loop2
  %inrange2 = icmp ule i64 %l2, 8
  br i1 %inrange2, label %check.eq2, label %notfound2

check.eq2:                                        ; pred: %bs.exit2
  %ptrl2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %l2
  %vall2 = load i32, i32* %ptrl2, align 4
  %eq2 = icmp eq i32 %vall2, %k2
  br i1 %eq2, label %found2, label %notfound2

found2:                                           ; pred: %check.eq2
  %fmtf2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  %l2.i64 = sext i64 %l2 to i64
  %callf2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtf2, i32 %k2, i64 %l2.i64)
  br label %after2

notfound2:                                        ; pred: %check.eq2, %bs.exit2
  %fmtn2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_nf, i64 0, i64 0
  %calln2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtn2, i32 %k2)
  br label %after2

after2:                                           ; pred: %notfound2, %found2
  ret i32 0

bs.update1:                                       ; No predecessors (placeholder to satisfy structure)
  unreachable

bs.update2:                                       ; No predecessors (placeholder to satisfy structure)
  unreachable
}