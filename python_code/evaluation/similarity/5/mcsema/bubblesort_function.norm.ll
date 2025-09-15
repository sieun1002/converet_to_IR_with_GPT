; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/mcsema/ll/O0/bubblesort_function.ll'
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
  %4 = getelementptr i64, i64* %1, i64 -1
  store i64 %0, i64* %4, align 8
  store i64 %3, i64* @RSP_2312_366235b8, align 8, !tbaa !8
  store i64 %3, i64* @RBP_2328_366235b8, align 8, !tbaa !8
  %5 = add i64 %2, -48
  %6 = load i64, i64* @RDI_2296_366235b8, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = add i64 %2, -56
  %9 = load i64, i64* @RSI_2280_366235b8, align 8
  %10 = inttoptr i64 %8 to i64*
  store i64 %9, i64* %10, align 8
  %11 = add i64 %9, -1
  %12 = icmp eq i64 %9, 0
  %13 = zext i1 %12 to i8
  store i8 %13, i8* @CF_2065_36623570, align 1, !tbaa !10
  %14 = trunc i64 %11 to i32
  %15 = and i32 %14, 255
  %16 = call i32 @llvm.ctpop.i32(i32 %15) #2, !range !24
  %17 = trunc i32 %16 to i8
  %18 = and i8 %17, 1
  %19 = xor i8 %18, 1
  store i8 %19, i8* @PF_2067_36623570, align 1, !tbaa !25
  %20 = xor i64 %9, %11
  %21 = trunc i64 %20 to i8
  %22 = lshr i8 %21, 4
  %23 = and i8 %22, 1
  store i8 %23, i8* @AF_2069_36623570, align 1, !tbaa !26
  %24 = icmp eq i64 %11, 0
  %25 = zext i1 %24 to i8
  store i8 %25, i8* @ZF_2071_36623570, align 1, !tbaa !27
  %26 = lshr i64 %11, 63
  %27 = trunc i64 %26 to i8
  store i8 %27, i8* @SF_2073_36623570, align 1, !tbaa !28
  %28 = lshr i64 %9, 63
  %29 = xor i64 %26, %28
  %30 = add nuw nsw i64 %29, %28
  %31 = icmp eq i64 %30, 2
  %32 = zext i1 %31 to i8
  store i8 %32, i8* @OF_2077_36623570, align 1, !tbaa !29
  %33 = icmp ult i64 %9, 2
  br i1 %33, label %inst_1289, label %inst_11a4

inst_1289:                                        ; preds = %inst_1269, %inst_1278, %inst_1189
  %34 = load i64, i64* %4, align 8
  store i64 %34, i64* @RBP_2328_366235b8, align 8, !tbaa !8
  %35 = add i64 %2, 8
  store i64 %35, i64* @RSP_2312_366235b8, align 8, !tbaa !8
  ret %struct.Memory* %memory

inst_1256:                                        ; preds = %inst_11c6, %inst_11f4
  %36 = load i64, i64* %116, align 8
  %37 = add i64 %36, 1
  br label %inst_125b

inst_1278:                                        ; preds = %inst_1270, %inst_11a4
  %storemerge = phi i64 [ %9, %inst_11a4 ], [ %102, %inst_1270 ]
  store i64 %storemerge, i64* %61, align 8
  %38 = add i64 %storemerge, -1
  store i8 0, i8* @CF_2065_36623570, align 1, !tbaa !10
  %39 = trunc i64 %38 to i32
  %40 = and i32 %39, 255
  %41 = call i32 @llvm.ctpop.i32(i32 %40) #2, !range !24
  %42 = trunc i32 %41 to i8
  %43 = and i8 %42, 1
  %44 = xor i8 %43, 1
  store i8 %44, i8* @PF_2067_36623570, align 1, !tbaa !25
  %45 = xor i64 %storemerge, %38
  %46 = trunc i64 %45 to i8
  %47 = lshr i8 %46, 4
  %48 = and i8 %47, 1
  store i8 %48, i8* @AF_2069_36623570, align 1, !tbaa !26
  %49 = icmp eq i64 %38, 0
  %50 = zext i1 %49 to i8
  store i8 %50, i8* @ZF_2071_36623570, align 1, !tbaa !27
  %51 = lshr i64 %38, 63
  %52 = trunc i64 %51 to i8
  store i8 %52, i8* @SF_2073_36623570, align 1, !tbaa !28
  %53 = lshr i64 %storemerge, 63
  %54 = xor i64 %51, %53
  %55 = add nuw nsw i64 %54, %53
  %56 = icmp eq i64 %55, 2
  %57 = zext i1 %56 to i8
  store i8 %57, i8* @OF_2077_36623570, align 1, !tbaa !29
  br i1 %49, label %inst_1289, label %inst_11b1

