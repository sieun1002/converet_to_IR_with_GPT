; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1080
; Intent: Print binary-search results for three keys over a sorted array (confidence=0.92). Evidence: lower_bound-style loop with high=9, cmp against key; format strings "key %d -> index %ld" and "key %d -> not found"

; Only the necessary external declarations:
declare i32 @__printf_chk(i32, i8*, ...)

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str_notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  ; local arrays
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16

  ; initialize sorted array: [-5, -1, 0, 2, 2, 3, 7, 9, 12]
  %a0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %a0, align 4
  %a1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %a1, align 4
  %a2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %a2, align 4
  %a3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %a3, align 4
  %a4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %a4, align 4
  %a5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %a5, align 4
  %a6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %a6, align 4
  %a7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %a7, align 4
  %a8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %a8, align 4

  ; initialize keys: [2, 5, -5]
  %k0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %k0, align 4
  %k1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %k1, align 4
  %k2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %k2, align 4

  br label %loop

loop:                                             ; i in [0..2]
  %i = phi i64 [ 0, %entry ], [ %i.next, %after_print ]
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key = load i32, i32* %keyptr, align 4

  ; lower_bound style binary search: low=0, high=9
  br label %bs.loop

bs.loop:
  %low = phi i64 [ 0, %loop ], [ %low2, %bs.next ]
  %high = phi i64 [ 9, %loop ], [ %high2, %bs.next ]
  %cond = icmp ugt i64 %high, %low
  br i1 %cond, label %bs.body, label %bs.exit

bs.body:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %eltptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %mid
  %elt = load i32, i32* %eltptr, align 4
  %lt = icmp slt i32 %elt, %key
  %midp1 = add i64 %mid, 1
  %low2 = select i1 %lt, i64 %midp1, i64 %low
  %high2 = select i1 %lt, i64 %high, i64 %mid
  br label %bs.next

bs.next:
  br label %bs.loop

bs.exit:
  ; check match at low (if low <= 8 and arr[low] == key)
  %inrange = icmp ule i64 %low, 8
  br i1 %inrange, label %check.value, label %notfound

check.value:
  %chkptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %low
  %chkv = load i32, i32* %chkptr, align 4
  %eq = icmp eq i32 %chkv, %key
  br i1 %eq, label %found, label %notfound

found:
  %fmtA = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtA, i32 %key, i64 %low)
  br label %after_print

notfound:
  %fmtB = getelementptr inbounds [21 x i8], [21 x i8]* @.str_notfound, i64 0, i64 0
  call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtB, i32 %key)
  br label %after_print

after_print:
  %i.next = add nuw nsw i64 %i, 1
  %cont = icmp ult i64 %i.next, 3
  br i1 %cont, label %loop, label %ret

ret:
  ret i32 0
}