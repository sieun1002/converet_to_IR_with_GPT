; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@_Format = internal constant [21 x i8] c"key %d -> index %ld\0A\00"
@aKeyDNotFound = internal constant [21 x i8] c"key %d -> not found\0A\00"

declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @binary_search(i32* noundef, i64 noundef, i32 noundef)

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32]
  %keys = alloca [3 x i32]
  %n = alloca i64
  %idx = alloca i64
  %count = alloca i64
  %res = alloca i32

  %arr0ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0ptr
  %arr1ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr1ptr
  %arr2ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr2ptr
  %arr3ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr3ptr
  %arr4ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4ptr
  %arr5ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr5ptr
  %arr6ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr6ptr
  %arr7ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr7ptr
  %arr8ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8ptr

  store i64 9, i64* %n

  %keys0ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0ptr
  %keys1ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1ptr
  %keys2ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2ptr

  store i64 3, i64* %count
  store i64 0, i64* %idx
  br label %loop.cond

loop.cond:
  %idx.cur = load i64, i64* %idx
  %count.cur = load i64, i64* %count
  %cmp = icmp ult i64 %idx.cur, %count.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %idx.cur
  %key = load i32, i32* %key.ptr
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n.val = load i64, i64* %n
  %call = call i32 @binary_search(i32* noundef %arr.base, i64 noundef %n.val, i32 noundef %key)
  store i32 %call, i32* %res
  %res.val = load i32, i32* %res
  %isneg = icmp slt i32 %res.val, 0
  br i1 %isneg, label %notfound, label %found

found:
  %fmt.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i64 0, i64 0
  %fmt.cast = bitcast i8* %fmt.ptr to i8*
  %print1 = call i32 (i8*, ...) @printf(i8* noundef %fmt.cast, i32 noundef %key, i32 noundef %res.val)
  br label %loop.inc

notfound:
  %fmt2.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %fmt2.cast = bitcast i8* %fmt2.ptr to i8*
  %print2 = call i32 (i8*, ...) @printf(i8* noundef %fmt2.cast, i32 noundef %key)
  br label %loop.inc

loop.inc:
  %idx.next = add i64 %idx.cur, 1
  store i64 %idx.next, i64* %idx
  br label %loop.cond

loop.end:
  ret i32 0
}