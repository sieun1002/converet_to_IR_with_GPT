; ModuleID = 'binsearch_module'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare dso_local dllimport i32 @printf(i8*, ...)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local i32 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) {
entry:
  %low = alloca i64, align 8
  %high = alloca i64, align 8
  store i64 0, i64* %low, align 8
  %nminus1 = add i64 %n, -1
  store i64 %nminus1, i64* %high, align 8
  br label %loop

loop:                                             ; preds = %go_left, %go_right, %entry
  %l = load i64, i64* %low, align 8
  %h = load i64, i64* %high, align 8
  %cmp_done = icmp sgt i64 %l, %h
  br i1 %cmp_done, label %notfound, label %cont

cont:                                             ; preds = %loop
  %sum = add i64 %l, %h
  %mid = lshr i64 %sum, 1
  %eltptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %eltptr, align 4
  %eq = icmp eq i32 %val, %key
  br i1 %eq, label %found, label %noteq

noteq:                                            ; preds = %cont
  %lt = icmp slt i32 %val, %key
  br i1 %lt, label %go_right, label %go_left

go_right:                                         ; preds = %noteq
  %mid_plus1 = add i64 %mid, 1
  store i64 %mid_plus1, i64* %low, align 8
  br label %loop

go_left:                                          ; preds = %noteq
  %mid_minus1 = add i64 %mid, -1
  store i64 %mid_minus1, i64* %high, align 8
  br label %loop

found:                                            ; preds = %cont
  %mid32 = trunc i64 %mid to i32
  ret i32 %mid32

notfound:                                         ; preds = %loop
  ret i32 -1
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %i = alloca i64, align 8
  %n = alloca i64, align 8
  %nkeys = alloca i64, align 8
  %res = alloca i32, align 4

  ; initialize array: [-5, -1, 0, 2, 2, 3, 7, 9, 12]
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8, align 4

  ; initialize keys: [2, 5, -5]
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2, align 4

  store i64 9, i64* %n, align 8
  store i64 3, i64* %nkeys, align 8
  store i64 0, i64* %i, align 8

  br label %loop

loop:                                             ; preds = %loop_end, %entry
  %i_val = load i64, i64* %i, align 8
  %nkeys_val = load i64, i64* %nkeys, align 8
  %cont_cmp = icmp ult i64 %i_val, %nkeys_val
  br i1 %cont_cmp, label %body, label %exit

body:                                             ; preds = %loop
  %keys_base = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  %key_ptr = getelementptr inbounds i32, i32* %keys_base, i64 %i_val
  %key_val = load i32, i32* %key_ptr, align 4

  %arr_base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n_val = load i64, i64* %n, align 8
  %call_res = call i32 @binary_search(i32* %arr_base, i64 %n_val, i32 %key_val)
  store i32 %call_res, i32* %res, align 4

  %is_neg = icmp slt i32 %call_res, 0
  br i1 %is_neg, label %not_found, label %found

found:                                            ; preds = %body
  %fmt_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %res_found = load i32, i32* %res, align 4
  %call_printf_found = call i32 (i8*, ...) @printf(i8* %fmt_ptr, i32 %key_val, i32 %res_found)
  br label %loop_end

not_found:                                        ; preds = %body
  %fmt2_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call_printf_nf = call i32 (i8*, ...) @printf(i8* %fmt2_ptr, i32 %key_val)
  br label %loop_end

loop_end:                                         ; preds = %not_found, %found
  %i_next = add i64 %i_val, 1
  store i64 %i_next, i64* %i, align 8
  br label %loop

exit:                                             ; preds = %loop
  ret i32 0
}