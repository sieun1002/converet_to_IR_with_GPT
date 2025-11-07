; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)
declare void @heap_sort(i32* noundef, i64 noundef)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %arrdecay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %e0ptr = getelementptr inbounds i32, i32* %arrdecay, i64 0
  store i32 7, i32* %e0ptr, align 4
  %e1ptr = getelementptr inbounds i32, i32* %arrdecay, i64 1
  store i32 3, i32* %e1ptr, align 4
  %e2ptr = getelementptr inbounds i32, i32* %arrdecay, i64 2
  store i32 9, i32* %e2ptr, align 4
  %e3ptr = getelementptr inbounds i32, i32* %arrdecay, i64 3
  store i32 1, i32* %e3ptr, align 4
  %e4ptr = getelementptr inbounds i32, i32* %arrdecay, i64 4
  store i32 4, i32* %e4ptr, align 4
  %e5ptr = getelementptr inbounds i32, i32* %arrdecay, i64 5
  store i32 8, i32* %e5ptr, align 4
  %e6ptr = getelementptr inbounds i32, i32* %arrdecay, i64 6
  store i32 2, i32* %e6ptr, align 4
  %e7ptr = getelementptr inbounds i32, i32* %arrdecay, i64 7
  store i32 6, i32* %e7ptr, align 4
  %e8ptr = getelementptr inbounds i32, i32* %arrdecay, i64 8
  store i32 5, i32* %e8ptr, align 4
  br label %loop1.cond

loop1.cond:
  %i1 = phi i64 [ 0, %entry ], [ %i1.next, %loop1.body ]
  %cmp1 = icmp ult i64 %i1, 9
  br i1 %cmp1, label %loop1.body, label %after1

loop1.body:
  %elem.ptr1 = getelementptr inbounds i32, i32* %arrdecay, i64 %i1
  %elem1 = load i32, i32* %elem.ptr1, align 4
  %fmtptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* noundef %fmtptr1, i32 noundef %elem1)
  %i1.next = add i64 %i1, 1
  br label %loop1.cond

after1:
  %nl1 = call i32 @putchar(i32 noundef 10)
  call void @heap_sort(i32* noundef %arrdecay, i64 noundef 9)
  br label %loop2.cond

loop2.cond:
  %i2 = phi i64 [ 0, %after1 ], [ %i2.next, %loop2.body ]
  %cmp2 = icmp ult i64 %i2, 9
  br i1 %cmp2, label %loop2.body, label %after2

loop2.body:
  %elem.ptr2 = getelementptr inbounds i32, i32* %arrdecay, i64 %i2
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %fmtptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* noundef %fmtptr2, i32 noundef %elem2)
  %i2.next = add i64 %i2, 1
  br label %loop2.cond

after2:
  %nl2 = call i32 @putchar(i32 noundef 10)
  ret i32 0
}