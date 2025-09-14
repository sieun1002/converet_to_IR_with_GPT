; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x11D7
; Intent: Demo linear search and report result (confidence=0.98). Evidence: call to linear_search; printf/puts with "Element found/not found" messages
; Preconditions: None
; Postconditions: Returns 0; prints search result

@.str_found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str_notfound = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1
@__stack_chk_guard = external global i64

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare void @__stack_chk_fail()
declare i32 @linear_search(i32*, i32, i32)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %0, i64* %canary.slot, align 8

  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0, align 16
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr2, align 8
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4, align 8

  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %idx = call i32 @linear_search(i32* %arrptr, i32 5, i32 4)
  %found = icmp ne i32 %idx, -1
  br i1 %found, label %if.found, label %if.notfound

if.found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str_found, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %idx)
  br label %cont

if.notfound:
  %nfptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str_notfound, i64 0, i64 0
  %callputs = call i32 @puts(i8* %nfptr)
  br label %cont

cont:
  %1 = load i64, i64* @__stack_chk_guard, align 8
  %2 = load i64, i64* %canary.slot, align 8
  %cmp = icmp eq i64 %1, %2
  br i1 %cmp, label %ret, label %stkfail

stkfail:
  call void @__stack_chk_fail()
  br label %ret

ret:
  ret i32 0
}