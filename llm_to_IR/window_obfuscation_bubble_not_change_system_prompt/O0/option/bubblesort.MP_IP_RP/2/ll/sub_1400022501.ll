; ModuleID = 'sub_140002250'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i32 @sub_140002250(i8* %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0, align 8
  %base.i16ptr = bitcast i8* %base.ptr to i16*
  %e_magic = load i16, i16* %base.i16ptr, align 1
  %is_mz = icmp eq i16 %e_magic, 23117
  br i1 %is_mz, label %after_mz, label %ret0

after_mz:                                         ; preds = %entry
  %base.plus.3c = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %base.plus.3c to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt.ptr = getelementptr i8, i8* %base.ptr, i64 %e_lfanew64
  %nt.sig.ptr = bitcast i8* %nt.ptr to i32*
  %nt.sig = load i32, i32* %nt.sig.ptr, align 1
  %is_pe = icmp eq i32 %nt.sig, 17744
  br i1 %is_pe, label %after_pe, label %ret0

after_pe:                                         ; preds = %after_mz
  %opt.magic.i8 = getelementptr i8, i8* %nt.ptr, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 1
  %is_peplus = icmp eq i16 %opt.magic, 523
  br i1 %is_peplus, label %after_magic, label %ret0

after_magic:                                      ; preds = %after_pe
  %numsec.i8 = getelementptr i8, i8* %nt.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %numsec.zero = icmp eq i16 %numsec16, 0
  br i1 %numsec.zero, label %ret0, label %have_sections

have_sections:                                    ; preds = %after_magic
  %soh.i8 = getelementptr i8, i8* %nt.ptr, i64 20
  %soh.ptr = bitcast i8* %soh.i8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 1
  %rcx.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %rcx.int, %base.int
  %nt.plus.18 = getelementptr i8, i8* %nt.ptr, i64 24
  %soh64 = zext i16 %soh16 to i64
  %first.sec = getelementptr i8, i8* %nt.plus.18, i64 %soh64
  %numsec32 = zext i16 %numsec16 to i32
  %n.minus1.32 = add i32 %numsec32, 4294967295
  %n.minus1.64 = zext i32 %n.minus1.32 to i64
  %mul5 = mul i64 %n.minus1.64, 5
  %mul5x8 = mul i64 %mul5, 8
  %plus28 = add i64 %mul5x8, 40
  %end.ptr = getelementptr i8, i8* %first.sec, i64 %plus28
  br label %loop

loop:                                             ; preds = %loop.next, %have_sections
  %cur = phi i8* [ %first.sec, %have_sections ], [ %next, %loop.next ]
  %va.i8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %cmp.lower = icmp ult i64 %rva, %va64
  br i1 %cmp.lower, label %loop.next, label %check.upper

check.upper:                                      ; preds = %loop
  %vs.i8 = getelementptr i8, i8* %cur, i64 8
  %vs.ptr = bitcast i8* %vs.i8 to i32*
  %vs32 = load i32, i32* %vs.ptr, align 1
  %sum32 = add i32 %va32, %vs32
  %sum64 = zext i32 %sum32 to i64
  %cmp.upper = icmp ult i64 %rva, %sum64
  br i1 %cmp.upper, label %ret0, label %loop.next

loop.next:                                        ; preds = %check.upper, %loop
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end.ptr
  br i1 %done, label %exit.zero, label %loop

exit.zero:                                        ; preds = %loop.next
  ret i32 0

ret0:                                             ; preds = %check.upper, %after_magic, %after_pe, %after_mz, %entry
  ret i32 0
}