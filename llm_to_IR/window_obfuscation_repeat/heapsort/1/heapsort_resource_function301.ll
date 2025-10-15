; ModuleID = 'pe_check_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_140002610(i8* %arg) local_unnamed_addr nounwind {
entry:
  %baseptr.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr.bc = bitcast i8* %baseptr.ptr to i16*
  %mz.val = load i16, i16* %mz.ptr.bc, align 1
  %mz.ok = icmp eq i16 %mz.val, 23117
  br i1 %mz.ok, label %check_pe, label %ret0

check_pe:
  %e_lfanew.ptr = getelementptr i8, i8* %baseptr.ptr, i64 60
  %e_lfanew.p32 = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew.val32 = load i32, i32* %e_lfanew.p32, align 1
  %e_lfanew.sext = sext i32 %e_lfanew.val32 to i64
  %nth.ptr = getelementptr i8, i8* %baseptr.ptr, i64 %e_lfanew.sext
  %sig.p32 = bitcast i8* %nth.ptr to i32*
  %sig.val = load i32, i32* %sig.p32, align 1
  %is.pe = icmp eq i32 %sig.val, 17744
  br i1 %is.pe, label %check_magic, label %ret0

check_magic:
  %magic.ptr = getelementptr i8, i8* %nth.ptr, i64 24
  %magic.p16 = bitcast i8* %magic.ptr to i16*
  %magic.val = load i16, i16* %magic.p16, align 1
  %is.pe32plus = icmp eq i16 %magic.val, 523
  br i1 %is.pe32plus, label %load_counts, label %ret0

load_counts:
  %numsec.ptr = getelementptr i8, i8* %nth.ptr, i64 6
  %numsec.p16 = bitcast i8* %numsec.ptr to i16*
  %numsec.val = load i16, i16* %numsec.p16, align 1
  %numsec.iszero = icmp eq i16 %numsec.val, 0
  br i1 %numsec.iszero, label %ret0, label %setup

setup:
  %szopt.ptr = getelementptr i8, i8* %nth.ptr, i64 20
  %szopt.p16 = bitcast i8* %szopt.ptr to i16*
  %szopt.val16 = load i16, i16* %szopt.p16, align 1
  %szopt.z = zext i16 %szopt.val16 to i64
  %arg.int = ptrtoint i8* %arg to i64
  %base.int = ptrtoint i8* %baseptr.ptr to i64
  %rva = sub i64 %arg.int, %base.int
  %opt.start = getelementptr i8, i8* %nth.ptr, i64 24
  %sect0 = getelementptr i8, i8* %opt.start, i64 %szopt.z
  %numsec.z = zext i16 %numsec.val to i64
  %nm1 = add i64 %numsec.z, -1
  %times5 = mul i64 %nm1, 5
  %times40 = shl i64 %times5, 3
  %endoff = add i64 %times40, 40
  %endptr = getelementptr i8, i8* %sect0, i64 %endoff
  br label %loop

loop:
  %cur = phi i8* [ %sect0, %setup ], [ %next.cur, %cont_next ]
  %done = icmp eq i8* %cur, %endptr
  br i1 %done, label %ret0, label %check_section

check_section:
  %va.ptr = getelementptr i8, i8* %cur, i64 12
  %va.p32 = bitcast i8* %va.ptr to i32*
  %va32 = load i32, i32* %va.p32, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %cont_next, label %check_in_range

check_in_range:
  %vsz.ptr = getelementptr i8, i8* %cur, i64 8
  %vsz.p32 = bitcast i8* %vsz.ptr to i32*
  %vsz32 = load i32, i32* %vsz.p32, align 1
  %vsz64 = zext i32 %vsz32 to i64
  %va_end = add i64 %va64, %vsz64
  %inrange = icmp ult i64 %rva, %va_end
  br i1 %inrange, label %ret0, label %cont_next

cont_next:
  %next.cur = getelementptr i8, i8* %cur, i64 40
  br label %loop

ret0:
  ret i32 0
}