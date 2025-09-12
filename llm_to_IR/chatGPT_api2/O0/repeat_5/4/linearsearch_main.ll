; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x11D7
; Intent: Initialize array and perform linear search; print result (confidence=0.95). Evidence: call to linear_search; prints found/not-found messages.
; Preconditions: None
; Postconditions: Returns 0; prints search result.

@format = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00"
@s = private unnamed_addr constant [18 x i8] c"Element not found\00"
@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare i32 @linear_search(i32*, i32, i32)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard
  %arr = alloca [5 x i32]
  %p0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %p0
  %p1 = getelementptr inbounds i32, i32* %p0, i64 1
  store i32 3, i32* %p1
  %p2 = getelementptr inbounds i32, i32* %p0, i64 2
  store i32 8, i32* %p2
  %p3 = getelementptr inbounds i32, i32* %p0, i64 3
  store i32 4, i32* %p3
  %p4 = getelementptr inbounds i32, i32* %p0, i64 4
  store i32 2, i32* %p4
  %call = call i32 @linear_search(i32* %p0, i32 5, i32 4)
  %cmp = icmp eq i32 %call, -1
  br i1 %cmp, label %not_found, label %found

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @format, i64 0, i64 0
  %printf_call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %call)
  br label %end

not_found:
  %sptr = getelementptr inbounds [18 x i8], [18 x i8]* @s, i64 0, i64 0
  %puts_call = call i32 @puts(i8* %sptr)
  br label %end

end:
  %guard2 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard, %guard2
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}