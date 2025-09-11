; main (typed pointers for LLVM 14)
target triple = "x86_64-unknown-linux-gnu"

@.str.orig   = private unnamed_addr constant [9  x i8]  c"\EC\9B\90\EB\B3\B8: \00",           align 1 ; "원본: "
@.str.sorted = private unnamed_addr constant [13 x i8]  c"\EC\A0\95\EB\A0\AC \ED\9B\84: \00", align 1 ; "정렬 후: "
@.str.d      = private unnamed_addr constant [4  x i8]  c"%d \00",                              align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32* %a, i64 %n)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [9 x i32], align 16
  %n   = alloca i64, align 8
  %i   = alloca i64, align 8
  %i2  = alloca i64, align 8

  ; 문자열 포인터들은 entry에서 한 번만 만듦(모든 사용을 지배)
  %fmt1  = getelementptr inbounds [9  x i8],  [9  x i8]*  @.str.orig,   i64 0, i64 0
  %fmt2  = getelementptr inbounds [13 x i8],  [13 x i8]* @.str.sorted, i64 0, i64 0
  %fmt_d = getelementptr inbounds [4  x i8],  [4  x i8]*  @.str.d,      i64 0, i64 0

  ; arr 초기화: {7,3,9,1,4,8,2,6,5}
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 3, i32* %p1,  align 4
  %p2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 9, i32* %p2,  align 4
  %p3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 1, i32* %p3,  align 4
  %p4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 4, i32* %p4,  align 4
  %p5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 8, i32* %p5,  align 4
  %p6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 2, i32* %p6,  align 4
  %p7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %p7,  align 4
  %p8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 5, i32* %p8,  align 4

  store i64 9, i64* %n, align 8

  ; printf("원본: ")
  call i32 (i8*, ...) @printf(i8* %fmt1)

  ; for (i=0; i<n; ++i) printf("%d ", arr[i]);
  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:
  %i.val = load i64, i64* %i, align 8
  %n.val = load i64, i64* %n, align 8
  %cmp   = icmp ult i64 %i.val, %n.val
  br i1 %cmp, label %loop1.body, label %loop1.end

loop1.body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem     = load i32, i32* %elem.ptr, align 4
  call i32 (i8*, ...) @printf(i8* %fmt_d, i32 %elem)
  %inc = add i64 %i.val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop1.cond

loop1.end:
  call i32 @putchar(i32 10) ; '\n'

  ; heap_sort(arr, n)
  %n2 = load i64, i64* %n, align 8
  call void @heap_sort(i32* %arr0, i64 %n2)

  ; printf("정렬 후: ")
  call i32 (i8*, ...) @printf(i8* %fmt2)

  ; for (i2=0; i<n; ++i2) printf("%d ", arr[i2]);
  store i64 0, i64* %i2, align 8
  br label %loop2.cond

loop2.cond:
  %i2.val = load i64, i64* %i2, align 8
  %n3     = load i64, i64* %n,  align 8
  %cmp2   = icmp ult i64 %i2.val, %n3
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2.val
  %elem2     = load i32, i32* %elem2.ptr, align 4
  call i32 (i8*, ...) @printf(i8* %fmt_d, i32 %elem2)
  %inc2 = add i64 %i2.val, 1
  store i64 %inc2, i64* %i2, align 8
  br label %loop2.cond

loop2.end:
  call i32 @putchar(i32 10) ; '\n'
  ret i32 0
}
