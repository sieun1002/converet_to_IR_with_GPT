; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@aAddressPHasNoI = internal unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare void @sub_14000CFBC(i8*, i8*, i32)
declare void @sub_140001700(i8*, i8*)

define dso_local void @sub_140001760(i8* %rcx) local_unnamed_addr {
entry:
  %var48 = alloca [48 x i8], align 8
  %0 = load i32, i32* @dword_1400070A4, align 4
  %1 = icmp sle i32 %0, 0
  br i1 %1, label %noentries, label %scan_init

scan_init:                                        ; preds = %entry
  %2 = load i8*, i8** @qword_1400070A8, align 8
  %3 = getelementptr inbounds i8, i8* %2, i64 24
  br label %loop

loop:                                             ; preds = %after_next, %scan_init
  %ptr = phi i8* [ %3, %scan_init ], [ %13, %after_next ]
  %i = phi i32 [ 0, %scan_init ], [ %12, %after_next ]
  %4 = bitcast i8* %ptr to i8**
  %5 = load i8*, i8** %4, align 8
  %6 = ptrtoint i8* %rcx to i64
  %7 = ptrtoint i8* %5 to i64
  %8 = icmp ult i64 %6, %7
  br i1 %8, label %after_next, label %check_end

check_end:                                        ; preds = %loop
  %9 = getelementptr inbounds i8, i8* %ptr, i64 8
  %10 = bitcast i8* %9 to i8**
  %11 = load i8*, i8** %10, align 8
  %12a = getelementptr inbounds i8, i8* %11, i64 8
  %13a = bitcast i8* %12a to i32*
  %14 = load i32, i32* %13a, align 4
  %15 = zext i32 %14 to i64
  %16 = ptrtoint i8* %5 to i64
  %17 = add i64 %16, %15
  %18 = icmp ult i64 %6, %17
  br i1 %18, label %found_return, label %after_next

after_next:                                       ; preds = %check_end, %loop
  %12 = add i32 %i, 1
  %13 = getelementptr inbounds i8, i8* %ptr, i64 40
  %19 = icmp ne i32 %12, %0
  br i1 %19, label %loop, label %notfound_path_from_loop

found_return:                                     ; preds = %check_end
  ret void

noentries:                                        ; preds = %entry
  br label %notfound_entry

notfound_path_from_loop:                          ; preds = %after_next
  br label %notfound_entry

notfound_entry:                                   ; preds = %notfound_path_from_loop, %noentries
  %esi_final = phi i32 [ 0, %noentries ], [ %0, %notfound_path_from_loop ]
  %20 = call i8* @sub_140002250(i8* %rcx)
  %21 = icmp eq i8* %20, null
  br i1 %21, label %print_error, label %continue_update

continue_update:                                  ; preds = %notfound_entry
  %22 = load i8*, i8** @qword_1400070A8, align 8
  %23 = sext i32 %esi_final to i64
  %24 = mul i64 %23, 5
  %25 = shl i64 %24, 3
  %26 = getelementptr inbounds i8, i8* %22, i64 %25
  %27 = getelementptr inbounds i8, i8* %26, i64 32
  %28 = bitcast i8* %27 to i8**
  store i8* %20, i8** %28, align 8
  %29 = bitcast i8* %26 to i32*
  store i32 0, i32* %29, align 4
  %30 = call i8* @sub_140002390()
  %31 = getelementptr inbounds i8, i8* %20, i64 12
  %32 = bitcast i8* %31 to i32*
  %33 = load i32, i32* %32, align 4
  %34 = zext i32 %33 to i64
  %35 = getelementptr inbounds i8, i8* %30, i64 %34
  %36 = load i8*, i8** @qword_1400070A8, align 8
  %37 = getelementptr inbounds i8, i8* %36, i64 %25
  %38 = getelementptr inbounds i8, i8* %37, i64 24
  %39 = bitcast i8* %38 to i8**
  store i8* %35, i8** %39, align 8
  %40 = getelementptr inbounds [48 x i8], [48 x i8]* %var48, i64 0, i64 0
  call void @sub_14000CFBC(i8* %35, i8* %40, i32 48)
  ret void

print_error:                                      ; preds = %notfound_entry
  %41 = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void @sub_140001700(i8* %41, i8* %rcx)
  ret void
}