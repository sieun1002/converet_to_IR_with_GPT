target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

declare i64 @sub_140002AC0(i8* noundef)
declare i32 @sub_140002AC8(i8* noundef, i8* noundef, i32 noundef)

define i8* @sub_140002570(i8* noundef %0) {
entry:
  %1 = call i64 @sub_140002AC0(i8* noundef %0)
  %2 = icmp ugt i64 %1, 8
  br i1 %2, label %ret_null, label %after_len

after_len:
  %3 = load i8*, i8** @off_1400043A0, align 8
  %4 = bitcast i8* %3 to i16*
  %5 = load i16, i16* %4, align 1
  %6 = icmp eq i16 %5, 23117
  br i1 %6, label %check_nt, label %ret_null

check_nt:
  %7 = getelementptr i8, i8* %3, i64 60
  %8 = bitcast i8* %7 to i32*
  %9 = load i32, i32* %8, align 1
  %10 = sext i32 %9 to i64
  %11 = getelementptr i8, i8* %3, i64 %10
  %12 = bitcast i8* %11 to i32*
  %13 = load i32, i32* %12, align 1
  %14 = icmp eq i32 %13, 17744
  br i1 %14, label %check_magic, label %ret_null

check_magic:
  %15 = getelementptr i8, i8* %11, i64 24
  %16 = bitcast i8* %15 to i16*
  %17 = load i16, i16* %16, align 1
  %18 = icmp eq i16 %17, 523
  br i1 %18, label %check_numsec, label %ret_null

check_numsec:
  %19 = getelementptr i8, i8* %11, i64 6
  %20 = bitcast i8* %19 to i16*
  %21 = load i16, i16* %20, align 1
  %22 = icmp eq i16 %21, 0
  br i1 %22, label %ret_null, label %calc_sections

calc_sections:
  %23 = getelementptr i8, i8* %11, i64 20
  %24 = bitcast i8* %23 to i16*
  %25 = load i16, i16* %24, align 1
  %26 = zext i16 %25 to i64
  %27 = getelementptr i8, i8* %11, i64 24
  %28 = getelementptr i8, i8* %27, i64 %26
  %29 = zext i16 %21 to i32
  br label %loop

loop:
  %30 = phi i8* [ %28, %calc_sections ], [ %34, %inc ]
  %31 = phi i32 [ 0, %calc_sections ], [ %35, %inc ]
  %32 = call i32 @sub_140002AC8(i8* noundef %30, i8* noundef %0, i32 noundef 8)
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %found, label %inc

inc:
  %34 = getelementptr i8, i8* %30, i64 40
  %35 = add i32 %31, 1
  %36 = icmp ult i32 %35, %29
  br i1 %36, label %loop, label %ret_null

found:
  ret i8* %30

ret_null:
  ret i8* null
}