; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @_initialize_narrow_environment()
declare i32 @_configure_narrow_argv(i32)
declare i32* @__p___argc()
declare i8*** @__p___argv()
declare i8*** @__p__environ()
declare i32 @_set_new_mode(i32)

define i32 @sub_140002A60(i32* %argcOut, i8*** %argvOut, i8*** %envOut, i32 %flag, i32* %newModePtr) {
entry:
  %call_init = call i32 @_initialize_narrow_environment()
  %cmp = icmp slt i32 %flag, 1
  %mode = select i1 %cmp, i32 1, i32 2
  %call_cfg = call i32 @_configure_narrow_argv(i32 %mode)
  %p_argc = call i32* @__p___argc()
  %argcval = load i32, i32* %p_argc, align 4
  store i32 %argcval, i32* %argcOut, align 4
  %p_argv_ptr = call i8*** @__p___argv()
  %argv = load i8**, i8*** %p_argv_ptr, align 8
  store i8** %argv, i8*** %argvOut, align 8
  %p_env_ptr = call i8*** @__p__environ()
  %env = load i8**, i8*** %p_env_ptr, align 8
  store i8** %env, i8*** %envOut, align 8
  %newmode = load i32, i32* %newModePtr, align 4
  %call_set = call i32 @_set_new_mode(i32 %newmode)
  ret i32 0
}