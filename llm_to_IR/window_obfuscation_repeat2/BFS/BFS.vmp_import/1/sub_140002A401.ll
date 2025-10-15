; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare i8* @loc_140002BAD(i32)
declare i8** @sub_140002AF0()
declare i64 @sub_140002BC8(i8*, i8*, i8*, i64)

define i64 @sub_140002A40(i8* %rcx_param, i8* %rdx_param, i8* %r8_param, i8* %r9_param) {
entry:
  %loc_fn_ptr_int = ptrtoint i8* (i32)* @loc_140002BAD to i64
  %loc_fn_ptr_int_plus3 = add i64 %loc_fn_ptr_int, 3
  %loc_fn_ptr = inttoptr i64 %loc_fn_ptr_int_plus3 to i8* (i32)*
  %call_loc = call i8* %loc_fn_ptr(i32 1)
  %p = call i8** @sub_140002AF0()
  %rcx_loaded = load i8*, i8** %p, align 8
  %call_bc8 = call i64 @sub_140002BC8(i8* %rcx_loaded, i8* %call_loc, i8* %rcx_param, i64 0)
  ret i64 %call_bc8
}