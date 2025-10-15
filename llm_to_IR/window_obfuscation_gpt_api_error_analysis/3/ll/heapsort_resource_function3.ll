; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*, align 8
@qword_1400070D0 = external global i32 (i8*)*, align 8

declare void @sub_140001010()
declare i8* @signal(i32, i8*)
declare void @sub_1400024E0()

define dso_local void @sub_1400013E0() local_unnamed_addr {
entry:
  %0 = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %0, align 4
  call void @sub_140001010()
  ret void
}

define dso_local i32 @sub_140002080(i8* %rcx) local_unnamed_addr {
entry:
  %0 = bitcast i8* %rcx to i8**
  %1 = load i8*, i8** %0, align 8
  %2 = bitcast i8* %1 to i32*
  %3 = load i32, i32* %2, align 4
  %4 = and i32 %3, 553648127
  %5 = icmp eq i32 %4, 541541187
  br i1 %5, label %check_flag, label %cont_checks

check_flag:                                       ; masked == 0x20474343
  %6 = getelementptr inbounds i8, i8* %1, i64 4
  %7 = load i8, i8* %6, align 1
  %8 = and i8 %7, 1
  %9 = icmp ne i8 %8, 0
  br i1 %9, label %cont_checks, label %ret_minus1

cont_checks:
  %10 = icmp ugt i32 %3, 3221225622
  br i1 %10, label %fallback, label %le_upper

le_upper:
  %11 = icmp ule i32 %3, 3221225611
  br i1 %11, label %block110, label %groupBlock

block110:
  %12 = icmp eq i32 %3, 3221225477
  br i1 %12, label %sigsegv, label %after_segv_check

after_segv_check:
  %13 = icmp ugt i32 %3, 3221225477
  br i1 %13, label %block150, label %before_fallback

before_fallback:
  %14 = icmp eq i32 %3, 2147483650
  br i1 %14, label %ret_minus1, label %fallback

block150:
  %15 = icmp eq i32 %3, 3221225480
  br i1 %15, label %ret_minus1, label %ill_check

ill_check:
  %16 = icmp eq i32 %3, 3221225501
  br i1 %16, label %sigill, label %fallback

groupBlock:
  switch i32 %3, label %ret_minus1 [
    i32 3221225613, label %fp_generic
    i32 3221225614, label %fp_generic
    i32 3221225615, label %fp_generic
    i32 3221225616, label %fp_generic
    i32 3221225617, label %fp_generic
    i32 3221225619, label %fp_generic
    i32 3221225620, label %fp_divzero
  ]

fp_generic:
  %17 = call i8* @signal(i32 8, i8* null)
  %18 = ptrtoint i8* %17 to i64
  %19 = icmp eq i64 %18, 1
  br i1 %19, label %fp_gen_ign, label %fp_gen_check

fp_gen_ign:
  %20 = inttoptr i64 1 to i8*
  %21 = call i8* @signal(i32 8, i8* %20)
  call void @sub_1400024E0()
  br label %ret_minus1

fp_gen_check:
  %22 = icmp ne i8* %17, null
  br i1 %22, label %call_old_fpe, label %fallback

call_old_fpe:
  %23 = bitcast i8* %17 to void (i32)*
  call void %23(i32 8)
  br label %ret_minus1

fp_divzero:
  %24 = call i8* @signal(i32 8, i8* null)
  %25 = ptrtoint i8* %24 to i64
  %26 = icmp eq i64 %25, 1
  br i1 %26, label %fp_div_ign, label %fp_div_check

fp_div_check:
  %27 = icmp ne i8* %24, null
  br i1 %27, label %call_old_fpe2, label %fallback

call_old_fpe2:
  %28 = bitcast i8* %24 to void (i32)*
  call void %28(i32 8)
  br label %ret_minus1

fp_div_ign:
  %29 = inttoptr i64 1 to i8*
  %30 = call i8* @signal(i32 8, i8* %29)
  br label %ret_minus1

sigill:
  %31 = call i8* @signal(i32 4, i8* null)
  %32 = ptrtoint i8* %31 to i64
  %33 = icmp eq i64 %32, 1
  br i1 %33, label %sigill_ign, label %sigill_chk

sigill_chk:
  %34 = icmp ne i8* %31, null
  br i1 %34, label %call_old_sigill, label %fallback

call_old_sigill:
  %35 = bitcast i8* %31 to void (i32)*
  call void %35(i32 4)
  br label %ret_minus1

sigill_ign:
  %36 = inttoptr i64 1 to i8*
  %37 = call i8* @signal(i32 4, i8* %36)
  br label %ret_minus1

sigsegv:
  %38 = call i8* @signal(i32 11, i8* null)
  %39 = ptrtoint i8* %38 to i64
  %40 = icmp eq i64 %39, 1
  br i1 %40, label %sigsegv_ign, label %sigsegv_chk

sigsegv_chk:
  %41 = icmp ne i8* %38, null
  br i1 %41, label %call_old_sigsegv, label %fallback

call_old_sigsegv:
  %42 = bitcast i8* %38 to void (i32)*
  call void %42(i32 11)
  br label %ret_minus1

sigsegv_ign:
  %43 = inttoptr i64 1 to i8*
  %44 = call i8* @signal(i32 11, i8* %43)
  br label %ret_minus1

fallback:
  %45 = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %46 = icmp eq i32 (i8*)* %45, null
  br i1 %46, label %ret_zero, label %tail

ret_zero:
  ret i32 0

tail:
  %47 = tail call i32 %45(i8* %rcx)
  ret i32 %47

ret_minus1:
  ret i32 -1
}