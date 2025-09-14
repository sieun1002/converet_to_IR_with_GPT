; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x13F7
; Intent: Sort an array using merge_sort and print the result (confidence=0.93). Evidence: call to merge_sort(arr, 10) and loop printing "%d ".
; Preconditions: merge_sort expects a valid pointer to at least 10 i32s and a length of 10.
; Postconditions: Prints the sorted array followed by a newline; returns 0.

; Only the necessary external declarations:
declare void @merge_sort(i32*, i64)
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %idx0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %idx0, align 4
  %idx1 = getelementptr inbounds i32, i32* %idx0, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %idx0, i64 2
  store i32 5, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %idx0, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %idx0, i64 4
  store i32 7, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %idx0, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %idx0, i64 6
  store i32 8, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %idx0, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %idx0, i64 8
  store i32 4, i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %idx0, i64 9
  store i32 0, i32* %idx9, align 4

  call void @merge_sort(i32* %idx0, i64 10)

  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %loop

loop:                                             ; preds = %body, %entry
  %i.val = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i.val, 10
  br i1 %cmp, label %body, label %done

body:                                             ; preds = %loop
  %elem.ptr = getelementptr inbounds i32, i32* %idx0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 @_printf(i8* %fmt, i32 %elem)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop

done:                                             ; preds = %loop
  %putc = call i32 @_putchar(i32 10)
  ret i32 0
}