; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x11D7
; Intent: Search for value in local int array and report index (confidence=0.86). Evidence: calls linear_search(arr, 5, 4), checks -1, prints result.
; Preconditions: none
; Postconditions: returns 0

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare i32 @linear_search(i32*, i32, i32)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [5 x i32], align 16
  %0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %0, align 4
  %1 = getelementptr inbounds i32, i32* %0, i64 1
  store i32 3, i32* %1, align 4
  %2 = getelementptr inbounds i32, i32* %0, i64 2
  store i32 8, i32* %2, align 4
  %3 = getelementptr inbounds i32, i32* %0, i64 3
  store i32 4, i32* %3, align 4
  %4 = getelementptr inbounds i32, i32* %0, i64 4
  store i32 2, i32* %4, align 4
  %call = call i32 @linear_search(i32* %0, i32 5, i32 4)
  %cmp = icmp eq i32 %call, -1
  br i1 %cmp, label %notfound, label %found

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %printfcall = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %call)
  br label %ret

notfound:
  %sptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %putscall = call i32 @puts(i8* %sptr)
  br label %ret

ret:
  ret i32 0
}