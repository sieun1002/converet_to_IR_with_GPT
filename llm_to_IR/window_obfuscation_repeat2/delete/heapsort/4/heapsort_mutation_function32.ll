; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8**)*

declare void @sub_140001010()
declare i8* @signal(i32, i8*)
declare void @sub_1400024E0()

define void @sub_1400013E0() {
entry:
  %0 = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %0, align 4
  call void @sub_140001010()
  ret void
}

define i32 @sub_140002080(i8** %p) {
entry:
  %rbx = alloca i8**, align 8
  store i8** %p, i8*** %rbx, align 8
  %0 = load i8**, i8*** %rbx, align 8
  %1 = load i8*, i8** %0, align 8
  %2 = bitcast i8* %1 to i32*
  %3 = load i32, i32* %2, align 4
  %4 = and i32 %3, 553648127
  %5 = icmp eq i32 %4, 541541187
  br i1 %5, label %ccg, label %cmpStart

ccg:
  %6 = getelementptr i8, i8* %1, i64 4
  %7 = load i8, i8* %6, align 1
  %8 = and i8 %7, 1
  %9 = icmp ne i8 %8, 0
  br i1 %9, label %cmpStart, label %ret_minus1

cmpStart:
  %10 = icmp ugt i32 %3, 3221225622
  br i1 %10, label %loc_0EF, label %cmp2

cmp2:
  %11 = icmp ule i32 %3, 3221225611
  br i1 %11, label %loc_110, label %switch_region

loc_110:
  %12 = icmp eq i32 %3, 3221225477
  br i1 %12, label %loc_1C0, label %loc_110_cmp2

loc_110_cmp2:
  %13 = icmp ugt i32 %3, 3221225477
  br i1 %13, label %loc_150, label %loc_11D

loc_11D:
  %14 = icmp eq i32 %3, 2147483650
  br i1 %14, label %ret_minus1, label %loc_0EF

loc_150:
  %15 = icmp eq i32 %3, 3221225480
  br i1 %15, label %ret_minus1, label %loc_150_cmp2

loc_150_cmp2:
  %16 = icmp eq i32 %3, 3221225501
  br i1 %16, label %loc_15E, label %loc_0EF

switch_region:
  %17 = icmp eq i32 %3, 3221225620
  br i1 %17, label %loc_190, label %switch_other

switch_other:
  %18 = icmp eq i32 %3, 3221225613
  %19 = icmp eq i32 %3, 3221225614
  %20 = or i1 %18, %19
  %21 = icmp eq i32 %3, 3221225615
  %22 = or i1 %20, %21
  %23 = icmp eq i32 %3, 3221225616
  %24 = or i1 %22, %23
  %25 = icmp eq i32 %3, 3221225617
  %26 = or i1 %24, %25
  %27 = icmp eq i32 %3, 3221225619
  %28 = or i1 %26, %27
  br i1 %28, label %loc_0D0, label %ret_minus1

loc_0D0:
  %29 = call i8* @signal(i32 8, i8* null)
  %30 = inttoptr i64 1 to i8*
  %31 = icmp eq i8* %29, %30
  br i1 %31, label %loc_224, label %loc_0E6_test1

loc_0E6_test1:
  %32 = icmp ne i8* %29, null
  br i1 %32, label %loc_1F0_call1, label %loc_0EF

loc_1F0_call1:
  %33 = bitcast i8* %29 to void (i32)*
  call void %33(i32 8)
  br label %ret_minus1

loc_190:
  %34 = call i8* @signal(i32 8, i8* null)
  %35 = inttoptr i64 1 to i8*
  %36 = icmp eq i8* %34, %35
  br i1 %36, label %loc_1A6, label %loc_0E6_test2

loc_0E6_test2:
  %37 = icmp ne i8* %34, null
  br i1 %37, label %loc_1F0_call2, label %loc_0EF

loc_1F0_call2:
  %38 = bitcast i8* %34 to void (i32)*
  call void %38(i32 8)
  br label %ret_minus1

loc_1A6:
  %39 = call i8* @signal(i32 8, i8* %35)
  br label %ret_minus1

loc_15E:
  %40 = call i8* @signal(i32 4, i8* null)
  %41 = inttoptr i64 1 to i8*
  %42 = icmp eq i8* %40, %41
  br i1 %42, label %loc_210, label %loc_15E_test

loc_15E_test:
  %43 = icmp ne i8* %40, null
  br i1 %43, label %loc_182_call, label %loc_0EF

loc_182_call:
  %44 = bitcast i8* %40 to void (i32)*
  call void %44(i32 4)
  br label %ret_minus1

loc_210:
  %45 = call i8* @signal(i32 4, i8* %41)
  br label %ret_minus1

loc_1C0:
  %46 = call i8* @signal(i32 11, i8* null)
  %47 = inttoptr i64 1 to i8*
  %48 = icmp eq i8* %46, %47
  br i1 %48, label %loc_1FC, label %loc_1C0_test

loc_1C0_test:
  %49 = icmp ne i8* %46, null
  br i1 %49, label %loc_1E0_call, label %loc_0EF

loc_1E0_call:
  %50 = bitcast i8* %46 to void (i32)*
  call void %50(i32 11)
  br label %ret_minus1

loc_1FC:
  %51 = call i8* @signal(i32 11, i8* %47)
  br label %ret_minus1

loc_224:
  %52 = call i8* @signal(i32 8, i8* %30)
  call void @sub_1400024E0()
  br label %ret_minus1

loc_0EF:
  %53 = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %54 = icmp eq i32 (i8**)* %53, null
  br i1 %54, label %ret0, label %tailcb

ret0:
  ret i32 0

tailcb:
  %55 = load i8**, i8*** %rbx, align 8
  %56 = tail call i32 %53(i8** %55)
  ret i32 %56

ret_minus1:
  ret i32 -1
}