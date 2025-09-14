; ModuleID = 'reconstructed_main'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @merge_sort(i32* noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.elem0.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %arr.elem1.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  %arr.elem2.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  %arr.elem3.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  %arr.elem4.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  %arr.elem5.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  %arr.elem6.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  %arr.elem7.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  %arr.elem8.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  %arr.elem9.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 9,  i32* %arr.elem0.ptr, align 4
  store i32 1,  i32* %arr.elem1.ptr, align 4
  store i32 5,  i32* %arr.elem2.ptr, align 4
  store i32 3,  i32* %arr.elem3.ptr, align 4
  store i32 7,  i32* %arr.elem4.ptr, align 4
  store i32 2,  i32* %arr.elem5.ptr, align 4
  store i32 8,  i32* %arr.elem6.ptr, align 4
  store i32 6,  i32* %arr.elem7.ptr, align 4
  store i32 4,  i32* %arr.elem8.ptr, align 4
  store i32 0,  i32* %arr.elem9.ptr, align 4
  %len = phi i64 [ 10, %entry ] ; canonical constant use
  call void @merge_sort(i32* noundef %arr.elem0.ptr, i64 noundef 10)
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %print ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %print, label %done

print:
  %elem.ptr = getelementptr inbounds i32, i32* %arr.elem0.ptr, i64 %i
  %elem.val = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr, i32 noundef %elem.val)
  %i.next = add nuw nsw i64 %i, 1
  br label %loop

done:
  %call.putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}