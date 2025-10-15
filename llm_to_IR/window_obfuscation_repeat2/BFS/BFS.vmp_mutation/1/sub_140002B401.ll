; ModuleID: 'module'
target triple = "x86_64-pc-windows-msvc"

declare i32 @_initialize_narrow_environment()
declare i32 @_configure_narrow_argv(i32)
declare i32* @__p___argc()
declare i8*** @__p___argv()
declare i8*** @__p__environ()
declare i32 @_set_new_mode(i32)

define i32 @sub_140002B40(i32* %out_argc, i8*** %out_argv, i8*** %out_env, i32 %flag, i32* %pNewMode) {
entry:
  %call_init = call i32 @_initialize_narrow_environment()
  %cmp = icmp ult i32 %flag, 1
  %mode = select i1 %cmp, i32 1, i32 2
  %call_cfg = call i32 @_configure_narrow_argv(i32 %mode)
  %pArgc = call i32* @__p___argc()
  %argc = load i32, i32* %pArgc, align 4
  store i32 %argc, i32* %out_argc, align 4
  %pArgvPtr = call i8*** @__p___argv()
  %argv = load i8**, i8*** %pArgvPtr, align 8
  store i8** %argv, i8*** %out_argv, align 8
  %pEnvPtr = call i8*** @__p__environ()
  %env = load i8**, i8*** %pEnvPtr, align 8
  store i8** %env, i8*** %out_env, align 8
  %newmode = load i32, i32* %pNewMode, align 4
  %call_set = call i32 @_set_new_mode(i32 %newmode)
  ret i32 0
}