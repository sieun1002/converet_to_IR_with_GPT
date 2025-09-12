; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1214
; Intent: Test harness that calls binary_search on a sorted array for several keys and prints the results (confidence=0.95). Evidence: call to binary_search with array pointer/length/key; printf with index or not-found message.
; Preconditions: binary_search(i32* a, i64 n, i32 key) returns a signed index in [0,n) if found, or a negative value if not found. The array is sorted non-decreasingly.
; Postconditions: Prints results for each key; returns 0.

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"
@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare i64 @binary_search(i32*, i64, i32)
declare i32 @printf(i8*, ...)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard0 = load i64, i64* @__stack_chk_guard
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  ; arr = {-5, -1, 0, 2, 2, 3, 7, 9, 12}
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
  ; keys = {2, 5, -5}
  %k0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %k0, align 4
  %k1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %k1, align 4
  %k2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %k2, align 4
  br label %loop.check

loop.check:
  %i = phi i64 [ 0, %entry ], [ %i.next, %cont ]
  %cmp = icmp ult i64 %i, 3
  br i1 %cmp, label %loop.body, label %epilogue

loop.body:
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %idx = call i64 @binary_search(i32* %arr.base, i64 9, i32 %key)
  %found = icmp slt i64 %idx, 0
  br i1 %found, label %notfound, label %found.lbl

found.lbl:
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %key, i64 %idx)
  br label %cont

notfound:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %cont

cont:
  %i.next = add nuw i64 %i, 1
  br label %loop.check

epilogue:
  %guard1 = load i64, i64* @__stack_chk_guard
  %eq = icmp eq i64 %guard0, %guard1
  br i1 %eq, label %ret, label %fail

ret:
  ret i32 0

fail:
  call void @__stack_chk_fail()
  unreachable
}