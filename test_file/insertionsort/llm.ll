; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1080
; Intent: insertion sort of 10 signed 32-bit integers and print them (confidence=0.95). Evidence: inner shifting loop with jge-like compare; final loop calling __printf_chk with "%d ".
; Preconditions: none
; Postconditions: prints the sorted sequence followed by a newline.

@.str = private unnamed_addr constant [4 x i8] c"%d \00"
@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00"

; Only the needed extern declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
; local array: 10 i32s initialized to {9,1,5,3,7,2,8,6,4,0}
%arr = alloca [10 x i32], align 16
%base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
store i32 9, i32* %base, align 4
%p1 = getelementptr inbounds i32, i32* %base, i64 1
store i32 1, i32* %p1, align 4
%p2 = getelementptr inbounds i32, i32* %base, i64 2
store i32 5, i32* %p2, align 4
%p3 = getelementptr inbounds i32, i32* %base, i64 3
store i32 3, i32* %p3, align 4
%p4 = getelementptr inbounds i32, i32* %base, i64 4
store i32 7, i32* %p4, align 4
%p5 = getelementptr inbounds i32, i32* %base, i64 5
store i32 2, i32* %p5, align 4
%p6 = getelementptr inbounds i32, i32* %base, i64 6
store i32 8, i32* %p6, align 4
%p7 = getelementptr inbounds i32, i32* %base, i64 7
store i32 6, i32* %p7, align 4
%p8 = getelementptr inbounds i32, i32* %base, i64 8
store i32 4, i32* %p8, align 4
%p9 = getelementptr inbounds i32, i32* %base, i64 9
store i32 0, i32* %p9, align 4
br label %outer

outer: ; i in [1..9]
%i = phi i64 [ 1, %entry ], [ %i.next, %inner.exit ]
%done = icmp sgt i64 %i, 9
br i1 %done, label %print.init, label %outer.body

outer.body:
%iptr = getelementptr inbounds i32, i32* %base, i64 %i
%key = load i32, i32* %iptr, align 4
br label %inner.cond

inner.cond:
%j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.shift ]
%j.gt0 = icmp sgt i64 %j, 0
br i1 %j.gt0, label %inner.cmp, label %inner.exit

inner.cmp:
%jm1 = add i64 %j, -1
%prev.ptr = getelementptr inbounds i32, i32* %base, i64 %jm1
%prev = load i32, i32* %prev.ptr, align 4
%ge = icmp sge i32 %key, %prev
br i1 %ge, label %inner.exit, label %inner.shift

inner.shift:
%j.ptr = getelementptr inbounds i32, i32* %base, i64 %j
store i32 %prev, i32* %j.ptr, align 4
%j.dec = add i64 %j, -1
br label %inner.cond

inner.exit:
%j.fin = phi i64 [ %j, %inner.cond ], [ %j, %inner.cmp ]
%ins.ptr = getelementptr inbounds i32, i32* %base, i64 %j.fin
store i32 %key, i32* %ins.ptr, align 4
%i.next = add i64 %i, 1
br label %outer

print.init:
br label %print.loop

print.loop:
%k = phi i64 [ 0, %print.init ], [ %k.next, %print.loop.body ]
%end = icmp eq i64 %k, 10
br i1 %end, label %print.done, label %print.loop.body

print.loop.body:
%elem.ptr = getelementptr inbounds i32, i32* %base, i64 %k
%elem = load i32, i32* %elem.ptr, align 4
%fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
%call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt, i32 %elem)
%k.next = add i64 %k, 1
br label %print.loop

print.done:
%nl = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0
%call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl)
ret i32 0
}