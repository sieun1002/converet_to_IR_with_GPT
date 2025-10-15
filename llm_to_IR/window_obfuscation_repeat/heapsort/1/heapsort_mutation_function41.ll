; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*, align 8
@qword_1400070D0 = external global i32 (i8*)*, align 8

declare void @sub_140001010()
declare void @sub_1400024E0()
declare void (i32)* @signal(i32, void (i32)*)

define i32 @start() {
entry:
  %p_ptr = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %p_ptr, align 4
  call void @sub_140001010()
  ret i32 0
}

define internal i32 @handle_signal(i32 %sig, i8* %ctx) {
entry:
  %prev = call void (i32)* @signal(i32 %sig, void (i32)* null)
  %prev_i8 = bitcast void (i32)* %prev to i8*
  %sig_ign_i8 = inttoptr i64 1 to i8*
  %is_ign = icmp eq i8* %prev_i8, %sig_ign_i8
  br i1 %is_ign, label %set_ign, label %check_null

set_ign:
  %sig_ign_func = inttoptr i64 1 to void (i32)*
  %tmp = call void (i32)* @signal(i32 %sig, void (i32)* %sig_ign_func)
  br label %ret_m1

check_null:
  %isnull = icmp eq void (i32)* %prev, null
  br i1 %isnull, label %fallback, label %call_prev

call_prev:
  call void %prev(i32 %sig)
  br label %ret_m1

fallback:
  %fp = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %hasfp = icmp ne i32 (i8*)* %fp, null
  br i1 %hasfp, label %call_fp, label %ret0

call_fp:
  %res = tail call i32 %fp(i8* %ctx)
  ret i32 %res

ret0:
  ret i32 0

ret_m1:
  ret i32 -1
}

define i32 @TopLevelExceptionFilter(i8* %ctx) {
entry:
  %ep_ptr_ptr = bitcast i8* %ctx to i8**
  %ep_ptr = load i8*, i8** %ep_ptr_ptr, align 8
  %code_ptr = bitcast i8* %ep_ptr to i32*
  %code = load i32, i32* %code_ptr, align 4
  %masked = and i32 %code, 553648127
  %is_magic = icmp eq i32 %masked, 541802179
  br i1 %is_magic, label %checkflag, label %dispatch

checkflag:
  %flags_i8 = getelementptr i8, i8* %ep_ptr, i64 4
  %flags_p = bitcast i8* %flags_i8 to i32*
  %flags = load i32, i32* %flags_p, align 4
  %bit = and i32 %flags, 1
  %bitnz = icmp ne i32 %bit, 0
  br i1 %bitnz, label %dispatch, label %ret_m1

dispatch:
  switch i32 %code, label %fallback [
    i32 -1073741819, label %handle_segv       ; 0xC0000005 EXCEPTION_ACCESS_VIOLATION
    i32 -1073741795, label %handle_sigill     ; 0xC000001D EXCEPTION_ILLEGAL_INSTRUCTION
    i32 -1073741685, label %handle_fpe        ; 0xC000008B
    i32 -1073741684, label %handle_fpe        ; 0xC000008C
    i32 -1073741683, label %handle_fpe        ; 0xC000008D
    i32 -1073741682, label %handle_fpe        ; 0xC000008E
    i32 -1073741680, label %handle_fpe        ; 0xC0000090
    i32 -1073741679, label %handle_fpe        ; 0xC0000091
    i32 -1073741676, label %handle_fpe        ; 0xC0000094
    i32 -1073741675, label %handle_fpe        ; 0xC0000095
    i32 -1073741674, label %handle_fpe        ; 0xC0000096
  ]

handle_segv:
  %r_segv = call i32 @handle_signal(i32 11, i8* %ctx)
  ret i32 %r_segv

handle_sigill:
  %r_sigill = call i32 @handle_signal(i32 4, i8* %ctx)
  ret i32 %r_sigill

handle_fpe:
  %r_fpe = call i32 @handle_signal(i32 8, i8* %ctx)
  ret i32 %r_fpe

fallback:
  %fp2 = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %hasfp2 = icmp ne i32 (i8*)* %fp2, null
  br i1 %hasfp2, label %call_fp2, label %ret0

call_fp2:
  %res2 = tail call i32 %fp2(i8* %ctx)
  ret i32 %res2

ret0:
  ret i32 0

ret_m1:
  ret i32 -1
}