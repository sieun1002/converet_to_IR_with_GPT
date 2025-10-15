; ModuleID = 'pe_scan'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_1400026D0(i64 %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr.cast = bitcast i8* %base.ptr to i16*
  %mz.val = load i16, i16* %mz.ptr.cast, align 1
  %mz.ok = icmp eq i16 %mz.val, 23117
  br i1 %mz.ok, label %check_pe, label %ret0

check_pe:
  %lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %lfanew.ptr = bitcast i8* %lfanew.ptr.i8 to i32*
  %lfanew.le = load i32, i32* %lfanew.ptr, align 1
  %lfanew.sext = sext i32 %lfanew.le to i64
  %nt.ptr = getelementptr i8, i8* %base.ptr, i64 %lfanew.sext
  %sig.ptr = bitcast i8* %nt.ptr to i32*
  %sig.val = load i32, i32* %sig.ptr, align 1
  %sig.ok = icmp eq i32 %sig.val, 17744
  br i1 %sig.ok, label %check_opt_magic, label %ret0

check_opt_magic:
  %opt.magic.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 1
  %is.pe32plus = icmp eq i16 %opt.magic, 523
  br i1 %is.pe32plus, label %load_counts, label %ret0

load_counts:
  %numsects.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 6
  %numsects.ptr = bitcast i8* %numsects.ptr.i8 to i16*
  %numsects.le = load i16, i16* %numsects.ptr, align 1
  %numsects.iszero = icmp eq i16 %numsects.le, 0
  br i1 %numsects.iszero, label %ret0, label %compute_section_range

compute_section_range:
  %soh.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh.le = load i16, i16* %soh.ptr, align 1
  %soh.zext = zext i16 %soh.le to i64
  %opt.start = getelementptr i8, i8* %nt.ptr, i64 24
  %first.sec = getelementptr i8, i8* %opt.start, i64 %soh.zext
  %numsects.zext = zext i16 %numsects.le to i64
  %total.bytes = mul i64 %numsects.zext, 40
  %end.ptr = getelementptr i8, i8* %first.sec, i64 %total.bytes
  br label %loop

loop:
  %cur.phi = phi i8* [ %first.sec, %compute_section_range ], [ %next.cur, %afterstep ]
  %cnt.phi = phi i64 [ %rcx, %compute_section_range ], [ %new.count, %afterstep ]
  %char.byte.ptr = getelementptr i8, i8* %cur.phi, i64 39
  %char.byte = load i8, i8* %char.byte.ptr, align 1
  %char.mask = and i8 %char.byte, 32
  %is.exec = icmp ne i8 %char.mask, 0
  br i1 %is.exec, label %flagged, label %noflag

flagged:
  %iszero.cnt = icmp eq i64 %cnt.phi, 0
  br i1 %iszero.cnt, label %ret0, label %decrement

decrement:
  %cnt.dec = add i64 %cnt.phi, -1
  br label %afterstep

noflag:
  br label %afterstep

afterstep:
  %new.count = phi i64 [ %cnt.dec, %decrement ], [ %cnt.phi, %noflag ]
  %next.cur = getelementptr i8, i8* %cur.phi, i64 40
  %cont = icmp ne i8* %next.cur, %end.ptr
  br i1 %cont, label %loop, label %ret0

ret0:
  ret i32 0
}