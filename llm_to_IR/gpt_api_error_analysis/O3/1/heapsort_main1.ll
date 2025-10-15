; ModuleID = 'heapsort_main'
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32* noundef, i64 noundef)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %gep0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %gep0, align 4
  %gep1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %gep2, align 4
  %gep3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %gep3, align 4
  %gep4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %gep4, align 4
  %gep5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %gep5, align 4
  %gep6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %gep6, align 4
  %gep7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %gep7, align 4
  %gep8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %gep8, align 4
  br label %preloop

preloop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loopbody ]
  %cmp = icmp ult i64 %i, 9
  br i1 %cmp, label %loopbody, label %after_preloop

loopbody:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.gep = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef %fmt.gep, i32 noundef %elem)
  %i.next = add nuw i64 %i, 1
  br label %preloop

after_preloop:
  %call.putchar = call i32 @putchar(i32 noundef 10)
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* noundef %arr.base, i64 noundef 9)
  br label %postloop

postloop:
  %j = phi i64 [ 0, %after_preloop ], [ %j.next, %loop2body ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %loop2body, label %after_postloop

loop2body:
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmt2.gep = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call2.printf = call i32 (i8*, ...) @printf(i8* noundef %fmt2.gep, i32 noundef %elem2)
  %j.next = add nuw i64 %j, 1
  br label %postloop

after_postloop:
  %call2.putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}