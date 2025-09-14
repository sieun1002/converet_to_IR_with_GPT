; ModuleID = 'main_from_disasm'
source_filename = "main_from_disasm.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str = private constant [27 x i8] c"Element found at index %d\0A\00"
@.str.1 = private constant [18 x i8] c"Element not found\00"

declare i32 @linear_search(i32* noundef, i32 noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @puts(i8* noundef)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %key = alloca i32, align 4

  ; arr = {5, 3, 8, 4, 2}
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4, align 4

  ; n = 5, key = 4
  store i32 5, i32* %n, align 4
  store i32 4, i32* %key, align 4

  ; call linear_search(arr, n, key)
  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  %keyval = load i32, i32* %key, align 4
  %idx = call i32 @linear_search(i32* noundef %arrptr, i32 noundef %nval, i32 noundef %keyval)

  ; if (idx == -1) puts("Element not found"); else printf("Element found at index %d\n", idx);
  %is_not_found = icmp eq i32 %idx, -1
  br i1 %is_not_found, label %notfound, label %found

found:
  %fmt = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %fmt, i32 noundef %idx)
  br label %end

notfound:
  %msg = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  call i32 @puts(i8* noundef %msg)
  br label %end

end:
  ret i32 0
}