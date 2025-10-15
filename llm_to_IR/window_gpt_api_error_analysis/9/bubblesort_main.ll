; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@Format = internal unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ult i64 %n, 2
  br i1 %cmp0, label %ret, label %outer.preheader

outer.preheader:
  %imax = sub i64 %n, 1
  br label %outer

outer:
  %i = phi i64 [ 0, %outer.preheader ], [ %i.next, %outer.latch ]
  %cond.outer.end = icmp uge i64 %i, %imax
  br i1 %cond.outer.end, label %ret, label %inner.preheader

inner.preheader:
  %tmp1 = sub i64 %n, %i
  %jlimit = sub i64 %tmp1, 1
  br label %inner

inner:
  %j = phi i64 [ 0, %inner.preheader ], [ %j.next, %noswap ]
  %cond.inner.end = icmp ugt i64 %j, %jlimit
  br i1 %cond.inner.end, label %outer.latch, label %body

body:
  %a.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %a = load i32, i32* %a.ptr, align 4
  %jp1 = add i64 %j, 1
  %b.ptr = getelementptr inbounds i32, i32* %arr, i64 %jp1
  %b = load i32, i32* %b.ptr, align 4
  %cmp = icmp sgt i32 %a, %b
  br i1 %cmp, label %swap, label %noswap

swap:
  store i32 %a, i32* %b.ptr, align 4
  store i32 %b, i32* %a.ptr, align 4
  br label %noswap

noswap:
  %j.next = add i64 %j, 1
  br label %inner

outer.latch:
  %i.next = add i64 %i, 1
  br label %outer

ret:
  ret void
}

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0
  store i32 9, i32* %arr0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 0, i32* %p9, align 4
  call void @bubble_sort(i32* %arr0, i64 10)
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %cont ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %body, label %done

body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @Format, i32 0, i32 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  br label %cont

cont:
  %i.next = add i64 %i, 1
  br label %loop

done:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}