; ModuleID = 'bubblesort.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu-elf"

%struct.State = type { %struct.ArchState, [32 x %union.VectorReg], %struct.ArithFlags, %union.anon, %struct.Segments, %struct.AddressSpace, %struct.GPR, %struct.X87Stack, %struct.MMX, %struct.FPUStatusFlags, %union.anon, %union.FPU, %struct.SegmentCaches }
%struct.ArchState = type { i32, i32, %union.anon }
%union.VectorReg = type { %union.vec512_t }
%union.vec512_t = type { %struct.uint64v8_t }
%struct.uint64v8_t = type { [8 x i64] }
%struct.ArithFlags = type { i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8 }
%struct.Segments = type { i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector }
%union.SegmentSelector = type { i16 }
%struct.AddressSpace = type { i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg }
%struct.Reg = type { %union.anon }
%struct.GPR = type { i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg }
%struct.X87Stack = type { [8 x %struct.anon.3] }
%struct.anon.3 = type { [6 x i8], %struct.float80_t }
%struct.float80_t = type { [10 x i8] }
%struct.MMX = type { [8 x %struct.anon.4] }
%struct.anon.4 = type { i64, %union.vec64_t }
%union.vec64_t = type { %struct.uint64v1_t }
%struct.uint64v1_t = type { [1 x i64] }
%struct.FPUStatusFlags = type { i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, [4 x i8] }
%union.anon = type { i64 }
%union.FPU = type { %struct.anon.13 }
%struct.anon.13 = type { %struct.FpuFXSAVE, [96 x i8] }
%struct.FpuFXSAVE = type { %union.SegmentSelector, %union.SegmentSelector, %union.FPUAbridgedTagWord, i8, i16, i32, %union.SegmentSelector, i16, i32, %union.SegmentSelector, i16, %union.FPUControlStatus, %union.FPUControlStatus, [8 x %struct.FPUStackElem], [16 x %union.vec128_t] }
%union.FPUAbridgedTagWord = type { i8 }
%union.FPUControlStatus = type { i32 }
%struct.FPUStackElem = type { %union.anon.11, [6 x i8] }
%union.anon.11 = type { %struct.float80_t }
%union.vec128_t = type { %struct.uint128v1_t }
%struct.uint128v1_t = type { [1 x i128] }
%struct.SegmentCaches = type { %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow }
%struct.SegmentShadow = type { %union.anon, i32, i32 }
%struct.Memory = type opaque

