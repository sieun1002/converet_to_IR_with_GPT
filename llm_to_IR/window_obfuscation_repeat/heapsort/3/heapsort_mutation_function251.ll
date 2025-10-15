; ModuleID = 'module.ll'
source_filename = "module.ll"
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @sub_1400024F0(i8* noundef %p) local_unnamed_addr nounwind {
entry:
  %ptr_i16 = bitcast i8* %p to i16*
  %mz = load i16, i16* %ptr_i16, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %check_pe, label %ret0

ret0:                                             ; preds = %check_pe, %entry
  ret i32 0

check_pe:                                         ; preds = %entry
  %gep_3c = getelementptr inbounds i8, i8* %p, i64 60
  %ptr_3c_i32 = bitcast i8* %gep_3c to i32*
  %e_lfanew32 = load i32, i32* %ptr_3c_i32, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt_ptr = getelementptr inbounds i8, i8* %p, i64 %e_lfanew64
  %nt_i32p = bitcast i8* %nt_ptr to i32*
  %sig = load i32, i32* %nt_i32p, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:                                      ; preds = %check_pe
  %opt_off = getelementptr inbounds i8, i8* %nt_ptr, i64 24
  %opt_i16p = bitcast i8* %opt_off to i16*
  %magic = load i16, i16* %opt_i16p, align 1
  %is_20b = icmp eq i16 %magic, 523
  %res = zext i1 %is_20b to i32
  ret i32 %res
}