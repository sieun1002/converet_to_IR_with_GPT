; ModuleID = 'pe_section_finder'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*

declare i64 @loc_140002A60(i8*)
declare i32 @sub_140002A68(i8*, i8*, i32)

define i8* @sub_140002510(i8* %arg) {
entry:
  %len = call i64 @loc_140002A60(i8* %arg)
  %len_gt_8 = icmp ugt i64 %len, 8
  br i1 %len_gt_8, label %fail_zero, label %after_len

after_len:
  %base = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %mz_ok, label %fail_zero

mz_ok:
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %base, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %pehdr = getelementptr i8, i8* %base, i64 %e_lfanew.sext
  %sig.ptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %sig_ok, label %fail_zero

sig_ok:
  %magic.ptr.i8 = getelementptr i8, i8* %pehdr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is_peplus = icmp eq i16 %magic, 523
  br i1 %is_peplus, label %magic_ok, label %fail_zero

magic_ok:
  %nsec.ptr.i8 = getelementptr i8, i8* %pehdr, i64 6
  %nsec.ptr = bitcast i8* %nsec.ptr.i8 to i16*
  %nsec = load i16, i16* %nsec.ptr, align 1
  %nsec_is_zero = icmp eq i16 %nsec, 0
  br i1 %nsec_is_zero, label %fail_zero, label %have_nsec

have_nsec:
  %soh.ptr.i8 = getelementptr i8, i8* %pehdr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 1
  %soh.zext = zext i16 %soh16 to i64
  %sect.off = add i64 %soh.zext, 24
  %sect0 = getelementptr i8, i8* %pehdr, i64 %sect.off
  br label %loop

loop:
  %i = phi i32 [ 0, %have_nsec ], [ %i.next, %loop_cont ]
  %sect.ptr = phi i8* [ %sect0, %have_nsec ], [ %sect.next, %loop_cont ]
  %call = call i32 @sub_140002A68(i8* %sect.ptr, i8* %arg, i32 8)
  %is_zero = icmp eq i32 %call, 0
  br i1 %is_zero, label %found, label %loop_cont

loop_cont:
  %nsec.reload = load i16, i16* %nsec.ptr, align 1
  %nsec.reload.z = zext i16 %nsec.reload to i32
  %i.next = add i32 %i, 1
  %sect.next = getelementptr i8, i8* %sect.ptr, i64 40
  %cont = icmp ult i32 %i.next, %nsec.reload.z
  br i1 %cont, label %loop, label %fail_zero

found:
  ret i8* %sect.ptr

fail_zero:
  ret i8* null
}