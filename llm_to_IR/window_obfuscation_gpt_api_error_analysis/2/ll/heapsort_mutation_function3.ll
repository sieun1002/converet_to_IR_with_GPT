; target
target triple = "x86_64-pc-windows-msvc"

; extern globals
@off_140004400 = external global i32*, align 8
@qword_1400070D0 = external global i32 (i8**)*, align 8

; extern functions
declare void @sub_140001010()
declare void @sub_1400024E0()
declare i8* @signal(i32, i8*)

; 0x1400013E0
define void @sub_1400013E0() {
entry:
  %0 = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %0, align 4
  call void @sub_140001010()
  ret void
}

; 0x140002080
define i32 @sub_140002080(i8** %p) {
entry:
  %0 = load i8*, i8** %p, align 8
  %1 = bitcast i8* %0 to i32*
  %2 = load i32, i32* %1, align 4
  %3 = and i32 %2, 553648127
  %4 = icmp eq i32 %3, 541541187
  br i1 %4, label %check_flag, label %contA1

check_flag:                                        ; if (masked == 0x20474343)
  %5 = getelementptr inbounds i8, i8* %0, i64 4
  %6 = load i8, i8* %5, align 1
  %7 = and i8 %6, 1
  %8 = icmp ne i8 %7, 0
  br i1 %8, label %contA1, label %ret_m1

contA1:
  %9 = icmp ugt i32 %2, 3221225622          ; > 0xC0000096
  br i1 %9, label %fallback, label %range_le_96

range_le_96:
  %10 = icmp ule i32 %2, 3221225611         ; <= 0xC000008B
  br i1 %10, label %le_8B, label %between_8C_96

le_8B:
  %11 = icmp eq i32 %2, 3221225477          ; 0xC0000005 (SEGV)
  br i1 %11, label %sigsegv, label %gt_5_or_lt

gt_5_or_lt:
  %12 = icmp ugt i32 %2, 3221225477         ; > 0xC0000005
  br i1 %12, label %gt5_block, label %lt5_block

gt5_block:
  %13 = icmp eq i32 %2, 3221225480          ; 0xC0000008
  br i1 %13, label %ret_m1, label %check_ill

check_ill:
  %14 = icmp eq i32 %2, 3221225501          ; 0xC000001D (ILL)
  br i1 %14, label %sigill, label %fallback

lt5_block:
  %15 = icmp eq i32 %2, 2147483650          ; 0x80000002
  br i1 %15, label %ret_m1, label %fallback

between_8C_96:
  switch i32 %2, label %ret_m1 [
    i32 3221225613, label %fpe_common       ; 0xC000008D
    i32 3221225614, label %fpe_common       ; 0xC000008E
    i32 3221225615, label %fpe_common       ; 0xC000008F
    i32 3221225616, label %fpe_common       ; 0xC0000090
    i32 3221225617, label %fpe_common       ; 0xC0000091
    i32 3221225619, label %fpe_common       ; 0xC0000093
    i32 3221225620, label %fpe_divz         ; 0xC0000094
    i32 3221225622, label %sigill           ; 0xC0000096
  ]

; SIGFPE common handler path
fpe_common:
  %16 = call i8* @signal(i32 8, i8* null)
  %17 = ptrtoint i8* %16 to i64
  %18 = icmp eq i64 %17, 1                  ; SIG_IGN
  br i1 %18, label %set_fpe_ign_and_helper, label %check_old_fpe

check_old_fpe:
  %19 = icmp eq i8* %16, null               ; SIG_DFL
  br i1 %19, label %fallback, label %call_old_fpe

call_old_fpe:
  %20 = bitcast i8* %16 to void (i32)*
  call void %20(i32 8)
  br label %ret_m1

set_fpe_ign_and_helper:
  %21 = inttoptr i64 1 to i8*
  %22 = call i8* @signal(i32 8, i8* %21)
  call void @sub_1400024E0()
  br label %ret_m1

; SIGFPE divide-by-zero special case
fpe_divz:
  %23 = call i8* @signal(i32 8, i8* null)
  %24 = ptrtoint i8* %23 to i64
  %25 = icmp eq i64 %24, 1                  ; SIG_IGN
  br i1 %25, label %set_fpe_ign_only, label %check_old2

check_old2:
  %26 = icmp eq i8* %23, null               ; SIG_DFL
  br i1 %26, label %fallback, label %call_old2

call_old2:
  %27 = bitcast i8* %23 to void (i32)*
  call void %27(i32 8)
  br label %ret_m1

set_fpe_ign_only:
  %28 = inttoptr i64 1 to i8*
  %29 = call i8* @signal(i32 8, i8* %28)
  br label %ret_m1

; SIGILL
sigill:
  %30 = call i8* @signal(i32 4, i8* null)
  %31 = ptrtoint i8* %30 to i64
  %32 = icmp eq i64 %31, 1                  ; SIG_IGN
  br i1 %32, label %set_ill_ign, label %check_old_ill

check_old_ill:
  %33 = icmp eq i8* %30, null               ; SIG_DFL
  br i1 %33, label %fallback, label %call_old_ill

call_old_ill:
  %34 = bitcast i8* %30 to void (i32)*
  call void %34(i32 4)
  br label %ret_m1

set_ill_ign:
  %35 = inttoptr i64 1 to i8*
  %36 = call i8* @signal(i32 4, i8* %35)
  br label %ret_m1

; SIGSEGV
sigsegv:
  %37 = call i8* @signal(i32 11, i8* null)
  %38 = ptrtoint i8* %37 to i64
  %39 = icmp eq i64 %38, 1                  ; SIG_IGN
  br i1 %39, label %set_segv_ign, label %check_old_segv

check_old_segv:
  %40 = icmp eq i8* %37, null               ; SIG_DFL
  br i1 %40, label %fallback, label %call_old_segv

call_old_segv:
  %41 = bitcast i8* %37 to void (i32)*
  call void %41(i32 11)
  br label %ret_m1

set_segv_ign:
  %42 = inttoptr i64 1 to i8*
  %43 = call i8* @signal(i32 11, i8* %42)
  br label %ret_m1

fallback:
  %44 = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %45 = icmp ne i32 (i8**)* %44, null
  br i1 %45, label %call_fp, label %ret_0

call_fp:
  %46 = call i32 %44(i8** %p)
  ret i32 %46

ret_m1:
  ret i32 -1

ret_0:
  ret i32 0
}