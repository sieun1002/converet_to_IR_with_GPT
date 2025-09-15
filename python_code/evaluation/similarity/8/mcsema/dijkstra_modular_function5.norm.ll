; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/mcsema/ll/O0/dijkstra_modular_function5.ll'
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

@__mcsema_reg_state = external thread_local(initialexec) global %struct.State
@data_401486 = external global i8
@data_40147c = external global i8
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
@RDX_2264_4145c660 = external global i32
@RSI_2280_4145c678 = external global i64
@RAX_2216_4145c660 = external global i32

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_401450_dijkstra(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_401450:
  %0 = load i64, i64* @RBP_2328_4145c678, align 8
  %1 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %2 = add i64 %1, -8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3, align 8
  store i64 %2, i64* @RBP_2328_4145c678, align 8, !tbaa !8
  %4 = add i64 %1, -16
  %5 = load i64, i64* @RDI_2296_4145c678, align 8
  %6 = inttoptr i64 %4 to i64*
  store i64 %5, i64* %6, align 8
  %7 = add i64 %1, -20
  %8 = load i32, i32* @RSI_2280_4145c660, align 4
  %9 = inttoptr i64 %7 to i32*
  store i32 %8, i32* %9, align 4
  %10 = add i64 %1, -24
  %11 = load i32, i32* @RDX_2264_4145c660, align 4
  %12 = inttoptr i64 %10 to i32*
  store i32 %11, i32* %12, align 4
  %13 = add i64 %1, -32
  %14 = load i64, i64* @RCX_2248_4145c678, align 8
  %15 = inttoptr i64 %13 to i64*
  store i64 %14, i64* %15, align 8
  %16 = add i64 %1, -440
  store i64 %16, i64* @RDI_2296_4145c678, align 8, !tbaa !8
  store i64 0, i64* @RSI_2280_4145c678, align 8, !tbaa !8
  store i8 0, i8* @CF_2065_4145c630, align 1, !tbaa !10
  store i8 1, i8* @PF_2067_4145c630, align 1, !tbaa !24
  store i8 1, i8* @ZF_2071_4145c630, align 1, !tbaa !25
  store i8 0, i8* @SF_2073_4145c630, align 1, !tbaa !26
  store i8 0, i8* @OF_2077_4145c630, align 1, !tbaa !27
  store i8 0, i8* @AF_2069_4145c630, align 1, !tbaa !28
  store i64 400, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  %17 = add i64 %1, -480
  %18 = inttoptr i64 %17 to i64*
  store i64 ptrtoint (i8* @data_40147c to i64), i64* %18, align 8
  store i64 %17, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %19 = call %struct.Memory* @ext_404068_memset(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  %20 = load i64, i64* @RBP_2328_4145c678, align 8
  %21 = add i64 %20, -436
  %22 = inttoptr i64 %21 to i32*
  br label %inst_401486

inst_401486:                                      ; preds = %inst_401495, %inst_401450
  %storemerge = phi i32 [ 0, %inst_401450 ], [ %134, %inst_401495 ]
  store i32 %storemerge, i32* %22, align 4
  %23 = add i64 %20, -12
  %24 = inttoptr i64 %23 to i32*
  %25 = load i32, i32* %24, align 4
  %26 = sub i32 %storemerge, %25
  %27 = lshr i32 %26, 31
  %28 = lshr i32 %storemerge, 31
  %29 = lshr i32 %25, 31
  %30 = xor i32 %29, %28
  %31 = xor i32 %27, %28
  %32 = add nuw nsw i32 %31, %30
  %33 = icmp eq i32 %32, 2
  %34 = icmp sgt i32 %26, -1
  %35 = xor i1 %34, %33
  %36 = add i64 %20, -24
  %37 = inttoptr i64 %36 to i64*
  %38 = load i64, i64* %37, align 8
  br i1 %35, label %inst_4014bb, label %inst_401495

inst_401629:                                      ; preds = %inst_4014e8, %inst_4014d4
  %39 = phi %struct.Memory* [ %81, %inst_4014d4 ], [ %143, %inst_4014e8 ]
  %40 = load i64*, i64** @RSP_2312_41463c00, align 8
  %41 = load i64, i64* @RSP_2312_4145c678, align 8
  %42 = add i64 %41, 464
  %43 = icmp ugt i64 %41, -465
  %44 = zext i1 %43 to i8
  store i8 %44, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %45 = trunc i64 %42 to i32
  %46 = and i32 %45, 255
  %47 = call i32 @llvm.ctpop.i32(i32 %46) #3, !range !29
  %48 = trunc i32 %47 to i8
  %49 = and i8 %48, 1
  %50 = xor i8 %49, 1
  store i8 %50, i8* @PF_2067_4145c630, align 1, !tbaa !24
  %51 = xor i64 %41, %42
  %52 = trunc i64 %51 to i8
  %53 = lshr i8 %52, 4
  %54 = and i8 %53, 1
  %55 = xor i8 %54, 1
  store i8 %55, i8* @AF_2069_4145c630, align 1, !tbaa !28
  %56 = icmp eq i64 %42, 0
  %57 = zext i1 %56 to i8
  store i8 %57, i8* @ZF_2071_4145c630, align 1, !tbaa !25
  %58 = lshr i64 %42, 63
  %59 = trunc i64 %58 to i8
  store i8 %59, i8* @SF_2073_4145c630, align 1, !tbaa !26
  %60 = lshr i64 %41, 63
  %61 = xor i64 %58, %60
  %62 = add nuw nsw i64 %61, %58
  %63 = icmp eq i64 %62, 2
  %64 = zext i1 %63 to i8
  store i8 %64, i8* @OF_2077_4145c630, align 1, !tbaa !27
  %65 = getelementptr i64, i64* %40, i64 58
  %66 = load i64, i64* %65, align 8
  store i64 %66, i64* @RBP_2328_4145c678, align 8, !tbaa !8
  %67 = add i64 %41, 480
  store i64 %67, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  ret %struct.Memory* %39

inst_40152f:                                      ; preds = %inst_401513, %inst_4015f7
  %storemerge1 = phi i32 [ 0, %inst_401513 ], [ %119, %inst_4015f7 ]
  store i32 %storemerge1, i32* %154, align 4
  %68 = add i64 %144, -12
  %69 = inttoptr i64 %68 to i32*
  %70 = load i32, i32* %69, align 4
  %71 = sub i32 %storemerge1, %70
  %72 = lshr i32 %71, 31
  %73 = lshr i32 %storemerge1, 31
  %74 = lshr i32 %70, 31
  %75 = xor i32 %74, %73
  %76 = xor i32 %72, %73
  %77 = add nuw nsw i32 %76, %75
  %78 = icmp eq i32 %77, 2
  %79 = icmp sgt i32 %71, -1
  %80 = xor i1 %79, %78
  br i1 %80, label %inst_401610, label %inst_40153e

inst_4014d4:                                      ; preds = %inst_401610, %inst_4014bb
  %81 = phi %struct.Memory* [ %19, %inst_4014bb ], [ %143, %inst_401610 ]
  %82 = load i64, i64* @RBP_2328_4145c678, align 8
  %83 = add i64 %82, -440
  %84 = inttoptr i64 %83 to i32*
  %85 = load i32, i32* %84, align 4
  %86 = zext i32 %85 to i64
  store i64 %86, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  %87 = add i64 %82, -12
  %88 = inttoptr i64 %87 to i32*
  %89 = load i32, i32* %88, align 4
  %90 = add i32 %89, -1
  %91 = zext i32 %90 to i64
  store i64 %91, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  %92 = sub i32 %85, %90
  %93 = icmp ult i32 %85, %90
  %94 = zext i1 %93 to i8
  store i8 %94, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %95 = and i32 %92, 255
  %96 = call i32 @llvm.ctpop.i32(i32 %95) #3, !range !29
  %97 = trunc i32 %96 to i8
  %98 = and i8 %97, 1
  %99 = xor i8 %98, 1
  store i8 %99, i8* @PF_2067_4145c630, align 1, !tbaa !24
  %100 = xor i32 %90, %85
  %101 = xor i32 %92, %100
  %102 = trunc i32 %101 to i8
  %103 = lshr i8 %102, 4
  %104 = and i8 %103, 1
  store i8 %104, i8* @AF_2069_4145c630, align 1, !tbaa !28
  %105 = icmp eq i32 %92, 0
  %106 = zext i1 %105 to i8
  store i8 %106, i8* @ZF_2071_4145c630, align 1, !tbaa !25
  %107 = lshr i32 %92, 31
  %108 = trunc i32 %107 to i8
  store i8 %108, i8* @SF_2073_4145c630, align 1, !tbaa !26
  %109 = lshr i32 %85, 31
  %110 = lshr i32 %90, 31
  %111 = xor i32 %110, %109
  %112 = xor i32 %107, %109
  %113 = add nuw nsw i32 %112, %111
  %114 = icmp eq i32 %113, 2
  %115 = zext i1 %114 to i8
  store i8 %115, i8* @OF_2077_4145c630, align 1, !tbaa !27
  %116 = icmp sgt i32 %92, -1
  %117 = xor i1 %116, %114
  br i1 %117, label %inst_401629, label %inst_4014e8

inst_4015f7:                                      ; preds = %inst_4015de, %inst_401591, %inst_401579, %inst_401564, %inst_40153e
  %118 = load i32, i32* %154, align 4
  %119 = add i32 %118, 1
  br label %inst_40152f

inst_4014bb:                                      ; preds = %inst_401486
  %120 = add i64 %20, -16
  %121 = inttoptr i64 %120 to i32*
  %122 = load i32, i32* %121, align 4
  %123 = sext i32 %122 to i64
  %124 = shl nsw i64 %123, 2
  %125 = add i64 %124, %38
  %126 = inttoptr i64 %125 to i32*
  store i32 0, i32* %126, align 4
  %127 = add i64 %20, -440
  %128 = inttoptr i64 %127 to i32*
  store i32 0, i32* %128, align 4
  br label %inst_4014d4

inst_401495:                                      ; preds = %inst_401486
  %129 = sext i32 %storemerge to i64
  %130 = shl nsw i64 %129, 2
  %131 = add i64 %130, %38
  %132 = inttoptr i64 %131 to i32*
  store i32 2147483647, i32* %132, align 4
  %133 = load i32, i32* %22, align 4
  %134 = add i32 %133, 1
  br label %inst_401486

inst_4014e8:                                      ; preds = %inst_4014d4
  %135 = zext i32 %89 to i64
  %136 = add i64 %82, -24
  %137 = inttoptr i64 %136 to i64*
  %138 = load i64, i64* %137, align 8
  store i64 %138, i64* @RDI_2296_4145c678, align 8, !tbaa !8
  %139 = add i64 %82, -432
  store i64 %139, i64* @RSI_2280_4145c678, align 8, !tbaa !8
  store i64 %135, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  %140 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %141 = add i64 %140, -8
  %142 = inttoptr i64 %141 to i64*
  store i64 add (i64 ptrtoint (i8* @data_401486 to i64), i64 117), i64* %142, align 8
  store i64 %141, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %143 = call %struct.Memory* @sub_4013c0_min_index(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %81)
  %144 = load i64, i64* @RBP_2328_4145c678, align 8
  %145 = add i64 %144, -444
  %146 = load i32, i32* @RAX_2216_4145c660, align 4
  %147 = inttoptr i64 %145 to i32*
  store i32 %146, i32* %147, align 4
  %.not = icmp eq i32 %146, -1
  br i1 %.not, label %inst_401629, label %inst_401513

inst_401513:                                      ; preds = %inst_4014e8
  %148 = sext i32 %146 to i64
  %149 = shl nsw i64 %148, 2
  %150 = add i64 %144, -432
  %151 = add i64 %150, %149
  %152 = inttoptr i64 %151 to i32*
  store i32 1, i32* %152, align 4
  %153 = add i64 %144, -448
  %154 = inttoptr i64 %153 to i32*
  br label %inst_40152f

inst_401610:                                      ; preds = %inst_40152f
  %155 = add i64 %144, -440
  %156 = inttoptr i64 %155 to i32*
  %157 = load i32, i32* %156, align 4
  %158 = add i32 %157, 1
  store i32 %158, i32* %156, align 4
  br label %inst_4014d4

inst_40153e:                                      ; preds = %inst_40152f
  %159 = add i64 %144, -8
  %160 = inttoptr i64 %159 to i64*
  %161 = load i64, i64* %160, align 8
  %162 = load i32, i32* %147, align 4
  %163 = sext i32 %162 to i64
  %164 = mul nsw i64 %163, 400
  %165 = add i64 %164, %161
  %166 = sext i32 %storemerge1 to i64
  %167 = shl nsw i64 %166, 2
  %168 = add i64 %167, %165
  %169 = inttoptr i64 %168 to i32*
  %170 = load i32, i32* %169, align 4
  %171 = icmp eq i32 %170, 0
  br i1 %171, label %inst_4015f7, label %inst_401564

inst_401564:                                      ; preds = %inst_40153e
  %172 = add i64 %150, %167
  %173 = inttoptr i64 %172 to i32*
  %174 = load i32, i32* %173, align 4
  %.not2 = icmp eq i32 %174, 0
  br i1 %.not2, label %inst_401579, label %inst_4015f7

inst_401579:                                      ; preds = %inst_401564
  %175 = add i64 %144, -24
  %176 = inttoptr i64 %175 to i64*
  %177 = load i64, i64* %176, align 8
  %178 = shl nsw i64 %163, 2
  %179 = add i64 %178, %177
  %180 = inttoptr i64 %179 to i32*
  %181 = load i32, i32* %180, align 4
  %182 = icmp eq i32 %181, 2147483647
  br i1 %182, label %inst_4015f7, label %inst_401591

inst_401591:                                      ; preds = %inst_401579
  %183 = add i32 %170, %181
  %184 = add i64 %144, -452
  %185 = inttoptr i64 %184 to i32*
  store i32 %183, i32* %185, align 4
  %186 = load i64, i64* %176, align 8
  %187 = load i32, i32* %154, align 4
  %188 = sext i32 %187 to i64
  store i64 %188, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  %189 = shl nsw i64 %188, 2
  %190 = add i64 %189, %186
  %191 = inttoptr i64 %190 to i32*
  %192 = load i32, i32* %191, align 4
  %193 = sub i32 %183, %192
  %194 = lshr i32 %193, 31
  %195 = lshr i32 %183, 31
  %196 = lshr i32 %192, 31
  %197 = xor i32 %196, %195
  %198 = xor i32 %194, %195
  %199 = add nuw nsw i32 %198, %197
  %200 = icmp eq i32 %199, 2
  %201 = icmp sgt i32 %193, -1
  %202 = xor i1 %201, %200
  br i1 %202, label %inst_4015f7, label %inst_4015de

inst_4015de:                                      ; preds = %inst_401591
  %203 = zext i32 %183 to i64
  store i64 %203, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  store i32 %183, i32* %191, align 4
  br label %inst_4015f7
}

; Function Attrs: noinline
declare hidden %struct.Memory* @sub_4013c0_min_index(%struct.State* noalias nonnull, i64, %struct.Memory* noalias) #1

; Function Attrs: noinline
declare hidden %struct.Memory* @ext_404068_memset(%struct.State*, i64, %struct.Memory*) #2

attributes #0 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #1 = { noinline "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { noinline }
attributes #3 = { nounwind }

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
!24 = !{!11, !6, i64 2067}
!25 = !{!11, !6, i64 2071}
!26 = !{!11, !6, i64 2073}
!27 = !{!11, !6, i64 2077}
!28 = !{!11, !6, i64 2069}
!29 = !{i32 0, i32 9}
