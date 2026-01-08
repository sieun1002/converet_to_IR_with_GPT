target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_140002700(i8*)
declare i32 @sub_140002708(i8*, i8*, i32)

@off_1400043C0 = external global i8*

define i8* @sub_1400021B0(i8* %0) {
entry:
  %1 = call i64 @sub_140002700(i8* %0)
  %2 = icmp ugt i64 %1, 8
  br i1 %2, label %ret_zero, label %check_mz

check_mz:
  %3 = load i8*, i8** @off_1400043C0, align 8
  %4 = bitcast i8* %3 to i16*
  %5 = load i16, i16* %4, align 1
  %6 = icmp eq i16 %5, 23117
  br i1 %6, label %ntcalc, label %ret_zero

ntcalc:
  %7 = getelementptr inbounds i8, i8* %3, i32 60
  %8 = bitcast i8* %7 to i32*
  %9 = load i32, i32* %8, align 1
  %10 = sext i32 %9 to i64
  %11 = getelementptr inbounds i8, i8* %3, i64 %10
  %12 = bitcast i8* %11 to i32*
  %13 = load i32, i32* %12, align 1
  %14 = icmp eq i32 %13, 17744
  br i1 %14, label %check_magic, label %ret_zero

check_magic:
  %15 = getelementptr inbounds i8, i8* %11, i32 24
  %16 = bitcast i8* %15 to i16*
  %17 = load i16, i16* %16, align 1
  %18 = icmp eq i16 %17, 523
  br i1 %18, label %check_nsec, label %ret_zero

check_nsec:
  %19 = getelementptr inbounds i8, i8* %11, i32 6
  %20 = bitcast i8* %19 to i16*
  %21 = load i16, i16* %20, align 1
  %22 = icmp eq i16 %21, 0
  br i1 %22, label %ret_zero, label %setup_loop

setup_loop:
  %23 = getelementptr inbounds i8, i8* %11, i32 20
  %24 = bitcast i8* %23 to i16*
  %25 = load i16, i16* %24, align 1
  %26 = zext i16 %25 to i32
  %27 = add i32 %26, 24
  %28 = zext i32 %27 to i64
  %29 = getelementptr inbounds i8, i8* %11, i64 %28
  %30 = zext i16 %21 to i32
  br label %loop

loop:
  %31 = phi i32 [ 0, %setup_loop ], [ %35, %loop_cont ]
  %32 = phi i8* [ %29, %setup_loop ], [ %36, %loop_cont ]
  %33 = call i32 @sub_140002708(i8* %32, i8* %0, i32 8)
  %34 = icmp eq i32 %33, 0
  br i1 %34, label %ret_rbx, label %loop_cont

loop_cont:
  %35 = add i32 %31, 1
  %36 = getelementptr inbounds i8, i8* %32, i32 40
  %37 = icmp ult i32 %35, %30
  br i1 %37, label %loop, label %ret_zero

ret_rbx:
  ret i8* %32

ret_zero:
  ret i8* null
}