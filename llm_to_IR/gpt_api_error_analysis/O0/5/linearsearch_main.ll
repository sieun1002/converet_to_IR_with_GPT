; ModuleID = 'recovered_main'
target triple = "x86_64-pc-linux-gnu"

@.str.found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.notfound = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32* noundef, i32 noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @puts(i8* noundef)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %target = alloca i32, align 4
  %idx = alloca i32, align 4

  %arr.elem0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr.elem0, align 4
  %arr.elem1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr.elem1, align 4
  %arr.elem2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr.elem2, align 4
  %arr.elem3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr.elem3, align 4
  %arr.elem4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr.elem4, align 4

  store i32 5, i32* %n, align 4
  store i32 4, i32* %target, align 4

  %arr.decay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %n.val = load i32, i32* %n, align 4
  %t.val = load i32, i32* %target, align 4
  %call.search = call i32 @linear_search(i32* noundef %arr.decay, i32 noundef %n.val, i32 noundef %t.val)
  store i32 %call.search, i32* %idx, align 4

  %idx.val = load i32, i32* %idx, align 4
  %cmp.m1 = icmp eq i32 %idx.val, -1
  br i1 %cmp.m1, label %notfound, label %found

found:
  %idx.print = load i32, i32* %idx, align 4
  %fmt.ptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str.found, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr, i32 noundef %idx.print)
  br label %done

notfound:
  %msg.ptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.notfound, i64 0, i64 0
  %call.puts = call i32 @puts(i8* noundef %msg.ptr)
  br label %done

done:
  ret i32 0
}