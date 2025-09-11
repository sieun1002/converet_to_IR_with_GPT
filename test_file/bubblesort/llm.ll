; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x0000000000001080
; Intent: Bubble-sort 10 fixed ints and print them (confidence=0.95). Evidence: adjacent swaps with last-swap boundary; printing with "%d " then newline.
; Preconditions: None
; Postconditions: Prints the sorted sequence in ascending order.

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Only the needed extern declarations:
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
%arr = alloca [10 x i32], align 16
; initialize array: [9,1,5,3,7,2,8,6,4,0]
%p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
store i32 9, i32* %p0, align 4
%p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
store i32 1, i32* %p1, align 4
%p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
store i32 5, i32* %p2, align 4
%p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
store i32 3, i32* %p3, align 4
%p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
store i32 7, i32* %p4, align 4
%p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
store i32 2, i32* %p5, align 4
%p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
store i32 8, i32* %p6, align 4
%p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
store i32 6, i32* %p7, align 4
%p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
store i32 4, i32* %p8, align 4
%p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
store i32 0, i32* %p9, align 4
br label %outer.cond

outer.cond: ; preds = %outer.next, %entry
%limit = phi i32 [ 10, %entry ], [ %last.exit, %outer.next ]
; left := arr[0]
%p0.ld = load i32, i32* %p0, align 4
br label %inner.cond

inner.cond: ; preds = %inner.cont, %outer.cond
%i = phi i32 [ 1, %outer.cond ], [ %i.next, %inner.cont ]
%left = phi i32 [ %p0.ld, %outer.cond ], [ %left.next, %inner.cont ]
%last = phi i32 [ 0, %outer.cond ], [ %last.next, %inner.cont ]
%cmp.i = icmp slt i32 %i, %limit
br i1 %cmp.i, label %inner.body, label %after.inner

inner.body: ; preds = %inner.cond
%i64 = zext i32 %i to i64
%pi = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i64
%right = load i32, i32* %pi, align 4
%lt = icmp slt i32 %right, %left
br i1 %lt, label %swap, label %noswap

swap: ; preds = %inner.body
%i.minus1 = add i32 %i, -1
%i.minus1.64 = zext i32 %i.minus1 to i64
%pim1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.minus1.64
store i32 %right, i32* %pim1, align 4
store i32 %left, i32* %pi, align 4
br label %inner.cont

noswap: ; preds = %inner.body
br label %inner.cont

inner.cont: ; preds = %noswap, %swap
%left.next = phi i32 [ %left, %swap ], [ %right, %noswap ]
%last.updated = phi i32 [ %i, %swap ], [ %last, %noswap ]
%i.next = add i32 %i, 1
%last.next = %last.updated
br label %inner.cond

after.inner: ; preds = %inner.cond
%last.exit = %last
%le1 = icmp ule i32 %last.exit, 1
br i1 %le1, label %print, label %outer.next

outer.next: ; preds = %after.inner
br label %outer.cond

print: ; preds = %after.inner
br label %print.loop

print.loop: ; preds = %print.loop, %print
%k = phi i32 [ 0, %print ], [ %k.next, %print.loop ]
%k64 = zext i32 %k to i64
%pk = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %k64
%val = load i32, i32* %pk, align 4
%fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
%call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt, i32 %val)
%k.next = add i32 %k, 1
%cont = icmp slt i32 %k.next, 10
br i1 %cont, label %print.loop, label %print.after

print.after: ; preds = %print.loop
%nlp = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
%call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlp)
ret i32 0
}