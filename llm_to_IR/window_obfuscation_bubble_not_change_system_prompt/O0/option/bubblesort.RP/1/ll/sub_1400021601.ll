; ModuleID = 'sub_140002160'
target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002160(i8* %rcx, i64 %rdx) {
entry:
  %p3C = getelementptr inbounds i8, i8* %rcx, i64 60
  %p3C_i32 = bitcast i8* %p3C to i32*
  %e_lfanew32 = load i32, i32* %p3C_i32, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt = getelementptr inbounds i8, i8* %rcx, i64 %e_lfanew64

  %pNum = getelementptr inbounds i8, i8* %nt, i64 6
  %pNum_i16 = bitcast i8* %pNum to i16*
  %num16 = load i16, i16* %pNum_i16, align 1
  %numZero = icmp eq i16 %num16, 0
  br i1 %numZero, label %ret_zero, label %after_num

after_num:
  %pSizeOpt = getelementptr inbounds i8, i8* %nt, i64 20
  %pSizeOpt_i16 = bitcast i8* %pSizeOpt to i16*
  %size16 = load i16, i16* %pSizeOpt_i16, align 1
  %size64 = zext i16 %size16 to i64

  %pFirst_off = getelementptr inbounds i8, i8* %nt, i64 24
  %first = getelementptr inbounds i8, i8* %pFirst_off, i64 %size64

  %num32 = zext i16 %num16 to i32
  %num64 = zext i32 %num32 to i64
  %span = mul nuw i64 %num64, 40
  %end = getelementptr inbounds i8, i8* %first, i64 %span
  br label %loop

loop:
  %cur = phi i8* [ %first, %after_num ], [ %cur_next, %cont ]

  %pVA = getelementptr inbounds i8, i8* %cur, i64 12
  %pVA_i32 = bitcast i8* %pVA to i32*
  %va32 = load i32, i32* %pVA_i32, align 1
  %va64 = zext i32 %va32 to i64

  %cmpLo = icmp ult i64 %rdx, %va64
  br i1 %cmpLo, label %cont, label %check_upper

check_upper:
  %pVS = getelementptr inbounds i8, i8* %cur, i64 8
  %pVS_i32 = bitcast i8* %pVS to i32*
  %vs32 = load i32, i32* %pVS_i32, align 1
  %vs64 = zext i32 %vs32 to i64
  %upper = add nuw i64 %va64, %vs64
  %cmpInside = icmp ult i64 %rdx, %upper
  br i1 %cmpInside, label %ret_cur, label %cont

cont:
  %cur_next = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %cur_next, %end
  br i1 %done, label %ret_zero, label %loop

ret_cur:
  ret i8* %cur

ret_zero:
  ret i8* null
}