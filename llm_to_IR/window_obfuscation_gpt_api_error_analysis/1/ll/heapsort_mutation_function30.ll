; ModuleID = 'sub_1400026D0.ll'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*

define dso_local i32 @sub_1400026D0(i64 %count) local_unnamed_addr {
entry:
  %base_p = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr.bc = bitcast i8* %base_p to i16*
  %mz = load i16, i16* %mz_ptr.bc, align 1
  %mz_ok = icmp eq i16 %mz, i16 23117
  br i1 %mz_ok, label %check_pe, label %ret0

check_pe:
  %e_lfanew.ptr = getelementptr inbounds i8, i8* %base_p, i64 60
  %e_lfanew.ptr.bc = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew.i32 = load i32, i32* %e_lfanew.ptr.bc, align 1
  %e_lfanew = sext i32 %e_lfanew.i32 to i64
  %nt_ptr = getelementptr inbounds i8, i8* %base_p, i64 %e_lfanew
  %pe_sig.ptr.bc = bitcast i8* %nt_ptr to i32*
  %pe_sig = load i32, i32* %pe_sig.ptr.bc, align 1
  %pe_ok = icmp eq i32 %pe_sig, i32 17744
  br i1 %pe_ok, label %check_opt, label %ret0

check_opt:
  %opt_magic.ptr = getelementptr inbounds i8, i8* %nt_ptr, i64 24
  %opt_magic.ptr.bc = bitcast i8* %opt_magic.ptr to i16*
  %opt_magic = load i16, i16* %opt_magic.ptr.bc, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, i16 523
  br i1 %is_pe32plus, label %cont1, label %ret0

cont1:
  %num_sec.ptr = getelementptr inbounds i8, i8* %nt_ptr, i64 6
  %num_sec.ptr.bc = bitcast i8* %num_sec.ptr to i16*
  %num_sec = load i16, i16* %num_sec.ptr.bc, align 1
  %num_sec.z = zext i16 %num_sec to i64
  %num_zero = icmp eq i64 %num_sec.z, 0
  br i1 %num_zero, label %ret0, label %cont2

cont2:
  %soh.ptr = getelementptr inbounds i8, i8* %nt_ptr, i64 20
  %soh.ptr.bc = bitcast i8* %soh.ptr to i16*
  %soh = load i16, i16* %soh.ptr.bc, align 1
  %soh.z = zext i16 %soh to i64
  %sect_start.pre = getelementptr inbounds i8, i8* %nt_ptr, i64 24
  %sect_start = getelementptr inbounds i8, i8* %sect_start.pre, i64 %soh.z
  %num_sec.i64 = zext i16 %num_sec to i64
  %mul40 = mul nuw i64 %num_sec.i64, 40
  %end_ptr = getelementptr inbounds i8, i8* %sect_start, i64 %mul40
  br label %loop

loop:
  %cur = phi i8* [ %sect_start, %cont2 ], [ %next_ptr, %inc ]
  %cnt = phi i64 [ %count, %cont2 ], [ %cnt.next, %inc ]
  %cbyte.ptr = getelementptr inbounds i8, i8* %cur, i64 39
  %cbyte = load i8, i8* %cbyte.ptr, align 1
  %mask = and i8 %cbyte, 32
  %bit_zero = icmp eq i8 %mask, 0
  br i1 %bit_zero, label %inc, label %check_cnt

check_cnt:
  %cnt_is_zero = icmp eq i64 %cnt, 0
  br i1 %cnt_is_zero, label %ret0, label %dec

dec:
  %cnt.dec = add i64 %cnt, -1
  br label %inc

inc:
  %cnt.next = phi i64 [ %cnt.dec, %dec ], [ %cnt, %loop ]
  %next_ptr = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %end_ptr, %next_ptr
  br i1 %done, label %done_block, label %loop

done_block:
  br label %ret0

ret0:
  ret i32 0
}