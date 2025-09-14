; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1214
; Intent: test binary_search and print results (confidence=0.88). Evidence: initializes array and key set; calls binary_search and prints "index"/"not found".
; Preconditions: array is sorted ascending (required by binary_search)
; Postconditions: prints search results for each key

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)
declare i64 @binary_search(i32*, i64, i32)
declare i32 @printf(i8*, ...)
declare void @__stack_chk_fail()

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %stack_canary = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %n = alloca i64, align 8
  %kcount = alloca i64, align 8
  %i = alloca i64, align 8
  %idx = alloca i64, align 8

  %canary.init = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  store i64 %canary.init, i64* %stack_canary, align 8

  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 4
  %gep1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 -1, i32* %gep1, align 4
  %gep2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 0, i32* %gep2, align 4
  %gep3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 2, i32* %gep3, align 4
  %gep4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 2, i32* %gep4, align 4
  %gep5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 3, i32* %gep5, align 4
  %gep6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 7, i32* %gep6, align 4
  %gep7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 9, i32* %gep7, align 4
  %gep8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 12, i32* %gep8, align 4

  store i64 9, i64* %n, align 8

  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2, align 4

  store i64 3, i64* %kcount, align 8
  store i64 0, i64* %i, align 8

  br label %loop

loop:                                             ; preds = %inc, %entry
  %i.val = load i64, i64* %i, align 8
  %kcount.val = load i64, i64* %kcount, align 8
  %cmp = icmp ult i64 %i.val, %kcount.val
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.val
  %key = load i32, i32* %keyptr, align 4
  %n.val = load i64, i64* %n, align 8
  %res = call i64 @binary_search(i32* %arr0, i64 %n.val, i32 %key)
  store i64 %res, i64* %idx, align 8
  %neg = icmp slt i64 %res, 0
  br i1 %neg, label %notfound, label %found

found:                                            ; preds = %body
  %fmt = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %res.ld = load i64, i64* %idx, align 8
  %call.ok = call i32 (i8*, ...) @printf(i8* %fmt, i32 %key, i64 %res.ld)
  br label %inc

notfound:                                         ; preds = %body
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call.nf = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %inc

inc:                                              ; preds = %notfound, %found
  %next = add i64 %i.val, 1
  store i64 %next, i64* %i, align 8
  br label %loop

after:                                            ; preds = %loop
  %saved.canary = load i64, i64* %stack_canary, align 8
  %canary.now = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  %ok = icmp eq i64 %saved.canary, %canary.now
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %after
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after
  ret i32 0
}