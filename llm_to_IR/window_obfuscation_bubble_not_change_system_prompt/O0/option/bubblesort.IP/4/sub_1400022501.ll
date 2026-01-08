; ModuleID = 'sub_140002250'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define i8* @sub_140002250(i8* %rcx) local_unnamed_addr {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0, align 8
  %base.word.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %base.word.ptr, align 1
  %mz.cmp = icmp eq i16 %mz, 23117
  br i1 %mz.cmp, label %nt_prep, label %ret_zero

nt_prep:
  %e_lfanew.ptr = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.i32ptr = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew.i32ptr, align 1
  %e_lfanew.z = zext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base.ptr, i64 %e_lfanew.z
  %sig.ptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %sig.ok = icmp eq i32 %sig, 17744
  br i1 %sig.ok, label %check_magic, label %ret_zero

check_magic:
  %magic.ptr.i8 = getelementptr i8, i8* %nt, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %magic.ok = icmp eq i16 %magic, 523
  br i1 %magic.ok, label %secsetup, label %ret_zero

secsetup:
  %numsec.ptr.i8 = getelementptr i8, i8* %nt, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %numsec.zero = icmp eq i16 %numsec16, 0
  br i1 %numsec.zero, label %ret_zero, label %have_numsec

have_numsec:
  %soh.ptr.i8 = getelementptr i8, i8* %nt, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %addr.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %addr.int, %base.int
  %sec.base.off = add i64 %soh64, 24
  %sec.base = getelementptr i8, i8* %nt, i64 %sec.base.off
  %numsec64 = zext i16 %numsec16 to i64
  %size.total = mul i64 %numsec64, 40
  %sec.end = getelementptr i8, i8* %sec.base, i64 %size.total
  br label %loop

loop:
  %cur = phi i8* [ %sec.base, %have_numsec ], [ %next, %loop_next ]
  %va.ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %lt.va = icmp ult i64 %rva, %va64
  br i1 %lt.va, label %loop_next, label %check_within

check_within:
  %vs.ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %vs.ptr = bitcast i8* %vs.ptr.i8 to i32*
  %vs32 = load i32, i32* %vs.ptr, align 1
  %endva32 = add i32 %va32, %vs32
  %endva64 = zext i32 %endva32 to i64
  %inrange = icmp ult i64 %rva, %endva64
  br i1 %inrange, label %ret_cur, label %loop_next

loop_next:
  %next = getelementptr i8, i8* %cur, i64 40
  %cont = icmp ne i8* %next, %sec.end
  br i1 %cont, label %loop, label %ret_zero

ret_cur:
  ret i8* %cur

ret_zero:
  ret i8* null
}