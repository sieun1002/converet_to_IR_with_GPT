; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1080
; Intent: initialize a 10-element i32 array, sort it with quick_sort, then print each element ("%d ") and a newline (confidence=0.95). Evidence: stack-constructed array literals; call to quick_sort; looped __printf_chk with "%d " then "\n".
; Preconditions: quick_sort uses 0-based indices [lo..hi] inclusive on an i32 array.
; Postconditions: prints the sorted sequence followed by a newline; returns 0.

; Only the needed extern declarations:
declare void @quick_sort(i32* nocapture, i64, i64)
declare i32 @__printf_chk(i32, i8*, ...)

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
; allocate local array of 10 i32
%arr = alloca [10 x i32], align 16
%p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
store i32 9, i32* %p0, align 16
%p1 = getelementptr inbounds i32, i32* %p0, i64 1
store i32 1, i32* %p1, align 4
%p2 = getelementptr inbounds i32, i32* %p0, i64 2
store i32 5, i32* %p2, align 8
%p3 = getelementptr inbounds i32, i32* %p0, i64 3
store i32 3, i32* %p3, align 4
%p4 = getelementptr inbounds i32, i32* %p0, i64 4
store i32 7, i32* %p4, align 16
%p5 = getelementptr inbounds i32, i32* %p0, i64 5
store i32 2, i32* %p5, align 4
%p6 = getelementptr inbounds i32, i32* %p0, i64 6
store i32 8, i32* %p6, align 8
%p7 = getelementptr inbounds i32, i32* %p0, i64 7
store i32 6, i32* %p7, align 4
%p8 = getelementptr inbounds i32, i32* %p0, i64 8
store i32 4, i32* %p8, align 16
%p9 = getelementptr inbounds i32, i32* %p0, i64 9
store i32 0, i32* %p9, align 4

; quick_sort(arr, 0, 9)
call void @quick_sort(i32* %p0, i64 0, i64 9)

; print sorted array: for i=0..9 printf("%d ", arr[i])
br label %loop

loop:
%i = phi i64 [ 0, %entry ], [ %i.next, %loop.inc ]
%elt.ptr = getelementptr inbounds i32, i32* %p0, i64 %i
%elt = load i32, i32* %elt.ptr, align 4
%fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
%call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %elt)
br label %loop.inc

loop.inc:
%i.next = add nuw nsw i64 %i, 1
%done = icmp eq i64 %i.next, 10
br i1 %done, label %after, label %loop

after:
; print newline
%nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
%call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
ret i32 0
}