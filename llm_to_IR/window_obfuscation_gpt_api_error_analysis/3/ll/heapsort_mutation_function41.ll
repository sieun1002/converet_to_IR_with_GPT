; target triple for MSVC x64
target triple = "x86_64-pc-windows-msvc"

declare i32 @_initialize_narrow_environment()
declare i32 @_configure_narrow_argv(i32)
declare i32* @__p___argc()
declare i8*** @__p___argv()
declare i8*** @__p__environ()
declare i32 @_set_new_mode(i32)

define i32 @sub_140002A60(i32* %argc_out, i8*** %argv_out, i8*** %env_out, i32 %flag, i32* %newmode_ptr) {
entry:
  %init = call i32 @_initialize_narrow_environment()
  %cmp = icmp slt i32 %flag, 1
  %mode = select i1 %cmp, i32 1, i32 2
  %cfg = call i32 @_configure_narrow_argv(i32 %mode)
  %p_argc = call i32* @__p___argc()
  %argc_val = load i32, i32* %p_argc, align 4
  store i32 %argc_val, i32* %argc_out, align 4
  %pp_argv = call i8*** @__p___argv()
  %p_argv = load i8**, i8*** %pp_argv, align 8
  store i8** %p_argv, i8*** %argv_out, align 8
  %pp_env = call i8*** @__p__environ()
  %p_env = load i8**, i8*** %pp_env, align 8
  store i8** %p_env, i8*** %env_out, align 8
  %newmode = load i32, i32* %newmode_ptr, align 4
  %setnm = call i32 @_set_new_mode(i32 %newmode)
  ret i32 0
}