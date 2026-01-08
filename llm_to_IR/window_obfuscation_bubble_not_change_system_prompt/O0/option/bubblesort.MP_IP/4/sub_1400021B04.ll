; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043C0 = external dso_local global i8*, align 8

declare i64 @sub_140002700()
declare i32 @sub_140002708(i8*, i8*, i32)

define dso_local i8* @sub_1400021B0(i8* %0) local_unnamed_addr {
entry:
  %1 = call i64 @sub_140002700()
  %2 = icmp ugt i64 %1, 8
  br i1 %2, label %return_zero, label %bb3

bb3:
  %3 = load i8*, i8** @off_1400043C0, align 8
  %4 = bitcast i8* %3 to i16*
  %5 = load i16, i16* %4, align 2
  %6 = icmp eq i16 %5, 23117
  br i1 %6, label %bb8, label %return_zero

bb8:
  %7 = getelementptr inbounds i8, i8* %3, i64 60
  %8 = bitcast i8* %7 to i32*
  %9 = load i32, i32* %8, align 4
  %10 = sext i32 %9 to i64
  %11 = getelementptr inbounds i8, i8* %3, i64 %10
  %12 = bitcast i8* %11 to i32*
  %13 = load i32, i32* %12, align 4
  %14 = icmp eq i32 %13, 17744
  br i1 %14, label %bb17, label %return_zero

bb17:
  %15 = getelementptr inbounds i8, i8* %11, i64 24
  %16 = bitcast i8* %15 to i16*
  %17 = load i16, i16* %16, align 2
  %18 = icmp eq i16 %17, 523
  br i1 %18, label %bb22, label %return_zero

bb22:
  %19 = getelementptr inbounds i8, i8* %11, i64 6
  %20 = bitcast i8* %19 to i16*
  %21 = load i16, i16* %20, align 2
  %22 = icmp eq i16 %21, 0
  br i1 %22, label %return_zero, label %bb27

bb27:
  %23 = getelementptr inbounds i8, i8* %11, i64 20
  %24 = bitcast i8* %23 to i16*
  %25 = load i16, i16* %24, align 2
  %26 = zext i16 %25 to i64
  %27 = getelementptr inbounds i8, i8* %11, i64 24
  %28 = getelementptr inbounds i8, i8* %27, i64 %26
  br label %bb34

bb34:
  %29 = phi i8* [ %28, %bb27 ], [ %33, %bb41 ]
  %30 = phi i32 [ 0, %bb27 ], [ %34, %bb41 ]
  %31 = call i32 @sub_140002708(i8* %29, i8* %0, i32 8)
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %return_cur, label %bb41

bb41:
  %33 = getelementptr inbounds i8, i8* %29, i64 40
  %34 = add i32 %30, 1
  %35 = load i16, i16* %24, align 2
  %36 = zext i16 %35 to i32
  %37 = icmp ult i32 %34, %36
  br i1 %37, label %bb34, label %return_zero

return_cur:
  ret i8* %29

return_zero:
  ret i8* null
}