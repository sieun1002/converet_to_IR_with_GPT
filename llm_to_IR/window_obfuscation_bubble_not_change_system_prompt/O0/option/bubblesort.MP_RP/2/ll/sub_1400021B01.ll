; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @sub_140002700(i8*)
declare i32 @sub_140002708(i8*, i8*, i32)

define i8* @sub_1400021B0(i8* %0) local_unnamed_addr {
entry:
  %1 = call i64 @sub_140002700(i8* %0)
  %2 = icmp ugt i64 %1, 8
  br i1 %2, label %ret_zero, label %check_mz

check_mz:
  %3 = load i8*, i8** @off_1400043C0, align 8
  %4 = bitcast i8* %3 to i16*
  %5 = load i16, i16* %4, align 2
  %6 = icmp eq i16 %5, 23117
  br i1 %6, label %after_mz, label %ret_zero

after_mz:
  %7 = getelementptr inbounds i8, i8* %3, i64 60
  %8 = bitcast i8* %7 to i32*
  %9 = load i32, i32* %8, align 4
  %10 = sext i32 %9 to i64
  %11 = getelementptr inbounds i8, i8* %3, i64 %10
  %12 = bitcast i8* %11 to i32*
  %13 = load i32, i32* %12, align 4
  %14 = icmp eq i32 %13, 17744
  br i1 %14, label %check_magic, label %ret_zero

check_magic:
  %15 = getelementptr inbounds i8, i8* %11, i64 24
  %16 = bitcast i8* %15 to i16*
  %17 = load i16, i16* %16, align 2
  %18 = icmp eq i16 %17, 523
  br i1 %18, label %check_nsects, label %ret_zero

check_nsects:
  %19 = getelementptr inbounds i8, i8* %11, i64 6
  %20 = bitcast i8* %19 to i16*
  %21 = load i16, i16* %20, align 2
  %22 = icmp eq i16 %21, 0
  br i1 %22, label %ret_zero, label %calc_firstsec

calc_firstsec:
  %23 = getelementptr inbounds i8, i8* %11, i64 20
  %24 = bitcast i8* %23 to i16*
  %25 = load i16, i16* %24, align 2
  %26 = zext i16 %25 to i64
  %27 = add i64 %26, 24
  %28 = getelementptr inbounds i8, i8* %11, i64 %27
  br label %loop

loop:
  %29 = phi i8* [ %28, %calc_firstsec ], [ %34, %incr ]
  %30 = phi i32 [ 0, %calc_firstsec ], [ %33, %incr ]
  %31 = call i32 @sub_140002708(i8* %29, i8* %0, i32 8)
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %ret_match, label %incr

incr:
  %33 = add i32 %30, 1
  %34 = getelementptr inbounds i8, i8* %29, i64 40
  %35 = getelementptr inbounds i8, i8* %11, i64 6
  %36 = bitcast i8* %35 to i16*
  %37 = load i16, i16* %36, align 2
  %38 = zext i16 %37 to i32
  %39 = icmp ult i32 %33, %38
  br i1 %39, label %loop, label %ret_zero

ret_match:
  ret i8* %29

ret_zero:
  ret i8* null
}