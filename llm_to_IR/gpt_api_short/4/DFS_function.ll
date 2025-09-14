; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x14AE
; Intent: Build a small graph, run DFS preorder from 0, and print the order (confidence=0.78). Evidence: dfs call with (graph, n, start, out, out_len); format strings "DFS preorder from %zu: " and "%zu%s"
; Preconditions: n=7, result buffer capacity >= n (here 8)
; Postconditions: Prints DFS preorder nodes separated by spaces and newline

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

@format = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@asc_201C = private unnamed_addr constant [2 x i8] c" \00"    ; " "
@unk_201E = private unnamed_addr constant [1 x i8] c"\00"     ; ""

define dso_local i32 @main() local_unnamed_addr {
entry:
  ; locals
  %arr = alloca [49 x i32], align 16              ; corresponds to var_D0 area (48 zeroed dwords + one extra dword)
  %res = alloca [8 x i64], align 16               ; corresponds to var_110 (8 entries)
  %n = alloca i64, align 8                        ; var_120
  %start = alloca i64, align 8                    ; var_118
  %out_len = alloca i64, align 8                  ; var_130
  %i = alloca i64, align 8                        ; var_128

  ; initialize n=7
  store i64 7, i64* %n, align 8

  ; memset arr[0..48] = 0 (49 * 4 bytes)
  %arr.bc = bitcast [49 x i32]* %arr to i8*
  call void @llvm.memset.p0i8.i64(i8* %arr.bc, i8 0, i64 196, i1 false)

  ; arr[1] = 1 (var_CC)
  %arr1.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1.ptr, align 4

  ; arr[n] = 1
  %n.val = load i64, i64* %n, align 8
  %arrn.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %arr, i64 0, i64 %n.val
  store i32 1, i32* %arrn.ptr, align 4

  ; arr[2] = 1 (var_C8)
  %arr2.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %arr, i64 0, i64 2
  store i32 1, i32* %arr2.ptr, align 4

  ; arr[2*n] = 1
  %two.n = shl i64 %n.val, 1
  %arr2n.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %arr, i64 0, i64 %two.n
  store i32 1, i32* %arr2n.ptr, align 4

  ; arr[n+3] = 1
  %n.plus3 = add i64 %n.val, 3
  %arrn3.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %arr, i64 0, i64 %n.plus3
  store i32 1, i32* %arrn3.ptr, align 4

  ; arr[3*n + 1] = 1
  %three.n.tmp = add i64 %two.n, %n.val
  %three.n.plus1 = add i64 %three.n.tmp, 1
  %arr3n1.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %arr, i64 0, i64 %three.n.plus1
  store i32 1, i32* %arr3n1.ptr, align 4

  ; arr[n+4] = 1
  %n.plus4 = add i64 %n.val, 4
  %arrn4.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %arr, i64 0, i64 %n.plus4
  store i32 1, i32* %arrn4.ptr, align 4

  ; arr[4*n + 1] = 1
  %four.n = shl i64 %n.val, 2
  %four.n.plus1 = add i64 %four.n, 1
  %arr4n1.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %arr, i64 0, i64 %four.n.plus1
  store i32 1, i32* %arr4n1.ptr, align 4

  ; arr[2*n + 5] = 1
  %two.n.plus5 = add i64 %two.n, 5
  %arr2n5.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %arr, i64 0, i64 %two.n.plus5
  store i32 1, i32* %arr2n5.ptr, align 4

  ; arr[5*n + 2] = 1
  %five.n = add i64 %four.n, %n.val
  %five.n.plus2 = add i64 %five.n, 2
  %arr5n2.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %arr, i64 0, i64 %five.n.plus2
  store i32 1, i32* %arr5n2.ptr, align 4

  ; arr[4*n + 5] = 1
  %four.n.plus5 = add i64 %four.n, 5
  %arr4n5.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %arr, i64 0, i64 %four.n.plus5
  store i32 1, i32* %arr4n5.ptr, align 4

  ; arr[5*n + 4] = 1
  %five.n.plus4 = add i64 %five.n, 4
  %arr5n4.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %arr, i64 0, i64 %five.n.plus4
  store i32 1, i32* %arr5n4.ptr, align 4

  ; arr[5*n + 6] = 1
  %five.n.plus6 = add i64 %five.n, 6
  %arr5n6.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %arr, i64 0, i64 %five.n.plus6
  store i32 1, i32* %arr5n6.ptr, align 4

  ; arr[6*n + 5] = 1
  %six.n = shl i64 %three.n.tmp, 1
  %six.n.plus5 = add i64 %six.n, 5
  %arr6n5.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %arr, i64 0, i64 %six.n.plus5
  store i32 1, i32* %arr6n5.ptr, align 4

  ; start = 0, out_len = 0
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  ; dfs(&arr[0], n, start, &res[0], &out_len)
  %arr.base = getelementptr inbounds [49 x i32], [49 x i32]* %arr, i64 0, i64 0
  %res.base = getelementptr inbounds [8 x i64], [8 x i64]* %res, i64 0, i64 0
  %n.call = load i64, i64* %n, align 8
  %start.call = load i64, i64* %start, align 8
  call void @dfs(i32* %arr.base, i64 %n.call, i64 %start.call, i64* %res.base, i64* %out_len)

  ; printf("DFS preorder from %zu: ", start)
  %fmt.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @format, i64 0, i64 0
  %start.print = load i64, i64* %start, align 8
  %call.printf1 = call i32 (i8*, ...) @_printf(i8* %fmt.ptr, i64 %start.print)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.val = load i64, i64* %i, align 8
  %len.val = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.val, %len.val
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  ; choose separator: " " if i+1 < len else ""
  %i.plus1 = add i64 %i.val, 1
  %more = icmp ult i64 %i.plus1, %len.val
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_201C, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_201E, i64 0, i64 0
  %sep.ptr = select i1 %more, i8* %space.ptr, i8* %empty.ptr

  ; load value res[i]
  %val.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %res, i64 0, i64 %i.val
  %val = load i64, i64* %val.ptr, align 8

  ; printf("%zu%s", val, sep)
  %fmt2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @_printf(i8* %fmt2.ptr, i64 %val, i8* %sep.ptr)

  ; i++
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  ; putchar('\n')
  %call.putchar = call i32 @_putchar(i32 10)
  ret i32 0
}