; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external dso_local global i32, align 4
@qword_1400070A8 = external dso_local global i8*, align 8
@aVirtualprotect = external dso_local constant i8, align 1
@aAddressPHasNoI = external dso_local constant i8, align 1

declare dso_local i8* @sub_140002250(i8*)
declare dso_local i8* @sub_140002390()
declare dso_local void @sub_140001700(i8*, ...)
declare dso_local i32 @loc_140012A4E(i8*, i8*, i64)
declare dso_local i32 @loc_1400D1740(i8*, i64, i32, i8*)

define dso_local void @sub_140001760(i8* %rcx) {
entry:
  %mem = alloca { i64, i64 }, align 8
  %0 = load i32, i32* @dword_1400070A4, align 4
  %1 = icmp sgt i32 %0, 0
  br i1 %1, label %loop_setup, label %no_match_from_zero

loop_setup:                                       ; preds = %entry
  %2 = load i8*, i8** @qword_1400070A8, align 8
  %3 = getelementptr inbounds i8, i8* %2, i64 24
  br label %loop

loop:                                             ; preds = %inc, %loop_setup
  %cell = phi i8* [ %3, %loop_setup ], [ %12, %inc ]
  %idx = phi i32 [ 0, %loop_setup ], [ %11, %inc ]
  %4 = bitcast i8* %cell to i8**
  %5 = load i8*, i8** %4, align 8
  %6 = ptrtoint i8* %rcx to i64
  %7 = ptrtoint i8* %5 to i64
  %8 = icmp ult i64 %6, %7
  br i1 %8, label %inc, label %check_range

check_range:                                      ; preds = %loop
  %9 = getelementptr inbounds i8, i8* %cell, i64 8
  %10 = bitcast i8* %9 to i8**
  %ptr_loaded = load i8*, i8** %10, align 8
  %ptr_plus8 = getelementptr inbounds i8, i8* %ptr_loaded, i64 8
  %13 = bitcast i8* %ptr_plus8 to i32*
  %14 = load i32, i32* %13, align 4
  %15 = zext i32 %14 to i64
  %16 = add i64 %7, %15
  %17 = icmp ult i64 %6, %16
  br i1 %17, label %ret, label %inc

inc:                                              ; preds = %check_range, %loop
  %11 = add i32 %idx, 1
  %12 = getelementptr inbounds i8, i8* %cell, i64 40
  %18 = icmp ne i32 %11, %0
  br i1 %18, label %loop, label %no_match

no_match_from_zero:                               ; preds = %entry
  br label %no_match

no_match:                                         ; preds = %inc, %no_match_from_zero
  %idx.final = phi i32 [ 0, %no_match_from_zero ], [ %0, %inc ]
  %19 = call i8* @sub_140002250(i8* %rcx)
  %20 = icmp eq i8* %19, null
  br i1 %20, label %has_no_image, label %prepare

prepare:                                          ; preds = %no_match
  %21 = load i8*, i8** @qword_1400070A8, align 8
  %22 = sext i32 %idx.final to i64
  %23 = mul i64 %22, 5
  %24 = shl i64 %23, 3
  %25 = getelementptr inbounds i8, i8* %21, i64 %24
  %26 = getelementptr inbounds i8, i8* %25, i64 32
  %27 = bitcast i8* %26 to i8**
  store i8* %19, i8** %27, align 8
  %28 = bitcast i8* %25 to i32*
  store i32 0, i32* %28, align 4
  %29 = call i8* @sub_140002390()
  %30 = getelementptr inbounds i8, i8* %19, i64 12
  %31 = bitcast i8* %30 to i32*
  %32 = load i32, i32* %31, align 4
  %33 = zext i32 %32 to i64
  %34 = getelementptr inbounds i8, i8* %29, i64 %33
  %35 = getelementptr inbounds i8, i8* %25, i64 24
  %36 = bitcast i8* %35 to i8**
  store i8* %34, i8** %36, align 8
  %37 = bitcast { i64, i64 }* %mem to i8*
  %38 = call i32 @loc_140012A4E(i8* %34, i8* %37, i64 48)
  %39 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %mem, i32 0, i32 0
  %40 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %mem, i32 0, i32 1
  %41 = load i64, i64* %39, align 8
  %42 = load i64, i64* %40, align 8
  %43 = icmp eq i32 %38, 2
  %44 = select i1 %43, i32 4, i32 64
  %45 = load i8*, i8** @qword_1400070A8, align 8
  %46 = getelementptr inbounds i8, i8* %45, i64 %24
  %47 = getelementptr inbounds i8, i8* %46, i64 8
  %48 = bitcast i8* %47 to i64*
  store i64 %41, i64* %48, align 8
  %49 = getelementptr inbounds i8, i8* %46, i64 16
  %50 = bitcast i8* %49 to i64*
  store i64 %42, i64* %50, align 8
  %51 = inttoptr i64 %41 to i8*
  %52 = call i32 @loc_1400D1740(i8* %51, i64 %42, i32 %44, i8* %46)
  call void (i8*, ...) @sub_140001700(i8* @aVirtualprotect, i32 %52)
  br label %ret

has_no_image:                                     ; preds = %no_match
  call void (i8*, ...) @sub_140001700(i8* @aAddressPHasNoI, i8* %rcx)
  br label %ret

ret:                                              ; preds = %prepare, %has_no_image, %check_range
  ret void
}