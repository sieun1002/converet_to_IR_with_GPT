; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i32 @_initialize_narrow_environment()
declare i32 @_configure_narrow_argv(i32)
declare i32* @__p___argc()
declare i8*** @__p___argv()
declare i8*** @__p__environ()
declare i32 @_set_new_mode(i32)

define i32 @sub_1400026A0(i32* %out_argc, i8*** %out_argv, i8*** %out_env, i32 %mode, i32* %pNewMode) {
entry:
  %call0 = call i32 @_initialize_narrow_environment()
  %cmp = icmp uge i32 %mode, 1
  %sel = select i1 %cmp, i32 2, i32 1
  %call1 = call i32 @_configure_narrow_argv(i32 %sel)
  %p_argc = call i32* @__p___argc()
  %argc = load i32, i32* %p_argc, align 4
  store i32 %argc, i32* %out_argc, align 4
  %p_argvpp = call i8*** @__p___argv()
  %argvp = load i8**, i8*** %p_argvpp, align 8
  store i8** %argvp, i8*** %out_argv, align 8
  %p_envpp = call i8*** @__p__environ()
  %envp = load i8**, i8*** %p_envpp, align 8
  store i8** %envp, i8*** %out_env, align 8
  %newmode = load i32, i32* %pNewMode, align 4
  %call2 = call i32 @_set_new_mode(i32 %newmode)
  ret i32 0
}