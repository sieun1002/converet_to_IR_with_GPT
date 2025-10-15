; target: Windows x86_64 PE parsing helper
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_140002790(i8* %addr) local_unnamed_addr {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.z = zext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base.ptr, i64 %e_lfanew.z
  %pesig.ptr = bitcast i8* %nt to i32*
  %pesig = load i32, i32* %pesig.ptr, align 1
  %is_pe = icmp eq i32 %pesig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %opt_magic.ptr.i8 = getelementptr i8, i8* %nt, i64 24
  %opt_magic.ptr = bitcast i8* %opt_magic.ptr.i8 to i16*
  %opt_magic = load i16, i16* %opt_magic.ptr, align 1
  %is_peplus = icmp eq i16 %opt_magic, 523
  br i1 %is_peplus, label %get_counts, label %ret0

get_counts:
  %numsec.ptr.i8 = getelementptr i8, i8* %nt, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %has_sections = icmp ne i16 %numsec16, 0
  br i1 %has_sections, label %cont, label %ret0

cont:
  %szopt.ptr.i8 = getelementptr i8, i8* %nt, i64 20
  %szopt.ptr = bitcast i8* %szopt.ptr.i8 to i16*
  %szopt16 = load i16, i16* %szopt.ptr, align 1
  %szopt64 = zext i16 %szopt16 to i64
  %rva.addr = ptrtoint i8* %addr to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %rva.addr, %base.int
  %secbase.pre = getelementptr i8, i8* %nt, i64 24
  %secbase = getelementptr i8, i8* %secbase.pre, i64 %szopt64
  %numsec32 = zext i16 %numsec16 to i32
  %numsec64 = zext i32 %numsec32 to i64
  %sechdr.bytes = mul i64 %numsec64, 40
  %secend = getelementptr i8, i8* %secbase, i64 %sechdr.bytes
  br label %loop

loop:
  %cur = phi i8* [ %secbase, %cont ], [ %next.cur, %next ]
  %done = icmp eq i8* %cur, %secend
  br i1 %done, label %notfound, label %check_one

check_one:
  %va.ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %before = icmp ult i64 %rva, %va64
  br i1 %before, label %next, label %check_end

check_end:
  %vsz.ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %vsz.ptr = bitcast i8* %vsz.ptr.i8 to i32*
  %vsz32 = load i32, i32* %vsz.ptr, align 1
  %vsz64 = zext i32 %vsz32 to i64
  %end = add i64 %va64, %vsz64
  %inrange = icmp ult i64 %rva, %end
  br i1 %inrange, label %found, label %next

next:
  %next.cur = getelementptr i8, i8* %cur, i64 40
  br label %loop

found:
  %ch.ptr.i8 = getelementptr i8, i8* %cur, i64 36
  %ch.ptr = bitcast i8* %ch.ptr.i8 to i32*
  %ch = load i32, i32* %ch.ptr, align 1
  %notch = xor i32 %ch, -1
  %retbit = lshr i32 %notch, 31
  ret i32 %retbit

notfound:
  ret i32 0

ret0:
  ret i32 0
}