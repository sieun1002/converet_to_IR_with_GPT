; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x144B
; Intent: Print an int array, heap-sort it, then print it again (confidence=0.93). Evidence: call to heap_sort; two loops printing "%d " elements before/after.
; Preconditions: heap_sort(i32*, i64) must be linked in and accept (int*, size_t).
; Postconditions: Writes two lines of array contents to stdout separated by headers and newlines.

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

@format = external global i8
@aD = external global i8
@byte_2011 = external global i8

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0, align 4
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 9, i32* %arr2, align 4
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 1, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 4, i32* %arr4, align 4
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 8, i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 2, i32* %arr6, align 4
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 5, i32* %arr8, align 4
  ; printf(format);
  %call0 = call i32 (i8*, ...) @printf(i8* @format)
  ; for (i=0; i<9; ++i) printf("%d ", arr[i]);
  br label %loop1

loop1:                                            ; preds = %loop1, %entry
  %i = phi i64 [ 0, %entry ], [ %inc, %loop1 ]
  %cmp = icmp ult i64 %i, 9
  br i1 %cmp, label %body1, label %end1

body1:                                            ; preds = %loop1
  %iptr = getelementptr inbounds i32, i32* %arr0, i64 %i
  %ival = load i32, i32* %iptr, align 4
  %call1 = call i32 (i8*, ...) @printf(i8* @aD, i32 %ival)
  %inc = add i64 %i, 1
  br label %loop1

end1:                                             ; preds = %loop1
  ; putchar('\n');
  %call2 = call i32 @putchar(i32 10)
  ; heap_sort(arr, 9);
  call void @heap_sort(i32* %arr0, i64 9)
  ; printf(byte_2011);
  %call3 = call i32 (i8*, ...) @printf(i8* @byte_2011)
  ; for (j=0; j<9; ++j) printf("%d ", arr[j]);
  br label %loop2

loop2:                                            ; preds = %loop2, %end1
  %j = phi i64 [ 0, %end1 ], [ %inc2, %loop2 ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %body2, label %end2

body2:                                            ; preds = %loop2
  %jptr = getelementptr inbounds i32, i32* %arr0, i64 %j
  %jval = load i32, i32* %jptr, align 4
  %call4 = call i32 (i8*, ...) @printf(i8* @aD, i32 %jval)
  %inc2 = add i64 %j, 1
  br label %loop2

end2:                                             ; preds = %loop2
  %call5 = call i32 @putchar(i32 10)
  ret i32 0
}