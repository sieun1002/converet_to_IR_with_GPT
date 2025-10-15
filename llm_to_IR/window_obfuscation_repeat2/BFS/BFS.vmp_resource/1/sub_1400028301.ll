; ModuleID = 'pe_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*, align 8

define i8* @sub_140002830() {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %isMZ = icmp eq i16 %mz, 23117
  br i1 %isMZ, label %checkPE, label %retZero

checkPE:                                          ; preds = %entry
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %pehdr.ptr = getelementptr i8, i8* %base.ptr, i64 %e_lfanew.sext
  %pe.sig.ptr = bitcast i8* %pehdr.ptr to i32*
  %pe.sig = load i32, i32* %pe.sig.ptr, align 1
  %isPE = icmp eq i32 %pe.sig, 17744
  br i1 %isPE, label %checkMagic, label %retZero

checkMagic:                                       ; preds = %checkPE
  %magic.ptr.i8 = getelementptr i8, i8* %pehdr.ptr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %isPE32p = icmp eq i16 %magic, 523
  br i1 %isPE32p, label %retBase, label %retZero

retBase:                                          ; preds = %checkMagic
  ret i8* %base.ptr

retZero:                                          ; preds = %checkMagic, %checkPE, %entry
  ret i8* null
}