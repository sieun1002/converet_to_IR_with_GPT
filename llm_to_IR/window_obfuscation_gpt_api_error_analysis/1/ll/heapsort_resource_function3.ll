; ModuleID = 'recovered.ll'
target triple = "x86_64-pc-windows-msvc"

%struct.EXCEPTION_RECORD = type { i32, i32, %struct.EXCEPTION_RECORD*, i8*, i32, [15 x i64] }
%struct.EXCEPTION_POINTERS = type { %struct.EXCEPTION_RECORD*, i8* }

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (%struct.EXCEPTION_POINTERS*)*

declare void @sub_140001010()
declare void (i32)* @signal(i32, void (i32)*)
declare void @sub_1400024E0()

define void @sub_1400013E0() local_unnamed_addr {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %p, align 4
  call void @sub_140001010()
  ret void
}

define i32 @sub_140002080(%struct.EXCEPTION_POINTERS* %p) local_unnamed_addr {
entry:
  %er.ptr = getelementptr inbounds %struct.EXCEPTION_POINTERS, %struct.EXCEPTION_POINTERS* %p, i32 0, i32 0
  %er = load %struct.EXCEPTION_RECORD*, %struct.EXCEPTION_RECORD** %er.ptr, align 8
  %code.ptr = getelementptr inbounds %struct.EXCEPTION_RECORD, %struct.EXCEPTION_RECORD* %er, i32 0, i32 0
  %code = load i32, i32* %code.ptr, align 4
  %masked = and i32 %code, 550502399
  %is_cgc = icmp eq i32 %masked, 541474243
  br i1 %is_cgc, label %chkflag, label %cont

chkflag:
  %flags.ptr = getelementptr inbounds %struct.EXCEPTION_RECORD, %struct.EXCEPTION_RECORD* %er, i32 0, i32 1
  %flags = load i32, i32* %flags.ptr, align 4
  %f1 = and i32 %flags, 1
  %f1nz = icmp ne i32 %f1, 0
  br i1 %f1nz, label %cont, label %ret_m1

cont:
  %cmp_ja = icmp ugt i32 %code, 3221225622
  br i1 %cmp_ja, label %fallback, label %cmp_le_8B

cmp_le_8B:
  %jbe = icmp ule i32 %code, 3221225611
  br i1 %jbe, label %lowRange, label %hiRange

lowRange:
  %is_0005 = icmp eq i32 %code, 3221225477
  br i1 %is_0005, label %handle_segv, label %low_gt

low_gt:
  %is_0008 = icmp eq i32 %code, 3221225480
  br i1 %is_0008, label %ret_m1, label %chk_001D

chk_001D:
  %is_001D = icmp eq i32 %code, 3221225501
  br i1 %is_001D, label %handle_ill, label %fallback

hiRange:
  switch i32 %code, label %ret_m1 [
    i32 3221225613, label %fpe_common
    i32 3221225614, label %fpe_common
    i32 3221225615, label %fpe_common
    i32 3221225616, label %fpe_common
    i32 3221225617, label %fpe_common
    i32 3221225619, label %fpe_common
    i32 3221225620, label %fpe_divzero
  ]

fpe_common:
  %prev_fpe = call void (i32)* @signal(i32 8, void (i32)* null)
  %is_ign_fpe = icmp eq void (i32)* %prev_fpe, inttoptr (i64 1 to void (i32)*)
  br i1 %is_ign_fpe, label %fpe_common_ign, label %fpe_common_chknull

fpe_common_ign:
  %tmp.reinstall.ign.fpe = call void (i32)* @signal(i32 8, void (i32)* inttoptr (i64 1 to void (i32)*))
  call void @sub_1400024E0()
  br label %ret_m1

fpe_common_chknull:
  %is_null_fpe = icmp eq void (i32)* %prev_fpe, null
  br i1 %is_null_fpe, label %fallback, label %call_prev_fpe

call_prev_fpe:
  call void %prev_fpe(i32 8)
  br label %ret_m1

fpe_divzero:
  %prev_fpe_dz = call void (i32)* @signal(i32 8, void (i32)* null)
  %is_ign_fpe_dz = icmp eq void (i32)* %prev_fpe_dz, inttoptr (i64 1 to void (i32)*)
  br i1 %is_ign_fpe_dz, label %fpe_divzero_setign, label %fpe_divzero_chknull

fpe_divzero_setign:
  %tmp.reinstall.ign.fpe.dz = call void (i32)* @signal(i32 8, void (i32)* inttoptr (i64 1 to void (i32)*))
  br label %ret_m1

fpe_divzero_chknull:
  %is_null_fpe_dz = icmp eq void (i32)* %prev_fpe_dz, null
  br i1 %is_null_fpe_dz, label %fallback, label %fpe_divzero_callprev

fpe_divzero_callprev:
  call void %prev_fpe_dz(i32 8)
  br label %ret_m1

handle_ill:
  %prev_ill = call void (i32)* @signal(i32 4, void (i32)* null)
  %is_ign_ill = icmp eq void (i32)* %prev_ill, inttoptr (i64 1 to void (i32)*)
  br i1 %is_ign_ill, label %ill_setign, label %ill_chknull

ill_setign:
  %tmp.reinstall.ign.ill = call void (i32)* @signal(i32 4, void (i32)* inttoptr (i64 1 to void (i32)*))
  br label %ret_m1

ill_chknull:
  %is_null_ill = icmp eq void (i32)* %prev_ill, null
  br i1 %is_null_ill, label %fallback, label %ill_callprev

ill_callprev:
  call void %prev_ill(i32 4)
  br label %ret_m1

handle_segv:
  %prev_segv = call void (i32)* @signal(i32 11, void (i32)* null)
  %is_ign_segv = icmp eq void (i32)* %prev_segv, inttoptr (i64 1 to void (i32)*)
  br i1 %is_ign_segv, label %segv_setign, label %segv_chknull

segv_setign:
  %tmp.reinstall.ign.segv = call void (i32)* @signal(i32 11, void (i32)* inttoptr (i64 1 to void (i32)*))
  br label %ret_m1

segv_chknull:
  %is_null_segv = icmp eq void (i32)* %prev_segv, null
  br i1 %is_null_segv, label %fallback, label %segv_callprev

segv_callprev:
  call void %prev_segv(i32 11)
  br label %ret_m1

fallback:
  %userf.ptr = load i32 (%struct.EXCEPTION_POINTERS*)*, i32 (%struct.EXCEPTION_POINTERS*)** @qword_1400070D0, align 8
  %userf.isnull = icmp eq i32 (%struct.EXCEPTION_POINTERS*)* %userf.ptr, null
  br i1 %userf.isnull, label %ret_0, label %tail_user

tail_user:
  %res = call i32 %userf.ptr(%struct.EXCEPTION_POINTERS* %p)
  ret i32 %res

ret_0:
  ret i32 0

ret_m1:
  ret i32 -1
}