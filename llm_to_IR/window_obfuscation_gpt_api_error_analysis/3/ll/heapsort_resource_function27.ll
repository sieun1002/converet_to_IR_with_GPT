target triple = "x86_64-pc-windows-msvc"

define dso_local i1 @sub_1400024F0(i8* nocapture readonly %p) {
entry:
  %mz.ptr = bitcast i8* %p to i16*
  %mz.val = load i16, i16* %mz.ptr, align 1
  %mz.ok = icmp eq i16 %mz.val, 23117
  br i1 %mz.ok, label %check_pe, label %ret_false

ret_false:
  ret i1 false

check_pe:
  %lfanew.ptr.i8 = getelementptr inbounds i8, i8* %p, i64 60
  %lfanew.ptr = bitcast i8* %lfanew.ptr.i8 to i32*
  %lfanew.val = load i32, i32* %lfanew.ptr, align 1
  %lfanew.ext = sext i32 %lfanew.val to i64
  %nt.ptr = getelementptr inbounds i8, i8* %p, i64 %lfanew.ext
  %sig.ptr = bitcast i8* %nt.ptr to i32*
  %sig.val = load i32, i32* %sig.ptr, align 1
  %pe.ok = icmp eq i32 %sig.val, 17744
  br i1 %pe.ok, label %check_opt_magic, label %ret_false

check_opt_magic:
  %magic.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic.val = load i16, i16* %magic.ptr, align 1
  %is.pe32plus = icmp eq i16 %magic.val, 523
  ret i1 %is.pe32plus
}