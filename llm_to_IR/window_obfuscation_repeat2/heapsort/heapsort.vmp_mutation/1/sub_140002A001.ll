; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @_initialize_narrow_environment()
declare i32 @_configure_narrow_argv(i32)
declare i32* @__p___argc()
declare i8*** @__p___argv()
declare i8*** @__p__environ()
declare i32 @_set_new_mode(i32)

define i32 @sub_140002A00(i32* %pArgcOut, i8*** %pArgvOut, i8*** %pEnvOut, i32 %flag, i32* %pNewMode) {
entry:
  %call_init = call i32 @_initialize_narrow_environment()
  %cmp_flag = icmp ne i32 %flag, 0
  %mode_sel = select i1 %cmp_flag, i32 2, i32 1
  %call_cfg = call i32 @_configure_narrow_argv(i32 %mode_sel)
  %argc_ptr = call i32* @__p___argc()
  %argc_val = load i32, i32* %argc_ptr, align 4
  store i32 %argc_val, i32* %pArgcOut, align 4
  %argv_pp = call i8*** @__p___argv()
  %argv_p = load i8**, i8*** %argv_pp, align 8
  store i8** %argv_p, i8*** %pArgvOut, align 8
  %env_pp = call i8*** @__p__environ()
  %env_p = load i8**, i8*** %env_pp, align 8
  store i8** %env_p, i8*** %pEnvOut, align 8
  %newmode_val = load i32, i32* %pNewMode, align 4
  %call_set = call i32 @_set_new_mode(i32 %newmode_val)
  ret i32 0
}