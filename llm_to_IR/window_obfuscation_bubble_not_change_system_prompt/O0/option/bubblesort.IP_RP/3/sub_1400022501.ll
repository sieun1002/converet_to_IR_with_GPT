target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define i32 @sub_140002250(i8* %rcx) {
entry:
  %0 = load i8*, i8** @off_1400043C0, align 8
  %1 = bitcast i8* %0 to i16*
  %2 = load i16, i16* %1, align 1
  %3 = icmp eq i16 %2, 23117
  br i1 %3, label %check_pe, label %ret0

ret0:                                             ; preds = %advance, %check_in, %check_opt, %check_pe, %entry, %get_sections
  ret i32 0

check_pe:                                         ; preds = %entry
  %4 = getelementptr i8, i8* %0, i64 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 1
  %7 = sext i32 %6 to i64
  %8 = getelementptr i8, i8* %0, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 1
  %11 = icmp eq i32 %10, 17744
  br i1 %11, label %check_opt, label %ret0

check_opt:                                        ; preds = %check_pe
  %12 = getelementptr i8, i8* %8, i64 24
  %13 = bitcast i8* %12 to i16*
  %14 = load i16, i16* %13, align 1
  %15 = icmp eq i16 %14, 523
  br i1 %15, label %get_sections, label %ret0

get_sections:                                     ; preds = %check_opt
  %16 = getelementptr i8, i8* %8, i64 6
  %17 = bitcast i8* %16 to i16*
  %18 = load i16, i16* %17, align 1
  %19 = zext i16 %18 to i32
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %ret0, label %cont1

cont1:                                            ; preds = %get_sections
  %21 = getelementptr i8, i8* %8, i64 20
  %22 = bitcast i8* %21 to i16*
  %23 = load i16, i16* %22, align 1
  %24 = zext i16 %23 to i32
  %25 = ptrtoint i8* %rcx to i64
  %26 = ptrtoint i8* %0 to i64
  %27 = sub i64 %25, %26
  %28 = zext i32 %24 to i64
  %29 = add i64 %28, 24
  %30 = getelementptr i8, i8* %8, i64 %29
  %31 = add i32 %19, -1
  %32 = mul i32 %31, 40
  %33 = zext i32 %32 to i64
  %34 = add i64 %33, 40
  %35 = getelementptr i8, i8* %30, i64 %34
  br label %loop

loop:                                             ; preds = %advance, %cont1
  %curr = phi i8* [ %30, %cont1 ], [ %next, %advance ]
  %36 = getelementptr i8, i8* %curr, i64 12
  %37 = bitcast i8* %36 to i32*
  %38 = load i32, i32* %37, align 1
  %39 = zext i32 %38 to i64
  %40 = icmp ult i64 %27, %39
  br i1 %40, label %advance, label %check_in

check_in:                                         ; preds = %loop
  %41 = getelementptr i8, i8* %curr, i64 8
  %42 = bitcast i8* %41 to i32*
  %43 = load i32, i32* %42, align 1
  %44 = zext i32 %43 to i64
  %45 = add i64 %39, %44
  %46 = icmp ult i64 %27, %45
  br i1 %46, label %ret_size, label %advance

advance:                                          ; preds = %check_in, %loop
  %next = getelementptr i8, i8* %curr, i64 40
  %47 = icmp eq i8* %next, %35
  br i1 %47, label %final_zero, label %loop

ret_size:                                         ; preds = %check_in
  ret i32 %24

final_zero:                                       ; preds = %advance
  ret i32 0
}