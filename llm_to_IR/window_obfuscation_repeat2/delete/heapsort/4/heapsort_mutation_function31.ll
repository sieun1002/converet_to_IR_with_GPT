; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8**)*

declare void @sub_140001010()
declare i8* @signal(i32, i8*)
declare void @sub_1400024E0()

define void @sub_1400013E0() {
entry:
  %0 = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %0, align 4
  call void @sub_140001010()
  ret void
}

define i32 @sub_140002080(i8** %p) {
entry:
  %rbx = alloca i8**, align 8
  store i8** %p, i8*** %rbx, align 8
  %1 = load i8**, i8*** %rbx, align 8
  %2 = load i8*, i8** %1, align 8
  %3 = bitcast i8* %2 to i32*
  %4 = load i32, i32* %3, align 4
  %5 = and i32 %4, 0x20FFFFFF
  %6 = icmp eq i32 %5, 0x20474343
  br i1 %6, label %ccg, label %cmpStart

ccg:                                              ; 0x140002130 path
  %7 = getelementptr i8, i8* %2, i64 4
  %8 = load i8, i8* %7, align 1
  %9 = and i8 %8, 1
  %10 = icmp ne i8 %9, 0
  br i1 %10, label %cmpStart, label %ret_minus1

cmpStart:                                         ; 0x1400020A1 sequence
  %11 = icmp ugt i32 %4, 0xC0000096
  br i1 %11, label %loc_0EF, label %cmp2

cmp2:                                             ; 0x1400020A8
  %12 = icmp ule i32 %4, 0xC000008B
  br i1 %12, label %loc_110, label %switch_region

loc_110:                                          ; 0x140002110
  %13 = icmp eq i32 %4, 0xC0000005
  br i1 %13, label %loc_1C0, label %loc_110_cmp2

loc_110_cmp2:
  %14 = icmp ugt i32 %4, 0xC0000005
  br i1 %14, label %loc_150, label %loc_11D

loc_11D:                                          ; 0x14000211D
  %15 = icmp eq i32 %4, 0x80000002
  br i1 %15, label %ret_minus1, label %loc_0EF

loc_150:                                          ; 0x140002150
  %16 = icmp eq i32 %4, 0xC0000008
  br i1 %16, label %ret_minus1, label %loc_150_cmp2

loc_150_cmp2:
  %17 = icmp eq i32 %4, 0xC000001D
  br i1 %17, label %loc_15E, label %loc_0EF

switch_region:                                    ; 0x1400020AF.. jump table modeled by compares
  %18 = icmp eq i32 %4, 0xC0000094
  br i1 %18, label %loc_190, label %switch_other

switch_other:
  %19 = icmp eq i32 %4, 0xC000008D
  %20 = icmp eq i32 %4, 0xC000008E
  %21 = or i1 %19, %20
  %22 = icmp eq i32 %4, 0xC000008F
  %23 = or i1 %21, %22
  %24 = icmp eq i32 %4, 0xC0000090
  %25 = or i1 %23, %24
  %26 = icmp eq i32 %4, 0xC0000091
  %27 = or i1 %25, %26
  %28 = icmp eq i32 %4, 0xC0000093
  %29 = or i1 %27, %28
  br i1 %29, label %loc_0D0, label %ret_minus1

loc_0D0:                                          ; 0x1400020D0
  %30 = call i8* @signal(i32 8, i8* null)
  %31 = inttoptr i64 1 to i8*
  %32 = icmp eq i8* %30, %31
  br i1 %32, label %loc_224, label %loc_0E6_test1

loc_0E6_test1:                                    ; 0x1400020E6
  %33 = icmp ne i8* %30, null
  br i1 %33, label %loc_1F0_call1, label %loc_0EF

loc_1F0_call1:                                    ; 0x1400021F0
  %34 = bitcast i8* %30 to void (i32)*
  call void %34(i32 8)
  br label %ret_minus1

loc_190:                                          ; 0x140002190
  %35 = call i8* @signal(i32 8, i8* null)
  %36 = inttoptr i64 1 to i8*
  %37 = icmp eq i8* %35, %36
  br i1 %37, label %loc_1A6, label %loc_0E6_test2

loc_0E6_test2:                                    ; 0x1400020E6 path
  %38 = icmp ne i8* %35, null
  br i1 %38, label %loc_1F0_call2, label %loc_0EF

loc_1F0_call2:
  %39 = bitcast i8* %35 to void (i32)*
  call void %39(i32 8)
  br label %ret_minus1

loc_1A6:                                          ; 0x1400021A6
  %40 = call i8* @signal(i32 8, i8* %36)
  br label %ret_minus1

loc_15E:                                          ; 0x14000215E
  %41 = call i8* @signal(i32 4, i8* null)
  %42 = inttoptr i64 1 to i8*
  %43 = icmp eq i8* %41, %42
  br i1 %43, label %loc_210, label %loc_15E_test

loc_15E_test:
  %44 = icmp ne i8* %41, null
  br i1 %44, label %loc_182_call, label %loc_0EF

loc_182_call:
  %45 = bitcast i8* %41 to void (i32)*
  call void %45(i32 4)
  br label %ret_minus1

loc_210:                                          ; 0x140002210
  %46 = call i8* @signal(i32 4, i8* %42)
  br label %ret_minus1

loc_1C0:                                          ; 0x1400021C0
  %47 = call i8* @signal(i32 11, i8* null)
  %48 = inttoptr i64 1 to i8*
  %49 = icmp eq i8* %47, %48
  br i1 %49, label %loc_1FC, label %loc_1C0_test

loc_1C0_test:
  %50 = icmp ne i8* %47, null
  br i1 %50, label %loc_1E0_call, label %loc_0EF

loc_1E0_call:
  %51 = bitcast i8* %47 to void (i32)*
  call void %51(i32 11)
  br label %ret_minus1

loc_1FC:                                          ; 0x1400021FC
  %52 = call i8* @signal(i32 11, i8* %48)
  br label %ret_minus1

loc_224:                                          ; 0x140002224
  %53 = call i8* @signal(i32 8, i8* %31)
  call void @sub_1400024E0()
  br label %ret_minus1

loc_0EF:                                          ; 0x1400020EF
  %54 = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %55 = icmp eq i32 (i8**)* %54, null
  br i1 %55, label %ret0, label %tailcb

ret0:                                             ; 0x140002140
  ret i32 0

tailcb:
  %56 = load i8**, i8*** %rbx, align 8
  %57 = tail call i32 %54(i8** %56)
  ret i32 %57

ret_minus1:                                       ; 0x140002124
  ret i32 -1
}