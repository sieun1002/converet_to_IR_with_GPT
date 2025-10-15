target triple = "x86_64-pc-windows-msvc"

define dso_local void @selection_sort(i32* %arg_0, i32 %arg_8) {
entry:
  %arg0.addr = alloca i32*, align 8
  %arg8.addr = alloca i32, align 4
  %var_4 = alloca i32, align 4
  %var_C = alloca i32, align 4
  %var_8 = alloca i32, align 4
  %var_10 = alloca i32, align 4
  store i32* %arg_0, i32** %arg0.addr, align 8
  store i32 %arg_8, i32* %arg8.addr, align 4
  store i32 0, i32* %var_4, align 4
  br label %loc_140001521

loc_14000146B:
  %0 = load i32, i32* %var_4, align 4
  store i32 %0, i32* %var_C, align 4
  %1 = load i32, i32* %var_4, align 4
  %2 = add nsw i32 %1, 1
  store i32 %2, i32* %var_8, align 4
  br label %loc_1400014B6

loc_14000147C:
  %3 = load i32, i32* %var_8, align 4
  %4 = sext i32 %3 to i64
  %5 = load i32*, i32** %arg0.addr, align 8
  %6 = getelementptr inbounds i32, i32* %5, i64 %4
  %7 = load i32, i32* %6, align 4
  %8 = load i32, i32* %var_C, align 4
  %9 = sext i32 %8 to i64
  %10 = load i32*, i32** %arg0.addr, align 8
  %11 = getelementptr inbounds i32, i32* %10, i64 %9
  %12 = load i32, i32* %11, align 4
  %13 = icmp sge i32 %7, %12
  br i1 %13, label %loc_1400014B2, label %loc_1400014AC

loc_1400014AC:
  %14 = load i32, i32* %var_8, align 4
  store i32 %14, i32* %var_C, align 4
  br label %loc_1400014B2

loc_1400014B2:
  %15 = load i32, i32* %var_8, align 4
  %16 = add nsw i32 %15, 1
  store i32 %16, i32* %var_8, align 4
  br label %loc_1400014B6

loc_1400014B6:
  %17 = load i32, i32* %var_8, align 4
  %18 = load i32, i32* %arg8.addr, align 4
  %19 = icmp slt i32 %17, %18
  br i1 %19, label %loc_14000147C, label %loc_1400014BE

loc_1400014BE:
  %20 = load i32, i32* %var_4, align 4
  %21 = sext i32 %20 to i64
  %22 = load i32*, i32** %arg0.addr, align 8
  %23 = getelementptr inbounds i32, i32* %22, i64 %21
  %24 = load i32, i32* %23, align 4
  store i32 %24, i32* %var_10, align 4
  %25 = load i32, i32* %var_C, align 4
  %26 = sext i32 %25 to i64
  %27 = load i32*, i32** %arg0.addr, align 8
  %28 = getelementptr inbounds i32, i32* %27, i64 %26
  %29 = load i32, i32* %var_4, align 4
  %30 = sext i32 %29 to i64
  %31 = load i32*, i32** %arg0.addr, align 8
  %32 = getelementptr inbounds i32, i32* %31, i64 %30
  %33 = load i32, i32* %28, align 4
  store i32 %33, i32* %32, align 4
  %34 = load i32, i32* %var_C, align 4
  %35 = sext i32 %34 to i64
  %36 = load i32*, i32** %arg0.addr, align 8
  %37 = getelementptr inbounds i32, i32* %36, i64 %35
  %38 = load i32, i32* %var_10, align 4
  store i32 %38, i32* %37, align 4
  %39 = load i32, i32* %var_4, align 4
  %40 = add nsw i32 %39, 1
  store i32 %40, i32* %var_4, align 4
  br label %loc_140001521

loc_140001521:
  %41 = load i32, i32* %arg8.addr, align 4
  %42 = add nsw i32 %41, -1
  %43 = load i32, i32* %var_4, align 4
  %44 = icmp slt i32 %43, %42
  br i1 %44, label %loc_14000146B, label %loc_140001530

loc_140001530:
  ret void
}