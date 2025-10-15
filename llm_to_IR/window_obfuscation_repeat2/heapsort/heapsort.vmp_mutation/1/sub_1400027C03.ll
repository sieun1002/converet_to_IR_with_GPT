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

check_pe:
  %4 = getelementptr inbounds i8, i8* %0, i64 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 4
  %7 = zext i32 %6 to i64
  %8 = getelementptr inbounds i8, i8* %0, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 4
  %11 = icmp eq i32 %10, 17744
  br i1 %11, label %check_magic, label %ret_null

check_magic:
  %12 = getelementptr inbounds i8, i8* %8, i64 24
  %13 = bitcast i8* %12 to i16*
  %14 = load i16, i16* %13, align 2
  %15 = icmp eq i16 %14, 523
  br i1 %15, label %read_import_rva, label %ret_null

read_import_rva:
  %16 = getelementptr inbounds i8, i8* %8, i64 144
  %17 = bitcast i8* %16 to i32*
  %18 = load i32, i32* %17, align 4
  %19 = icmp ne i32 %18, 0
  br i1 %19, label %read_sections_count, label %ret_null

read_sections_count:
  %20 = getelementptr inbounds i8, i8* %8, i64 6
  %21 = bitcast i8* %20 to i16*
  %22 = load i16, i16* %21, align 2
  %23 = zext i16 %22 to i32
  %24 = icmp ne i32 %23, 0
  br i1 %24, label %read_sizeopt, label %ret_null

read_sizeopt:
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

sec_loop:
  %34 = phi i8* [ %30, %read_sizeopt ], [ %next_sec_ptr, %sec_inc ]
  %35 = icmp eq i8* %34, %33
  br i1 %35, label %ret_null, label %sec_check

sec_check:
  %36 = getelementptr inbounds i8, i8* %34, i64 12
  %37 = bitcast i8* %36 to i32*
  %sec_va = load i32, i32* %37, align 4
  %38 = icmp ult i32 %18, %sec_va
  br i1 %38, label %sec_inc, label %check_end_in_sec

check_end_in_sec:
  %39 = getelementptr inbounds i8, i8* %34, i64 8
  %40 = bitcast i8* %39 to i32*
  %41 = load i32, i32* %40, align 4
  %42 = add i32 %sec_va, %41
  %43 = icmp ult i32 %18, %42
  br i1 %43, label %found_sec, label %sec_inc

sec_inc:
  %next_sec_ptr = getelementptr inbounds i8, i8* %34, i64 40
  br label %sec_loop

found_sec:
  %44 = zext i32 %18 to i64
  %45 = getelementptr inbounds i8, i8* %0, i64 %44
  br label %desc_loop

desc_loop:
  %46 = phi i8* [ %45, %found_sec ], [ %56, %desc_advance ]
  %47 = phi i32 [ %ecx, %found_sec ], [ %55, %desc_advance ]
  %48 = getelementptr inbounds i8, i8* %46, i64 4
  %49 = bitcast i8* %48 to i32*
  %desc_thunk = load i32, i32* %49, align 4
  %has_thunk = icmp ne i32 %desc_thunk, 0
  br i1 %has_thunk, label %check_idx, label %check_null_desc

check_null_desc:
  %50 = getelementptr inbounds i8, i8* %46, i64 12
  %51 = bitcast i8* %50 to i32*
  %52 = load i32, i32* %51, align 4
  %53 = icmp eq i32 %52, 0
  br i1 %53, label %ret_null, label %check_idx

check_idx:
  %54 = icmp sgt i32 %47, 0
  br i1 %54, label %desc_advance, label %return_name

desc_advance:
  %55 = add nsw i32 %47, -1
  %56 = getelementptr inbounds i8, i8* %46, i64 20
  br label %desc_loop

return_name:
  %57 = getelementptr inbounds i8, i8* %46, i64 12
  %58 = bitcast i8* %57 to i32*
  %59 = load i32, i32* %58, align 4
  %60 = zext i32 %59 to i64
  %61 = getelementptr inbounds i8, i8* %0, i64 %60
  ret i8* %61

ret_null:
  ret i8* null
}