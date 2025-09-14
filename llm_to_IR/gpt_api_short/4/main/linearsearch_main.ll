; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x11D7
; Intent: Test linear search and print result (confidence=0.79). Evidence: calls linear_search; prints found/not found messages
; Preconditions: none
; Postconditions: returns 0; prints result to stdout

@format = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@s = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare dso_local i32 @linear_search(i32*, i32, i32) local_unnamed_addr
declare dso_local i32 @_printf(i8*, ...) local_unnamed_addr
declare dso_local i32 @_puts(i8*) local_unnamed_addr

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %key = alloca i32, align 4
  %idx = alloca i32, align 4

  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4, align 4

  store i32 5, i32* %n, align 4
  store i32 4, i32* %key, align 4

  %arr_decay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  %keyval = load i32, i32* %key, align 4
  %call = call i32 @linear_search(i32* %arr_decay, i32 %nval, i32 %keyval)
  store i32 %call, i32* %idx, align 4

  %idxv = load i32, i32* %idx, align 4
  %cmp = icmp eq i32 %idxv, -1
  br i1 %cmp, label %notfound, label %found

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @format, i64 0, i64 0
  %idxv2 = load i32, i32* %idx, align 4
  %callp = call i32 (i8*, ...) @_printf(i8* %fmtptr, i32 %idxv2)
  br label %retblk

notfound:
  %sptr = getelementptr inbounds [18 x i8], [18 x i8]* @s, i64 0, i64 0
  %callputs = call i32 @_puts(i8* %sptr)
  br label %retblk

retblk:
  ret i32 0
}