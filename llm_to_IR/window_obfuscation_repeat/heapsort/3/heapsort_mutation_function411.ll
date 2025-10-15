; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

declare dllimport i32 @_initialize_narrow_environment()
declare dllimport i32 @_configure_narrow_argv(i32)
declare dllimport i32* @__p___argc()
declare dllimport i8*** @__p___argv()
declare dllimport i8*** @__p__environ()
declare dllimport i32 @_set_new_mode(i32)

define dso_local i32 @sub_140002A60(i32* %argc_out, i8*** %argv_out_ref, i8*** %env_out_ref, i32 %flag, i32* %newmode_ptr) {
entry:
  %call_init = call i32 @_initialize_narrow_environment()
  %cmp = icmp slt i32 %flag, 1
  %mode = select i1 %cmp, i32 1, i32 2
  %call_cfg = call i32 @_configure_narrow_argv(i32 %mode)
  %argc_ptr = call i32* @__p___argc()
  %argc_val = load i32, i32* %argc_ptr, align 4
  store i32 %argc_val, i32* %argc_out, align 4
  %argv_pp = call i8*** @__p___argv()
  %argv_p = load i8**, i8*** %argv_pp, align 8
  store i8** %argv_p, i8*** %argv_out_ref, align 8
  %env_pp = call i8*** @__p__environ()
  %env_p = load i8**, i8*** %env_pp, align 8
  store i8** %env_p, i8*** %env_out_ref, align 8
  %nm_val = load i32, i32* %newmode_ptr, align 4
  %call_set = call i32 @_set_new_mode(i32 %nm_val)
  ret i32 0
}