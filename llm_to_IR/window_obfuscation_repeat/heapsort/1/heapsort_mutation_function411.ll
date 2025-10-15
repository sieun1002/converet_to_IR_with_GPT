; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @_initialize_narrow_environment()
declare i32 @_configure_narrow_argv(i32)
declare i32* @__p___argc()
declare i8*** @__p___argv()
declare i8*** @__p__environ()
declare i32 @_set_new_mode(i32)

define i32 @sub_140002A60(i32* %argcOut, i8*** %argvOut, i8*** %envOut, i32 %mode, i32* %pNewMode) {
entry:
  %call_init = call i32 @_initialize_narrow_environment()
  %iszero = icmp eq i32 %mode, 0
  %cfg = select i1 %iszero, i32 1, i32 2
  %call_cfg = call i32 @_configure_narrow_argv(i32 %cfg)
  %argc_ptr = call i32* @__p___argc()
  %argc_val = load i32, i32* %argc_ptr, align 4
  store i32 %argc_val, i32* %argcOut, align 4
  %argv_ppp = call i8*** @__p___argv()
  %argv_pp = load i8**, i8*** %argv_ppp, align 8
  store i8** %argv_pp, i8*** %argvOut, align 8
  %env_ppp = call i8*** @__p__environ()
  %env_pp = load i8**, i8*** %env_ppp, align 8
  store i8** %env_pp, i8*** %envOut, align 8
  %newmode_val = load i32, i32* %pNewMode, align 4
  %call_set = call i32 @_set_new_mode(i32 %newmode_val)
  ret i32 0
}