target triple = "x86_64-pc-windows-msvc"

declare i32 @_initialize_narrow_environment()
declare i32 @_configure_narrow_argv(i32 noundef)
declare i32* @__p___argc()
declare i8*** @__p___argv()
declare i8*** @__p__environ()
declare i32 @_set_new_mode(i32 noundef)

define i32 @sub_1400026A0(i32* noundef %argc_out, i8*** noundef %argv_out, i8*** noundef %env_out, i32 noundef %flag, i32* noundef %newmode_ptr) {
entry:
  %call0 = call i32 @_initialize_narrow_environment()
  %cmp = icmp ult i32 %flag, 1
  %sel = select i1 %cmp, i32 1, i32 2
  %call1 = call i32 @_configure_narrow_argv(i32 %sel)
  %p_argc = call i32* @__p___argc()
  %argc_val = load i32, i32* %p_argc, align 4
  store i32 %argc_val, i32* %argc_out, align 4
  %p_argv = call i8*** @__p___argv()
  %argv_val = load i8**, i8*** %p_argv, align 8
  store i8** %argv_val, i8*** %argv_out, align 8
  %p_env = call i8*** @__p__environ()
  %env_val = load i8**, i8*** %p_env, align 8
  store i8** %env_val, i8*** %env_out, align 8
  %nm = load i32, i32* %newmode_ptr, align 4
  %call2 = call i32 @_set_new_mode(i32 %nm)
  ret i32 0
}