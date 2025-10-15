%struct.S = type { i32, i32, i8*, i64 }

@dword_1400070E8 = external dso_local global i32
@qword_1400070E0 = external dso_local global i8*
@unk_140007100 = external dso_local global i8

declare dso_local i8* @sub_140002BA8(i32, i32)
declare dso_local i8* @sub_1400DA76B(i8*)
declare dso_local void @sub_1403CBAAE(i8*)

define dso_local i32 @sub_1400022B0(i32 %arg1, i8* %arg2) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %g_is_zero = icmp eq i32 %g, 0
  br i1 %g_is_zero, label %ret_zero, label %do_alloc

ret_zero:
  ret i32 0

do_alloc:
  %p = call i8* @sub_140002BA8(i32 1, i32 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %ret_minus1, label %cont

ret_minus1:
  ret i32 -1

cont:
  %ps = bitcast i8* %p to %struct.S*
  %fld0 = getelementptr inbounds %struct.S, %struct.S* %ps, i64 0, i32 0
  store i32 %arg1, i32* %fld0, align 4
  %fld2 = getelementptr inbounds %struct.S, %struct.S* %ps, i64 0, i32 2
  store i8* %arg2, i8** %fld2, align 8

  %r_unk = call i8* @sub_1400DA76B(i8* @unk_140007100)

  ; emulate: sub ecx, [rax-0x75]; adc eax, 0x4DC8 (results unused)
  %mem_ptr = getelementptr i8, i8* %r_unk, i64 -117
  %mem_i32ptr = bitcast i8* %mem_ptr to i32*
  %mem_i32 = load i32, i32* %mem_i32ptr, align 1
  %ecx_init = add i32 0, 1
  %subres = sub i32 %ecx_init, %mem_i32
  %cf = icmp ult i32 %ecx_init, %mem_i32
  %rax_i64 = ptrtoint i8* %r_unk to i64
  %eax_i32 = trunc i64 %rax_i64 to i32
  %add_base = add i32 %eax_i32, 19912
  %cfz = zext i1 %cf to i32
  %adc_res = add i32 %add_base, %cfz

  %fld3 = getelementptr inbounds %struct.S, %struct.S* %ps, i64 0, i32 3
  store i64 24, i64* %fld3, align 8

  store i8* %p, i8** @qword_1400070E0, align 8

  call void @sub_1403CBAAE(i8* @unk_140007100)

  ret i32 0
}