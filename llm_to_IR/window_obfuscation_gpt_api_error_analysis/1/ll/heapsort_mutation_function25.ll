define i32 @sub_1400024F0(i8* %p) {
entry:
  %mz.ptr = bitcast i8* %p to i16*
  %mz.load = load i16, i16* %mz.ptr, align 1
  %mz.ok = icmp eq i16 %mz.load, 23117
  br i1 %mz.ok, label %check_pe, label %ret0

ret0:
  ret i32 0

check_pe:
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %p, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew.i32 = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew = sext i32 %e_lfanew.i32 to i64
  %nt.ptr = getelementptr i8, i8* %p, i64 %e_lfanew
  %pe.sig.ptr = bitcast i8* %nt.ptr to i32*
  %pe.sig = load i32, i32* %pe.sig.ptr, align 1
  %is_pe = icmp eq i32 %pe.sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:
  %optmagic.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 24
  %optmagic.ptr = bitcast i8* %optmagic.ptr.i8 to i16*
  %optmagic = load i16, i16* %optmagic.ptr, align 1
  %is64 = icmp eq i16 %optmagic, 523
  %res = zext i1 %is64 to i32
  ret i32 %res
}