source_filename = "m"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @_initialize_narrow_environment()
declare i32 @_configure_narrow_argv(i32)
declare i32* @__p___argc()
declare i8*** @__p___argv()
declare i8*** @__p__environ()
declare i32 @_set_new_mode(i32)

define i32 @sub_140002A60(i32* %out_argc, i8*** %out_argv, i8*** %out_env, i32 %flag, i32* %pNewMode) {
entry:
  %call_init = call i32 @_initialize_narrow_environment()
  %cmp = icmp uge i32 %flag, 1
  %mode = select i1 %cmp, i32 2, i32 1
  %call_cfg = call i32 @_configure_narrow_argv(i32 %mode)
  %argc_ptr = call i32* @__p___argc()
  %argc_val = load i32, i32* %argc_ptr, align 4
  store i32 %argc_val, i32* %out_argc, align 4
  %argv_ptrptr = call i8*** @__p___argv()
  %argv_val = load i8**, i8*** %argv_ptrptr, align 8
  store i8** %argv_val, i8*** %out_argv, align 8
  %env_ptrptr = call i8*** @__p__environ()
  %env_val = load i8**, i8*** %env_ptrptr, align 8
  store i8** %env_val, i8*** %out_env, align 8
  %newmode_val = load i32, i32* %pNewMode, align 4
  %call_set = call i32 @_set_new_mode(i32 %newmode_val)
  ret i32 0
}