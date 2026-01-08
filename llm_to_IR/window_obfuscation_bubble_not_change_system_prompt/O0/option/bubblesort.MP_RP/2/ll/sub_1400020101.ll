; ModuleID = 'sub_140002010'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32
@qword_1400070E0 = external dso_local global i8*
@unk_140007100 = external dso_local global [0 x i8]
@qword_140008250 = external dso_local global void (i8*)*
@qword_140008268 = external dso_local global void (i8*)*

declare void @sub_140001E80()
declare void @sub_1400027F0(i8*)
declare void @sub_140002120()

define dso_local i32 @sub_140002010(i32 %edx) {
entry:
  %var10 = alloca i8*, align 8
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %loc_20D8, label %after_cmp2

after_cmp2:                                       ; 0x140002017
  %ugt2 = icmp ugt i32 %edx, 2
  br i1 %ugt2, label %loc_2048, label %loc_201F

loc_201F:                                         ; 0x14000201F
  %iszero_edx = icmp eq i32 %edx, 0
  br i1 %iszero_edx, label %loc_2060, label %loc_2023

loc_2023:                                         ; 0x140002023
  %e_2023 = load i32, i32* @dword_1400070E8, align 4
  %e_zero_2023 = icmp eq i32 %e_2023, 0
  br i1 %e_zero_2023, label %loc_2100, label %loc_2031

loc_2100:                                         ; 0x140002100
  %p_2100 = getelementptr [0 x i8], [0 x i8]* @unk_140007100, i64 0, i64 0
  %fp_2100 = load void (i8*)*, void (i8*)** @qword_140008268, align 8
  call void %fp_2100(i8* %p_2100)
  br label %loc_2031

loc_2031:                                         ; 0x140002031
  store i32 1, i32* @dword_1400070E8, align 4
  br label %loc_003B

loc_2048:                                         ; 0x140002048
  %cmp3 = icmp eq i32 %edx, 3
  br i1 %cmp3, label %loc_204D, label %loc_003B

loc_204D:                                         ; 0x14000204D
  %e_204D = load i32, i32* @dword_1400070E8, align 4
  %e_zero_204D = icmp eq i32 %e_204D, 0
  br i1 %e_zero_204D, label %loc_003B, label %loc_2057

loc_2057:                                         ; 0x140002057
  call void @sub_140001E80()
  br label %loc_003B

loc_2060:                                         ; 0x140002060
  %e_2060 = load i32, i32* @dword_1400070E8, align 4
  %e_nz_2060 = icmp ne i32 %e_2060, 0
  br i1 %e_nz_2060, label %loc_20F0, label %loc_206E

loc_206E:                                         ; 0x14000206E
  %e_206E = load i32, i32* @dword_1400070E8, align 4
  %e_eq1_206E = icmp eq i32 %e_206E, 1
  br i1 %e_eq1_206E, label %loc_2079, label %loc_003B

loc_2079:                                         ; 0x140002079
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_isnull = icmp eq i8* %head, null
  br i1 %head_isnull, label %loc_20AB, label %loc_2090

loc_2090:                                         ; 0x140002090
  %cur = phi i8* [ %head, %loc_2079 ], [ %next2, %loc_2090 ]
  %addr = getelementptr i8, i8* %cur, i64 16
  %addrp = bitcast i8* %addr to i8**
  %next = load i8*, i8** %addrp, align 8
  store i8* %next, i8** %var10, align 8
  call void @sub_1400027F0(i8* %cur)
  %next2 = load i8*, i8** %var10, align 8
  %nz_next2 = icmp ne i8* %next2, null
  br i1 %nz_next2, label %loc_2090, label %loc_20AB

loc_20AB:                                         ; 0x1400020AB
  %p_20AB = getelementptr [0 x i8], [0 x i8]* @unk_140007100, i64 0, i64 0
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %fp_20AB = load void (i8*)*, void (i8*)** @qword_140008250, align 8
  call void %fp_20AB(i8* %p_20AB)
  br label %loc_003B

loc_20F0:                                         ; 0x1400020F0
  call void @sub_140001E80()
  br label %loc_206E

loc_20D8:                                         ; 0x1400020D8
  call void @sub_140002120()
  ret i32 1

loc_003B:                                         ; 0x14000203B
  ret i32 1
}