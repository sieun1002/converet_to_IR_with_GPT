target triple = "x86_64-pc-windows-msvc"

define i32 @sub_1400024F0(i8* %rcx) {
entry:
  %p0 = bitcast i8* %rcx to i16*
  %w = load i16, i16* %p0, align 1
  %cmpMZ = icmp eq i16 %w, 23117
  br i1 %cmpMZ, label %checkPE, label %ret0

checkPE:
  %p_offset = getelementptr i8, i8* %rcx, i64 60
  %p_offset_i32p = bitcast i8* %p_offset to i32*
  %off32 = load i32, i32* %p_offset_i32p, align 1
  %off64 = sext i32 %off32 to i64
  %pePtr = getelementptr i8, i8* %rcx, i64 %off64
  %sigp = bitcast i8* %pePtr to i32*
  %sig = load i32, i32* %sigp, align 1
  %isPE = icmp eq i32 %sig, 17744
  br i1 %isPE, label %checkMagic, label %ret0

checkMagic:
  %optMagicPtrI8 = getelementptr i8, i8* %pePtr, i64 24
  %optMagicPtr = bitcast i8* %optMagicPtrI8 to i16*
  %magic = load i16, i16* %optMagicPtr, align 1
  %is64 = icmp eq i16 %magic, 523
  %res = zext i1 %is64 to i32
  ret i32 %res

ret0:
  ret i32 0
}