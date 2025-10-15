; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i32 @_initialize_narrow_environment()
declare i32 @_configure_narrow_argv(i32)
declare i32* @__p___argc()
declare i8*** @__p___argv()
declare i8*** @__p__environ()
declare i32 @_set_new_mode(i32)

define i32 @sub_140002A60(i32* %outArgc, i8*** %outArgv, i8*** %outEnv, i32 %flag, i32* %newModePtr) {
entry:
  %call_init = call i32 @_initialize_narrow_environment()
  %cmp_flag = icmp ne i32 %flag, 0
  %mode = select i1 %cmp_flag, i32 2, i32 1
  %call_cfg = call i32 @_configure_narrow_argv(i32 %mode)
  %p_argc = call i32* @__p___argc()
  %argc_val = load i32, i32* %p_argc, align 4
  store i32 %argc_val, i32* %outArgc, align 4
  %pp_argv = call i8*** @__p___argv()
  %argv_val = load i8**, i8*** %pp_argv, align 8
  store i8** %argv_val, i8*** %outArgv, align 8
  %pp_env = call i8*** @__p__environ()
  %env_val = load i8**, i8*** %pp_env, align 8
  store i8** %env_val, i8*** %outEnv, align 8
  %nm = load i32, i32* %newModePtr, align 4
  %call_set = call i32 @_set_new_mode(i32 %nm)
  ret i32 0
}