; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x11D7
; Intent: Perform linear search on a fixed int array and print result (confidence=0.96). Evidence: call to linear_search; printf/puts with messages about found index/not found.
; Preconditions: linear_search(int*, int, int) returns index or -1.
; Postconditions: prints outcome; returns 0; triggers __stack_chk_fail on stack canary mismatch.

; Only the necessary external declarations:
declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare void @__stack_chk_fail()

@.str.found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00"
@.str.notfound = private unnamed_addr constant [18 x i8] c"Element not found\00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  %stack_canary.save = alloca i64, align 8
  %arr = alloca [5 x i32], align 16

  ; read canary from fs:0x28 and save it
  %canary.init = call i64 asm "movq %fs:0x28, $0", "=r"()
  store i64 %canary.init, i64* %stack_canary.save, align 8

  ; initialize array: {5, 3, 8, 4, 2}
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

  ; call linear_search(&arr[0], 5, 4)
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %idx = call i32 @linear_search(i32* %arrdecay, i32 5, i32 4)

  ; branch on result
  %found = icmp ne i32 %idx, -1
  br i1 %found, label %if.found, label %if.notfound

if.found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str.found, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %idx)
  br label %after.print

if.notfound:
  %notptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.notfound, i64 0, i64 0
  %callputs = call i32 @puts(i8* %notptr)
  br label %after.print

after.print:
  ; check stack canary
  %canary.now = call i64 asm "movq %fs:0x28, $0", "=r"()
  %canary.saved = load i64, i64* %stack_canary.save, align 8
  %ok = icmp eq i64 %canary.saved, %canary.now
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}