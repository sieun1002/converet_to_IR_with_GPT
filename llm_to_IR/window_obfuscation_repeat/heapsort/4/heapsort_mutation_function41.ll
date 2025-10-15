; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@global_i32 = internal global i32 0, align 4
@off_140004400 = dso_local global i32* @global_i32, align 8
@qword_1400070D0 = dso_local global i8* null, align 8

declare dso_local void (i32)* @signal(i32, void (i32)*)

define dso_local i32 @sub_140001010() {
entry:
  ret i32 0
}

define dso_local void @sub_1400024E0() {
entry:
  ret void
}

define dso_local i32 @start() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %p, align 4
  %call = call i32 @sub_140001010()
  ret i32 0
}

define dso_local i32 @TopLevelExceptionFilter(i8* %rec) {
entry:
  ; Load ExceptionRecord pointer: rdx = [rcx]
  %rec_ptr_ptr = bitcast i8* %rec to i8**
  %rdx = load i8*, i8** %rec_ptr_ptr, align 8
  ; Load exception code: eax = [rdx]
  %rdx_i32ptr = bitcast i8* %rdx to i32*
  %code = load i32, i32* %rdx_i32ptr, align 4

  ; Switch for a couple of common exceptions; default goes to global handler path
  switch i32 %code, label %default_handler [
    i32 -1073741819, label %handle_segv      ; 0xC0000005
    i32 -1073741795, label %handle_ill       ; 0xC000001D
  ]

handle_segv:
  ; SIGSEGV == 11
  %old_segv = call void (i32)* @signal(i32 11, void (i32)* null)
  %sig_ign_const_segv = inttoptr i64 1 to void (i32)*
  %is_ign_segv = icmp eq void (i32)* %old_segv, %sig_ign_const_segv
  br i1 %is_ign_segv, label %set_ign_segv, label %check_null_segv

set_ign_segv:
  %tmp1 = call void (i32)* @signal(i32 11, void (i32)* %sig_ign_const_segv)
  br label %return_minus_one

check_null_segv:
  %is_null_segv = icmp eq void (i32)* %old_segv, null
  br i1 %is_null_segv, label %gw_handler, label %call_old_segv

call_old_segv:
  call void %old_segv(i32 11)
  br label %return_minus_one

handle_ill:
  ; SIGILL == 4
  %old_ill = call void (i32)* @signal(i32 4, void (i32)* null)
  %sig_ign_const_ill = inttoptr i64 1 to void (i32)*
  %is_ign_ill = icmp eq void (i32)* %old_ill, %sig_ign_const_ill
  br i1 %is_ign_ill, label %set_ign_ill, label %check_null_ill

set_ign_ill:
  %tmp2 = call void (i32)* @signal(i32 4, void (i32)* %sig_ign_const_ill)
  br label %return_minus_one

check_null_ill:
  %is_null_ill = icmp eq void (i32)* %old_ill, null
  br i1 %is_null_ill, label %gw_handler, label %call_old_ill

call_old_ill:
  call void %old_ill(i32 4)
  br label %return_minus_one

default_handler:
  br label %gw_handler

gw_handler:
  ; Emulate the behavior of consulting a global handler pointer (qword_1400070D0)
  %hptr_i8 = load i8*, i8** @qword_1400070D0, align 8
  %is_null_h = icmp eq i8* %hptr_i8, null
  br i1 %is_null_h, label %return_zero, label %call_gw

call_gw:
  %hptr_fn = bitcast i8* %hptr_i8 to i32 (i8*)*
  %gw_ret = call i32 %hptr_fn(i8* %rec)
  ret i32 %gw_ret

return_zero:
  ret i32 0

return_minus_one:
  ret i32 -1
}