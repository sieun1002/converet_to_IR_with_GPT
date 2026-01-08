; ModuleID = 'sub_1400026A0.ll'
target triple = "x86_64-pc-windows-msvc"

declare i32 @_initialize_narrow_environment()
declare i32 @_configure_narrow_argv(i32)
declare i32* @__p___argc()
declare i8*** @__p___argv()
declare i8*** @__p__environ()
declare i32 @_set_new_mode(i32)

define dso_local i32 @sub_1400026A0(i32* %argcp, i8*** %argvp, i8*** %envp, i32 %flags, i32* %newmode_ptr) {
entry:
  %call_init = call i32 @_initialize_narrow_environment()
  %cmp = icmp ult i32 %flags, 1
  %mode = select i1 %cmp, i32 1, i32 2
  %call_cfg = call i32 @_configure_narrow_argv(i32 %mode)
  %p_argc = call i32* @__p___argc()
  %argc = load i32, i32* %p_argc, align 4
  store i32 %argc, i32* %argcp, align 4
  %p_argvp = call i8*** @__p___argv()
  %argv = load i8**, i8*** %p_argvp, align 8
  store i8** %argv, i8*** %argvp, align 8
  %p_env = call i8*** @__p__environ()
  %env = load i8**, i8*** %p_env, align 8
  store i8** %env, i8*** %envp, align 8
  %newmode = load i32, i32* %newmode_ptr, align 4
  %call_set = call i32 @_set_new_mode(i32 %newmode)
  ret i32 0
}