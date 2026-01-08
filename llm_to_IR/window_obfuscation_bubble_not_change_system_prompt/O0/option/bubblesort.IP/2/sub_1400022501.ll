target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i32 @sub_140002250(i8* %rcx) {
entry:
  %0 = load i8*, i8** @off_1400043C0, align 8
  %1 = bitcast i8* %0 to i16*
  %2 = load i16, i16* %1, align 2
  %3 = icmp eq i16 %2, 23117
  br i1 %3, label %check_pe, label %ret0

check_pe:
  %4 = getelementptr inbounds i8, i8* %0, i64 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 4
  %7 = sext i32 %6 to i64
  %8 = getelementptr inbounds i8, i8* %0, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 4
  %11 = icmp eq i32 %10, 17744
  br i1 %11, label %check_opt, label %ret0

check_opt:
  %12 = getelementptr inbounds i8, i8* %8, i64 24
  %13 = bitcast i8* %12 to i16*
  %14 = load i16, i16* %13, align 2
  %15 = icmp eq i16 %14, 523
  br i1 %15, label %have_numsec, label %ret0

have_numsec:
  %16 = getelementptr inbounds i8, i8* %8, i64 6
  %17 = bitcast i8* %16 to i16*
  %18 = load i16, i16* %17, align 2
  %19 = icmp eq i16 %18, 0
  br i1 %19, label %ret0, label %calc_loop_bounds

calc_loop_bounds:
  %20 = getelementptr inbounds i8, i8* %8, i64 20
  %21 = bitcast i8* %20 to i16*
  %22 = load i16, i16* %21, align 2
  %23 = ptrtoint i8* %rcx to i64
  %24 = ptrtoint i8* %0 to i64
  %25 = sub i64 %23, %24
  %26 = zext i16 %18 to i32
  %27 = add i32 %26, -1
  %28 = mul i32 %27, 5
  %29 = zext i16 %22 to i64
  %30 = getelementptr inbounds i8, i8* %8, i64 24
  %31 = getelementptr inbounds i8, i8* %30, i64 %29
  %32 = zext i32 %28 to i64
  %33 = shl i64 %32, 3
  %34 = getelementptr inbounds i8, i8* %31, i64 %33
  %35 = getelementptr inbounds i8, i8* %34, i64 40
  br label %loop

loop:
  %36 = phi i8* [ %31, %calc_loop_bounds ], [ %42, %after_add ]
  %37 = getelementptr inbounds i8, i8* %36, i64 12
  %38 = bitcast i8* %37 to i32*
  %39 = load i32, i32* %38, align 4
  %40 = zext i32 %39 to i64
  %41 = icmp ult i64 %25, %40
  br i1 %41, label %after_add, label %ge_va

ge_va:
  %vs.ptr = getelementptr inbounds i8, i8* %36, i64 8
  %vs32p = bitcast i8* %vs.ptr to i32*
  %vs = load i32, i32* %vs32p, align 4
  %vs64 = zext i32 %vs to i64
  %sum = add i64 %40, %vs64
  %cmp2 = icmp ult i64 %25, %sum
  br i1 %cmp2, label %ret0, label %after_add

after_add:
  %42 = getelementptr inbounds i8, i8* %36, i64 40
  %43 = icmp ne i8* %42, %35
  br i1 %43, label %loop, label %end

ret0:
  ret i32 0

end:
  ret i32 0
}