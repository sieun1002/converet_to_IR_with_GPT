; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8*)*

declare void @sub_140001010()
declare void @sub_1400024E0()
declare void (i32)* @signal(i32, void (i32)*)

define void @start() {
entry:
  %p0 = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %p0, align 4
  call void @sub_140001010()
  ret void
}

define i32 @TopLevelExceptionFilter(i8* %rcx) {
entry:
  %er_ptr_ptr = bitcast i8* %rcx to i8**
  %er_ptr = load i8*, i8** %er_ptr_ptr, align 8
  %er_i32 = bitcast i8* %er_ptr to i32*
  %code = load i32, i32* %er_i32, align 4
  %masked = and i32 %code, 545259519
  %is_magic = icmp eq i32 %masked, 541343811
  br i1 %is_magic, label %L130, label %L0A1

L130:                                             ; loc_140002130
  %flags_ptrb = getelementptr i8, i8* %er_ptr, i64 4
  %flags_ptri32 = bitcast i8* %flags_ptrb to i32*
  %flags = load i32, i32* %flags_ptri32, align 4
  %flag1 = and i32 %flags, 1
  %flag_nz = icmp ne i32 %flag1, 0
  br i1 %flag_nz, label %L0A1, label %default_return

L0A1:                                             ; loc_1400020A1
  %cmp_96 = icmp ugt i32 %code, 3221225622
  br i1 %cmp_96, label %L0EF, label %L0A8

L0A8:
  %cmp_8B_or_below = icmp ule i32 %code, 3221225611
  br i1 %cmp_8B_or_below, label %L110, label %L0AF

L0AF:
  %idx = add i32 %code, 1073741683
  %idx_gt9 = icmp ugt i32 %idx, 9
  br i1 %idx_gt9, label %default_return, label %switch

switch:                                           ; jpt_1400020C7 range mapping
  switch i32 %idx, label %default_return [
    i32 0, label %L0D0
    i32 1, label %L0D0
    i32 2, label %L0D0
    i32 3, label %L0D0
    i32 4, label %L0D0
    i32 5, label %default_return
    i32 6, label %L0D0
    i32 7, label %L190
    i32 8, label %default_return
    i32 9, label %L15E
  ]

L0D0:                                             ; loc_1400020D0 -> SIGFPE common
  %h_fpe0 = call void (i32)* @signal(i32 8, void (i32)* null)
  %h_fpe0_int = ptrtoint void (i32)* %h_fpe0 to i64
  %is_ign_fpe0 = icmp eq i64 %h_fpe0_int, 1
  br i1 %is_ign_fpe0, label %L224, label %L0E6

L0E6:                                             ; loc_1400020E6
  %is_null_fpe0 = icmp eq void (i32)* %h_fpe0, null
  br i1 %is_null_fpe0, label %L0EF, label %L1F0

L190:                                             ; loc_140002190 -> SIGFPE special
  %h_fpe1 = call void (i32)* @signal(i32 8, void (i32)* null)
  %h_fpe1_int = ptrtoint void (i32)* %h_fpe1 to i64
  %is_ign_fpe1 = icmp eq i64 %h_fpe1_int, 1
  br i1 %is_ign_fpe1, label %L1A6, label %L0E6b

L0E6b:                                            ; same as 0E6 but for h_fpe1
  %is_null_fpe1 = icmp eq void (i32)* %h_fpe1, null
  br i1 %is_null_fpe1, label %L0EF, label %L1F0

L1A6:                                             ; loc_1400021A6 -> set SIG_IGN for SIGFPE
  %sig_ign_ptr_8 = inttoptr i64 1 to void (i32)*
  %prev_fpe_ign = call void (i32)* @signal(i32 8, void (i32)* %sig_ign_ptr_8)
  br label %default_return

L15E:                                             ; loc_14000215E -> SIGILL
  %h_ill = call void (i32)* @signal(i32 4, void (i32)* null)
  %h_ill_int = ptrtoint void (i32)* %h_ill to i64
  %is_ign_ill = icmp eq i64 %h_ill_int, 1
  br i1 %is_ign_ill, label %L210, label %L174

L174:
  %is_null_ill = icmp eq void (i32)* %h_ill, null
  br i1 %is_null_ill, label %L0EF, label %L17D

L17D:
  call void %h_ill(i32 4)
  br label %default_return

L210:                                             ; loc_140002210 -> set SIG_IGN for SIGILL
  %sig_ign_ptr_4 = inttoptr i64 1 to void (i32)*
  %prev_ill_ign = call void (i32)* @signal(i32 4, void (i32)* %sig_ign_ptr_4)
  br label %default_return

L110:                                             ; loc_140002110
  %is_av = icmp eq i32 %code, 3221225477
  br i1 %is_av, label %L1C0, label %L11B

L11B:
  %above_av = icmp ugt i32 %code, 3221225477
  br i1 %above_av, label %L150, label %L11D

L11D:
  %is_80000002 = icmp eq i32 %code, 2147483650
  br i1 %is_80000002, label %default_return, label %L0EF

L150:                                             ; loc_140002150
  %is_c0000008 = icmp eq i32 %code, 3221225480
  br i1 %is_c0000008, label %default_return, label %L157

L157:
  %is_c000001d = icmp eq i32 %code, 3221225501
  br i1 %is_c000001d, label %L15E, label %L0EF

L1C0:                                             ; loc_1400021C0 -> SIGSEGV
  %h_segv = call void (i32)* @signal(i32 11, void (i32)* null)
  %h_segv_int = ptrtoint void (i32)* %h_segv to i64
  %is_ign_segv = icmp eq i64 %h_segv_int, 1
  br i1 %is_ign_segv, label %L1FC, label %L1D2

L1D2:
  %is_null_segv = icmp eq void (i32)* %h_segv, null
  br i1 %is_null_segv, label %L0EF, label %L1DB

L1DB:
  call void %h_segv(i32 11)
  br label %default_return

L1FC:                                             ; loc_1400021FC -> set SIG_IGN for SIGSEGV
  %sig_ign_ptr_11 = inttoptr i64 1 to void (i32)*
  %prev_segv_ign = call void (i32)* @signal(i32 11, void (i32)* %sig_ign_ptr_11)
  br label %default_return

L1F0:                                             ; loc_1400021F0
  %hphi = phi void (i32)* [ %h_fpe0, %L0E6 ], [ %h_fpe1, %L0E6b ]
  call void %hphi(i32 8)
  br label %default_return

L224:                                             ; loc_140002224
  %sig_ign_ptr_8b = inttoptr i64 1 to void (i32)*
  %prev_fpe_ign_b = call void (i32)* @signal(i32 8, void (i32)* %sig_ign_ptr_8b)
  call void @sub_1400024E0()
  br label %default_return

L0EF:                                             ; loc_1400020EF
  %cbh = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %cbh_isnull = icmp eq i32 (i8*)* %cbh, null
  br i1 %cbh_isnull, label %L140, label %L0FB

L0FB:
  %ret_val = call i32 %cbh(i8* %rcx)
  ret i32 %ret_val

L140:                                             ; loc_140002140
  ret i32 0

default_return:                                   ; def_1400020C7
  ret i32 -1
}