@RSP_2312_366235b8 = external global i64
@OF_2077_36623570 = external global i8
@SF_2073_36623570 = external global i8
@ZF_2071_36623570 = external global i8
@AF_2069_36623570 = external global i8
@PF_2067_36623570 = external global i8
@CF_2065_36623570 = external global i8
@RAX_2216_366235b8 = external global i64
@RSP_2312_3662abc0 = external global i64*
@RDI_2296_366235b8 = external global i64
@RBP_2328_366235b8 = external global i64
@RCX_2248_366235b8 = external global i64
@RSI_2280_366235b8 = external global i64
@RDX_2264_366235b8 = external global i64

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_1189_bubble_sort(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_1189:
  %0 = load i64, i64* @RBP_2328_366235b8, align 8
  %1 = load i64*, i64** @RSP_2312_3662abc0, align 8
  %2 = load i64, i64* @RSP_2312_366235b8, align 8, !tbaa !5
  %3 = add i64 %2, -8
  %4 = getelementptr i64, i64* %1, i32 -1
  store i64 %0, i64* %4, align 8
  store i64 %3, i64* @RSP_2312_366235b8, align 8, !tbaa !8
  store i64 %3, i64* @RBP_2328_366235b8, align 8, !tbaa !8
  %5 = sub i64 %3, 40
  %6 = load i64, i64* @RDI_2296_366235b8, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = sub i64 %3, 48
  %9 = load i64, i64* @RSI_2280_366235b8, align 8
  %10 = inttoptr i64 %8 to i64*
  store i64 %9, i64* %10, align 8
  %11 = sub i64 %9, 1
  %12 = icmp ult i64 %9, 1
  %13 = zext i1 %12 to i8
  store i8 %13, i8* @CF_2065_36623570, align 1, !tbaa !10
  %14 = trunc i64 %11 to i32
  %15 = and i32 %14, 255
  %16 = call i32 @llvm.ctpop.i32(i32 %15) #2, !range !24
  %17 = trunc i32 %16 to i8
  %18 = and i8 %17, 1
  %19 = xor i8 %18, 1
  store i8 %19, i8* @PF_2067_36623570, align 1, !tbaa !25
  %20 = xor i64 %9, 1
  %21 = xor i64 %20, %11
  %22 = lshr i64 %21, 4
  %23 = trunc i64 %22 to i8
  %24 = and i8 %23, 1
  store i8 %24, i8* @AF_2069_36623570, align 1, !tbaa !26
  %25 = icmp eq i64 %11, 0
  %26 = zext i1 %25 to i8
  store i8 %26, i8* @ZF_2071_36623570, align 1, !tbaa !27
  %27 = lshr i64 %11, 63
  %28 = trunc i64 %27 to i8
  store i8 %28, i8* @SF_2073_36623570, align 1, !tbaa !28
  %29 = lshr i64 %9, 63
  %30 = xor i64 %27, %29
  %31 = add nuw nsw i64 %30, %29
  %32 = icmp eq i64 %31, 2
  %33 = zext i1 %32 to i8
  store i8 %33, i8* @OF_2077_36623570, align 1, !tbaa !29
  %34 = or i8 %26, %13
  %35 = icmp ne i8 %34, 0
  br i1 %35, label %inst_1289, label %inst_11a4

inst_1289:                                        ; preds = %inst_1269, %inst_1278, %inst_1189
  %36 = phi %struct.Memory* [ %41, %inst_1269 ], [ %memory, %inst_1189 ], [ %41, %inst_1278 ]
  %37 = load i64, i64* %4, align 8
  store i64 %37, i64* @RBP_2328_366235b8, align 8, !tbaa !8
  %38 = add i64 %2, 8
  store i64 %38, i64* @RSP_2312_366235b8, align 8, !tbaa !8
  ret %struct.Memory* %36

inst_1256:                                        ; preds = %inst_11c6, %inst_11f4
  %39 = load i64, i64* %132, align 8
  %40 = add i64 %39, 1
  store i64 %40, i64* %132, align 8
  br label %inst_125b

inst_1278:                                        ; preds = %inst_1270, %inst_11a4
  %41 = phi %struct.Memory* [ %memory, %inst_11a4 ], [ %41, %inst_1270 ]
  %42 = load i64, i64* %72, align 8
  %43 = sub i64 %42, 1
  %44 = icmp ult i64 %42, 1
  %45 = zext i1 %44 to i8
  store i8 %45, i8* @CF_2065_36623570, align 1, !tbaa !10
  %46 = trunc i64 %43 to i32
  %47 = and i32 %46, 255
  %48 = call i32 @llvm.ctpop.i32(i32 %47) #2, !range !24
  %49 = trunc i32 %48 to i8
  %50 = and i8 %49, 1
  %51 = xor i8 %50, 1
  store i8 %51, i8* @PF_2067_36623570, align 1, !tbaa !25
  %52 = xor i64 %42, 1
  %53 = xor i64 %52, %43
  %54 = lshr i64 %53, 4
  %55 = trunc i64 %54 to i8
  %56 = and i8 %55, 1
  store i8 %56, i8* @AF_2069_36623570, align 1, !tbaa !26
  %57 = icmp eq i64 %43, 0
  %58 = zext i1 %57 to i8
  store i8 %58, i8* @ZF_2071_36623570, align 1, !tbaa !27
  %59 = lshr i64 %43, 63
  %60 = trunc i64 %59 to i8
  store i8 %60, i8* @SF_2073_36623570, align 1, !tbaa !28
  %61 = lshr i64 %42, 63
  %62 = xor i64 %59, %61
  %63 = add nuw nsw i64 %62, %61
  %64 = icmp eq i64 %63, 2
  %65 = zext i1 %64 to i8
  store i8 %65, i8* @OF_2077_36623570, align 1, !tbaa !29
  %66 = or i8 %58, %45
  %67 = icmp eq i8 %66, 0
  br i1 %67, label %inst_11b1, label %inst_1289

inst_125b:                                        ; preds = %inst_11b1, %inst_1256
  %68 = load i64, i64* %132, align 8
  store i64 %68, i64* @RAX_2216_366235b8, align 8, !tbaa !8
  %69 = load i64, i64* %72, align 8
  %70 = icmp ugt i64 %69, %68
  br i1 %70, label %inst_11c6, label %inst_1269

inst_11a4:                                        ; preds = %inst_1189
  store i64 %9, i64* @RAX_2216_366235b8, align 8, !tbaa !8
  %71 = sub i64 %3, 24
  %72 = inttoptr i64 %71 to i64*
  store i64 %9, i64* %72, align 8
  br label %inst_1278

inst_11f4:                                        ; preds = %inst_11c6
  %73 = sub i64 %3, 28
  %74 = inttoptr i64 %73 to i32*
  store i32 %99, i32* %74, align 4
  %75 = load i64, i64* %132, align 8
  %76 = mul i64 %75, 4
  %77 = load i64, i64* %7, align 8
  %78 = add i64 %76, %77
  %79 = shl i64 %75, 1
  %80 = shl i64 %79, 1
  %81 = sub i64 %80, 4
  store i64 %81, i64* @RCX_2248_366235b8, align 8, !tbaa !8
  %82 = add i64 %81, %77
  %83 = inttoptr i64 %78 to i32*
  %84 = load i32, i32* %83, align 4
  %85 = inttoptr i64 %82 to i32*
  store i32 %84, i32* %85, align 4
  %86 = load i64, i64* %132, align 8
  %87 = mul i64 %86, 4
  %88 = load i64, i64* %7, align 8
  %89 = add i64 %88, %87
  store i64 %89, i64* @RDX_2264_366235b8, align 8, !tbaa !8
  %90 = load i32, i32* %74, align 4
  %91 = inttoptr i64 %89 to i32*
  store i32 %90, i32* %91, align 4
  %92 = load i64, i64* %132, align 8
  store i64 %92, i64* %130, align 8
  br label %inst_1256

inst_11c6:                                        ; preds = %inst_125b
  %93 = shl i64 %68, 1
  %94 = shl i64 %93, 1
  %95 = sub i64 %94, 4
  %96 = load i64, i64* %7, align 8
  %97 = add i64 %95, %96
  %98 = inttoptr i64 %97 to i32*
  %99 = load i32, i32* %98, align 4
  %100 = zext i32 %99 to i64
  store i64 %100, i64* @RDX_2264_366235b8, align 8, !tbaa !8
  %101 = mul i64 %68, 4
  store i64 %101, i64* @RCX_2248_366235b8, align 8, !tbaa !8
  %102 = add i64 %101, %96
  %103 = inttoptr i64 %102 to i32*
  %104 = load i32, i32* %103, align 4
  %105 = sub i32 %99, %104
  %106 = icmp eq i32 %105, 0
  %107 = lshr i32 %105, 31
  %108 = trunc i32 %107 to i8
  %109 = lshr i32 %99, 31
  %110 = lshr i32 %104, 31
  %111 = xor i32 %110, %109
  %112 = xor i32 %107, %109
  %113 = add nuw nsw i32 %112, %111
  %114 = icmp eq i32 %113, 2
  %115 = icmp ne i8 %108, 0
  %116 = xor i1 %115, %114
  %117 = or i1 %106, %116
  br i1 %117, label %inst_1256, label %inst_11f4

inst_1269:                                        ; preds = %inst_125b
  %118 = load i64, i64* %130, align 8
  store i8 0, i8* @CF_2065_36623570, align 1, !tbaa !10
  %119 = trunc i64 %118 to i32
  %120 = and i32 %119, 255
  %121 = call i32 @llvm.ctpop.i32(i32 %120) #2, !range !24
  %122 = trunc i32 %121 to i8
  %123 = and i8 %122, 1
  %124 = xor i8 %123, 1
  store i8 %124, i8* @PF_2067_36623570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_36623570, align 1, !tbaa !26
  %125 = icmp eq i64 %118, 0
  %126 = zext i1 %125 to i8
  store i8 %126, i8* @ZF_2071_36623570, align 1, !tbaa !27
  %127 = lshr i64 %118, 63
  %128 = trunc i64 %127 to i8
  store i8 %128, i8* @SF_2073_36623570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_36623570, align 1, !tbaa !29
  br i1 %125, label %inst_1289, label %inst_1270

inst_1270:                                        ; preds = %inst_1269
  store i64 %118, i64* @RAX_2216_366235b8, align 8, !tbaa !8
  store i64 %118, i64* %72, align 8
  br label %inst_1278

inst_11b1:                                        ; preds = %inst_1278
  %129 = sub i64 %3, 16
  %130 = inttoptr i64 %129 to i64*
  store i64 0, i64* %130, align 8
  %131 = sub i64 %3, 8
  %132 = inttoptr i64 %131 to i64*
  store i64 1, i64* %132, align 8
  br label %inst_125b
}

