; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_140002610(i8* %rcx) {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr1 = bitcast i8* %baseptr to i16*
  %mz1 = load i16, i16* %mzptr1, align 2
  %isMZ = icmp eq i16 %mz1, 23117
  br i1 %isMZ, label %check_nt, label %ret0

check_nt:
  %e_lfanew_byteptr = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr32 = bitcast i8* %e_lfanew_byteptr to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_ptr32, align 4
  %eoff = sext i32 %e_lfanew32 to i64
  %nthdr = getelementptr i8, i8* %baseptr, i64 %eoff
  %sig_ptr = bitcast i8* %nthdr to i32*
  %sig = load i32, i32* %sig_ptr, align 4
  %isPE = icmp eq i32 %sig, 17744
  br i1 %isPE, label %after_sig, label %ret0

after_sig:
  %optmag_ptr8 = getelementptr i8, i8* %nthdr, i64 24
  %optmag_ptr16 = bitcast i8* %optmag_ptr8 to i16*
  %optmag = load i16, i16* %optmag_ptr16, align 2
  %isPE32p = icmp eq i16 %optmag, 523
  br i1 %isPE32p, label %cont1, label %ret0

cont1:
  %numsec_ptr8 = getelementptr i8, i8* %nthdr, i64 6
  %numsec_ptr16 = bitcast i8* %numsec_ptr8 to i16*
  %numsec = load i16, i16* %numsec_ptr16, align 2
  %isZero = icmp eq i16 %numsec, 0
  br i1 %isZero, label %ret0, label %cont2

cont2:
  %sizeopt_ptr8 = getelementptr i8, i8* %nthdr, i64 20
  %sizeopt_ptr16 = bitcast i8* %sizeopt_ptr8 to i16*
  %sizeopt = load i16, i16* %sizeopt_ptr16, align 2
  %sizeopt_z64 = zext i16 %sizeopt to i64
  %rcx_i64 = ptrtoint i8* %rcx to i64
  %base_i64 = ptrtoint i8* %baseptr to i64
  %offset = sub i64 %rcx_i64, %base_i64
  %numsec_z64 = zext i16 %numsec to i64
  %numsec_minus1 = add i64 %numsec_z64, -1
  %numsec_times5 = mul i64 %numsec_minus1, 5
  %firstsec_base = getelementptr i8, i8* %nthdr, i64 24
  %firstsec_hdr = getelementptr i8, i8* %firstsec_base, i64 %sizeopt_z64
  %numsec_times40 = shl i64 %numsec_times5, 3
  %after_minus1 = getelementptr i8, i8* %firstsec_hdr, i64 %numsec_times40
  %endptr = getelementptr i8, i8* %after_minus1, i64 40
  br label %loop

loop:
  %curphi = phi i8* [ %firstsec_hdr, %cont2 ], [ %next, %loop_inc ]
  %cmp_end = icmp eq i8* %curphi, %endptr
  br i1 %cmp_end, label %after_loop, label %inloop

inloop:
  %va_ptr8 = getelementptr i8, i8* %curphi, i64 12
  %va_ptr32 = bitcast i8* %va_ptr8 to i32*
  %va = load i32, i32* %va_ptr32, align 4
  %va_z64 = zext i32 %va to i64
  %lt1 = icmp ult i64 %offset, %va_z64
  br i1 %lt1, label %loop_inc, label %check2

check2:
  %vs_ptr8 = getelementptr i8, i8* %curphi, i64 8
  %vs_ptr32 = bitcast i8* %vs_ptr8 to i32*
  %vs = load i32, i32* %vs_ptr32, align 4
  %va_plus_vs32 = add i32 %va, %vs
  %va_plus_vs64 = zext i32 %va_plus_vs32 to i64
  %lt2 = icmp ult i64 %offset, %va_plus_vs64
  br i1 %lt2, label %ret0, label %loop_inc

loop_inc:
  %next = getelementptr i8, i8* %curphi, i64 40
  br label %loop

after_loop:
  br label %ret0

ret0:
  ret i32 0
}