inst_125b:                                        ; preds = %inst_11b1, %inst_1256
  %storemerge1 = phi i64 [ 1, %inst_11b1 ], [ %37, %inst_1256 ]
  store i64 %storemerge1, i64* %116, align 8
  store i64 %storemerge1, i64* @RAX_2216_366235b8, align 8, !tbaa !8
  %58 = load i64, i64* %61, align 8
  %59 = icmp ugt i64 %58, %storemerge1
  br i1 %59, label %inst_11c6, label %inst_1269

inst_11a4:                                        ; preds = %inst_1189
  store i64 %9, i64* @RAX_2216_366235b8, align 8, !tbaa !8
  %60 = add i64 %2, -32
  %61 = inttoptr i64 %60 to i64*
  br label %inst_1278

inst_11f4:                                        ; preds = %inst_11c6
  %62 = add i64 %2, -36
  %63 = inttoptr i64 %62 to i32*
  store i32 %85, i32* %63, align 4
  %64 = load i64, i64* %116, align 8
  %65 = shl i64 %64, 2
  %66 = load i64, i64* %7, align 8
  %67 = add i64 %65, %66
  %68 = add i64 %65, -4
  store i64 %68, i64* @RCX_2248_366235b8, align 8, !tbaa !8
  %69 = add i64 %68, %66
  %70 = inttoptr i64 %67 to i32*
  %71 = load i32, i32* %70, align 4
  %72 = inttoptr i64 %69 to i32*
  store i32 %71, i32* %72, align 4
  %73 = load i64, i64* %116, align 8
  %74 = shl i64 %73, 2
  %75 = load i64, i64* %7, align 8
  %76 = add i64 %75, %74
  store i64 %76, i64* @RDX_2264_366235b8, align 8, !tbaa !8
  %77 = load i32, i32* %63, align 4
  %78 = inttoptr i64 %76 to i32*
  store i32 %77, i32* %78, align 4
  %79 = load i64, i64* %116, align 8
  store i64 %79, i64* %114, align 8
  br label %inst_1256

inst_11c6:                                        ; preds = %inst_125b
  %80 = shl i64 %storemerge1, 2
  %81 = add i64 %80, -4
  %82 = load i64, i64* %7, align 8
  %83 = add i64 %81, %82
  %84 = inttoptr i64 %83 to i32*
  %85 = load i32, i32* %84, align 4
  %86 = zext i32 %85 to i64
  store i64 %86, i64* @RDX_2264_366235b8, align 8, !tbaa !8
  store i64 %80, i64* @RCX_2248_366235b8, align 8, !tbaa !8
  %87 = add i64 %80, %82
  %88 = inttoptr i64 %87 to i32*
  %89 = load i32, i32* %88, align 4
  %90 = sub i32 %85, %89
  %91 = icmp eq i32 %90, 0
  %92 = lshr i32 %90, 31
  %93 = lshr i32 %85, 31
  %94 = lshr i32 %89, 31
  %95 = xor i32 %94, %93
  %96 = xor i32 %92, %93
  %97 = add nuw nsw i32 %96, %95
  %98 = icmp eq i32 %97, 2
  %99 = icmp slt i32 %90, 0
  %100 = xor i1 %99, %98
  %101 = or i1 %91, %100
  br i1 %101, label %inst_1256, label %inst_11f4

inst_1269:                                        ; preds = %inst_125b
  %102 = load i64, i64* %114, align 8
  store i8 0, i8* @CF_2065_36623570, align 1, !tbaa !10
  %103 = trunc i64 %102 to i32
  %104 = and i32 %103, 255
  %105 = call i32 @llvm.ctpop.i32(i32 %104) #2, !range !24
  %106 = trunc i32 %105 to i8
  %107 = and i8 %106, 1
  %108 = xor i8 %107, 1
  store i8 %108, i8* @PF_2067_36623570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_36623570, align 1, !tbaa !26
  %109 = icmp eq i64 %102, 0
  %110 = zext i1 %109 to i8
  store i8 %110, i8* @ZF_2071_36623570, align 1, !tbaa !27
  %111 = lshr i64 %102, 63
  %112 = trunc i64 %111 to i8
  store i8 %112, i8* @SF_2073_36623570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_36623570, align 1, !tbaa !29
  br i1 %109, label %inst_1289, label %inst_1270

inst_1270:                                        ; preds = %inst_1269
  store i64 %102, i64* @RAX_2216_366235b8, align 8, !tbaa !8
  br label %inst_1278

inst_11b1:                                        ; preds = %inst_1278
  %113 = add i64 %2, -24
  %114 = inttoptr i64 %113 to i64*
  store i64 0, i64* %114, align 8
  %115 = add i64 %2, -16
  %116 = inttoptr i64 %115 to i64*
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
