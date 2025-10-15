; ModuleID = 'fixed_module'
source_filename = "fixed_module"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare dllimport i32 @_initialize_narrow_environment()
declare dllimport i32 @_configure_narrow_argv(i32)
declare dllimport i32* @__p___argc()
declare dllimport i8*** @__p___argv()
declare dllimport i8*** @__p__environ()
declare dllimport i32 @_set_new_mode(i32)

define dso_local i32 @sub_140002A60(i32* %argcOut, i8*** %argvOut, i8*** %envOut, i32 %flag, i32* %newModePtr) local_unnamed_addr {
entry:
  %call_init = call i32 @_initialize_narrow_environment()
  %cmp_flag = icmp sgt i32 %flag, 0
  %mode = select i1 %cmp_flag, i32 2, i32 1
  %call_cfg = call i32 @_configure_narrow_argv(i32 %mode)
  %p_argc = call i32* @__p___argc()
  %argc_val = load i32, i32* %p_argc, align 4
  store i32 %argc_val, i32* %argcOut, align 4
  %p_argv_ptr = call i8*** @__p___argv()
  %argv_val = load i8**, i8*** %p_argv_ptr, align 8
  store i8** %argv_val, i8*** %argvOut, align 8
  %p_env_ptr = call i8*** @__p__environ()
  %env_val = load i8**, i8*** %p_env_ptr, align 8
  store i8** %env_val, i8*** %envOut, align 8
  %new_mode_val = load i32, i32* %newModePtr, align 4
  %call_set = call i32 @_set_new_mode(i32 %new_mode_val)
  ret i32 0
}