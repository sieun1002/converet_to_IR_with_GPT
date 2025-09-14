; ModuleID = 'main.ll'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32* noundef, i32 noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @puts(i8* noundef)

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [5 x i32], align 16
  %idx = alloca i32, align 4
  %value = alloca i32, align 4
  %size = alloca i32, align 4

  ; arr = {5, 3, 8, 4, 2}
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 8, i32* %arr2, align 4
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 4, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 2, i32* %arr4, align 4

  ; value = 5; size = 4
  store i32 5, i32* %value, align 4
  store i32 4, i32* %size, align 4

  ; call linear_search(arr, value, size)
  %v = load i32, i32* %value, align 4
  %n = load i32, i32* %size, align 4
  %call = call i32 @linear_search(i32* noundef %arr0, i32 noundef %v, i32 noundef %n)
  store i32 %call, i32* %idx, align 4

  ; if (idx == -1) puts("Element not found"); else printf("Element found at index %d\n", idx);
  %res = load i32, i32* %idx, align 4
  %cmp = icmp eq i32 %res, -1
  br i1 %cmp, label %notfound, label %found

found:
  %res2 = load i32, i32* %idx, align 4
  %fmt = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %printf_call = call i32 (i8*, ...) @printf(i8* noundef %fmt, i32 noundef %res2)
  br label %ret

notfound:
  %msg = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %puts_call = call i32 @puts(i8* noundef %msg)
  br label %ret

ret:
  ret i32 0
}