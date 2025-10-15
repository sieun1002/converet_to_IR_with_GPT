; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i8*

declare void @sub_140001010()
declare i8* @signal(i32, i8*)
declare void @sub_1400024E0()

define void @start() {
entry:
  %p = load i32*, i32** @off_140004400
  store i32 0, i32* %p, align 4
  call void @sub_140001010()
  ret void
}

define i32 @TopLevelExceptionFilter(i8** %rcx) {
entry:
  %rdx = load i8*, i8** %rcx, align 8
  %rdx_i32ptr = bitcast i8* %rdx to i32*
  %eax0 = load i32, i32* %rdx_i32ptr, align 4
  %andmask = and i32 %eax0, 553648127
  %cmp_magic = icmp eq i32 %andmask, 541541187
  br i1 %cmp_magic, label %loc_140002130, label %loc_1400020A1

loc_140002130:                                 ; preds = %entry
  %rdx_plus4 = getelementptr i8, i8* %rdx, i64 4
  %byte4 = load i8, i8* %rdx_plus4, align 1
  %bit0 = and i8 %byte4, 1
  %bit0_nz = icmp ne i8 %bit0, 0
  br i1 %bit0_nz, label %loc_1400020A1, label %def_1400020C7

loc_1400020A1:                                 ; preds = %loc_140002130, %entry
  %cmp_ja_0096 = icmp ugt i32 %eax0, -1073741674
  br i1 %cmp_ja_0096, label %loc_1400020EF, label %cmp_jbe_008B

cmp_jbe_008B:                                  ; preds = %loc_1400020A1
  %jbe_008B = icmp ule i32 %eax0, -1073741685
  br i1 %jbe_008B, label %loc_140002110, label %switchpath

loc_140002110:                                 ; preds = %cmp_jbe_008B
  %is_0005 = icmp eq i32 %eax0, -1073741819
  br i1 %is_0005, label %loc_1400021C0, label %after_1C0_cmp

after_1C0_cmp:                                 ; preds = %loc_140002110
  %gt_0005 = icmp ugt i32 %eax0, -1073741819
  br i1 %gt_0005, label %loc_140002150, label %cmp_eq_80000002

cmp_eq_80000002:                               ; preds = %after_1C0_cmp
  %is_80000002 = icmp eq i32 %eax0, -2147483646
  br i1 %is_80000002, label %def_1400020C7, label %loc_1400020EF

loc_140002150:                                 ; preds = %after_1C0_cmp
  %is_0008 = icmp eq i32 %eax0, -1073741816
  br i1 %is_0008, label %def_1400020C7, label %cmp_eq_001D

cmp_eq_001D:                                   ; preds = %loc_140002150
  %is_001D = icmp eq i32 %eax0, -1073741795
  br i1 %is_001D, label %loc_14000215E, label %loc_1400020EF

switchpath:                                    ; preds = %cmp_jbe_008B
  %uge_8D = icmp uge i32 %eax0, -1073741683
  %ule_91 = icmp ule i32 %eax0, -1073741679
  %inrange_8D_91 = and i1 %uge_8D, %ule_91
  %is_0093 = icmp eq i32 %eax0, -1073741677
  %range_or_93 = or i1 %inrange_8D_91, %is_0093
  br i1 %range_or_93, label %loc_1400020D0, label %check_0094

check_0094:                                    ; preds = %switchpath
  %is_0094 = icmp eq i32 %eax0, -1073741676
  br i1 %is_0094, label %loc_140002190, label %check_0096

check_0096:                                    ; preds = %check_0094
  %is_0096 = icmp eq i32 %eax0, -1073741674
  br i1 %is_0096, label %loc_14000215E, label %def_1400020C7

def_1400020C7:                                 ; preds = %check_0096, %cmp_eq_80000002, %loc_140002150, %loc_140002130, %loc_1400021E2, %loc_1400021F7, %loc_14000220B, %loc_14000221F, %loc_140002238, %call_handler_4, %call_handler_11, %call_handler_8, %call_handler_8_b, %loc_140002174
  ret i32 -1

loc_1400020D0:                                 ; preds = %switchpath
  %sig_fpe_0 = call i8* @signal(i32 8, i8* null)
  %sig_fpe_0_int = ptrtoint i8* %sig_fpe_0 to i64
  %is_one_fpe0 = icmp eq i64 %sig_fpe_0_int, 1
  br i1 %is_one_fpe0, label %loc_140002224, label %after_cmp_one_fpe0

after_cmp_one_fpe0:                            ; preds = %loc_1400020D0
  %is_null_fpe0 = icmp eq i8* %sig_fpe_0, null
  br i1 %is_null_fpe0, label %loc_1400020EF, label %loc_1400021F0

loc_1400020EF:                                 ; preds = %after_cmp_one_fpe0, %cmp_eq_001D, %cmp_eq_80000002, %cmp_jbe_008B, %loc_1400020A1, %loc_140002174, %loc_1400021D5, %loc_140002177, %loc_1400020E6
  %fpglobal = load i8*, i8** @qword_1400070D0, align 8
  %isnullfp = icmp eq i8* %fpglobal, null
  br i1 %isnullfp, label %loc_140002140, label %tailjump

tailjump:                                      ; preds = %loc_1400020EF
  %fp_as_fn = bitcast i8* %fpglobal to i32 (i8**)* 
  %res = tail call i32 %fp_as_fn(i8** %rcx)
  ret i32 %res

loc_140002140:                                 ; preds = %loc_1400020EF
  ret i32 0

loc_14000215E:                                 ; preds = %cmp_eq_001D, %check_0096
  %sig_ill_0 = call i8* @signal(i32 4, i8* null)
  %sig_ill_0_int = ptrtoint i8* %sig_ill_0 to i64
  %is_one_ill0 = icmp eq i64 %sig_ill_0_int, 1
  br i1 %is_one_ill0, label %loc_140002210, label %after_cmp_one_ill0

after_cmp_one_ill0:                            ; preds = %loc_14000215E
  %is_null_ill0 = icmp eq i8* %sig_ill_0, null
  br i1 %is_null_ill0, label %loc_1400020EF, label %call_handler_4

call_handler_4:                                ; preds = %after_cmp_one_ill0
  %handler4 = bitcast i8* %sig_ill_0 to void (i32)*
  call void %handler4(i32 4)
  br label %def_1400020C7

loc_140002190:                                 ; preds = %check_0094
  %sig_fpe_1 = call i8* @signal(i32 8, i8* null)
  %sig_fpe_1_int = ptrtoint i8* %sig_fpe_1 to i64
  %is_one_fpe1 = icmp eq i64 %sig_fpe_1_int, 1
  br i1 %is_one_fpe1, label %loc_140002224_alt, label %loc_1400020E6

loc_1400020E6:                                 ; preds = %loc_140002190
  %is_null_fpe1 = icmp eq i8* %sig_fpe_1, null
  br i1 %is_null_fpe1, label %loc_1400020EF, label %loc_1400021F0

loc_1400021C0:                                 ; preds = %loc_140002110
  %sig_segv_0 = call i8* @signal(i32 11, i8* null)
  %sig_segv_0_int = ptrtoint i8* %sig_segv_0 to i64
  %is_one_segv0 = icmp eq i64 %sig_segv_0_int, 1
  br i1 %is_one_segv0, label %loc_1400021FC, label %after_cmp_one_segv0

after_cmp_one_segv0:                           ; preds = %loc_1400021C0
  %is_null_segv0 = icmp eq i8* %sig_segv_0, null
  br i1 %is_null_segv0, label %loc_1400020EF, label %call_handler_11

call_handler_11:                               ; preds = %after_cmp_one_segv0
  %handler11 = bitcast i8* %sig_segv_0 to void (i32)*
  call void %handler11(i32 11)
  br label %def_1400020C7

loc_1400021F0:                                 ; preds = %loc_1400020E6, %after_cmp_one_fpe0
  %handler8 = phi i8* [ %sig_fpe_1, %loc_1400020E6 ], [ %sig_fpe_0, %after_cmp_one_fpe0 ]
  %handler8_fn = bitcast i8* %handler8 to void (i32)*
  call void %handler8_fn(i32 8)
  br label %def_1400020C7

loc_1400021FC:                                 ; preds = %loc_1400021C0
  %one_ptr_11 = inttoptr i64 1 to i8*
  %tmp_sig_11 = call i8* @signal(i32 11, i8* %one_ptr_11)
  br label %def_1400020C7

loc_140002210:                                 ; preds = %loc_14000215E
  %one_ptr_4 = inttoptr i64 1 to i8*
  %tmp_sig_4 = call i8* @signal(i32 4, i8* %one_ptr_4)
  br label %def_1400020C7

loc_140002224:                                 ; preds = %loc_1400020D0
  %one_ptr_8_a = inttoptr i64 1 to i8*
  %tmp_sig_8_a = call i8* @signal(i32 8, i8* %one_ptr_8_a)
  call void @sub_1400024E0()
  br label %def_1400020C7

loc_140002224_alt:                             ; preds = %loc_140002190
  %one_ptr_8_b = inttoptr i64 1 to i8*
  %tmp_sig_8_b = call i8* @signal(i32 8, i8* %one_ptr_8_b)
  br label %def_1400020C7
}