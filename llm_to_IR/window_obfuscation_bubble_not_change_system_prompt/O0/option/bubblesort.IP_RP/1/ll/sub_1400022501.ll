; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i32 @sub_140002250(i8* %rcx) local_unnamed_addr {
entry:
  %baseptr.ptr = load i8*, i8** @off_1400043C0, align 8
  %base_i16ptr = bitcast i8* %baseptr.ptr to i16*
  %mz = load i16, i16* %base_i16ptr, align 2
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %check_pe_sig, label %ret0

check_pe_sig:
  %base_i64 = ptrtoint i8* %baseptr.ptr to i64
  %rcx_i64 = ptrtoint i8* %rcx to i64
  %delta = sub i64 %rcx_i64, %base_i64
  %e_lfanew.ptr = getelementptr i8, i8* %baseptr.ptr, i64 60
  %e_lfanew.i32ptr = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew.i32 = load i32, i32* %e_lfanew.i32ptr, align 4
  %e_lfanew.i64 = sext i32 %e_lfanew.i32 to i64
  %pehdr.ptr = getelementptr i8, i8* %baseptr.ptr, i64 %e_lfanew.i64
  %sig.ptr = bitcast i8* %pehdr.ptr to i32*
  %sig = load i32, i32* %sig.ptr, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt_magic, label %ret0

check_opt_magic:
  %opt_magic.ptr = getelementptr i8, i8* %pehdr.ptr, i64 24
  %opt_magic.i16ptr = bitcast i8* %opt_magic.ptr to i16*
  %opt_magic = load i16, i16* %opt_magic.i16ptr, align 2
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %load_nsects, label %ret0

load_nsects:
  %nsects.ptr = getelementptr i8, i8* %pehdr.ptr, i64 6
  %nsects.i16ptr = bitcast i8* %nsects.ptr to i16*
  %nsects.i16 = load i16, i16* %nsects.i16ptr, align 2
  %nsects_is_zero = icmp eq i16 %nsects.i16, 0
  br i1 %nsects_is_zero, label %ret0, label %prep_sections

prep_sections:
  %soh.ptr = getelementptr i8, i8* %pehdr.ptr, i64 20
  %soh.i16ptr = bitcast i8* %soh.ptr to i16*
  %soh.i16 = load i16, i16* %soh.i16ptr, align 2
  %soh.i32 = zext i16 %soh.i16 to i32
  %soh.i64 = zext i16 %soh.i16 to i64
  %firstsec.base = getelementptr i8, i8* %pehdr.ptr, i64 24
  %firstsec.ptr = getelementptr i8, i8* %firstsec.base, i64 %soh.i64
  %nsects.i32 = zext i16 %nsects.i16 to i32
  %nminus1 = add i32 %nsects.i32, -1
  %n5 = mul i32 %nminus1, 5
  %n5.zext = zext i32 %n5 to i64
  %scaled = mul i64 %n5.zext, 8
  %end.offset = add i64 %scaled, 40
  %end.ptr = getelementptr i8, i8* %firstsec.ptr, i64 %end.offset
  br label %loop

loop:
  %sec.ptr = phi i8* [ %firstsec.ptr, %prep_sections ], [ %next.ptr, %iter ]
  %va.ptr = getelementptr i8, i8* %sec.ptr, i64 12
  %va.i32ptr = bitcast i8* %va.ptr to i32*
  %va.i32 = load i32, i32* %va.i32ptr, align 4
  %va.i64 = zext i32 %va.i32 to i64
  %delta_lt_va = icmp ult i64 %delta, %va.i64
  br i1 %delta_lt_va, label %iter, label %check_range

check_range:
  %vs.ptr = getelementptr i8, i8* %sec.ptr, i64 8
  %vs.i32ptr = bitcast i8* %vs.ptr to i32*
  %vs.i32 = load i32, i32* %vs.i32ptr, align 4
  %sum.i32 = add i32 %va.i32, %vs.i32
  %sum.i64 = zext i32 %sum.i32 to i64
  %delta_lt_sum = icmp ult i64 %delta, %sum.i64
  br i1 %delta_lt_sum, label %ret0, label %iter

iter:
  %next.ptr = getelementptr i8, i8* %sec.ptr, i64 40
  %done = icmp eq i8* %next.ptr, %end.ptr
  br i1 %done, label %ret_zero_end, label %loop

ret_zero_end:
  ret i32 0

ret0:
  ret i32 0
}