attributes #0 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #1 = { noinline "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }

!llvm.ident = !{!0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!llvm.dbg.cu = !{}

!0 = !{!"clang version 9.0.1 (https://github.com/trailofbits/vcpkg.git 4592a93cc4ca82f1963dba08413c43639662d7ae)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 2, !"Dwarf Version", i32 4}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{!"base.helper.semantics"}
!5 = !{!6, !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C++ TBAA"}
!8 = !{!9, !9, i64 0}
!9 = !{!"long", !6, i64 0}
!10 = !{!11, !6, i64 2065}
!11 = !{!"_ZTS5State", !6, i64 16, !12, i64 2064, !6, i64 2080, !13, i64 2088, !15, i64 2112, !17, i64 2208, !18, i64 2480, !19, i64 2608, !20, i64 2736, !6, i64 2760, !6, i64 2768, !21, i64 3280}
!12 = !{!"_ZTS10ArithFlags", !6, i64 0, !6, i64 1, !6, i64 2, !6, i64 3, !6, i64 4, !6, i64 5, !6, i64 6, !6, i64 7, !6, i64 8, !6, i64 9, !6, i64 10, !6, i64 11, !6, i64 12, !6, i64 13, !6, i64 14, !6, i64 15}
!13 = !{!"_ZTS8Segments", !14, i64 0, !6, i64 2, !14, i64 4, !6, i64 6, !14, i64 8, !6, i64 10, !14, i64 12, !6, i64 14, !14, i64 16, !6, i64 18, !14, i64 20, !6, i64 22}
!14 = !{!"short", !6, i64 0}
!15 = !{!"_ZTS12AddressSpace", !9, i64 0, !16, i64 8, !9, i64 16, !16, i64 24, !9, i64 32, !16, i64 40, !9, i64 48, !16, i64 56, !9, i64 64, !16, i64 72, !9, i64 80, !16, i64 88}
!16 = !{!"_ZTS3Reg", !6, i64 0}
!17 = !{!"_ZTS3GPR", !9, i64 0, !16, i64 8, !9, i64 16, !16, i64 24, !9, i64 32, !16, i64 40, !9, i64 48, !16, i64 56, !9, i64 64, !16, i64 72, !9, i64 80, !16, i64 88, !9, i64 96, !16, i64 104, !9, i64 112, !16, i64 120, !9, i64 128, !16, i64 136, !9, i64 144, !16, i64 152, !9, i64 160, !16, i64 168, !9, i64 176, !16, i64 184, !9, i64 192, !16, i64 200, !9, i64 208, !16, i64 216, !9, i64 224, !16, i64 232, !9, i64 240, !16, i64 248, !9, i64 256, !16, i64 264}
!18 = !{!"_ZTS8X87Stack", !6, i64 0}
!19 = !{!"_ZTS3MMX", !6, i64 0}
!20 = !{!"_ZTS14FPUStatusFlags", !6, i64 0, !6, i64 1, !6, i64 2, !6, i64 3, !6, i64 4, !6, i64 5, !6, i64 6, !6, i64 7, !6, i64 8, !6, i64 9, !6, i64 10, !6, i64 11, !6, i64 12, !6, i64 13, !6, i64 14, !6, i64 15, !6, i64 16, !6, i64 17, !6, i64 18, !6, i64 19, !6, i64 20}
!21 = !{!"_ZTS13SegmentCaches", !22, i64 0, !22, i64 16, !22, i64 32, !22, i64 48, !22, i64 64, !22, i64 80}
!22 = !{!"_ZTS13SegmentShadow", !6, i64 0, !23, i64 8, !23, i64 12}
!23 = !{!"int", !6, i64 0}
!24 = !{i32 0, i32 9}
!25 = !{!11, !6, i64 2067}
!26 = !{!11, !6, i64 2069}
!27 = !{!11, !6, i64 2071}
!28 = !{!11, !6, i64 2073}
!29 = !{!11, !6, i64 2077}
