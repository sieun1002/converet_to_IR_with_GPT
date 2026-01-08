; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define i8* @sub_140002460(i32 %ecx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0
  %mz.ptr.bc = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr.bc
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %chk_pe, label %ret0

chk_pe:
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew.i32 = load i32, i32* %e_lfanew.ptr
  %e_lfanew = sext i32 %e_lfanew.i32 to i64
  %nt = getelementptr i8, i8* %base.ptr, i64 %e_lfanew
  %sig.ptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig.ptr
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %chk_opt_magic, label %ret0

chk_opt_magic:
  %opt.magic.ptr.i8 = getelementptr i8, i8* %nt, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr
  %is_pe32p = icmp eq i16 %opt.magic, 523
  br i1 %is_pe32p, label %load_dir, label %ret0

load_dir:
  %imp.rva.ptr.i8 = getelementptr i8, i8* %nt, i64 144
  %imp.rva.ptr = bitcast i8* %imp.rva.ptr.i8 to i32*
  %imp.rva.i32 = load i32, i32* %imp.rva.ptr
  %imp.nonzero = icmp ne i32 %imp.rva.i32, 0
  br i1 %imp.nonzero, label %sec_setup, label %ret0

sec_setup:
  %num.sec.ptr.i8 = getelementptr i8, i8* %nt, i64 6
  %num.sec.ptr = bitcast i8* %num.sec.ptr.i8 to i16*
  %num.sec.i16 = load i16, i16* %num.sec.ptr
  %has_secs = icmp ne i16 %num.sec.i16, 0
  br i1 %has_secs, label %sec_first, label %ret0

sec_first:
  %sz.opt.ptr.i8 = getelementptr i8, i8* %nt, i64 20
  %sz.opt.ptr = bitcast i8* %sz.opt.ptr.i8 to i16*
  %sz.opt.i16 = load i16, i16* %sz.opt.ptr
  %sz.opt = zext i16 %sz.opt.i16 to i64
  %sec.start = getelementptr i8, i8* %nt, i64 24
  %sec.start2 = getelementptr i8, i8* %sec.start, i64 %sz.opt
  %nsec.i64 = zext i16 %num.sec.i16 to i64
  %nsec.bytes = mul i64 %nsec.i64, 40
  %sec.end = getelementptr i8, i8* %sec.start2, i64 %nsec.bytes
  %rva64 = zext i32 %imp.rva.i32 to i64
  br label %sec_loop

sec_loop:
  %cur.sec = phi i8* [ %sec.start2, %sec_first ], [ %next.sec, %sec_advance ]
  %va.ptr.i8 = getelementptr i8, i8* %cur.sec, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va.i32 = load i32, i32* %va.ptr
  %va64 = zext i32 %va.i32 to i64
  %rva_lt_va = icmp ult i64 %rva64, %va64
  br i1 %rva_lt_va, label %sec_advance, label %sec_check_end

sec_check_end:
  %vsize.ptr.i8 = getelementptr i8, i8* %cur.sec, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize.i32 = load i32, i32* %vsize.ptr
  %va.end.i32 = add i32 %va.i32, %vsize.i32
  %va.end64 = zext i32 %va.end.i32 to i64
  %in_range = icmp ult i64 %rva64, %va.end64
  br i1 %in_range, label %found_section, label %sec_advance

sec_advance:
  %next.sec = getelementptr i8, i8* %cur.sec, i64 40
  %at_end = icmp eq i8* %next.sec, %sec.end
  br i1 %at_end, label %ret0, label %sec_loop

found_section:
  %imp.addr = getelementptr i8, i8* %base.ptr, i64 %rva64
  br label %desc_loop

desc_loop:
  %cur.desc = phi i8* [ %imp.addr, %found_section ], [ %next.desc, %desc_iter ]
  %idx = phi i32 [ %ecx, %found_section ], [ %idx.next, %desc_iter ]
  %ts.ptr.i8 = getelementptr i8, i8* %cur.desc, i64 4
  %ts.ptr = bitcast i8* %ts.ptr.i8 to i32*
  %ts = load i32, i32* %ts.ptr
  %ts.zero = icmp eq i32 %ts, 0
  br i1 %ts.zero, label %chk_name_nonzero, label %chk_idx

chk_name_nonzero:
  %name.ptr.i8.pre = getelementptr i8, i8* %cur.desc, i64 12
  %name.ptr.pre = bitcast i8* %name.ptr.i8.pre to i32*
  %name.rva.pre = load i32, i32* %name.ptr.pre
  %name.zero = icmp eq i32 %name.rva.pre, 0
  br i1 %name.zero, label %ret0, label %chk_idx

chk_idx:
  %idx.pos = icmp sgt i32 %idx, 0
  br i1 %idx.pos, label %desc_iter, label %ret_name

desc_iter:
  %idx.next = add i32 %idx, -1
  %next.desc = getelementptr i8, i8* %cur.desc, i64 20
  br label %desc_loop

ret_name:
  %name.ptr.i8 = getelementptr i8, i8* %cur.desc, i64 12
  %name.ptr = bitcast i8* %name.ptr.i8 to i32*
  %name.rva = load i32, i32* %name.ptr
  %name.rva64 = zext i32 %name.rva to i64
  %ret.ptr = getelementptr i8, i8* %base.ptr, i64 %name.rva64
  ret i8* %ret.ptr

ret0:
  ret i8* null
}