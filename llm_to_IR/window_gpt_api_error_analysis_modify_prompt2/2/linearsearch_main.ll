; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00"
@Buffer = private unnamed_addr constant [18 x i8] c"Element not found\00"

declare dllimport i32 @printf(i8*, ...)
declare dllimport i32 @puts(i8*)
declare i32 @linear_search(i32*, i32, i32)

define i32 @main() {
entry:
  %arr = alloca [5 x i32]
  %key = alloca i32
  %n = alloca i32
  %result = alloca i32

  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr2
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr3
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4

  store i32 5, i32* %key
  store i32 4, i32* %n

  %key.val = load i32, i32* %key
  %n.val = load i32, i32* %n
  %arr.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %call = call i32 @linear_search(i32* %arr.ptr, i32 %key.val, i32 %n.val)
  store i32 %call, i32* %result

  %res.ld = load i32, i32* %result
  %cmp = icmp eq i32 %res.ld, -1
  br i1 %cmp, label %notfound, label %found

found:
  %res.printf = load i32, i32* %result
  %fmt.ptr = getelementptr inbounds [27 x i8], [27 x i8]* @_Format, i64 0, i64 0
  %printf.call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %res.printf)
  br label %done

notfound:
  %buf.ptr = getelementptr inbounds [18 x i8], [18 x i8]* @Buffer, i64 0, i64 0
  %puts.call = call i32 @puts(i8* %buf.ptr)
  br label %done

done:
  ret i32 0
}