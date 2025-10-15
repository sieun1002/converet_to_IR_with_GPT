; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002610(i8* %0) local_unnamed_addr {
entry:
  %1 = load i8*, i8** @off_1400043A0, align 8
  %2 = bitcast i8* %1 to i16*
  %3 = load i16, i16* %2, align 1
  %4 = icmp eq i16 %3, 23117
  br i1 %4, label %check_pe, label %ret0

check_pe:                                         ; preds = %entry
  %5 = getelementptr i8, i8* %1, i64 60
  %6 = bitcast i8* %5 to i32*
  %7 = load i32, i32* %6, align 1
  %8 = sext i32 %7 to i64
  %9 = getelementptr i8, i8* %1, i64 %8
  %10 = bitcast i8* %9 to i32*
  %11 = load i32, i32* %10, align 1
  %12 = icmp eq i32 %11, 17744
  br i1 %12, label %check_magic, label %ret0

check_magic:                                      ; preds = %check_pe
  %13 = getelementptr i8, i8* %9, i64 24
  %14 = bitcast i8* %13 to i16*
  %15 = load i16, i16* %14, align 1
  %16 = icmp eq i16 %15, 523
  br i1 %16, label %load_sections, label %ret0

load_sections:                                    ; preds = %check_magic
  %17 = getelementptr i8, i8* %9, i64 6
  %18 = bitcast i8* %17 to i16*
  %19 = load i16, i16* %18, align 1
  %20 = icmp eq i16 %19, 0
  br i1 %20, label %ret0, label %calc_section_table

calc_section_table:                               ; preds = %load_sections
  %21 = getelementptr i8, i8* %9, i64 20
  %22 = bitcast i8* %21 to i16*
  %23 = load i16, i16* %22, align 1
  %24 = zext i16 %23 to i64
  %25 = add i64 %24, 24
  %26 = getelementptr i8, i8* %9, i64 %25
  %27 = ptrtoint i8* %0 to i64
  %28 = ptrtoint i8* %1 to i64
  %29 = sub i64 %27, %28
  %30 = zext i16 %19 to i64
  %31 = mul i64 %30, 40
  %32 = getelementptr i8, i8* %26, i64 %31
  br label %loop

loop:                                             ; preds = %inc, %calc_section_table
  %33 = phi i8* [ %26, %calc_section_table ], [ %38, %inc ]
  %34 = icmp eq i8* %33, %32
  br i1 %34, label %ret0, label %check_section

check_section:                                    ; preds = %loop
  %35 = getelementptr i8, i8* %33, i64 12
  %36 = bitcast i8* %35 to i32*
  %37 = load i32, i32* %36, align 1
  %40 = zext i32 %37 to i64
  %41 = icmp uge i64 %29, %40
  br i1 %41, label %check_upper, label %inc

check_upper:                                      ; preds = %check_section
  %42 = getelementptr i8, i8* %33, i64 8
  %43 = bitcast i8* %42 to i32*
  %44 = load i32, i32* %43, align 1
  %45 = add i32 %37, %44
  %46 = zext i32 %45 to i64
  %47 = icmp ult i64 %29, %46
  br i1 %47, label %ret0, label %inc

inc:                                              ; preds = %check_upper, %check_section
  %38 = getelementptr i8, i8* %33, i64 40
  br label %loop

ret0:                                             ; preds = %check_upper, %loop, %calc_section_table, %load_sections, %check_magic, %check_pe, %entry
  ret i32 0
}