; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = dso_local constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@aKeyDNotFound = dso_local constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @binary_search(i32*, i64, i32)

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [9 x i32], align 16
  %queries = alloca [3 x i32], align 16
  %len = alloca i64, align 8
  %count = alloca i64, align 8
  %res = alloca i32, align 4

  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 -1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 0, i32* %arr2, align 4
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 2, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 2, i32* %arr4, align 4
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 3, i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 7, i32* %arr6, align 4
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 9, i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 12, i32* %arr8, align 4

  %q0 = getelementptr inbounds [3 x i32], [3 x i32]* %queries, i64 0, i64 0
  store i32 2, i32* %q0, align 4
  %q1 = getelementptr inbounds i32, i32* %q0, i64 1
  store i32 5, i32* %q1, align 4
  %q2 = getelementptr inbounds i32, i32* %q0, i64 2
  store i32 -5, i32* %q2, align 4

  store i64 9, i64* %len, align 8
  store i64 3, i64* %count, align 8
  br label %check

check:                                            ; preds = %entry, %inc
  %i = phi i64 [ 0, %entry ], [ %i.next, %inc ]
  %cnt = load i64, i64* %count, align 8
  %cmp = icmp ult i64 %i, %cnt
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %check
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %queries, i64 0, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  %n = load i64, i64* %len, align 8
  %call = call i32 @binary_search(i32* %arr0, i64 %n, i32 %key)
  store i32 %call, i32* %res, align 4
  %resv = load i32, i32* %res, align 4
  %isneg = icmp slt i32 %resv, 0
  br i1 %isneg, label %notfound, label %found

found:                                            ; preds = %body
  %fmt.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i64 0, i64 0
  %resv2 = load i32, i32* %res, align 4
  %callp = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %key, i32 %resv2)
  br label %inc

notfound:                                         ; preds = %body
  %nf.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %callp2 = call i32 (i8*, ...) @printf(i8* %nf.ptr, i32 %key)
  br label %inc

inc:                                              ; preds = %found, %notfound
  %i.next = add i64 %i, 1
  br label %check

exit:                                             ; preds = %check
  ret i32 0
}