; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x0000000000001080
; Intent: Bubble-sort a small int array and print it (confidence=0.95). Evidence: optimized bubble sort with last-swap bound; printf of "%d " then "\n".
; Preconditions: none
; Postconditions: prints 10 integers in nondecreasing order, returns 0

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %guard = alloca i64, align 8
  store i64 0, i64* %guard, align 8

  ; initialize array elements per observed stores
  %a0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %a1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  %a2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  %a3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  %a4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  %a5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  %a6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  %a7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  %a8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  ; note: element 9 is intentionally left uninitialized as in the binary

  store i32 9,  i32* %a0, align 4
  store i32 1,  i32* %a1, align 4
  store i32 5,  i32* %a2, align 4
  store i32 3,  i32* %a3, align 4
  store i32 7,  i32* %a4, align 4
  store i32 2,  i32* %a5, align 4
  store i32 8,  i32* %a6, align 4
  store i32 6,  i32* %a7, align 4
  store i32 4,  i32* %a8, align 4

  br label %outer

outer:                                            ; outer pass with shrinking bound
  %limit = phi i64 [ 10, %entry ], [ %ls, %outer.loop.back ]
  %prev0 = load i32, i32* %a0, align 4
  br label %inner

inner:
  %i = phi i64 [ 1, %outer ], [ %i.next, %inner.next ]
  %lastSwap = phi i64 [ 0, %outer ], [ %lastSwap.new, %inner.next ]
  %prev = phi i32 [ %prev0, %outer ], [ %prev.new, %inner.next ]
  %cond = icmp ult i64 %i, %limit
  br i1 %cond, label %inner.body, label %outer.end

inner.body:
  %cur.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %cur = load i32, i32* %cur.ptr, align 4
  %lt = icmp slt i32 %cur, %prev
  br i1 %lt, label %swap, label %noswap

swap:                                             ; perform swap and mark last swap index
  %im1 = add i64 %i, -1
  %prev.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %im1
  store i32 %cur,  i32* %prev.ptr, align 4
  store i32 %prev, i32* %cur.ptr,  align 4
  br label %inner.next

noswap:                                           ; advance prev
  br label %inner.next

inner.next:
  %lastSwap.new = phi i64 [ %i, %swap ], [ %lastSwap, %noswap ]
  %prev.new = phi i32 [ %prev, %swap ], [ %cur, %noswap ]
  %i.next = add nuw nsw i64 %i, 1
  br label %inner

outer.end:
  %ls = phi i64 [ %lastSwap, %inner ]
  %done = icmp ule i64 %ls, 1
  br i1 %done, label %print, label %outer.loop.back

outer.loop.back:
  br label %outer

print:
  ; print the 10 integers
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  br label %p.loop

p.loop:
  %pi = phi i64 [ 0, %print ], [ %pi.next, %p.loop.body ]
  %pcond = icmp ult i64 %pi, 10
  br i1 %pcond, label %p.loop.body, label %after.print

p.loop.body:
  %vptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %pi
  %val = load i32, i32* %vptr, align 4
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt, i32 %val)
  %pi.next = add nuw nsw i64 %pi, 1
  br label %p.loop

after.print:
  %nl = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl)
  %g2 = load i64, i64* %guard, align 8
  %ok = icmp eq i64 %g2, 0
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}