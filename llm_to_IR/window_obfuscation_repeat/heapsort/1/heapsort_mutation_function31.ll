; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8**)*

declare void @sub_140001010()
declare i8* @signal(i32, i8*)
declare void @sub_1400024E0()

define void @sub_1400013E0() {
entry:
  %p.addr = load i32*, i32** @off_140004400
  store i32 1, i32* %p.addr, align 4
  call void @sub_140001010()
  ret void
}

define i32 @sub_140002080(i8** %ctx) {
entry:
  %rec.ptr = load i8*, i8** %ctx
  %excode.ptr = bitcast i8* %rec.ptr to i32*
  %code = load i32, i32* %excode.ptr, align 4
  %masked = and i32 %code, 553648127
  %is.magic = icmp eq i32 %masked, 542657731
  br i1 %is.magic, label %check_byte4, label %main_switch

check_byte4:
  %byte4.ptr = getelementptr i8, i8* %rec.ptr, i64 4
  %byte4 = load i8, i8* %byte4.ptr, align 1
  %bit = and i8 %byte4, 1
  %bitnz = icmp ne i8 %bit, 0
  br i1 %bitnz, label %main_switch, label %ret_m1

main_switch:
  switch i32 %code, label %ret_m1 [
    i32 -1073741819, label %case_segv
    i32 -1073741795, label %case_ill
    i32 -1073741685, label %case_fpe
  ]

case_fpe:
  %old_fpe = call i8* @signal(i32 8, i8* null)
  %old_fpe_int = ptrtoint i8* %old_fpe to i64
  %is_ign_fpe = icmp eq i64 %old_fpe_int, 1
  br i1 %is_ign_fpe, label %fpe_ign, label %fpe_not_ign

fpe_ign:
  %sig_ign_ptr = inttoptr i64 1 to i8*
  %reset_ign_fpe = call i8* @signal(i32 8, i8* %sig_ign_ptr)
  call void @sub_1400024E0()
  br label %ret_m1

fpe_not_ign:
  %is_null_fpe = icmp eq i8* %old_fpe, null
  br i1 %is_null_fpe, label %fallback, label %call_old_fpe

call_old_fpe:
  %old_fpe_fn = bitcast i8* %old_fpe to void (i32)*
  call void %old_fpe_fn(i32 8)
  br label %ret_m1

case_ill:
  %old_ill = call i8* @signal(i32 4, i8* null)
  %old_ill_int = ptrtoint i8* %old_ill to i64
  %ill_is_ign = icmp eq i64 %old_ill_int, 1
  br i1 %ill_is_ign, label %ill_set_ign, label %ill_not_ign

ill_set_ign:
  %sig_ign_ptr2 = inttoptr i64 1 to i8*
  %reset_ign_ill = call i8* @signal(i32 4, i8* %sig_ign_ptr2)
  br label %ret_m1

ill_not_ign:
  %ill_is_null = icmp eq i8* %old_ill, null
  br i1 %ill_is_null, label %fallback, label %ill_call_old

ill_call_old:
  %old_ill_fn = bitcast i8* %old_ill to void (i32)*
  call void %old_ill_fn(i32 4)
  br label %ret_m1

case_segv:
  %old_segv = call i8* @signal(i32 11, i8* null)
  %old_segv_int = ptrtoint i8* %old_segv to i64
  %segv_is_ign = icmp eq i64 %old_segv_int, 1
  br i1 %segv_is_ign, label %segv_set_ign, label %segv_not_ign

segv_set_ign:
  %sig_ign_ptr3 = inttoptr i64 1 to i8*
  %reset_ign_segv = call i8* @signal(i32 11, i8* %sig_ign_ptr3)
  br label %ret_m1

segv_not_ign:
  %segv_is_null = icmp eq i8* %old_segv, null
  br i1 %segv_is_null, label %fallback, label %segv_call_old

segv_call_old:
  %old_segv_fn = bitcast i8* %old_segv to void (i32)*
  call void %old_segv_fn(i32 11)
  br label %ret_m1

fallback:
  %h = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0
  %h_null = icmp eq i32 (i8**)* %h, null
  br i1 %h_null, label %ret_0, label %tail_to_h

tail_to_h:
  %res = tail call i32 %h(i8** %ctx)
  ret i32 %res

ret_m1:
  ret i32 -1

ret_0:
  ret i32 0
}