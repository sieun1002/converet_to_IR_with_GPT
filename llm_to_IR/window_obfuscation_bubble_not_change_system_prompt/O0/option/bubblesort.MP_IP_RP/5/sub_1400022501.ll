; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define i8* @sub_140002250(i8* %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0
  %mz.p = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.p, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew.p8 = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.p = bitcast i8* %e_lfanew.p8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew.p, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt = getelementptr i8, i8* %base.ptr, i64 %e_lfanew64
  %sig.p = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig.p, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %magic.p8 = getelementptr i8, i8* %nt, i64 24
  %magic.p = bitcast i8* %magic.p8 to i16*
  %magic = load i16, i16* %magic.p, align 1
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %check_nsects, label %ret0

check_nsects:
  %nsec.p8 = getelementptr i8, i8* %nt, i64 6
  %nsec.p = bitcast i8* %nsec.p8 to i16*
  %nsec16 = load i16, i16* %nsec.p, align 1
  %nsec_is_zero = icmp eq i16 %nsec16, 0
  br i1 %nsec_is_zero, label %ret0, label %prep

prep:
  %opt_sz.p8 = getelementptr i8, i8* %nt, i64 20
  %opt_sz.p = bitcast i8* %opt_sz.p8 to i16*
  %opt_sz16 = load i16, i16* %opt_sz.p, align 1
  %opt_sz64 = zext i16 %opt_sz16 to i64
  %opt_base = getelementptr i8, i8* %nt, i64 24
  %first = getelementptr i8, i8* %opt_base, i64 %opt_sz64

  %rcx_i = ptrtoint i8* %rcx to i64
  %base_i = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %rcx_i, %base_i

  %nsec32 = zext i16 %nsec16 to i32
  %nsecm1 = sub i32 %nsec32, 1
  %nsecm1_x4 = mul i32 %nsecm1, 4
  %nsecm1_x5 = add i32 %nsecm1, %nsecm1_x4
  %nsecm1_x5_64 = zext i32 %nsecm1_x5 to i64
  %off_bytes = shl i64 %nsecm1_x5_64, 3
  %end_tmp = getelementptr i8, i8* %first, i64 %off_bytes
  %end = getelementptr i8, i8* %end_tmp, i64 40
  br label %loop

loop:
  %cur = phi i8* [ %first, %prep ], [ %next, %inc ]

  %va.p8 = getelementptr i8, i8* %cur, i64 12
  %va.p = bitcast i8* %va.p8 to i32*
  %va32 = load i32, i32* %va.p, align 1
  %va64 = zext i32 %va32 to i64
  %lt_va = icmp ult i64 %rva, %va64
  br i1 %lt_va, label %inc, label %check_inside

check_inside:
  %vsz.p8 = getelementptr i8, i8* %cur, i64 8
  %vsz.p = bitcast i8* %vsz.p8 to i32*
  %vsz32 = load i32, i32* %vsz.p, align 1
  %end32 = add i32 %va32, %vsz32
  %end64 = zext i32 %end32 to i64
  %in_range = icmp ult i64 %rva, %end64
  br i1 %in_range, label %ret_found, label %inc

inc:
  %next = getelementptr i8, i8* %cur, i64 40
  %cont = icmp ne i8* %next, %end
  br i1 %cont, label %loop, label %ret0

ret_found:
  ret i8* %cur

ret0:
  ret i8* null
}