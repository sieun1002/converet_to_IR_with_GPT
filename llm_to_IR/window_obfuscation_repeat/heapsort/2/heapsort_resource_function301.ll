; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002610(i8* %p) local_unnamed_addr nounwind {
entry:
  %0 = load i8*, i8** @off_1400043A0, align 8
  %1 = bitcast i8* %0 to i16*
  %2 = load i16, i16* %1, align 1
  %3 = icmp eq i16 %2, 23117
  br i1 %3, label %check_nt, label %ret0

check_nt:
  %4 = getelementptr i8, i8* %0, i64 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 1
  %7 = zext i32 %6 to i64
  %8 = getelementptr i8, i8* %0, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 1
  %11 = icmp eq i32 %10, 17744
  br i1 %11, label %check_magic, label %ret0

check_magic:
  %12 = getelementptr i8, i8* %8, i64 24
  %13 = bitcast i8* %12 to i16*
  %14 = load i16, i16* %13, align 1
  %15 = icmp eq i16 %14, 523
  br i1 %15, label %check_sections, label %ret0

check_sections:
  %16 = getelementptr i8, i8* %8, i64 6
  %17 = bitcast i8* %16 to i16*
  %18 = load i16, i16* %17, align 1
  %19 = icmp ne i16 %18, 0
  br i1 %19, label %calc_tables, label %ret0

calc_tables:
  %20 = getelementptr i8, i8* %8, i64 20
  %21 = bitcast i8* %20 to i16*
  %22 = load i16, i16* %21, align 1
  %23 = zext i16 %22 to i64
  %24 = add i64 %23, 24
  %25 = getelementptr i8, i8* %8, i64 %24
  %26 = zext i16 %18 to i64
  %27 = mul i64 %26, 40
  %28 = getelementptr i8, i8* %25, i64 %27
  %29 = ptrtoint i8* %p to i64
  %30 = ptrtoint i8* %0 to i64
  %31 = sub i64 %29, %30
  br label %loop

loop:
  %32 = phi i8* [ %25, %calc_tables ], [ %37, %advance ]
  %33 = getelementptr i8, i8* %32, i64 12
  %34 = bitcast i8* %33 to i32*
  %35 = load i32, i32* %34, align 1
  %36 = zext i32 %35 to i64
  %cmp_ge = icmp uge i64 %31, %36
  br i1 %cmp_ge, label %check_range, label %advance

check_range:
  %vs_ptr_off = getelementptr i8, i8* %32, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_off to i32*
  %vs32 = load i32, i32* %vs_ptr, align 1
  %vs64 = zext i32 %vs32 to i64
  %end = add i64 %36, %vs64
  %inrange = icmp ult i64 %31, %end
  br i1 %inrange, label %ret0, label %advance

advance:
  %37 = getelementptr i8, i8* %32, i64 40
  %done = icmp eq i8* %37, %28
  br i1 %done, label %ret0, label %loop

ret0:
  ret i32 0
}