; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043C0 = external dso_local global i8*, align 8

declare x86_64_win64cc i64 @sub_140002700()
declare x86_64_win64cc i32 @sub_140002708(i8*, i8*, i32)

define dso_local x86_64_win64cc i8* @sub_1400021B0(i8* %0) local_unnamed_addr {
entry:
  %1 = call x86_64_win64cc i64 @sub_140002700()
  %2 = icmp ugt i64 %1, 8
  br i1 %2, label %return_zero, label %3

3:                                                ; preds = %entry
  %4 = load i8*, i8** @off_1400043C0, align 8
  %5 = bitcast i8* %4 to i16*
  %6 = load i16, i16* %5, align 2
  %7 = icmp eq i16 %6, 23117
  br i1 %7, label %8, label %return_zero

8:                                                ; preds = %3
  %9 = getelementptr inbounds i8, i8* %4, i64 60
  %10 = bitcast i8* %9 to i32*
  %11 = load i32, i32* %10, align 4
  %12 = sext i32 %11 to i64
  %13 = getelementptr inbounds i8, i8* %4, i64 %12
  %14 = bitcast i8* %13 to i32*
  %15 = load i32, i32* %14, align 4
  %16 = icmp eq i32 %15, 17744
  br i1 %16, label %17, label %return_zero

17:                                               ; preds = %8
  %18 = getelementptr inbounds i8, i8* %13, i64 24
  %19 = bitcast i8* %18 to i16*
  %20 = load i16, i16* %19, align 2
  %21 = icmp eq i16 %20, 523
  br i1 %21, label %22, label %return_zero

22:                                               ; preds = %17
  %23 = getelementptr inbounds i8, i8* %13, i64 6
  %24 = bitcast i8* %23 to i16*
  %25 = load i16, i16* %24, align 2
  %26 = icmp eq i16 %25, 0
  br i1 %26, label %return_zero, label %27

27:                                               ; preds = %22
  %28 = getelementptr inbounds i8, i8* %13, i64 20
  %29 = bitcast i8* %28 to i16*
  %30 = load i16, i16* %29, align 2
  %31 = zext i16 %30 to i64
  %32 = getelementptr inbounds i8, i8* %13, i64 24
  %33 = getelementptr inbounds i8, i8* %32, i64 %31
  br label %34

34:                                               ; preds = %41, %27
  %35 = phi i8* [ %33, %27 ], [ %42, %41 ]
  %36 = phi i32 [ 0, %27 ], [ %43, %41 ]
  %37 = call x86_64_win64cc i32 @sub_140002708(i8* %35, i8* %0, i32 8)
  %38 = icmp eq i32 %37, 0
  br i1 %38, label %return_cur, label %41

41:                                               ; preds = %34
  %42 = getelementptr inbounds i8, i8* %35, i64 40
  %43 = add i32 %36, 1
  %44 = load i16, i16* %24, align 2
  %45 = zext i16 %44 to i32
  %46 = icmp ult i32 %43, %45
  br i1 %46, label %34, label %return_zero

return_cur:                                       ; preds = %34
  ret i8* %35

return_zero:                                      ; preds = %41, %22, %17, %8, %3, %entry
  ret i8* null
}