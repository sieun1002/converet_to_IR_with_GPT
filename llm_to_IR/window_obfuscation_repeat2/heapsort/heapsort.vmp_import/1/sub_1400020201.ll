; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i32 (i8**)*

declare i8* @sub_140002AF8(i32, i32)
declare void @sub_140002480()

define i32 @sub_140002020(i8** %rcx) {
entry:
  %rdx = load i8*, i8** %rcx
  %rdx_i32ptr = bitcast i8* %rdx to i32*
  %status = load i32, i32* %rdx_i32ptr
  %masked = and i32 %status, 553648127
  %cmp_magic = icmp eq i32 %masked, 541216067
  br i1 %cmp_magic, label %checkByte, label %afterMask

checkByte:                                         ; corresponds to 0x1400020D0
  %ptr4 = getelementptr i8, i8* %rdx, i64 4
  %b = load i8, i8* %ptr4
  %b1 = and i8 %b, 1
  %nz = icmp ne i8 %b1, 0
  br i1 %nz, label %afterMask, label %ret_m1

afterMask:                                         ; corresponds to 0x140002041
  %cmp_ja = icmp ugt i32 %status, 3221225622
  br i1 %cmp_ja, label %globalptr, label %le_0096

le_0096:
  %cmp_jbe = icmp ule i32 %status, 3221225483
  br i1 %cmp_jbe, label %le_008b, label %switch_range

switch_range:
  switch i32 %status, label %ret_m1 [
    i32 3221225484, label %case_group8    ; 0xC000008C
    i32 3221225485, label %case_group8    ; 0xC000008D
    i32 3221225486, label %case_group8    ; 0xC000008E
    i32 3221225487, label %case_group8    ; 0xC000008F
    i32 3221225488, label %case_group8    ; 0xC0000090
    i32 3221225489, label %case_group8    ; 0xC0000091
    i32 3221225490, label %ret_m1         ; 0xC0000092
    i32 3221225491, label %case_group8    ; 0xC0000093
    i32 3221225492, label %case_130       ; 0xC0000094
    i32 3221225493, label %ret_m1         ; 0xC0000095
    i32 3221225494, label %case_0fe       ; 0xC0000096
  ]

case_group8:                                       ; corresponds to 0x140002070/0x140002130 path using ecx=8
  %ret_g8 = call i8* @sub_140002AF8(i32 8, i32 0)
  %ret_g8_i = ptrtoint i8* %ret_g8 to i64
  %is_one_g8 = icmp eq i64 %ret_g8_i, 1
  br i1 %is_one_g8, label %label_1c4, label %not_one_g8

not_one_g8:
  %is_null_g8 = icmp eq i8* %ret_g8, null
  br i1 %is_null_g8, label %globalptr, label %label_190

label_190:                                         ; corresponds to 0x140002190
  %fp_190 = bitcast i8* %ret_g8 to void (i32)*
  call void %fp_190(i32 8)
  br label %ret_m1

label_1c4:                                         ; corresponds to 0x1400021C4
  %tmp1c4 = call i8* @sub_140002AF8(i32 8, i32 1)
  call void @sub_140002480()
  br label %ret_m1

case_130:                                          ; corresponds to 0x140002130 (ecx=8 path specialized elsewhere in asm)
  %ret_130 = call i8* @sub_140002AF8(i32 8, i32 0)
  %ret_130_i = ptrtoint i8* %ret_130 to i64
  %is_one_130 = icmp eq i64 %ret_130_i, 1
  br i1 %is_one_130, label %label_1c4, label %not_one_130

not_one_130:
  %is_null_130 = icmp eq i8* %ret_130, null
  br i1 %is_null_130, label %globalptr, label %call_130

call_130:
  %fp_130 = bitcast i8* %ret_130 to void (i32)*
  call void %fp_130(i32 8)
  br label %ret_m1

case_0fe:                                          ; corresponds to 0x1400020FE (ecx=4 path)
  %ret_0fe = call i8* @sub_140002AF8(i32 4, i32 0)
  %ret_0fe_i = ptrtoint i8* %ret_0fe to i64
  %is_one_0fe = icmp eq i64 %ret_0fe_i, 1
  br i1 %is_one_0fe, label %label_1b0, label %not_one_0fe

not_one_0fe:
  %is_null_0fe = icmp eq i8* %ret_0fe, null
  br i1 %is_null_0fe, label %globalptr, label %call_0fe

call_0fe:
  %fp_0fe = bitcast i8* %ret_0fe to void (i32)*
  call void %fp_0fe(i32 4)
  br label %ret_m1

label_1b0:                                         ; corresponds to 0x1400021B0
  %tmp1b0 = call i8* @sub_140002AF8(i32 4, i32 1)
  br label %ret_m1

le_008b:                                           ; corresponds to 0x1400020B0
  %is_0005 = icmp eq i32 %status, 3221225477
  br i1 %is_0005, label %case_160, label %ja_after5

ja_after5:                                         ; corresponds to 0x1400020BB
  %ugt_5 = icmp ugt i32 %status, 3221225477
  br i1 %ugt_5, label %case_0f0, label %check_80000002

check_80000002:                                    ; corresponds to 0x1400020BD
  %eq_80000002 = icmp eq i32 %status, 2147483650
  br i1 %eq_80000002, label %ret_m1, label %globalptr

case_0f0:                                          ; corresponds to 0x1400020F0
  %eq_0008 = icmp eq i32 %status, 3221225480
  br i1 %eq_0008, label %ret_m1, label %check_001d

check_001d:                                        ; corresponds to 0x1400020F7
  %eq_001d = icmp eq i32 %status, 3221225501
  br i1 %eq_001d, label %case_0fe, label %globalptr

case_160:                                          ; corresponds to 0x140002160 (ecx=0x0B path)
  %ret_160 = call i8* @sub_140002AF8(i32 11, i32 0)
  %ret_160_i = ptrtoint i8* %ret_160 to i64
  %is_one_160 = icmp eq i64 %ret_160_i, 1
  br i1 %is_one_160, label %label_19c, label %not_one_160

not_one_160:
  %is_null_160 = icmp eq i8* %ret_160, null
  br i1 %is_null_160, label %globalptr, label %call_160

call_160:
  %fp_160 = bitcast i8* %ret_160 to void (i32)*
  call void %fp_160(i32 11)
  br label %ret_m1

label_19c:                                         ; corresponds to 0x14000219C
  %tmp19c = call i8* @sub_140002AF8(i32 11, i32 1)
  br label %ret_m1

globalptr:                                         ; corresponds to 0x14000208F
  %fp_glob = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0
  %fp_null = icmp eq i32 (i8**)* %fp_glob, null
  br i1 %fp_null, label %ret_0, label %tailcall_fp

tailcall_fp:
  %res = call i32 %fp_glob(i8** %rcx)
  ret i32 %res

ret_m1:                                            ; corresponds to 0x1400020C4 and other default exits
  ret i32 -1

ret_0:                                             ; corresponds to 0x1400020E0
  ret i32 0
}