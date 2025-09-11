; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1080
; Intent: Bubble-sort 10 integers then print them (confidence=0.96). Evidence: last-swap optimized adjacent-swap loop; printing "%d " then newline
; Preconditions:
; Postconditions: returns 0 after printing the sorted sequence

; Only the needed extern declarations:
declare i32 @__printf_chk(i32, i8*, ...)

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.strnl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %a0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %a0, align 16
  %a1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %a1
  %a2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %a2
  %a3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %a3
  %a4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %a4
  %a5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %a5
  %a6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %a6
  %a7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %a7
  %a8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %a8
  %a9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %a9
  br label %outer

outer:                                            ; preds = %entry, %outer_continue
  %limit = phi i32 [ 10, %entry ], [ %last, %outer_continue ]
  %prev0 = load i32, i32* %a0, align 16
  br label %inner

inner:                                            ; preds = %inner_next, %outer
  %i = phi i32 [ 1, %outer ], [ %i.next, %inner_next ]
  %prev = phi i32 [ %prev0, %outer ], [ %prev.next, %inner_next ]
  %last = phi i32 [ 0, %outer ], [ %last.upd, %inner_next ]
  %cond.inner = icmp slt i32 %i, %limit
  br i1 %cond.inner, label %inner_body, label %outer_after

inner_body:                                       ; preds = %inner
  %i64 = zext i32 %i to i64
  %curr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i64
  %curr = load i32, i32* %curr.ptr
  %lt = icmp slt i32 %curr, %prev
  br i1 %lt, label %swap, label %noswap

swap:                                             ; preds = %inner_body
  %im1 = add i32 %i, -1
  %im1_64 = zext i32 %im1 to i64
  %prev.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %im1_64
  store i32 %curr, i32* %prev.ptr
  store i32 %prev, i32* %curr.ptr
  br label %inner_next

noswap:                                           ; preds = %inner_body
  br label %inner_next

inner_next:                                       ; preds = %noswap, %swap
  %last.upd = phi i32 [ %i, %swap ], [ %last, %noswap ]
  %prev.next = phi i32 [ %prev, %swap ], [ %curr, %noswap ]
  %i.next = add i32 %i, 1
  br label %inner

outer_after:                                      ; preds = %inner
  %done = icmp ule i32 %last, 1
  br i1 %done, label %print, label %outer_continue

outer_continue:                                   ; preds = %outer_after
  br label %outer

print:                                            ; preds = %outer_after
  br label %print_loop

print_loop:                                       ; preds = %print_loop, %print
  %k = phi i32 [ 0, %print ], [ %k.next, %print_loop ]
  %k64 = zext i32 %k to i64
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %k64
  %val = load i32, i32* %elem.ptr
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt, i32 %val)
  %k.next = add i32 %k, 1
  %done.print = icmp eq i32 %k.next, 10
  br i1 %done.print, label %print_after, label %print_loop

print_after:                                      ; preds = %print_loop
  %nl = getelementptr inbounds [2 x i8], [2 x i8]* @.strnl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl)
  ret i32 0
}