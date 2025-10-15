; ModuleID = 'fixed_module'
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
  %cmp = icmp uge i32 %flag, 1
  %mode.sel = select i1 %cmp, i32 2, i32 1
  %call_cfg = call i32 @_configure_narrow_argv(i32 %mode.sel)
  %p_argc = call i32* @__p___argc()
  %argc = load i32, i32* %p_argc, align 4
  store i32 %argc, i32* %outArgc, align 4
  %p_argvptr = call i8*** @__p___argv()
  %argvptr = load i8**, i8*** %p_argvptr, align 8
  store i8** %argvptr, i8*** %outArgv, align 8
  %p_envptr = call i8*** @__p__environ()
  %envptr = load i8**, i8*** %p_envptr, align 8
  store i8** %envptr, i8*** %outEnv, align 8
  %newmode = load i32, i32* %newModePtr, align 4
  %call_set = call i32 @_set_new_mode(i32 %newmode)
  ret i32 0
}