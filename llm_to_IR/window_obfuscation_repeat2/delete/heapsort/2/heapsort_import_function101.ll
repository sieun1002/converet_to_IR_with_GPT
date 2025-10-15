; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare i8* @sub_140002BA8(i32, i32)
declare { i8*, i64 } @sub_1400DA76B(i8*)
declare void @sub_1403CBAAE(i8*)

define i32 @sub_1400022B0(i32 %arg0, i8* %arg1) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flagnz = icmp ne i32 %flag, 0
  br i1 %flagnz, label %loc_2D0, label %ret_zero

ret_zero:
  ret i32 0

loc_2D0:
  %alloc = call i8* @sub_140002BA8(i32 1, i32 24)
  %isnull = icmp eq i8* %alloc, null
  br i1 %isnull, label %fail, label %cont

fail:
  ret i32 -1

cont:
  %p32 = bitcast i8* %alloc to i32*
  store i32 %arg0, i32* %p32, align 4
  %p8 = getelementptr i8, i8* %alloc, i64 8
  %p8_as_ptr = bitcast i8* %p8 to i8**
  store i8* %arg1, i8** %p8_as_ptr, align 8
  %retpair = call { i8*, i64 } @sub_1400DA76B(i8* @unk_140007100)
  %retptr = extractvalue { i8*, i64 } %retpair, 0
  %retdx = extractvalue { i8*, i64 } %retpair, 1
  %addrm = getelementptr i8, i8* %retptr, i64 -117
  %addrm_i32 = bitcast i8* %addrm to i32*
  %memval = load i32, i32* %addrm_i32, align 1
  %subres = sub i32 1, %memval
  %retptr_i64 = ptrtoint i8* %retptr to i64
  %retptr_lo32 = trunc i64 %retptr_i64 to i32
  %cf = icmp ult i32 1, %memval
  %cf_z = zext i1 %cf to i32
  %add_base = add i32 %retptr_lo32, 19912
  %adcres = add i32 %add_base, %cf_z
  %p16 = getelementptr i8, i8* %alloc, i64 16
  %p16_i64 = bitcast i8* %p16 to i64*
  store i64 %retdx, i64* %p16_i64, align 8
  store i8* %alloc, i8** @qword_1400070E0, align 8
  call void @sub_1403CBAAE(i8* @unk_140007100)
  ret i32 0
}