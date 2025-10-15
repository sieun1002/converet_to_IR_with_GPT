; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare i32 @_initialize_narrow_environment()
declare i32 @_configure_narrow_argv(i32)
declare i32* @__p___argc()
declare i8*** @__p___argv()
declare i8*** @__p__environ()
declare i32 @_set_new_mode(i32)

define i32 @sub_140002A60(i32* %argc_out, i8*** %argv_out_ptr, i8*** %env_out_ptr, i32 %flag, i32* %newmode_ptr) {
entry:
  %call_init = call i32 @_initialize_narrow_environment()
  %cmp = icmp ult i32 %flag, 1
  %mode = select i1 %cmp, i32 1, i32 2
  %call_cfg = call i32 @_configure_narrow_argv(i32 %mode)
  %p_argc = call i32* @__p___argc()
  %argc_val = load i32, i32* %p_argc, align 4
  store i32 %argc_val, i32* %argc_out, align 4
  %p_argvpp = call i8*** @__p___argv()
  %argvp = load i8**, i8*** %p_argvpp, align 8
  store i8** %argvp, i8*** %argv_out_ptr, align 8
  %p_envpp = call i8*** @__p__environ()
  %envp = load i8**, i8*** %p_envpp, align 8
  store i8** %envp, i8*** %env_out_ptr, align 8
  %nm_val = load i32, i32* %newmode_ptr, align 4
  %call_set = call i32 @_set_new_mode(i32 %nm_val)
  ret i32 0
}