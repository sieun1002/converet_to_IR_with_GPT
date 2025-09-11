; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10A0
; Intent: Parse and print integers (confidence=0.80). Evidence: printing loop, comparison logic
; Preconditions: `argv` contains integer strings.
; Postconditions: Prints integers from `argv`.

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %rsp = alloca i64, align 8
  %var_20 = getelementptr i64, i64* %rsp, i64 -8
  %var_48 = getelementptr i64, i64* %rsp, i64 -24
  %r8_alloc = alloca i32, i32 %argc
  %print_fmt = alloca i8, i8 %format

  store i64 0, i64* %var_20
  store i64 1099511627777, i64* %var_48
  store i32 1, i32* %r8
  store i64 12884901888, i64* %var_40
  store i64 8589934599, i64* %var_38
  store i64 25769803776, i64* %var_30
  store i64 4, i64* %var_28
  store i32 %argc, i32* @TIG_IZ_6dco_argc
  store i8** %argv, i8*** @TIG_IZ_6dco_argv

  br label %loop

loop: 
  %0 = load i8**, i8*** %argv
  %1 = getelementptr i8*, i8** %0, i32 %r8
  %arg_i = load i8*, i8** %1
  
  %str_val = bitcast i8* %arg_i to i32*
  %val_i = trunc i32 %str_val to i32
  %2 = icmp sge i32 %r8_alloc, %str_val
  br i1 %2, label %if.end, label %else

else:
  %val = phi i32 [ %val_i, %loop ], [ 0, %entry ]
  store i32 %val, i32* %r8
  br label %loop

if.end:
  call i32 (i8*, ...) @printf(i8* %format, i32 %val_i)
  %cmp = icmp eq i32 %val, %argc
  br i1 %cmp, label %end, label %loop

end:
  call i32 @putchar(i32 10)
  ret i32 0
}