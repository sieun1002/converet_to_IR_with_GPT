; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x11D7
; Intent: Search for a key (4) in a 5-element array using linear_search and report the index or not found (confidence=0.95). Evidence: call to linear_search(arr, 5, 4); compare with -1 and printf/puts.

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00"
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00"
@__stack_chk_guard = external local_unnamed_addr global i64

; Only the needed extern declarations:
declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %guard.init = load i64, i64* @__stack_chk_guard
  store i64 %guard.init, i64* %canary.slot, align 8

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

  %call = call i32 @linear_search(i32* %arr0, i32 5, i32 4)
  %cmp = icmp ne i32 %call, -1
  br i1 %cmp, label %found, label %notfound

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %call_printf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %call)
  br label %join

notfound:
  %msgptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %call_puts = call i32 @puts(i8* %msgptr)
  br label %join

join:
  %guard.final = load i64, i64* @__stack_chk_guard
  %canary.loaded = load i64, i64* %canary.slot, align 8
  %canary.ok = icmp eq i64 %canary.loaded, %guard.final
  br i1 %canary.ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}