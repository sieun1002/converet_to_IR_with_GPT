; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/mcsema/ll/O0/linearsearch_function.ll'
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

@RSP_2312_d4765b8 = external global i64
@OF_2077_d476570 = external global i8
@SF_2073_d476570 = external global i8
@ZF_2071_d476570 = external global i8
@AF_2069_d476570 = external global i8
@PF_2067_d476570 = external global i8
@CF_2065_d476570 = external global i8
@RAX_2216_d4765b8 = external global i64
@RSP_2312_d47dbc0 = external global i64*
@RDI_2296_d4765b8 = external global i64
@RBP_2328_d4765b8 = external global i64
@RDX_2264_d4765b8 = external global i64
@RDX_2264_d4765a0 = external global i32
@RSI_2280_d4765a0 = external global i32

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_1189_linear_search(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_1189:
  %0 = load i32, i32* @RDX_2264_d4765a0, align 4
  %1 = load i64, i64* @RBP_2328_d4765b8, align 8
  %2 = load i64*, i64** @RSP_2312_d47dbc0, align 8
  %3 = load i64, i64* @RSP_2312_d4765b8, align 8, !tbaa !5
  %4 = add i64 %3, -8
  %5 = getelementptr i64, i64* %2, i64 -1
  store i64 %1, i64* %5, align 8
  store i64 %4, i64* @RSP_2312_d4765b8, align 8, !tbaa !8
  store i64 %4, i64* @RBP_2328_d4765b8, align 8, !tbaa !8
  %6 = add i64 %3, -32
  %7 = load i64, i64* @RDI_2296_d4765b8, align 8
  %8 = inttoptr i64 %6 to i64*
  store i64 %7, i64* %8, align 8
  %9 = add i64 %3, -36
  %10 = load i32, i32* @RSI_2280_d4765a0, align 4
  %11 = inttoptr i64 %9 to i32*
  store i32 %10, i32* %11, align 4
  %12 = add i64 %3, -40
  %13 = inttoptr i64 %12 to i32*
  store i32 %0, i32* %13, align 4
  %14 = add i64 %3, -12
  %15 = inttoptr i64 %14 to i32*
  br label %inst_11c8

inst_11c8:                                        ; preds = %inst_11c4, %inst_1189
  %storemerge = phi i32 [ 0, %inst_1189 ], [ %45, %inst_11c4 ]
  store i32 %storemerge, i32* %15, align 4
  %16 = load i32, i32* %11, align 4
  %17 = sub i32 %storemerge, %16
  %18 = icmp ult i32 %storemerge, %16
  %19 = zext i1 %18 to i8
  store i8 %19, i8* @CF_2065_d476570, align 1, !tbaa !10
  %20 = and i32 %17, 255
  %21 = call i32 @llvm.ctpop.i32(i32 %20) #2, !range !24
  %22 = trunc i32 %21 to i8
  %23 = and i8 %22, 1
  %24 = xor i8 %23, 1
  store i8 %24, i8* @PF_2067_d476570, align 1, !tbaa !25
  %25 = xor i32 %16, %storemerge
  %26 = xor i32 %25, %17
  %27 = trunc i32 %26 to i8
  %28 = lshr i8 %27, 4
  %29 = and i8 %28, 1
  store i8 %29, i8* @AF_2069_d476570, align 1, !tbaa !26
  %30 = icmp eq i32 %17, 0
  %31 = zext i1 %30 to i8
  store i8 %31, i8* @ZF_2071_d476570, align 1, !tbaa !27
  %32 = lshr i32 %17, 31
  %33 = trunc i32 %32 to i8
  store i8 %33, i8* @SF_2073_d476570, align 1, !tbaa !28
  %34 = lshr i32 %storemerge, 31
  %35 = lshr i32 %16, 31
  %36 = xor i32 %35, %34
  %37 = xor i32 %32, %34
  %38 = add nuw nsw i32 %37, %36
  %39 = icmp eq i32 %38, 2
  %40 = zext i1 %39 to i8
  store i8 %40, i8* @OF_2077_d476570, align 1, !tbaa !29
  %41 = icmp slt i32 %17, 0
  %42 = xor i1 %41, %39
  br i1 %42, label %inst_11a4, label %inst_11d5

inst_11d5:                                        ; preds = %inst_11c8, %inst_11bf
  %storemerge1 = phi i64 [ %46, %inst_11bf ], [ 4294967295, %inst_11c8 ]
  store i64 %storemerge1, i64* @RAX_2216_d4765b8, align 8, !tbaa !8
  %43 = load i64, i64* %5, align 8
  store i64 %43, i64* @RBP_2328_d4765b8, align 8, !tbaa !8
  %44 = add i64 %3, 8
  store i64 %44, i64* @RSP_2312_d4765b8, align 8, !tbaa !8
  ret %struct.Memory* %memory

inst_11c4:                                        ; preds = %inst_11a4
  %45 = add i32 %storemerge, 1
  br label %inst_11c8

inst_11bf:                                        ; preds = %inst_11a4
  %46 = zext i32 %storemerge to i64
  br label %inst_11d5

inst_11a4:                                        ; preds = %inst_11c8
  %47 = sext i32 %storemerge to i64
  %48 = shl nsw i64 %47, 2
  store i64 %48, i64* @RDX_2264_d4765b8, align 8, !tbaa !8
  %49 = load i64, i64* %8, align 8
  %50 = add i64 %48, %49
  %51 = inttoptr i64 %50 to i32*
  %52 = load i32, i32* %51, align 4
  %53 = load i32, i32* %13, align 4
  %54 = sub i32 %53, %52
  %55 = icmp ult i32 %53, %52
  %56 = zext i1 %55 to i8
  store i8 %56, i8* @CF_2065_d476570, align 1, !tbaa !10
  %57 = and i32 %54, 255
  %58 = call i32 @llvm.ctpop.i32(i32 %57) #2, !range !24
  %59 = trunc i32 %58 to i8
  %60 = and i8 %59, 1
  %61 = xor i8 %60, 1
  store i8 %61, i8* @PF_2067_d476570, align 1, !tbaa !25
  %62 = xor i32 %53, %52
  %63 = xor i32 %62, %54
  %64 = trunc i32 %63 to i8
  %65 = lshr i8 %64, 4
  %66 = and i8 %65, 1
  store i8 %66, i8* @AF_2069_d476570, align 1, !tbaa !26
  %67 = icmp eq i32 %54, 0
  %68 = zext i1 %67 to i8
  store i8 %68, i8* @ZF_2071_d476570, align 1, !tbaa !27
  %69 = lshr i32 %54, 31
  %70 = trunc i32 %69 to i8
  store i8 %70, i8* @SF_2073_d476570, align 1, !tbaa !28
  %71 = lshr i32 %53, 31
  %72 = lshr i32 %52, 31
  %73 = xor i32 %71, %72
  %74 = xor i32 %69, %71
  %75 = add nuw nsw i32 %74, %73
  %76 = icmp eq i32 %75, 2
  %77 = zext i1 %76 to i8
  store i8 %77, i8* @OF_2077_d476570, align 1, !tbaa !29
  br i1 %67, label %inst_11bf, label %inst_11c4
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
