; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = external global i8*

%struct.ArgPack = type { i32, i32, i8*, double, double, double }

define void @sub_140002030(i32 %a, i8* %b, double %c, double %d, double %e) {
entry:
  %fp.addr = load i8*, i8** @qword_1400070B0
  %isnull = icmp eq i8* %fp.addr, null
  br i1 %isnull, label %ret, label %prepare

prepare:
  %ap = alloca %struct.ArgPack, align 8
  %ap_i32_ptr = getelementptr inbounds %struct.ArgPack, %struct.ArgPack* %ap, i32 0, i32 0
  store i32 %a, i32* %ap_i32_ptr, align 4
  %ap_pad_ptr = getelementptr inbounds %struct.ArgPack, %struct.ArgPack* %ap, i32 0, i32 1
  store i32 0, i32* %ap_pad_ptr, align 4
  %ap_ptr_ptr = getelementptr inbounds %struct.ArgPack, %struct.ArgPack* %ap, i32 0, i32 2
  store i8* %b, i8** %ap_ptr_ptr, align 8
  %ap_d0_ptr = getelementptr inbounds %struct.ArgPack, %struct.ArgPack* %ap, i32 0, i32 3
  store double %c, double* %ap_d0_ptr, align 8
  %ap_d1_ptr = getelementptr inbounds %struct.ArgPack, %struct.ArgPack* %ap, i32 0, i32 4
  store double %d, double* %ap_d1_ptr, align 8
  %ap_d2_ptr = getelementptr inbounds %struct.ArgPack, %struct.ArgPack* %ap, i32 0, i32 5
  store double %e, double* %ap_d2_ptr, align 8
  %ap_cast = bitcast %struct.ArgPack* %ap to i8*
  %fp_typed = bitcast i8* %fp.addr to void (i8*)*
  call void %fp_typed(i8* %ap_cast)
  br label %ret

ret:
  ret void
}