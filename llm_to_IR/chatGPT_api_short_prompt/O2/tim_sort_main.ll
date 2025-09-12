; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x0000000000001100
; Intent: sort and print static array (confidence=0.89). Evidence: calls timsort_constprop_0; prints with __printf_chk

; Only the necessary external declarations:
declare i32 @__printf_chk(i32, i8*, ...)
declare void @timsort_constprop_0(i32*)

@.str = private unnamed_addr constant [4 x i8] c"%d%s\00", align 1
@.spc = private unnamed_addr constant [2 x i8] c" \00", align 1
@.nl  = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [15 x i32], align 16

  ; initialize the 15-element array
  store [15 x i32] [i32 5, i32 3, i32 1, i32 2, i32 9, i32 5, i32 5, i32 6, i32 7, i32 8, i32 0, i32 4, i32 4, i32 10, i32 -1], [15 x i32]* %arr, align 16

  ; call timsort on the array
  %arr0 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 0
  call void @timsort_constprop_0(i32* %arr0)

  ; common constants
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %spc = getelementptr inbounds [2 x i8], [2 x i8]* @.spc, i64 0, i64 0
  %nlp = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0

  ; print first 14 elements with trailing space
  br label %loop

loop:                                             ; preds = %entry, %loop
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %elt.ptr = getelementptr inbounds i32, i32* %arr0, i64 (i64 sext (i32 %i to i64))
  %val = load i32, i32* %elt.ptr, align 4
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt, i32 %val, i8* %spc)
  %i.next = add nuw nsw i32 %i, 1
  %cmp = icmp ult i32 %i.next, 14
  br i1 %cmp, label %loop, label %after_loop

after_loop:
  ; print last element with newline
  %last.ptr = getelementptr inbounds i32, i32* %arr0, i64 14
  %last = load i32, i32* %last.ptr, align 4
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt, i32 %last, i8* %nlp)

  ret i32 0
}