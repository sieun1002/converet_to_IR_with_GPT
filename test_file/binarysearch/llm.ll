; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1080
; Intent: Print binary-search results for three keys (2, 5, -5) in a fixed sorted array using a lower_bound loop (confidence=0.95). Evidence: hi/lo loop with mid=(hi-lo)/2+lo and post-check arr[lo]==key; stack-initialized sorted ints -5,-1,0,2,2,3,7,9,12.

; Preconditions: None
; Postconditions: Writes three lines to stdout.

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@.str_nf = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"
@arr = private unnamed_addr constant [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12]
@keys = private unnamed_addr constant [3 x i32] [i32 2, i32 5, i32 -5]

; Only the needed extern declarations:
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
br label %loop.hdr

loop.hdr:
%i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
%cmp = icmp slt i32 %i, 3
br i1 %cmp, label %loop.body, label %exit

loop.body:
%i64 = sext i32 %i to i64
%kptr = getelementptr inbounds [3 x i32], [3 x i32]* @keys, i64 0, i64 %i64
%key = load i32, i32* %kptr, align 4
br label %bs.head

bs.head:
%lo = phi i64 [ 0, %loop.body ], [ %lo.next, %bs.upd ]
%hi = phi i64 [ 9, %loop.body ], [ %hi.next, %bs.upd ]
%cond = icmp ugt i64 %hi, %lo
br i1 %cond, label %bs.calc, label %bs.done

bs.calc:
%diff = sub i64 %hi, %lo
%half = lshr i64 %diff, 1
%mid = add i64 %half, %lo
%aptr = getelementptr inbounds [9 x i32], [9 x i32]* @arr, i64 0, i64 %mid
%aval = load i32, i32* %aptr, align 4
%lt = icmp slt i32 %aval, %key
br i1 %lt, label %bs.setlo, label %bs.sethi

bs.setlo:
%lo.inc = add i64 %mid, 1
br label %bs.upd

bs.sethi:
br label %bs.upd

bs.upd:
%lo.next = phi i64 [ %lo.inc, %bs.setlo ], [ %lo, %bs.sethi ]
%hi.next = phi i64 [ %hi, %bs.setlo ], [ %mid, %bs.sethi ]
br label %bs.head

bs.done:
; final lower_bound index is %lo
%oob = icmp ugt i64 %lo, 8
br i1 %oob, label %notfound, label %check.eq

check.eq:
%aptr2 = getelementptr inbounds [9 x i32], [9 x i32]* @arr, i64 0, i64 %lo
%aval2 = load i32, i32* %aptr2, align 4
%eq = icmp eq i32 %aval2, %key
br i1 %eq, label %found, label %notfound

found:
%fmtF = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtF, i32 %key, i64 %lo)
br label %loop.latch

notfound:
%fmtN = getelementptr inbounds [21 x i8], [21 x i8]* @.str_nf, i64 0, i64 0
call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtN, i32 %key)
br label %loop.latch

loop.latch:
%i.next = add i32 %i, 1
br label %loop.hdr

exit:
ret i32 0
}