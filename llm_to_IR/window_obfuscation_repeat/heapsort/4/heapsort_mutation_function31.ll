; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8*)*

declare void @sub_140001010()
declare void @sub_1400024E0()
declare dllimport void (i32)* @signal(i32, void (i32)*)

define void @sub_1400013E0() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %p, align 4
  call void @sub_140001010()
  ret void
}

define i32 @sub_140002080(i8* %ctx) {
entry:
  %ctx_as_pp = bitcast i8* %ctx to i8**
  %rdx = load i8*, i8** %ctx_as_pp, align 8
  %codeptr = bitcast i8* %rdx to i32*
  %code = load i32, i32* %codeptr, align 4
  %masked = and i32 %code, 553648127
  %isMagic = icmp eq i32 %masked, 541549379
  br i1 %isMagic, label %L130, label %L0A1

L130:                                             ; 0x140002130
  %flagsbyteptr = getelementptr i8, i8* %rdx, i64 4
  %flagsbyte = load i8, i8* %flagsbyteptr, align 1
  %flag1 = and i8 %flagsbyte, 1
  %nz = icmp ne i8 %flag1, 0
  br i1 %nz, label %L0A1, label %ret_m1

L0A1:                                             ; 0x1400020A1
  %cmp_ja = icmp ugt i32 %code, 3221225622
  br i1 %cmp_ja, label %L0EF, label %L0A8

L0A8:                                             ; 0x1400020A8
  %cmp_jbe = icmp ule i32 %code, 3221225611
  br i1 %cmp_jbe, label %L110, label %SwitchGroup

L110:                                             ; 0x140002110
  %is_segv = icmp eq i32 %code, 3221225477
  br i1 %is_segv, label %L1C0, label %L11B

L11B:                                             ; 0x14000211B
  %gt_0005 = icmp ugt i32 %code, 3221225477
  br i1 %gt_0005, label %L150, label %L11D

L11D:                                             ; 0x14000211D
  %is_80000002 = icmp eq i32 %code, 2147483650
  br i1 %is_80000002, label %ret_m1, label %L0EF

L150:                                             ; 0x140002150
  %is_0008 = icmp eq i32 %code, 3221225480
  br i1 %is_0008, label %ret_m1, label %L157

L157:                                             ; 0x140002157
  %is_001D = icmp eq i32 %code, 3221225501
  br i1 %is_001D, label %L15E, label %L0EF

SwitchGroup:                                      ; 0x1400020AF and dispatch
  %is_0094 = icmp eq i32 %code, 3221225620
  br i1 %is_0094, label %L190, label %Lswitch_else1

Lswitch_else1:
  %is_008D = icmp eq i32 %code, 3221225613
  %is_008E = icmp eq i32 %code, 3221225614
  %or1 = or i1 %is_008D, %is_008E
  %is_008F = icmp eq i32 %code, 3221225615
  %or2 = or i1 %or1, %is_008F
  %is_0090 = icmp eq i32 %code, 3221225616
  %or3 = or i1 %or2, %is_0090
  %is_0091 = icmp eq i32 %code, 3221225617
  %or4 = or i1 %or3, %is_0091
  %is_0093 = icmp eq i32 %code, 3221225619
  %or5 = or i1 %or4, %is_0093
  br i1 %or5, label %L0D0, label %ret_m1

L0D0:                                             ; 0x1400020D0
  %h1 = call dllimport void (i32)* @signal(i32 8, void (i32)* null)
  %sig_ign_ptr = inttoptr i64 1 to void (i32)*
  %is_ign1 = icmp eq void (i32)* %h1, %sig_ign_ptr
  br i1 %is_ign1, label %L2224, label %L0E6

L0E6:                                             ; 0x1400020E6
  %is_nonnull1 = icmp ne void (i32)* %h1, null
  br i1 %is_nonnull1, label %L1F0_from_h1, label %L0EF

L1F0_from_h1:                                     ; 0x1400021F0
  call void %h1(i32 8)
  br label %ret_m1

L2224:                                            ; 0x140002224
  %tmp_sigset1 = call dllimport void (i32)* @signal(i32 8, void (i32)* %sig_ign_ptr)
  call void @sub_1400024E0()
  br label %ret_m1

L190:                                             ; 0x140002190
  %h2 = call dllimport void (i32)* @signal(i32 8, void (i32)* null)
  %is_ign2 = icmp eq void (i32)* %h2, %sig_ign_ptr
  br i1 %is_ign2, label %L1A6, label %L0E6_2

L0E6_2:                                           ; 0x1400020E6 path reuse
  %is_nonnull2 = icmp ne void (i32)* %h2, null
  br i1 %is_nonnull2, label %L1F0_from_h2, label %L0EF

L1F0_from_h2:                                     ; 0x1400021F0 equivalent
  call void %h2(i32 8)
  br label %ret_m1

L1A6:                                             ; 0x1400021A6
  %tmp_sigset2 = call dllimport void (i32)* @signal(i32 8, void (i32)* %sig_ign_ptr)
  br label %ret_m1

L15E:                                             ; 0x14000215E
  %h3 = call dllimport void (i32)* @signal(i32 4, void (i32)* null)
  %is_ign3 = icmp eq void (i32)* %h3, %sig_ign_ptr
  br i1 %is_ign3, label %L210, label %L16E

L16E:                                             ; 0x14000216E
  %is_nonnull3 = icmp ne void (i32)* %h3, null
  br i1 %is_nonnull3, label %L17D, label %L0EF

L17D:                                             ; 0x14000217D
  call void %h3(i32 4)
  br label %ret_m1

L210:                                             ; 0x140002210
  %tmp_sigset3 = call dllimport void (i32)* @signal(i32 4, void (i32)* %sig_ign_ptr)
  br label %ret_m1

L1C0:                                             ; 0x1400021C0
  %h4 = call dllimport void (i32)* @signal(i32 11, void (i32)* null)
  %is_ign4 = icmp eq void (i32)* %h4, %sig_ign_ptr
  br i1 %is_ign4, label %L1FC, label %L1D2

L1D2:                                             ; 0x1400021D2
  %is_nonnull4 = icmp ne void (i32)* %h4, null
  br i1 %is_nonnull4, label %L1DB, label %L0EF

L1DB:                                             ; 0x1400021DB
  call void %h4(i32 11)
  br label %ret_m1

L1FC:                                             ; 0x1400021FC
  %tmp_sigset4 = call dllimport void (i32)* @signal(i32 11, void (i32)* %sig_ign_ptr)
  br label %ret_m1

L0EF:                                             ; 0x1400020EF
  %altp = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %alt_isnull = icmp eq i32 (i8*)* %altp, null
  br i1 %alt_isnull, label %L140, label %L0FB

L0FB:                                             ; 0x1400020FB
  %retv = tail call i32 %altp(i8* %ctx)
  ret i32 %retv

L140:                                             ; 0x140002140
  ret i32 0

ret_m1:
  ret i32 -1
}