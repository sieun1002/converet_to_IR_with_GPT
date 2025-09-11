; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1080
; Intent: Performs a binary search and prints the result (confidence=0.95). Evidence: Key comparison and direct indexing.
; Preconditions: Array is sorted and contains at least one element.
; Postconditions: Outputs the result of the search.

declare i32 @printf(i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %var_64 = alloca [16 x i8]
  %var_30 = alloca i64
  %var_38 = alloca i32

  %0 = bitcast i8** %argv to i64
  %1 = load i64, i64* %0, align 8
  store i64 %1, i64* %var_30, align 8

  store i32 12, i32* %var_38, align 4
  %array = alloca [10 x i32]
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %array, i64 0, i64 0
  store i32 536870912, i32* %2
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %array, i64 0, i64 1
  store i32 805306370, i32* %3
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %array, i64 0, i64 2
  store i32 1610612743, i32* %4

  %idx = alloca i32
  %5 = load i32, i32* %var_38, align 4
  store i32 0, i32* %idx

  br label %loop

loop:                                             ; preds = %check, %entry
  %6 = load i32, i32* %idx
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %array, i64 0, i32 %6
  %value = load i32, i32* %7, align 4
  %cmp = icmp eq i32 %value, 2
  br i1 %cmp, label %found, label %check

check:                                            ; preds = %loop
  %8 = load i32, i32* %idx
  %inc = add nsw i32 %8, 1
  store i32 %inc, i32* %idx
  %9 = icmp eq i32 %inc, 9
  br i1 %9, label %not_found, label %loop

found:                                            ; preds = %loop
  %10 = load i64, i64* %var_30, align 8

  %11 = call i32 (i8*, ...) @printf(i8* getelementptr ([17 x i8], [17 x i8]* bitcast ([17 x i8]* @.str1 to i8*), i64 0, i64 0), i32 2, i64 %10)
  br label %cleanup

not_found:                                        ; preds = %check
  %12 = call i32 (i8*, ...) @printf(i8* getelementptr ([18 x i8], [18 x i8]* bitcast ([18 x i8]* @.str2 to i8*), i64 0, i64 0), i32 2)
  br label %cleanup

cleanup:                                          ; preds = %found, %not_found
  ret i32 0
}

@.str1 = private unnamed_addr constant [17 x i8] c"key %d -> index %ld\0A\00"
@.str2 = private unnamed_addr constant [18 x i8] c"key %d -> not found\0A\00"