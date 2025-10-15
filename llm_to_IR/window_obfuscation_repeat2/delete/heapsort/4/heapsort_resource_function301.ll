; ModuleID = 'module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_140002610(i8* %p) local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr16 = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr16, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %check_pe, label %ret0

check_pe:
  %off_ptr = getelementptr inbounds i8, i8* %baseptr, i64 60
  %off_i32p = bitcast i8* %off_ptr to i32*
  %off32 = load i32, i32* %off_i32p, align 1
  %off64 = sext i32 %off32 to i64
  %pehdr = getelementptr inbounds i8, i8* %baseptr, i64 %off64
  %sigp = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sigp, align 1
  %sig_ok = icmp eq i32 %sig, 17744
  br i1 %sig_ok, label %check_magic, label %ret0

check_magic:
  %magic_ptr = getelementptr inbounds i8, i8* %pehdr, i64 24
  %magic_p16 = bitcast i8* %magic_ptr to i16*
  %magic = load i16, i16* %magic_p16, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %check_numsec, label %ret0

check_numsec:
  %numsec_ptr = getelementptr inbounds i8, i8* %pehdr, i64 6
  %numsec_p16 = bitcast i8* %numsec_ptr to i16*
  %numsec16 = load i16, i16* %numsec_p16, align 1
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret0, label %cont_setup

cont_setup:
  %soh_ptr = getelementptr inbounds i8, i8* %pehdr, i64 20
  %soh_p16 = bitcast i8* %soh_ptr to i16*
  %soh16 = load i16, i16* %soh_p16, align 1
  %p_int = ptrtoint i8* %p to i64
  %base_int = ptrtoint i8* %baseptr to i64
  %diff = sub i64 %p_int, %base_int
  %soh64 = zext i16 %soh16 to i64
  %start_tmp = getelementptr inbounds i8, i8* %pehdr, i64 %soh64
  %start = getelementptr inbounds i8, i8* %start_tmp, i64 24
  %numsec64 = zext i16 %numsec16 to i64
  %nbytes = mul nuw nsw i64 %numsec64, 40
  %end = getelementptr inbounds i8, i8* %start, i64 %nbytes
  br label %loop

loop:
  %cur = phi i8* [ %start, %cont_setup ], [ %next, %loop_cont ]
  %va_ptr = getelementptr inbounds i8, i8* %cur, i64 12
  %va_p32 = bitcast i8* %va_ptr to i32*
  %va32 = load i32, i32* %va_p32, align 1
  %va64 = zext i32 %va32 to i64
  %cmp1 = icmp ult i64 %diff, %va64
  br i1 %cmp1, label %loop_cont, label %check_range

check_range:
  %sz_ptr = getelementptr inbounds i8, i8* %cur, i64 8
  %sz_p32 = bitcast i8* %sz_ptr to i32*
  %sz32 = load i32, i32* %sz_p32, align 1
  %sum32 = add i32 %va32, %sz32
  %sum64 = zext i32 %sum32 to i64
  %inrange = icmp ult i64 %diff, %sum64
  br i1 %inrange, label %ret0, label %loop_cont

loop_cont:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end
  br i1 %done, label %final_ret, label %loop

final_ret:
  br label %ret0

ret0:
  ret i32 0
}