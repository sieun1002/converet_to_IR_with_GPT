; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x11D7
; Intent: Search for an element in a local int array using linear_search and report result (confidence=0.94). Evidence: call to linear_search with arr/n/x; printf/puts with “found/not found” messages
; Preconditions: linear_search(int* arr, int n, int x) returns index or -1
; Postconditions: returns 0

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare i32 @linear_search(i32*, i32, i32)

@.str.found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.notfound = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [5 x i32], align 16
  %0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %0, align 16
  %1 = getelementptr inbounds i32, i32* %0, i64 1
  store i32 3, i32* %1, align 4
  %2 = getelementptr inbounds i32, i32* %0, i64 2
  store i32 8, i32* %2, align 8
  %3 = getelementptr inbounds i32, i32* %0, i64 3
  store i32 4, i32* %3, align 4
  %4 = getelementptr inbounds i32, i32* %0, i64 4
  store i32 2, i32* %4, align 16
  %idx = call i32 @linear_search(i32* %0, i32 5, i32 4)
  %cmp = icmp eq i32 %idx, -1
  br i1 %cmp, label %notfound, label %found

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str.found, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %idx)
  br label %done

notfound:
  %strptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.notfound, i64 0, i64 0
  %callq = call i32 @puts(i8* %strptr)
  br label %done

done:
  ret i32 0
}