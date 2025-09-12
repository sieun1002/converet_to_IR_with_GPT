; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1100
; Intent: sort a fixed array (confidence=0.90). Evidence: initializes 14 ints, calls timsort_constprop_0, then prints them
; Preconditions: timsort_constprop_0 sorts 14 i32s at the given pointer
; Postconditions: prints the (presumably sorted) 14 elements separated by spaces, then prints -1 and a newline

@.fmt = private unnamed_addr constant [5 x i8] c"%d%s\00", align 1
@.spc = private unnamed_addr constant [2 x i8] c" \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Only the needed extern declarations:
declare void @timsort_constprop_0(i32*)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [14 x i32], align 16
  %0 = getelementptr inbounds [14 x i32], [14 x i32]* %arr, i64 0, i64 0
  ; Initialize: [5,3,1,2,9,5,5,6,7,8,0,4,4,10]
  store i32 5, i32* %0, align 16
  %1 = getelementptr inbounds i32, i32* %0, i64 1
  store i32 3, i32* %1, align 4
  %2 = getelementptr inbounds i32, i32* %0, i64 2
  store i32 1, i32* %2, align 8
  %3 = getelementptr inbounds i32, i32* %0, i64 3
  store i32 2, i32* %3, align 4
  %4 = getelementptr inbounds i32, i32* %0, i64 4
  store i32 9, i32* %4, align 16
  %5 = getelementptr inbounds i32, i32* %0, i64 5
  store i32 5, i32* %5, align 4
  %6 = getelementptr inbounds i32, i32* %0, i64 6
  store i32 5, i32* %6, align 8
  %7 = getelementptr inbounds i32, i32* %0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds i32, i32* %0, i64 8
  store i32 7, i32* %8, align 16
  %9 = getelementptr inbounds i32, i32* %0, i64 9
  store i32 8, i32* %9, align 4
  %10 = getelementptr inbounds i32, i32* %0, i64 10
  store i32 0, i32* %10, align 8
  %11 = getelementptr inbounds i32, i32* %0, i64 11
  store i32 4, i32* %11, align 4
  %12 = getelementptr inbounds i32, i32* %0, i64 12
  store i32 4, i32* %12, align 16
  %13 = getelementptr inbounds i32, i32* %0, i64 13
  store i32 10, i32* %13, align 4

  ; sort
  call void @timsort_constprop_0(i32* nonnull %0)

  ; printing loop for 14 elements
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp ult i64 %i, 14
  br i1 %cmp, label %loop.body, label %after_loop

loop.body:
  %elem.ptr = getelementptr inbounds i32, i32* %0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [5 x i8], [5 x i8]* @.fmt, i64 0, i64 0
  %spc.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.spc, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %elem, i8* %spc.ptr)
  %i.next = add i64 %i, 1
  br label %loop

after_loop:
  ; print -1 and newline
  %fmt.ptr2 = getelementptr inbounds [5 x i8], [5 x i8]* @.fmt, i64 0, i64 0
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr2, i32 -1, i8* %nl.ptr)
  ret i32 0
}