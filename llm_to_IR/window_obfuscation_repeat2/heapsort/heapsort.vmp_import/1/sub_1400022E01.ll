; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare i8* @loc_1403DC01F(i8*)
declare void @sub_140002B40()
declare i32 @sub_1403BE3E1(i8*)

define i32 @sub_1400022E0(i32 %arg0) {
entry:
  %0 = load i32, i32* @dword_1400070E8, align 4
  %cmp0 = icmp eq i32 %0, 0
  br i1 %cmp0, label %ret_zero, label %cont

ret_zero:
  ret i32 0

cont:
  %rcx_param = getelementptr i8, i8* @unk_140007100, i64 0
  %call1 = call i8* @loc_1403DC01F(i8* %rcx_param)
  %ptr_minus = getelementptr i8, i8* %call1, i64 -117
  %ptr_minus_i32 = bitcast i8* %ptr_minus to i32*
  %val_at = load i32, i32* %ptr_minus_i32, align 1
  %cmp_ignored = icmp eq i32 %val_at, %arg0
  %call1_int = ptrtoint i8* %call1 to i64
  %call1_trunc = trunc i64 %call1_int to i32
  %or_eax = or i32 %call1_trunc, 19920
  %or_eax_zext = zext i32 %or_eax to i64
  %or_ptr = inttoptr i64 %or_eax_zext to i8*
  %rcx_is_null = icmp eq i8* %rcx_param, null
  br i1 %rcx_is_null, label %label_343, label %preloop

preloop:
  br label %loop_check

loop_check:
  %rcx_cur = phi i8* [ %rcx_param, %preloop ], [ %rcx_next, %advance ]
  %r8_prev = phi i8* [ null, %preloop ], [ %r8_new, %advance ]
  %key_ptr = bitcast i8* %rcx_cur to i32*
  %key = load i32, i32* %key_ptr, align 4
  %ne = icmp ne i32 %key, %arg0
  %next_addr = getelementptr i8, i8* %rcx_cur, i64 16
  %next_ptr_ptr = bitcast i8* %next_addr to i8**
  %next_ptr = load i8*, i8** %next_ptr_ptr, align 8
  br i1 %ne, label %not_equal, label %found

not_equal:
  %r8_new = bitcast i8* %rcx_cur to i8*
  %next_is_null = icmp eq i8* %next_ptr, null
  br i1 %next_is_null, label %label_343, label %advance

advance:
  %rcx_next = bitcast i8* %next_ptr to i8*
  br label %loop_check

found:
  %is_head = icmp eq i8* %r8_prev, null
  br i1 %is_head, label %headcase, label %interior

headcase:
  store i8* %next_ptr, i8** @qword_1400070E0, align 8
  br label %callb40

interior:
  %prev_next_addr = getelementptr i8, i8* %r8_prev, i64 16
  %prev_next_ptr = bitcast i8* %prev_next_addr to i8**
  store i8* %next_ptr, i8** %prev_next_ptr, align 8
  br label %callb40

callb40:
  call void @sub_140002B40()
  br label %label_343

label_343:
  %rcx2 = getelementptr i8, i8* @unk_140007100, i64 0
  %final = call i32 @sub_1403BE3E1(i8* %rcx2)
  ret i32 %final
}