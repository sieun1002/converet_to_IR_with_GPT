target triple = "x86_64-pc-windows-msvc"

define dso_local i8* @sub_140002160(i8* %0, i64 %1) {
entry:
  %2 = getelementptr inbounds i8, i8* %0, i64 60
  %3 = bitcast i8* %2 to i32*
  %4 = load i32, i32* %3, align 4
  %5 = sext i32 %4 to i64
  %6 = getelementptr inbounds i8, i8* %0, i64 %5
  %7 = getelementptr inbounds i8, i8* %6, i64 6
  %8 = bitcast i8* %7 to i16*
  %9 = load i16, i16* %8, align 2
  %10 = icmp eq i16 %9, 0
  br i1 %10, label %ret_zero, label %nonzero

nonzero:
  %11 = getelementptr inbounds i8, i8* %6, i64 20
  %12 = bitcast i8* %11 to i16*
  %13 = load i16, i16* %12, align 2
  %14 = getelementptr inbounds i8, i8* %6, i64 24
  %15 = zext i16 %13 to i64
  %16 = getelementptr inbounds i8, i8* %14, i64 %15
  %17 = zext i16 %9 to i32
  %18 = add i32 %17, -1
  %19 = mul i32 %18, 5
  %20 = zext i32 %19 to i64
  %21 = shl i64 %20, 3
  %22 = add i64 %21, 40
  %23 = getelementptr inbounds i8, i8* %16, i64 %22
  br label %loop

loop:
  %24 = phi i8* [ %16, %nonzero ], [ %30, %inc ]
  %25 = getelementptr inbounds i8, i8* %24, i64 12
  %26 = bitcast i8* %25 to i32*
  %27 = load i32, i32* %26, align 4
  %28 = zext i32 %27 to i64
  %29 = icmp ult i64 %1, %28
  br i1 %29, label %inc, label %check2

check2:
  %32 = getelementptr inbounds i8, i8* %24, i64 8
  %33 = bitcast i8* %32 to i32*
  %34 = load i32, i32* %33, align 4
  %35 = add i32 %27, %34
  %36 = zext i32 %35 to i64
  %37 = icmp ult i64 %1, %36
  br i1 %37, label %ret_curr, label %inc

inc:
  %30 = getelementptr inbounds i8, i8* %24, i64 40
  %31 = icmp ne i8* %30, %23
  br i1 %31, label %loop, label %ret_zero

ret_curr:
  ret i8* %24

ret_zero:
  ret i8* null
}