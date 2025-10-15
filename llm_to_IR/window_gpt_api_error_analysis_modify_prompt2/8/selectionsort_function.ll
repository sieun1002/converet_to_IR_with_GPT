target triple = "x86_64-pc-windows-msvc"

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  %arr.addr = alloca i32*, align 8
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %min = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i32 %n, i32* %n.addr, align 4
  store i32 0, i32* %i, align 4
  br label %outer.check

outer.body:
  %0 = load i32, i32* %i, align 4
  store i32 %0, i32* %min, align 4
  %1 = load i32, i32* %i, align 4
  %2 = add i32 %1, 1
  store i32 %2, i32* %j, align 4
  br label %inner.check

inner.body:
  %3 = load i32, i32* %j, align 4
  %4 = sext i32 %3 to i64
  %5 = load i32*, i32** %arr.addr, align 8
  %6 = getelementptr inbounds i32, i32* %5, i64 %4
  %7 = load i32, i32* %6, align 4
  %8 = load i32, i32* %min, align 4
  %9 = sext i32 %8 to i64
  %10 = load i32*, i32** %arr.addr, align 8
  %11 = getelementptr inbounds i32, i32* %10, i64 %9
  %12 = load i32, i32* %11, align 4
  %13 = icmp slt i32 %7, %12
  br i1 %13, label %update_min, label %after_update

update_min:
  %14 = load i32, i32* %j, align 4
  store i32 %14, i32* %min, align 4
  br label %after_update

after_update:
  %15 = load i32, i32* %j, align 4
  %16 = add i32 %15, 1
  store i32 %16, i32* %j, align 4
  br label %inner.check

inner.check:
  %17 = load i32, i32* %j, align 4
  %18 = load i32, i32* %n.addr, align 4
  %19 = icmp slt i32 %17, %18
  br i1 %19, label %inner.body, label %inner.exit

inner.exit:
  %20 = load i32, i32* %i, align 4
  %21 = sext i32 %20 to i64
  %22 = load i32*, i32** %arr.addr, align 8
  %23 = getelementptr inbounds i32, i32* %22, i64 %21
  %24 = load i32, i32* %23, align 4
  store i32 %24, i32* %tmp, align 4
  %25 = load i32, i32* %min, align 4
  %26 = sext i32 %25 to i64
  %27 = load i32*, i32** %arr.addr, align 8
  %28 = getelementptr inbounds i32, i32* %27, i64 %26
  %29 = load i32, i32* %i, align 4
  %30 = sext i32 %29 to i64
  %31 = load i32*, i32** %arr.addr, align 8
  %32 = getelementptr inbounds i32, i32* %31, i64 %30
  %33 = load i32, i32* %28, align 4
  store i32 %33, i32* %32, align 4
  %34 = load i32*, i32** %arr.addr, align 8
  %35 = load i32, i32* %min, align 4
  %36 = sext i32 %35 to i64
  %37 = getelementptr inbounds i32, i32* %34, i64 %36
  %38 = load i32, i32* %tmp, align 4
  store i32 %38, i32* %37, align 4
  %39 = load i32, i32* %i, align 4
  %40 = add i32 %39, 1
  store i32 %40, i32* %i, align 4
  br label %outer.check

outer.check:
  %41 = load i32, i32* %n.addr, align 4
  %42 = add i32 %41, -1
  %43 = load i32, i32* %i, align 4
  %44 = icmp slt i32 %43, %42
  br i1 %44, label %outer.body, label %outer.exit

outer.exit:
  ret void
}