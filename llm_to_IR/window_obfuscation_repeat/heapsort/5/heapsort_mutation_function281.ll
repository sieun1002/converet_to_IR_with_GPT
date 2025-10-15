; ModuleID = 'pe_section_check'
source_filename = "pe_section_check.ll"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002610(i8* %addr) {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr.cast = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr.cast, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew.ptr.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.z = zext i32 %e_lfanew to i64
  %nt.ptr = getelementptr inbounds i8, i8* %base.ptr, i64 %e_lfanew.z
  %pe.sig.ptr = bitcast i8* %nt.ptr to i32*
  %pe.sig = load i32, i32* %pe.sig.ptr, align 1
  %is_pe = icmp eq i32 %pe.sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %magic.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is_pe64 = icmp eq i16 %magic, 523
  br i1 %is_pe64, label %get_counts, label %ret0

get_counts:
  %numsec.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %numsec.zero = icmp eq i16 %numsec16, 0
  br i1 %numsec.zero, label %ret0, label %cont_counts

cont_counts:
  %numsec32 = zext i16 %numsec16 to i32
  %sizeopt.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 20
  %sizeopt.ptr = bitcast i8* %sizeopt.ptr.i8 to i16*
  %sizeopt16 = load i16, i16* %sizeopt.ptr, align 1
  %sizeopt64 = zext i16 %sizeopt16 to i64
  %nt.plus.24 = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %sect.start = getelementptr inbounds i8, i8* %nt.plus.24, i64 %sizeopt64
  %numsec64 = zext i32 %numsec32 to i64
  %total.shdr.bytes = mul nuw nsw i64 %numsec64, 40
  %sect.end = getelementptr inbounds i8, i8* %sect.start, i64 %total.shdr.bytes
  %addr.i64 = ptrtoint i8* %addr to i64
  %base.i64 = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %addr.i64, %base.i64
  br label %loop

loop:
  %curr = phi i8* [ %sect.start, %cont_counts ], [ %next, %loop_next ]
  %curr.i = ptrtoint i8* %curr to i64
  %end.i = ptrtoint i8* %sect.end to i64
  %done = icmp uge i64 %curr.i, %end.i
  br i1 %done, label %ret0, label %check_section

check_section:
  %vs.ptr.i8 = getelementptr inbounds i8, i8* %curr, i64 8
  %vs.ptr = bitcast i8* %vs.ptr.i8 to i32*
  %vs32 = load i32, i32* %vs.ptr, align 1
  %va.ptr.i8 = getelementptr inbounds i8, i8* %curr, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %vs64 = zext i32 %vs32 to i64
  %rva.lt.va = icmp ult i64 %rva, %va64
  br i1 %rva.lt.va, label %loop_next, label %check_upper

check_upper:
  %va.plus.vs = add i64 %va64, %vs64
  %rva.lt.end = icmp ult i64 %rva, %va.plus.vs
  br i1 %rva.lt.end, label %ret1, label %loop_next

loop_next:
  %next = getelementptr inbounds i8, i8* %curr, i64 40
  br label %loop

ret1:
  ret i32 1

ret0:
  ret i32 0
}