; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8*)*

declare void @sub_140001010()
declare void @sub_1400024E0()
declare i8* @signal(i32, i8*)

define void @sub_1400013E0() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %p, align 4
  call void @sub_140001010()
  ret void
}

define i32 @sub_140002080(i8* %rcx) {
entry:
  %rec.pp = bitcast i8* %rcx to i8**
  %rec.p = load i8*, i8** %rec.pp, align 8
  %code.p = bitcast i8* %rec.p to i32*
  %code = load i32, i32* %code.p, align 4
  %flags.ptr = getelementptr i8, i8* %rec.p, i64 4
  %flags.b = load i8, i8* %flags.ptr, align 1
  %masked = and i32 %code, 553648127
  %maskmatch = icmp eq i32 %masked, 541541187
  %flag1 = and i8 %flags.b, 1
  %flag1_zero = icmp eq i8 %flag1, 0
  %need_fallback_from_mask = and i1 %maskmatch, %flag1_zero
  br i1 %need_fallback_from_mask, label %fallback, label %rangecheck

rangecheck:
  %gt_0096 = icmp ugt i32 %code, 3221225622
  br i1 %gt_0096, label %fallback, label %leq0096

leq0096:
  %leq_008b = icmp ule i32 %code, 3221225611
  br i1 %leq_008b, label %blk2110, label %inrange

blk2110:
  %eq_0005 = icmp eq i32 %code, 3221225477
  br i1 %eq_0005, label %segv_case, label %after0005

after0005:
  %ugt_0005 = icmp ugt i32 %code, 3221225477
  br i1 %ugt_0005, label %blk2150, label %lt0005

lt0005:
  %eq_80000002 = icmp eq i32 %code, 2147483650
  br i1 %eq_80000002, label %ret_minus1, label %fallback

blk2150:
  %eq_0008 = icmp eq i32 %code, 3221225480
  br i1 %eq_0008, label %fallback, label %chk001d

chk001d:
  %eq_001d = icmp eq i32 %code, 3221225501
  br i1 %eq_001d, label %ill_case, label %fallback

inrange:
  %eq_0096 = icmp eq i32 %code, 3221225622
  br i1 %eq_0096, label %ill_case, label %check_fpe

check_fpe:
  %eq_0094 = icmp eq i32 %code, 3221225620
  %eq_008d = icmp eq i32 %code, 3221225613
  %eq_008e = icmp eq i32 %code, 3221225614
  %eq_008f = icmp eq i32 %code, 3221225615
  %eq_0090 = icmp eq i32 %code, 3221225616
  %eq_0091 = icmp eq i32 %code, 3221225617
  %eq_0093 = icmp eq i32 %code, 3221225619
  %tmp1 = or i1 %eq_008d, %eq_008e
  %tmp2 = or i1 %eq_008f, %eq_0090
  %tmp3 = or i1 %eq_0091, %eq_0093
  %tmp4 = or i1 %tmp1, %tmp2
  %is_fpe_main = or i1 %tmp4, %tmp3
  br i1 %eq_0094, label %fpe_alt, label %after_alt

after_alt:
  br i1 %is_fpe_main, label %fpe_main, label %fallback

segv_case:
  %h_segv = call i8* @signal(i32 11, i8* null)
  %h_segv_int = ptrtoint i8* %h_segv to i64
  %h_segv_is_ign = icmp eq i64 %h_segv_int, 1
  br i1 %h_segv_is_ign, label %segv_setign, label %segv_checknull

segv_setign:
  %_ = call i8* @signal(i32 11, i8* inttoptr (i64 1 to i8*))
  br label %fallback

segv_checknull:
  %h_segv_is_null = icmp eq i8* %h_segv, null
  br i1 %h_segv_is_null, label %fallback, label %segv_call

segv_call:
  %h_segv_fn = bitcast i8* %h_segv to void (i32)*
  call void %h_segv_fn(i32 11)
  br label %fallback

ill_case:
  %h_ill = call i8* @signal(i32 4, i8* null)
  %h_ill_int = ptrtoint i8* %h_ill to i64
  %h_ill_is_ign = icmp eq i64 %h_ill_int, 1
  br i1 %h_ill_is_ign, label %ill_setign, label %ill_checknull

ill_setign:
  %__ = call i8* @signal(i32 4, i8* inttoptr (i64 1 to i8*))
  br label %fallback

ill_checknull:
  %h_ill_is_null = icmp eq i8* %h_ill, null
  br i1 %h_ill_is_null, label %fallback, label %ill_call

ill_call:
  %h_ill_fn = bitcast i8* %h_ill to void (i32)*
  call void %h_ill_fn(i32 4)
  br label %fallback

fpe_main:
  %h_fpe = call i8* @signal(i32 8, i8* null)
  %h_fpe_int = ptrtoint i8* %h_fpe to i64
  %h_fpe_is_ign = icmp eq i64 %h_fpe_int, 1
  br i1 %h_fpe_is_ign, label %fpe_setign_and_call, label %fpe_checknull

fpe_setign_and_call:
  %___ = call i8* @signal(i32 8, i8* inttoptr (i64 1 to i8*))
  call void @sub_1400024E0()
  br label %fallback

fpe_checknull:
  %h_fpe_is_null = icmp eq i8* %h_fpe, null
  br i1 %h_fpe_is_null, label %fallback, label %fpe_call

fpe_call:
  %h_fpe_fn = bitcast i8* %h_fpe to void (i32)*
  call void %h_fpe_fn(i32 8)
  br label %fallback

fpe_alt:
  %h_fpe2 = call i8* @signal(i32 8, i8* null)
  %h_fpe2_int = ptrtoint i8* %h_fpe2 to i64
  %h_fpe2_is_ign = icmp eq i64 %h_fpe2_int, 1
  br i1 %h_fpe2_is_ign, label %fpe_alt_setign, label %fpe_alt_checknull

fpe_alt_setign:
  %____ = call i8* @signal(i32 8, i8* inttoptr (i64 1 to i8*))
  br label %fallback

fpe_alt_checknull:
  %h_fpe2_is_null = icmp eq i8* %h_fpe2, null
  br i1 %h_fpe2_is_null, label %fallback, label %fpe_alt_call

fpe_alt_call:
  %h_fpe2_fn = bitcast i8* %h_fpe2 to void (i32)*
  call void %h_fpe2_fn(i32 8)
  br label %fallback

ret_minus1:
  ret i32 -1

fallback:
  %fp = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %isnull = icmp eq i32 (i8*)* %fp, null
  br i1 %isnull, label %ret0, label %callfp

ret0:
  ret i32 0

callfp:
  %res = call i32 %fp(i8* %rcx)
  ret i32 %res
}