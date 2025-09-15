; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/mcsema/ll/O0/dijkstra_modular_function2.ll'
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

@RSP_2312_4145c678 = external global i64
@OF_2077_4145c630 = external global i8
@SF_2073_4145c630 = external global i8
@ZF_2071_4145c630 = external global i8
@AF_2069_4145c630 = external global i8
@PF_2067_4145c630 = external global i8
@CF_2065_4145c630 = external global i8
@RAX_2216_4145c678 = external global i64
@RSP_2312_41463c00 = external global i64*
@RCX_2248_4145c678 = external global i64
@RDI_2296_4145c678 = external global i64
@RBP_2328_4145c678 = external global i64
@RSI_2280_4145c660 = external global i32
@RDX_2264_4145c678 = external global i64
@RCX_2248_4145c660 = external global i32
@RDX_2264_4145c660 = external global i32
@R8_2344_4145c660 = external global i32

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_4011b0_add_edge(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_4011b0:
  %0 = load i64, i64* @RBP_2328_4145c678, align 8
  %1 = load i64*, i64** @RSP_2312_41463c00, align 8
  %2 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %3 = add i64 %2, -8
  %4 = getelementptr i64, i64* %1, i64 -1
  store i64 %0, i64* %4, align 8
  store i64 %3, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %5 = add i64 %2, -16
  %6 = load i64, i64* @RDI_2296_4145c678, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = add i64 %2, -20
  %9 = load i32, i32* @RSI_2280_4145c660, align 4
  %10 = inttoptr i64 %8 to i32*
  store i32 %9, i32* %10, align 4
  %11 = add i64 %2, -24
  %12 = load i32, i32* @RDX_2264_4145c660, align 4
  %13 = inttoptr i64 %11 to i32*
  store i32 %12, i32* %13, align 4
  %14 = add i64 %2, -28
  %15 = load i32, i32* @RCX_2248_4145c660, align 4
  %16 = inttoptr i64 %14 to i32*
  store i32 %15, i32* %16, align 4
  %17 = add i64 %2, -32
  %18 = load i32, i32* @R8_2344_4145c660, align 4
  %19 = inttoptr i64 %17 to i32*
  store i32 %18, i32* %19, align 4
  %20 = load i32, i32* %10, align 4
  store i8 0, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %21 = and i32 %20, 255
  %22 = call i32 @llvm.ctpop.i32(i32 %21) #2, !range !24
  %23 = trunc i32 %22 to i8
  %24 = and i8 %23, 1
  %25 = xor i8 %24, 1
  store i8 %25, i8* @PF_2067_4145c630, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %26 = icmp eq i32 %20, 0
  %27 = zext i1 %26 to i8
  store i8 %27, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %28 = lshr i32 %20, 31
  %29 = trunc i32 %28 to i8
  store i8 %29, i8* @SF_2073_4145c630, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %.not = icmp sgt i32 %20, -1
  br i1 %.not, label %inst_4011cf, label %inst_401220

inst_401220:                                      ; preds = %inst_401204, %inst_4011de, %inst_4011cf, %inst_4011b0
  %30 = load i64, i64* %4, align 8
  store i64 %30, i64* @RBP_2328_4145c678, align 8, !tbaa !8
  %31 = add i64 %2, 8
  store i64 %31, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  ret %struct.Memory* %memory

inst_4011cf:                                      ; preds = %inst_4011b0
  %32 = load i32, i32* %13, align 4
  store i8 0, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %33 = and i32 %32, 255
  %34 = call i32 @llvm.ctpop.i32(i32 %33) #2, !range !24
  %35 = trunc i32 %34 to i8
  %36 = and i8 %35, 1
  %37 = xor i8 %36, 1
  store i8 %37, i8* @PF_2067_4145c630, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %38 = icmp eq i32 %32, 0
  %39 = zext i1 %38 to i8
  store i8 %39, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %40 = lshr i32 %32, 31
  %41 = trunc i32 %40 to i8
  store i8 %41, i8* @SF_2073_4145c630, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %42 = icmp sgt i32 %32, -1
  br i1 %42, label %inst_4011de, label %inst_401220

inst_4011de:                                      ; preds = %inst_4011cf
  %43 = load i32, i32* %16, align 4
  %44 = zext i32 %43 to i64
  store i64 %44, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  %45 = load i64, i64* %7, align 8
  %46 = sext i32 %20 to i64
  %47 = mul nsw i64 %46, 400
  %48 = add i64 %47, %45
  store i64 %48, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  %49 = sext i32 %32 to i64
  store i64 %49, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  %50 = shl nsw i64 %49, 2
  %51 = add i64 %50, %48
  %52 = inttoptr i64 %51 to i32*
  store i32 %43, i32* %52, align 4
  %53 = load i32, i32* %19, align 4
  store i8 0, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %54 = and i32 %53, 255
  %55 = call i32 @llvm.ctpop.i32(i32 %54) #2, !range !24
  %56 = trunc i32 %55 to i8
  %57 = and i8 %56, 1
  %58 = xor i8 %57, 1
  store i8 %58, i8* @PF_2067_4145c630, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %59 = icmp eq i32 %53, 0
  %60 = zext i1 %59 to i8
  store i8 %60, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %61 = lshr i32 %53, 31
  %62 = trunc i32 %61 to i8
  store i8 %62, i8* @SF_2073_4145c630, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_4145c630, align 1, !tbaa !29
  br i1 %59, label %inst_401220, label %inst_401204

inst_401204:                                      ; preds = %inst_4011de
  %63 = load i32, i32* %16, align 4
  %64 = zext i32 %63 to i64
  store i64 %64, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  %65 = load i64, i64* %7, align 8
  %66 = load i32, i32* %13, align 4
  %67 = sext i32 %66 to i64
  %68 = mul nsw i64 %67, 400
  %69 = add i64 %68, %65
  store i64 %69, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  %70 = icmp ult i64 %69, %65
  %71 = icmp ult i64 %69, %68
  %72 = or i1 %70, %71
  %73 = zext i1 %72 to i8
  store i8 %73, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %74 = trunc i64 %69 to i32
  %75 = and i32 %74, 255
  %76 = call i32 @llvm.ctpop.i32(i32 %75) #2, !range !24
  %77 = trunc i32 %76 to i8
  %78 = and i8 %77, 1
  %79 = xor i8 %78, 1
  store i8 %79, i8* @PF_2067_4145c630, align 1, !tbaa !25
  %80 = xor i64 %68, %65
  %81 = xor i64 %80, %69
  %82 = trunc i64 %81 to i8
  %83 = lshr i8 %82, 4
  %84 = and i8 %83, 1
  store i8 %84, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %85 = icmp eq i64 %69, 0
  %86 = zext i1 %85 to i8
  store i8 %86, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %87 = lshr i64 %69, 63
  %88 = trunc i64 %87 to i8
  store i8 %88, i8* @SF_2073_4145c630, align 1, !tbaa !28
  %89 = lshr i64 %65, 63
  %90 = lshr i64 %68, 63
  %91 = xor i64 %87, %89
  %92 = xor i64 %87, %90
  %93 = add nuw nsw i64 %91, %92
  %94 = icmp eq i64 %93, 2
  %95 = zext i1 %94 to i8
  store i8 %95, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %96 = load i32, i32* %10, align 4
  %97 = sext i32 %96 to i64
  store i64 %97, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  %98 = shl nsw i64 %97, 2
  %99 = add i64 %98, %69
  %100 = inttoptr i64 %99 to i32*
  store i32 %63, i32* %100, align 4
  br label %inst_401220
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
