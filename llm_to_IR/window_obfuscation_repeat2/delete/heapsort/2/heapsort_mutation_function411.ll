; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @_initialize_narrow_environment()
declare i32 @_configure_narrow_argv(i32)
declare i32* @__p___argc()
declare i8*** @__p___argv()
declare i8*** @__p__environ()
declare i32 @_set_new_mode(i32)

define dso_local i32 @sub_140002A60(i32* %outArgc, i8*** %outArgv, i8*** %outEnv, i32 %flag, i32* %pNewMode) {
entry:
  %call_init = call i32 @_initialize_narrow_environment()
  %cmp = icmp eq i32 %flag, 0
  %mode = select i1 %cmp, i32 1, i32 2
  %call_cfg = call i32 @_configure_narrow_argv(i32 %mode)
  %p_argc = call i32* @__p___argc()
  %argc_val = load i32, i32* %p_argc, align 4
  store i32 %argc_val, i32* %outArgc, align 4
  %p_argv_ptr = call i8*** @__p___argv()
  %argv_val = load i8**, i8*** %p_argv_ptr, align 8
  store i8** %argv_val, i8*** %outArgv, align 8
  %p_env_ptr = call i8*** @__p__environ()
  %env_val = load i8**, i8*** %p_env_ptr, align 8
  store i8** %env_val, i8*** %outEnv, align 8
  %newmode_val = load i32, i32* %pNewMode, align 4
  %call_set = call i32 @_set_new_mode(i32 %newmode_val)
  ret i32 0
}