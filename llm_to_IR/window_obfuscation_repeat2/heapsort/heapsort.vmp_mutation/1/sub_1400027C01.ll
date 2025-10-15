; ModuleID = 'pe_utils'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i8* @sub_1400027C0(i32 %ecx) {
entry:
  %0 = load i8*, i8** @off_1400043A0
  %1 = bitcast i8* %0 to i16*
  %2 = load i16, i16* %1, align 2
  %3 = icmp eq i16 %2, 23117
  br i1 %3, label %check_pe, label %ret_null

check_pe:                                         ; preds = %entry
  %4 = getelementptr inbounds i8, i8* %0, i64 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 4
  %7 = zext i32 %6 to i64
  %8 = getelementptr inbounds i8, i8* %0, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 4
  %11 = icmp eq i32 %10, 17744
  br i1 %11, label %check_magic, label %ret_null

check_magic:                                      ; preds = %check_pe
  %12 = getelementptr inbounds i8, i8* %8, i64 24
  %13 = bitcast i8* %12 to i16*
  %14 = load i16, i16* %13, align 2
  %15 = icmp eq i16 %14, 523
  br i1 %15, label %read_import_rva, label %ret_null

read_import_rva:                                  ; preds = %check_magic
  %16 = getelementptr inbounds i8, i8* %8, i64 144
  %17 = bitcast i8* %16 to i32*
  %18 = load i32, i32* %17, align 4
  %19 = icmp ne i32 %18, 0
  br i1 %19, label %read_sections_count, label %ret_null

read_sections_count:                              ; preds = %read_import_rva
  %20 = getelementptr inbounds i8, i8* %8, i64 6
  %21 = bitcast i8* %20 to i16*
  %22 = load i16, i16* %21, align 2
  %23 = zext i16 %22 to i32
  %24 = icmp ne i32 %23, 0
  br i1 %24, label %read_sizeopt, label %ret_null

read_sizeopt:                                     ; preds = %read_sections_count
  %25 = getelementptr inbounds i8, i8* %8, i64 20
  %26 = bitcast i8* %25 to i16*
  %27 = load i16, i16* %26, align 2
  %28 = zext i16 %27 to i64
  %29 = getelementptr inbounds i8, i8* %8, i64 24
  %30 = getelementptr inbounds i8, i8* %29, i64 %28
  %31 = zext i32 %23 to i64
  %32 = mul nuw i64 %31, 40
  %33 = getelementptr inbounds i8, i8* %30, i64 %32
  br label %sec_loop

sec_loop:                                         ; preds = %sec_inc, %read_sizeopt
  %34 = phi i8* [ %30, %read_sizeopt ], [ %38, %sec_inc ]
  %35 = icmp eq i8* %34, %33
  br i1 %35, label %ret_null, label %sec_check

sec_check:                                        ; preds = %sec_loop
  %36 = getelementptr inbounds i8, i8* %34, i64 12
  %37 = bitcast i8* %36 to i32*
  %38load = load i32, i32* %37, align 4
  %39 = icmp ult i32 %18, %38load
  br i1 %39, label %sec_inc, label %check_end_in_sec

check_end_in_sec:                                 ; preds = %sec_check
  %40 = getelementptr inbounds i8, i8* %34, i64 8
  %41 = bitcast i8* %40 to i32*
  %42 = load i32, i32* %41, align 4
  %43 = add i32 %38load, %42
  %44 = icmp ult i32 %18, %43
  br i1 %44, label %found_sec, label %sec_inc

sec_inc:                                          ; preds = %check_end_in_sec, %sec_check
  %38 = getelementptr inbounds i8, i8* %34, i64 40
  br label %sec_loop

found_sec:                                        ; preds = %check_end_in_sec
  %45 = zext i32 %18 to i64
  %46 = getelementptr inbounds i8, i8* %0, i64 %45
  br label %desc_loop

desc_loop:                                        ; preds = %desc_advance, %found_sec
  %47 = phi i8* [ %46, %found_sec ], [ %52, %desc_advance ]
  %48 = phi i32 [ %ecx, %found_sec ], [ %51, %desc_advance ]
  %49 = getelementptr inbounds i8, i8* %47, i64 4
  %50 = bitcast i8* %49 to i32*
  %51load = load i32, i32* %50, align 4
  %52cmp = icmp ne i32 %51load, 0
  br i1 %52cmp, label %check_idx, label %check_null_desc

check_null_desc:                                  ; preds = %desc_loop
  %53 = getelementptr inbounds i8, i8* %47, i64 12
  %54 = bitcast i8* %53 to i32*
  %55 = load i32, i32* %54, align 4
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %ret_null, label %check_idx

check_idx:                                        ; preds = %check_null_desc, %desc_loop
  %57 = icmp sgt i32 %48, 0
  br i1 %57, label %desc_advance, label %return_name

desc_advance:                                     ; preds = %check_idx
  %51 = add nsw i32 %48, -1
  %52 = getelementptr inbounds i8, i8* %47, i64 20
  br label %desc_loop

return_name:                                      ; preds = %check_idx
  %58 = getelementptr inbounds i8, i8* %47, i64 12
  %59 = bitcast i8* %58 to i32*
  %60 = load i32, i32* %59, align 4
  %61 = zext i32 %60 to i64
  %62 = getelementptr inbounds i8, i8* %0, i64 %61
  ret i8* %62

ret_null:                                         ; preds = %check_null_desc, %sec_loop, %read_sections_count, %read_import_rva, %check_magic, %check_pe, %entry
  ret i8* null
}