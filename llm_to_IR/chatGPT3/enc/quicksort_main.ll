; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10A0
; Intent: Entry point for program execution (confidence=1.00). Evidence: standard main signature
; Preconditions: argc ≥ 0, argv is a null-terminated array of C strings.
; Postconditions: Returns 0 on success.

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @quick_sort(i32* %base, i32 %size)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %var_20 = alloca i64
  %var_48 = alloca i64
  %array_base = alloca i32, i64 9

  ; Prepare stack canary
  %fsbase = load i64, i64* inttoptr (i64 0x28 to i64*)
  store i64 %fsbase, i64* %var_20
  
  ; Initialize the array with specific values (not shown in disassembly)
  store i64 100000009, i64* %var_48
  store i64 300000005, i64* getelementptr (i64, i64* %var_48, i32 1)
  store i64 200000007, i64* getelementptr (i64, i64* %var_48, i32 2)
  store i64 600000008, i64* getelementptr (i64, i64* %var_48, i32 3)
  store i32 4, i32* getelementptr (i32, i32* %array_base, i32 8)

  ; Calls sorting algorithm
  %base_ptr = bitcast i32* %array_base to i8*
  call void @quick_sort(i32* %array_base, i32 9)

  ; Print sorted array
  %fmt_ptr = bitcast [4 x i8]* @format to i8*
  br label %loop

loop:
  %current = phi i32* [ %array_base, %entry ], [ %next, %loopcheck ]
  %value = load i32, i32* %current
  call i32 (i8*, ...) @printf(i8* %fmt_ptr, i32 %value)
  %next = getelementptr inbounds i32, i32* %current, i32 1
  %end_check = icmp eq i32* %next, getelementptr (i32, i32* %array_base, i32 9)
  br i1 %end_check, label %newline, label %loop

newline:
  call i32 @putchar(i32 10)
  %stack_chk = load i64, i64* %var_20
  %canary_fail = icmp ne i64 %stack_chk, %fsbase
  br i1 %canary_fail, label %failed, label %exit

failed:
  call void @__stack_chk_fail()
  unreachable

exit:
  ret i32 0
}

@format = private unnamed_addr constant [4 x i8] c"%d\00"
