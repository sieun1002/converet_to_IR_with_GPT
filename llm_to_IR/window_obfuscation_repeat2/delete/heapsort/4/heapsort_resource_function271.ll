; ModuleID = 'pe_check'
target triple = "x86_64-pc-windows-msvc"

define i32 @sub_1400024F0(i8* %p) {
entry:
  %p16 = bitcast i8* %p to i16*
  %w = load i16, i16* %p16, align 1
  %isMZ = icmp eq i16 %w, 23117
  br i1 %isMZ, label %then_mz, label %ret0

then_mz:                                          ; preds = %entry
  %p_gep_3c = getelementptr i8, i8* %p, i64 60
  %p32 = bitcast i8* %p_gep_3c to i32*
  %lfanew32 = load i32, i32* %p32, align 1
  %lfanew64 = sext i32 %lfanew32 to i64
  %pehdr = getelementptr i8, i8* %p, i64 %lfanew64
  %pe32ptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %pe32ptr, align 1
  %isPE = icmp eq i32 %sig, 17744
  br i1 %isPE, label %then_pe, label %ret0

then_pe:                                          ; preds = %then_mz
  %opt_ptr8 = getelementptr i8, i8* %pehdr, i64 24
  %opt_ptr16 = bitcast i8* %opt_ptr8 to i16*
  %magic = load i16, i16* %opt_ptr16, align 1
  %isPE32plus = icmp eq i16 %magic, 523
  %res = zext i1 %isPE32plus to i32
  ret i32 %res

ret0:                                             ; preds = %then_mz, %entry
  ret i32 0
}