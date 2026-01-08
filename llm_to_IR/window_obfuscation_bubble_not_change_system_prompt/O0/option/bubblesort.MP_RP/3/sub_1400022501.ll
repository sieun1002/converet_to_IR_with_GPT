; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i32 @sub_140002250(i8* %rcx) local_unnamed_addr {
entry:
  %0 = load i8*, i8** @off_1400043C0, align 8
  %1 = getelementptr i8, i8* %0, i64 0
  %2 = bitcast i8* %1 to i16*
  %3 = load i16, i16* %2, align 1
  %4 = icmp eq i16 %3, 23117
  br i1 %4, label %after_mz, label %ret0

after_mz:                                            ; preds = %entry
  %5 = getelementptr i8, i8* %0, i64 60
  %6 = bitcast i8* %5 to i32*
  %7 = load i32, i32* %6, align 1
  %8 = sext i32 %7 to i64
  %9 = getelementptr i8, i8* %0, i64 %8
  %10 = bitcast i8* %9 to i32*
  %11 = load i32, i32* %10, align 1
  %12 = icmp eq i32 %11, 17744
  br i1 %12, label %check_opt, label %ret0

check_opt:                                           ; preds = %after_mz
  %13 = getelementptr i8, i8* %9, i64 24
  %14 = bitcast i8* %13 to i16*
  %15 = load i16, i16* %14, align 1
  %16 = icmp eq i16 %15, 523
  br i1 %16, label %cont_after_magic, label %ret0

cont_after_magic:                                    ; preds = %check_opt
  %17 = getelementptr i8, i8* %9, i64 6
  %18 = bitcast i8* %17 to i16*
  %19 = load i16, i16* %18, align 1
  %20 = zext i16 %19 to i32
  %21 = icmp eq i32 %20, 0
  br i1 %21, label %ret0, label %have_nsec

have_nsec:                                           ; preds = %cont_after_magic
  %22 = getelementptr i8, i8* %9, i64 20
  %23 = bitcast i8* %22 to i16*
  %24 = load i16, i16* %23, align 1
  %25 = zext i16 %24 to i32
  %26 = ptrtoint i8* %rcx to i64
  %27 = ptrtoint i8* %0 to i64
  %28 = sub i64 %26, %27
  %29 = sub i32 %20, 1
  %30 = zext i32 %29 to i64
  %31 = mul i64 %30, 5
  %32 = zext i32 %25 to i64
  %33 = getelementptr i8, i8* %9, i64 24
  %34 = getelementptr i8, i8* %33, i64 %32
  %35 = mul i64 %31, 8
  %36 = getelementptr i8, i8* %34, i64 %35
  %37 = getelementptr i8, i8* %36, i64 40
  br label %loop.body

loop.body:                                           ; preds = %loop.cont, %have_nsec
  %cur = phi i8* [ %34, %have_nsec ], [ %next, %loop.cont ]
  %38 = getelementptr i8, i8* %cur, i64 12
  %39 = bitcast i8* %38 to i32*
  %40 = load i32, i32* %39, align 1
  %41 = zext i32 %40 to i64
  %42 = icmp ult i64 %28, %41
  br i1 %42, label %loc_1400022C4, label %after_cmp1

after_cmp1:                                          ; preds = %loop.body
  %43 = getelementptr i8, i8* %cur, i64 8
  %44 = bitcast i8* %43 to i32*
  %45 = load i32, i32* %44, align 1
  %46 = add i32 %40, %45
  %47 = zext i32 %46 to i64
  %48 = icmp ult i64 %28, %47
  br i1 %48, label %ret_match, label %loc_1400022C4

loc_1400022C4:                                       ; preds = %after_cmp1, %loop.body
  %next = getelementptr i8, i8* %cur, i64 40
  %49 = icmp ne i8* %next, %37
  br i1 %49, label %loop.cont, label %end_notfound

loop.cont:                                           ; preds = %loc_1400022C4
  br label %loop.body

ret_match:                                           ; preds = %after_cmp1
  %50 = ptrtoint i8* %cur to i64
  %51 = trunc i64 %50 to i32
  ret i32 %51

end_notfound:                                        ; preds = %loc_1400022C4
  ret i32 0

ret0:                                                ; preds = %cont_after_magic, %check_opt, %after_mz, %entry
  ret i32 0
}