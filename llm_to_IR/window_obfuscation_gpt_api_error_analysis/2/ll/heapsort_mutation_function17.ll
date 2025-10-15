; ModuleID = 'pseudo_reloc'
source_filename = "pseudo_reloc.ll"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external dso_local global i32
@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@off_1400043A0 = external dso_local global i8*
@off_1400043B0 = external dso_local global i8*
@off_1400043C0 = external dso_local global i8*

@.str.unknown_bits = private unnamed_addr constant [41 x i8] c"  Unknown pseudo relocation bit size %d\0A\00", align 1
@.str.unknown_proto = private unnamed_addr constant [52 x i8] c"  Unknown pseudo relocation protocol version %d\0A\00", align 1
@.str.range = private unnamed_addr constant [57 x i8] c"%d bit pseudo relocation out of range at target %p\0A\00", align 1

declare i32 @sub_140002690()
declare void @sub_1400028E0(i64)
declare void @sub_140001B30(i8*)
declare void @sub_140001AD0(i8*)
declare i8* @memcpy(i8* noalias writeonly, i8* noalias readonly, i64)
declare i1 @VirtualProtect(i8* nocapture, i64, i32, i32* nocapture)

define dso_local void @sub_140001CA0() local_unnamed_addr {
entry:
  %once.ld = load i32, i32* @dword_1400070A0, align 4
  %once.is0 = icmp eq i32 %once.ld, 0
  br i1 %once.is0, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %n32 = call i32 @sub_140002690()
  %n64 = sext i32 %n32 to i64
  %mul5 = mul i64 %n64, 5
  %mul40 = mul i64 %mul5, 8
  %add15 = add i64 %mul40, 15
  %aligned = and i64 %add15, -16
  call void @sub_1400028E0(i64 %aligned)
  %end.ld = load i8*, i8** @off_1400043B0, align 8
  %begin.ld = load i8*, i8** @off_1400043C0, align 8
  %dyn = alloca i8, i64 %aligned, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %dyn, i8** @qword_1400070A8, align 8
  %tmpbuf = alloca [8 x i8], align 8
  %oldProt = alloca i32, align 4
  %base.ld = load i8*, i8** @off_1400043A0, align 8
  %begin.int = ptrtoint i8* %begin.ld to i64
  %end.int = ptrtoint i8* %end.ld to i64
  %diff = sub i64 %end.int, %begin.int
  %has.any = icmp uge i64 %diff, 1
  br i1 %has.any, label %decide_proto, label %finalize

decide_proto:
  %has.header = icmp uge i64 %diff, 12
  br i1 %has.header, label %read_header, label %path_v1

read_header:
  %hdr0.ptr = bitcast i8* %begin.ld to i32*
  %hdr0 = load i32, i32* %hdr0.ptr, align 4
  %hdr1.ptr.i8 = getelementptr inbounds i8, i8* %begin.ld, i64 4
  %hdr1.ptr = bitcast i8* %hdr1.ptr.i8 to i32*
  %hdr1 = load i32, i32* %hdr1.ptr, align 4
  %hdr2.ptr.i8 = getelementptr inbounds i8, i8* %begin.ld, i64 8
  %hdr2.ptr = bitcast i8* %hdr2.ptr.i8 to i32*
  %hdr2 = load i32, i32* %hdr2.ptr, align 4
  %is.v2.header = and i1 (icmp eq i32 %hdr0, 0), (icmp eq i32 %hdr1, 0)
  br i1 %is.v2.header, label %check_version, label %path_v1

check_version:
  %ver.is1 = icmp eq i32 %hdr2, 1
  br i1 %ver.is1, label %v2.start, label %unknown_proto

unknown_proto:
  %up.str = getelementptr inbounds [52 x i8], [52 x i8]* @.str.unknown_proto, i64 0, i64 0
  call void @sub_140001AD0(i8* %up.str)
  br label %finalize

v2.start:
  %after.header = getelementptr inbounds i8, i8* %begin.ld, i64 12
  br label %v2.loop

v2.loop:
  %rbx.cur = phi i8* [ %after.header, %v2.start ], [ %rbx.next, %v2.cont ]
  %cont.cond = icmp ult i8* %rbx.cur, %end.ld
  br i1 %cont.cond, label %v2.body, label %finalize

v2.body:
  %symoff.ptr = bitcast i8* %rbx.cur to i32*
  %symoff = load i32, i32* %symoff.ptr, align 4
  %tgoff.ptr.i8 = getelementptr inbounds i8, i8* %rbx.cur, i64 4
  %tgoff.ptr = bitcast i8* %tgoff.ptr.i8 to i32*
  %tgoff = load i32, i32* %tgoff.ptr, align 4
  %flags.ptr.i8 = getelementptr inbounds i8, i8* %rbx.cur, i64 8
  %flags.ptr = bitcast i8* %flags.ptr.i8 to i32*
  %flags = load i32, i32* %flags.ptr, align 4
  %bits.u8 = and i32 %flags, 255
  %flags.hi = and i32 %flags, 192
  %symoff.sext = sext i32 %symoff to i64
  %tgoff.sext = sext i32 %tgoff to i64
  %src.ptr.i8 = getelementptr inbounds i8, i8* %base.ld, i64 %symoff.sext
  %tgt.ptr.i8 = getelementptr inbounds i8, i8* %base.ld, i64 %tgoff.sext
  %r9.ptr = bitcast i8* %src.ptr.i8 to i64*
  %r9.val = load i64, i64* %r9.ptr, align 8
  %src.ptr.int = ptrtoint i8* %src.ptr.i8 to i64
  %bits.is8 = icmp eq i32 %bits.u8, 8
  %bits.is16 = icmp eq i32 %bits.u8, 16
  %bits.is32 = icmp eq i32 %bits.u8, 32
  %bits.is64 = icmp eq i32 %bits.u8, 64
  %is.small = or i1 %bits.is8, %bits.is16
  %is.any = or i1 (or i1 %bits.is32, %bits.is64), %is.small
  br i1 %is.any, label %v2.dispatch, label %v2.unknown_bits

v2.unknown_bits:
  %ub.str = getelementptr inbounds [41 x i8], [41 x i8]* @.str.unknown_bits, i64 0, i64 0
  call void @sub_140001AD0(i8* %ub.str)
  br label %finalize

v2.dispatch:
  br i1 %bits.is32, label %v2.bits32, label %v2.check16_8

v2.check16_8:
  br i1 %bits.is16, label %v2.bits16, label %v2.check8_64

v2.check8_64:
  br i1 %bits.is8, label %v2.bits8, label %v2.bits64

v2.bits32:
  %tgt32.ptr = bitcast i8* %tgt.ptr.i8 to i32*
  %old32 = load i32, i32* %tgt32.ptr, align 4
  %old32.sext = sext i32 %old32 to i64
  %sub32 = sub i64 %old32.sext, %src.ptr.int
  %new32 = add i64 %sub32, %r9.val
  %no.ovf32 = icmp eq i32 %flags.hi, 0
  br i1 %no.ovf32, label %v2.range32, label %v2.write32

v2.range32:
  %too.big32 = icmp ugt i64 %new32, 4294967295
  br i1 %too.big32, label %range_error, label %range32.low

range32.low:
  %min32 = icmp slt i64 %new32, -2147483648
  br i1 %min32, label %range_error, label %v2.write32

v2.write32:
  %tmpbuf.i8.32 = bitcast [8 x i8]* %tmpbuf to i8*
  %tmpbuf.i32 = bitcast i8* %tmpbuf.i8.32 to i32*
  %new32.trunc = trunc i64 %new32 to i32
  store i32 %new32.trunc, i32* %tmpbuf.i32, align 4
  call void @sub_140001B30(i8* %tgt.ptr.i8)
  %call.mem32 = call i8* @memcpy(i8* nonnull %tgt.ptr.i8, i8* nonnull %tmpbuf.i8.32, i64 4)
  br label %v2.cont

v2.bits16:
  %tgt16.ptr = bitcast i8* %tgt.ptr.i8 to i16*
  %old16 = load i16, i16* %tgt16.ptr, align 2
  %old16.sext = sext i16 %old16 to i64
  %sub16 = sub i64 %old16.sext, %src.ptr.int
  %new16 = add i64 %sub16, %r9.val
  %no.ovf16 = icmp eq i32 %flags.hi, 0
  br i1 %no.ovf16, label %v2.range16, label %v2.write16

v2.range16:
  %too.big16 = icmp ugt i64 %new16, 65535
  br i1 %too.big16, label %range_error, label %range16.low

range16.low:
  %min16 = icmp slt i64 %new16, -32768
  br i1 %min16, label %range_error, label %v2.write16

v2.write16:
  %tmpbuf.i8.16 = bitcast [8 x i8]* %tmpbuf to i8*
  %tmpbuf.i16 = bitcast i8* %tmpbuf.i8.16 to i16*
  %new16.trunc = trunc i64 %new16 to i16
  store i16 %new16.trunc, i16* %tmpbuf.i16, align 2
  call void @sub_140001B30(i8* %tgt.ptr.i8)
  %call.mem16 = call i8* @memcpy(i8* nonnull %tgt.ptr.i8, i8* nonnull %tmpbuf.i8.16, i64 2)
  br label %v2.cont

v2.bits8:
  %tgt8.ptr = bitcast i8* %tgt.ptr.i8 to i8*
  %old8 = load i8, i8* %tgt8.ptr, align 1
  %old8.sext = sext i8 %old8 to i64
  %sub8 = sub i64 %old8.sext, %src.ptr.int
  %new8 = add i64 %sub8, %r9.val
  %no.ovf8 = icmp eq i32 %flags.hi, 0
  br i1 %no.ovf8, label %v2.range8, label %v2.write8

v2.range8:
  %too.big8 = icmp ugt i64 %new8, 255
  br i1 %too.big8, label %range_error, label %range8.low

range8.low:
  %min8 = icmp slt i64 %new8, -128
  br i1 %min8, label %range_error, label %v2.write8

v2.write8:
  %tmpbuf.i8.8 = bitcast [8 x i8]* %tmpbuf to i8*
  %new8.trunc = trunc i64 %new8 to i8
  store i8 %new8.trunc, i8* %tmpbuf.i8.8, align 1
  call void @sub_140001B30(i8* %tgt.ptr.i8)
  %call.mem8 = call i8* @memcpy(i8* nonnull %tgt.ptr.i8, i8* nonnull %tmpbuf.i8.8, i64 1)
  br label %v2.cont

v2.bits64:
  %tgt64.ptr = bitcast i8* %tgt.ptr.i8 to i64*
  %old64 = load i64, i64* %tgt64.ptr, align 8
  %sub64 = sub i64 %old64, %src.ptr.int
  %new64 = add i64 %sub64, %r9.val
  %no.ovf64 = icmp eq i32 %flags.hi, 0
  br i1 %no.ovf64, label %v2.range64, label %v2.write64

v2.range64:
  %nonneg = icmp sge i64 %new64, 0
  br i1 %nonneg, label %range_error, label %v2.write64

v2.write64:
  %tmpbuf.i8.64 = bitcast [8 x i8]* %tmpbuf to i8*
  %tmpbuf.i64 = bitcast i8* %tmpbuf.i8.64 to i64*
  store i64 %new64, i64* %tmpbuf.i64, align 8
  call void @sub_140001B30(i8* %tgt.ptr.i8)
  %call.mem64 = call i8* @memcpy(i8* nonnull %tgt.ptr.i8, i8* nonnull %tmpbuf.i8.64, i64 8)
  br label %v2.cont

v2.cont:
  %rbx.next = getelementptr inbounds i8, i8* %rbx.cur, i64 12
  br label %v2.loop

range_error:
  %re.str = getelementptr inbounds [57 x i8], [57 x i8]* @.str.range, i64 0, i64 0
  call void @sub_140001AD0(i8* %re.str)
  br label %finalize

path_v1:
  br label %v1.loop

v1.loop:
  %p.cur = phi i8* [ %begin.ld, %path_v1 ], [ %p.next, %v1.cont ]
  %v1.continue = icmp ult i8* %p.cur, %end.ld
  br i1 %v1.continue, label %v1.body, label %finalize

v1.body:
  %addend.ptr = bitcast i8* %p.cur to i32*
  %addend = load i32, i32* %addend.ptr, align 4
  %tgofs.ptr.i8 = getelementptr inbounds i8, i8* %p.cur, i64 4
  %tgofs.ptr = bitcast i8* %tgofs.ptr.i8 to i32*
  %tgofs = load i32, i32* %tgofs.ptr, align 4
  %tgofs.sext = sext i32 %tgofs to i64
  %tgt.ptr.v1 = getelementptr inbounds i8, i8* %base.ld, i64 %tgofs.sext
  %tgt32.ptr.v1 = bitcast i8* %tgt.ptr.v1 to i32*
  %cur32 = load i32, i32* %tgt32.ptr.v1, align 4
  %sum32 = add i32 %cur32, %addend
  %tmpbuf.i8.v1 = bitcast [8 x i8]* %tmpbuf to i8*
  %tmpbuf.i32.v1 = bitcast i8* %tmpbuf.i8.v1 to i32*
  store i32 %sum32, i32* %tmpbuf.i32.v1, align 4
  call void @sub_140001B30(i8* %tgt.ptr.v1)
  %call.mem.v1 = call i8* @memcpy(i8* nonnull %tgt.ptr.v1, i8* nonnull %tmpbuf.i8.v1, i64 4)
  br label %v1.cont

v1.cont:
  %p.next = getelementptr inbounds i8, i8* %p.cur, i64 8
  br label %v1.loop

finalize:
  %count = load i32, i32* @dword_1400070A4, align 4
  %has.recs = icmp sgt i32 %count, 0
  br i1 %has.recs, label %vp.loop, label %ret

vp.loop:
  %i = phi i32 [ 0, %finalize ], [ %i.next, %vp.cont ]
  %base.rec = load i8*, i8** @qword_1400070A8, align 8
  %i.zext = zext i32 %i to i64
  %off.bytes = mul i64 %i.zext, 40
  %rec.ptr = getelementptr inbounds i8, i8* %base.rec, i64 %off.bytes
  %fl.ptr = bitcast i8* %rec.ptr to i32*
  %fl = load i32, i32* %fl.ptr, align 4
  %has.prot = icmp ne i32 %fl, 0
  br i1 %has.prot, label %do.vp, label %vp.cont

do.vp:
  %addr.ptr.i8 = getelementptr inbounds i8, i8* %rec.ptr, i64 8
  %addr.ptr = bitcast i8* %addr.ptr.i8 to i8**
  %addr = load i8*, i8** %addr.ptr, align 8
  %size.ptr.i8 = getelementptr inbounds i8, i8* %rec.ptr, i64 16
  %size.ptr = bitcast i8* %size.ptr.i8 to i64*
  %size = load i64, i64* %size.ptr, align 8
  store i32 0, i32* %oldProt, align 4
  %vp.call = call i1 @VirtualProtect(i8* %addr, i64 %size, i32 %fl, i32* %oldProt)
  br label %vp.cont

vp.cont:
  %i.next = add i32 %i, 1
  %still = icmp slt i32 %i.next, %count
  br i1 %still, label %vp.loop, label %ret

ret:
  ret void
}