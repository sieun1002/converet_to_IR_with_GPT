; ModuleID = 'pe_helper'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define i8* @sub_140002900(i32 %ecx_in, i64 %rva_in) {
entry:
  %imgbase.ptr = load i8*, i8** @off_1400043C0, align 8
  %mz.ptr = bitcast i8* %imgbase.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_null

check_pe:
  %lfanew.ptr = getelementptr inbounds i8, i8* %imgbase.ptr, i64 60
  %lfanew.p32 = bitcast i8* %lfanew.ptr to i32*
  %lfanew.i32 = load i32, i32* %lfanew.p32, align 4
  %lfanew.i64 = sext i32 %lfanew.i32 to i64
  %nt.ptr = getelementptr inbounds i8, i8* %imgbase.ptr, i64 %lfanew.i64
  %pe.sig.p32 = bitcast i8* %nt.ptr to i32*
  %pe.sig = load i32, i32* %pe.sig.p32, align 4
  %is_pe = icmp eq i32 %pe.sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_null

check_magic:
  %magic.ptr = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %magic.p16 = bitcast i8* %magic.ptr to i16*
  %magic = load i16, i16* %magic.p16, align 2
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %check_field90, label %ret_null

check_field90:
  %f90.ptr = getelementptr inbounds i8, i8* %nt.ptr, i64 144
  %f90.p32 = bitcast i8* %f90.ptr to i32*
  %f90 = load i32, i32* %f90.p32, align 4
  %f90.nz = icmp ne i32 %f90, 0
  br i1 %f90.nz, label %check_numsecs, label %ret_null

check_numsecs:
  %numsec.ptr = getelementptr inbounds i8, i8* %nt.ptr, i64 6
  %numsec.p16 = bitcast i8* %numsec.ptr to i16*
  %numsec16 = load i16, i16* %numsec.p16, align 2
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret_null, label %prep_secs

prep_secs:
  %szopt.ptr = getelementptr inbounds i8, i8* %nt.ptr, i64 20
  %szopt.p16 = bitcast i8* %szopt.ptr to i16*
  %szopt16 = load i16, i16* %szopt.p16, align 2
  %szopt64 = zext i16 %szopt16 to i64
  %firstsec.base = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %firstsec.ptr = getelementptr inbounds i8, i8* %firstsec.base, i64 %szopt64
  %numsec64 = zext i16 %numsec16 to i64
  %nminus1 = add i64 %numsec64, -1
  %times5 = mul i64 %nminus1, 5
  %times5x8 = mul i64 %times5, 8
  %endoff = add i64 %times5x8, 40
  %end.ptr = getelementptr inbounds i8, i8* %firstsec.ptr, i64 %endoff
  br label %sec_loop

sec_loop:
  %cursec.phi = phi i8* [ %firstsec.ptr, %prep_secs ], [ %nextsec, %sec_advance ]
  %va.ptr = getelementptr inbounds i8, i8* %cursec.phi, i64 12
  %va.p32 = bitcast i8* %va.ptr to i32*
  %va32 = load i32, i32* %va.p32, align 4
  %va64 = zext i32 %va32 to i64
  %rva_below_va = icmp ult i64 %rva_in, %va64
  br i1 %rva_below_va, label %sec_advance, label %check_endrva

check_endrva:
  %vsize.ptr = getelementptr inbounds i8, i8* %cursec.phi, i64 8
  %vsize.p32 = bitcast i8* %vsize.ptr to i32*
  %vsize32 = load i32, i32* %vsize.p32, align 4
  %endva32 = add i32 %va32, %vsize32
  %endva64 = zext i32 %endva32 to i64
  %rva_below_end = icmp ult i64 %rva_in, %endva64
  br i1 %rva_below_end, label %found, label %sec_advance

sec_advance:
  %nextsec = getelementptr inbounds i8, i8* %cursec.phi, i64 40
  %more = icmp ne i8* %nextsec, %end.ptr
  br i1 %more, label %sec_loop, label %ret_null

found:
  %desc.start = getelementptr inbounds i8, i8* %imgbase.ptr, i64 %rva_in
  br label %desc_check

desc_check:
  %desc.ptr.phi = phi i8* [ %desc.start, %found ], [ %desc.next, %desc_dec ]
  %ecx.phi = phi i32 [ %ecx_in, %found ], [ %ecx.dec, %desc_dec ]
  %f4.ptr = getelementptr inbounds i8, i8* %desc.ptr.phi, i64 4
  %f4.p32 = bitcast i8* %f4.ptr to i32*
  %f4 = load i32, i32* %f4.p32, align 4
  %f4.iszero = icmp eq i32 %f4, 0
  br i1 %f4.iszero, label %desc_check_namezero, label %desc_ecx_check

desc_check_namezero:
  %name0.ptr = getelementptr inbounds i8, i8* %desc.ptr.phi, i64 12
  %name0.p32 = bitcast i8* %name0.ptr to i32*
  %name0 = load i32, i32* %name0.p32, align 4
  %name0.iszero = icmp eq i32 %name0, 0
  br i1 %name0.iszero, label %ret_null, label %desc_ecx_check

desc_ecx_check:
  %ecx_pos = icmp sgt i32 %ecx.phi, 0
  br i1 %ecx_pos, label %desc_dec, label %desc_return

desc_dec:
  %ecx.dec = add i32 %ecx.phi, -1
  %desc.next = getelementptr inbounds i8, i8* %desc.ptr.phi, i64 20
  br label %desc_check

desc_return:
  %name.ptr = getelementptr inbounds i8, i8* %desc.ptr.phi, i64 12
  %name.p32 = bitcast i8* %name.ptr to i32*
  %name = load i32, i32* %name.p32, align 4
  %name64 = zext i32 %name to i64
  %ret.ptr = getelementptr inbounds i8, i8* %imgbase.ptr, i64 %name64
  ret i8* %ret.ptr

ret_null:
  ret i8* null
}