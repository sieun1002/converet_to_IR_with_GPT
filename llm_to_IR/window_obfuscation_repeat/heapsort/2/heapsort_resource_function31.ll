; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*, align 8
@qword_1400070D0 = external global i32 (i8*)*, align 8

declare void @sub_140001010()
declare void (i32)* @signal(i32, void (i32)*)
declare void @sub_1400024E0()

define void @sub_1400013E0() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %p, align 4
  call void @sub_140001010()
  ret void
}

define i32 @sub_140002080(i8** %arg) {
entry:
  %arg_as_i8 = bitcast i8** %arg to i8*
  %pctx = load i8*, i8** %arg, align 8
  %status_ptr = bitcast i8* %pctx to i32*
  %status = load i32, i32* %status_ptr, align 4
  %masked = and i32 %status, 553648127
  %cmp_magic = icmp eq i32 %masked, 541541187
  %byte4ptr = getelementptr inbounds i8, i8* %pctx, i64 4
  %byte4 = load i8, i8* %byte4ptr, align 1
  %bit1 = and i8 %byte4, 1
  %bit1_set = icmp ne i8 %bit1, 0
  %not_bit1 = xor i1 %bit1_set, true
  %must_bail = and i1 %cmp_magic, %not_bit1
  br i1 %must_bail, label %ret_neg1, label %check_special

check_special:
  %is_special = icmp eq i32 %status, 2147483650
  br i1 %is_special, label %ret_neg1, label %check_segv

check_segv:
  %is_segv = icmp eq i32 %status, -1073741819
  br i1 %is_segv, label %handle_segv, label %check_ill

check_ill:
  %is_ill = icmp eq i32 %status, -1073741795
  %is_priv = icmp eq i32 %status, -1073741674
  %ill_any = or i1 %is_ill, %is_priv
  br i1 %ill_any, label %handle_ill, label %check_fpe

check_fpe:
  %is_fpe_8b = icmp eq i32 %status, -1073741685
  %is_fpe_8c = icmp eq i32 %status, -1073741684
  %is_fpe_8d = icmp eq i32 %status, -1073741683
  %t1 = or i1 %is_fpe_8b, %is_fpe_8c
  %t2 = or i1 %t1, %is_fpe_8d
  %is_fpe_8e = icmp eq i32 %status, -1073741682
  %t3 = or i1 %t2, %is_fpe_8e
  %is_fpe_90 = icmp eq i32 %status, -1073741680
  %t4 = or i1 %t3, %is_fpe_90
  %is_fpe_91 = icmp eq i32 %status, -1073741679
  %t5 = or i1 %t4, %is_fpe_91
  %is_fpe_93 = icmp eq i32 %status, -1073741677
  %t6 = or i1 %t5, %is_fpe_93
  %is_fpe_94 = icmp eq i32 %status, -1073741676
  %t7 = or i1 %t6, %is_fpe_94
  %is_fpe_95 = icmp eq i32 %status, -1073741675
  %is_any_fpe = or i1 %t7, %is_fpe_95
  br i1 %is_any_fpe, label %handle_fpe, label %fallback

handle_segv:
  %prev_segv = call void (i32)* @signal(i32 11, void (i32)* null)
  %sig_ign_ptr = inttoptr i64 1 to void (i32)*
  %is_ign_segv = icmp eq void (i32)* %prev_segv, %sig_ign_ptr
  br i1 %is_ign_segv, label %set_ign_segv, label %chk_null_segv

set_ign_segv:
  %tmp_segv = call void (i32)* @signal(i32 11, void (i32)* %sig_ign_ptr)
  br label %ret_neg1

chk_null_segv:
  %is_null_segv = icmp eq void (i32)* %prev_segv, null
  br i1 %is_null_segv, label %fallback, label %call_prev_segv

call_prev_segv:
  call void %prev_segv(i32 11)
  br label %ret_neg1

handle_ill:
  %prev_ill = call void (i32)* @signal(i32 4, void (i32)* null)
  %sig_ign_ptr2 = inttoptr i64 1 to void (i32)*
  %is_ign_ill = icmp eq void (i32)* %prev_ill, %sig_ign_ptr2
  br i1 %is_ign_ill, label %set_ign_ill, label %chk_null_ill

set_ign_ill:
  %tmp_ill = call void (i32)* @signal(i32 4, void (i32)* %sig_ign_ptr2)
  br label %ret_neg1

chk_null_ill:
  %is_null_ill = icmp eq void (i32)* %prev_ill, null
  br i1 %is_null_ill, label %fallback, label %call_prev_ill

call_prev_ill:
  call void %prev_ill(i32 4)
  br label %ret_neg1

handle_fpe:
  %prev_fpe = call void (i32)* @signal(i32 8, void (i32)* null)
  %sig_ign_ptr3 = inttoptr i64 1 to void (i32)*
  %is_ign_fpe = icmp eq void (i32)* %prev_fpe, %sig_ign_ptr3
  br i1 %is_ign_fpe, label %set_ign_fpe, label %chk_null_fpe

set_ign_fpe:
  %tmp_fpe = call void (i32)* @signal(i32 8, void (i32)* %sig_ign_ptr3)
  call void @sub_1400024E0()
  br label %ret_neg1

chk_null_fpe:
  %is_null_fpe = icmp eq void (i32)* %prev_fpe, null
  br i1 %is_null_fpe, label %fallback, label %call_prev_fpe

call_prev_fpe:
  call void %prev_fpe(i32 8)
  br label %ret_neg1

fallback:
  %translator = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %has_translator = icmp ne i32 (i8*)* %translator, null
  br i1 %has_translator, label %call_translator, label %ret_zero

call_translator:
  %res = call i32 %translator(i8* %arg_as_i8)
  ret i32 %res

ret_zero:
  ret i32 0

ret_neg1:
  ret i32 -1
}