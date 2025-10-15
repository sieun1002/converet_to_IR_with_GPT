; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002790(i8* %rcx) local_unnamed_addr {
entry:
  %0 = load i8*, i8** @off_1400043A0, align 1
  %1 = bitcast i8* %0 to i16*
  %2 = load i16, i16* %1, align 1
  %3 = icmp eq i16 %2, 23117
  br i1 %3, label %check_pe, label %ret0

check_pe:                                         ; preds = %entry
  %4 = getelementptr i8, i8* %0, i64 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 1
  %7 = zext i32 %6 to i64
  %8 = getelementptr i8, i8* %0, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 1
  %11 = icmp eq i32 %10, 17744
  br i1 %11, label %check_magic, label %ret0

check_magic:                                      ; preds = %check_pe
  %12 = getelementptr i8, i8* %8, i64 24
  %13 = bitcast i8* %12 to i16*
  %14 = load i16, i16* %13, align 1
  %15 = icmp eq i16 %14, 523
  br i1 %15, label %get_sections, label %ret0

get_sections:                                     ; preds = %check_magic
  %16 = getelementptr i8, i8* %8, i64 6
  %17 = bitcast i8* %16 to i16*
  %18 = load i16, i16* %17, align 1
  %19 = icmp ne i16 %18, 0
  br i1 %19, label %cont1, label %ret0

cont1:                                            ; preds = %get_sections
  %20 = getelementptr i8, i8* %8, i64 20
  %21 = bitcast i8* %20 to i16*
  %22 = load i16, i16* %21, align 1
  %23 = zext i16 %22 to i32
  %24 = ptrtoint i8* %rcx to i64
  %25 = ptrtoint i8* %0 to i64
  %26 = sub i64 %24, %25
  %27 = zext i16 %18 to i32
  %28 = add i32 %27, 4294967295
  %29 = mul i32 %28, 5
  %30 = zext i32 %23 to i64
  %31 = getelementptr i8, i8* %8, i64 24
  %32 = getelementptr i8, i8* %31, i64 %30
  %33 = zext i32 %29 to i64
  %34 = shl i64 %33, 3
  %35 = getelementptr i8, i8* %32, i64 %34
  %36 = getelementptr i8, i8* %35, i64 40
  br label %loop

loop:                                             ; preds = %loop_cont, %cont1
  %rax_cur = phi i8* [ %32, %cont1 ], [ %rax_next, %loop_cont ]
  %37 = getelementptr i8, i8* %rax_cur, i64 12
  %38 = bitcast i8* %37 to i32*
  %39 = load i32, i32* %38, align 1
  %40 = zext i32 %39 to i64
  %41 = icmp ult i64 %26, %40
  br i1 %41, label %loop_cont, label %check_end

check_end:                                        ; preds = %loop
  %42 = getelementptr i8, i8* %rax_cur, i64 8
  %43 = bitcast i8* %42 to i32*
  %44 = load i32, i32* %43, align 1
  %45 = add i32 %39, %44
  %46 = zext i32 %45 to i64
  %47 = icmp ult i64 %26, %46
  br i1 %47, label %found, label %loop_cont

loop_cont:                                        ; preds = %check_end, %loop
  %rax_next = getelementptr i8, i8* %rax_cur, i64 40
  %48 = icmp eq i8* %36, %rax_next
  br i1 %48, label %ret0, label %loop

found:                                            ; preds = %check_end
  %49 = getelementptr i8, i8* %rax_cur, i64 36
  %50 = bitcast i8* %49 to i32*
  %51 = load i32, i32* %50, align 1
  %52 = xor i32 %51, -1
  %53 = lshr i32 %52, 31
  ret i32 %53

ret0:                                             ; preds = %loop_cont, %get_sections, %check_magic, %check_pe, %entry
  ret i32 0
}