; ModuleID = 'dijkstra_modular.ll'
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
  %4 = sub i64 %2, 464
  %5 = sub i64 %2, 8
  %6 = load i64, i64* @RDI_2296_4145c678, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = sub i64 %2, 12
  %9 = load i32, i32* @RSI_2280_4145c660, align 4
  %10 = inttoptr i64 %8 to i32*
  store i32 %9, i32* %10, align 4
  %11 = sub i64 %2, 16
  %12 = load i32, i32* @RDX_2264_4145c660, align 4
  %13 = inttoptr i64 %11 to i32*
  store i32 %12, i32* %13, align 4
  %14 = sub i64 %2, 24
  %15 = load i64, i64* @RCX_2248_4145c678, align 8
  %16 = inttoptr i64 %14 to i64*
  store i64 %15, i64* %16, align 8
  %17 = sub i64 %2, 432
  store i64 %17, i64* @RDI_2296_4145c678, align 8, !tbaa !8
  store i64 0, i64* @RSI_2280_4145c678, align 8, !tbaa !8
  store i8 0, i8* @CF_2065_4145c630, align 1, !tbaa !10
  store i8 1, i8* @PF_2067_4145c630, align 1, !tbaa !24
  store i8 1, i8* @ZF_2071_4145c630, align 1, !tbaa !25
  store i8 0, i8* @SF_2073_4145c630, align 1, !tbaa !26
  store i8 0, i8* @OF_2077_4145c630, align 1, !tbaa !27
  store i8 0, i8* @AF_2069_4145c630, align 1, !tbaa !28
  store i64 400, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  %18 = add i64 %4, -8
  %19 = inttoptr i64 %18 to i64*
  store i64 ptrtoint (i8* @data_40147c to i64), i64* %19, align 8
  store i64 %18, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %20 = call %struct.Memory* @ext_404068_memset(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  %21 = load i64, i64* @RBP_2328_4145c678, align 8
  %22 = sub i64 %21, 436
  %23 = inttoptr i64 %22 to i32*
  store i32 0, i32* %23, align 4
  br label %inst_401486

inst_401486:                                      ; preds = %inst_401495, %inst_401450
  %24 = load i32, i32* %23, align 4
  %25 = sub i64 %21, 12
  %26 = inttoptr i64 %25 to i32*
  %27 = load i32, i32* %26, align 4
  %28 = sub i32 %24, %27
  %29 = lshr i32 %28, 31
  %30 = trunc i32 %29 to i8
  %31 = lshr i32 %24, 31
  %32 = lshr i32 %27, 31
  %33 = xor i32 %32, %31
  %34 = xor i32 %29, %31
  %35 = add nuw nsw i32 %34, %33
  %36 = icmp eq i32 %35, 2
  %37 = icmp eq i8 %30, 0
  %38 = xor i1 %37, %36
  %39 = sub i64 %21, 24
  %40 = inttoptr i64 %39 to i64*
  %41 = load i64, i64* %40, align 8
  br i1 %38, label %inst_4014bb, label %inst_401495

inst_401629:                                      ; preds = %inst_4014e8, %inst_4014d4
  %42 = phi %struct.Memory* [ %89, %inst_4014d4 ], [ %152, %inst_4014e8 ]
  %43 = load i64*, i64** @RSP_2312_41463c00, align 8
  %44 = load i64, i64* @RSP_2312_4145c678, align 8
  %45 = add i64 464, %44
  %46 = icmp ult i64 %45, %44
  %47 = icmp ult i64 %45, 464
  %48 = or i1 %46, %47
  %49 = zext i1 %48 to i8
  store i8 %49, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %50 = trunc i64 %45 to i32
  %51 = and i32 %50, 255
  %52 = call i32 @llvm.ctpop.i32(i32 %51) #3, !range !29
  %53 = trunc i32 %52 to i8
  %54 = and i8 %53, 1
  %55 = xor i8 %54, 1
  store i8 %55, i8* @PF_2067_4145c630, align 1, !tbaa !24
  %56 = xor i64 464, %44
  %57 = xor i64 %56, %45
  %58 = lshr i64 %57, 4
  %59 = trunc i64 %58 to i8
  %60 = and i8 %59, 1
  store i8 %60, i8* @AF_2069_4145c630, align 1, !tbaa !28
  %61 = icmp eq i64 %45, 0
  %62 = zext i1 %61 to i8
  store i8 %62, i8* @ZF_2071_4145c630, align 1, !tbaa !25
  %63 = lshr i64 %45, 63
  %64 = trunc i64 %63 to i8
  store i8 %64, i8* @SF_2073_4145c630, align 1, !tbaa !26
  %65 = lshr i64 %44, 63
  %66 = xor i64 %63, %65
  %67 = add nuw nsw i64 %66, %63
  %68 = icmp eq i64 %67, 2
  %69 = zext i1 %68 to i8
  store i8 %69, i8* @OF_2077_4145c630, align 1, !tbaa !27
  %70 = add i64 %45, 8
  %71 = getelementptr i64, i64* %43, i32 58
  %72 = load i64, i64* %71, align 8
  store i64 %72, i64* @RBP_2328_4145c678, align 8, !tbaa !8
  %73 = add i64 %70, 8
  store i64 %73, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  ret %struct.Memory* %42

inst_40152f:                                      ; preds = %inst_401513, %inst_4015f7
  %74 = load i32, i32* %167, align 4
  %75 = sub i64 %153, 12
  %76 = inttoptr i64 %75 to i32*
  %77 = load i32, i32* %76, align 4
  %78 = sub i32 %74, %77
  %79 = lshr i32 %78, 31
  %80 = trunc i32 %79 to i8
  %81 = lshr i32 %74, 31
  %82 = lshr i32 %77, 31
  %83 = xor i32 %82, %81
  %84 = xor i32 %79, %81
  %85 = add nuw nsw i32 %84, %83
  %86 = icmp eq i32 %85, 2
  %87 = icmp eq i8 %80, 0
  %88 = xor i1 %87, %86
  br i1 %88, label %inst_401610, label %inst_40153e

inst_4014d4:                                      ; preds = %inst_401610, %inst_4014bb
  %89 = phi %struct.Memory* [ %20, %inst_4014bb ], [ %152, %inst_401610 ]
  %90 = load i64, i64* @RBP_2328_4145c678, align 8
  %91 = sub i64 %90, 440
  %92 = inttoptr i64 %91 to i32*
  %93 = load i32, i32* %92, align 4
  %94 = zext i32 %93 to i64
  store i64 %94, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  %95 = sub i64 %90, 12
  %96 = inttoptr i64 %95 to i32*
  %97 = load i32, i32* %96, align 4
  %98 = sub i32 %97, 1
  %99 = zext i32 %98 to i64
  store i64 %99, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  %100 = sub i32 %93, %98
  %101 = icmp ult i32 %93, %98
  %102 = zext i1 %101 to i8
  store i8 %102, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %103 = and i32 %100, 255
  %104 = call i32 @llvm.ctpop.i32(i32 %103) #3, !range !29
  %105 = trunc i32 %104 to i8
  %106 = and i8 %105, 1
  %107 = xor i8 %106, 1
  store i8 %107, i8* @PF_2067_4145c630, align 1, !tbaa !24
  %108 = xor i64 %99, %94
  %109 = trunc i64 %108 to i32
  %110 = xor i32 %100, %109
  %111 = lshr i32 %110, 4
  %112 = trunc i32 %111 to i8
  %113 = and i8 %112, 1
  store i8 %113, i8* @AF_2069_4145c630, align 1, !tbaa !28
  %114 = icmp eq i32 %100, 0
  %115 = zext i1 %114 to i8
  store i8 %115, i8* @ZF_2071_4145c630, align 1, !tbaa !25
  %116 = lshr i32 %100, 31
  %117 = trunc i32 %116 to i8
  store i8 %117, i8* @SF_2073_4145c630, align 1, !tbaa !26
  %118 = lshr i32 %93, 31
  %119 = lshr i32 %98, 31
  %120 = xor i32 %119, %118
  %121 = xor i32 %116, %118
  %122 = add nuw nsw i32 %121, %120
  %123 = icmp eq i32 %122, 2
  %124 = zext i1 %123 to i8
  store i8 %124, i8* @OF_2077_4145c630, align 1, !tbaa !27
  %125 = icmp eq i8 %117, 0
  %126 = xor i1 %125, %123
  br i1 %126, label %inst_401629, label %inst_4014e8

inst_4015f7:                                      ; preds = %inst_4015de, %inst_401591, %inst_401579, %inst_401564, %inst_40153e
  %127 = load i32, i32* %167, align 4
  %128 = add i32 1, %127
  store i32 %128, i32* %167, align 4
  br label %inst_40152f

inst_4014bb:                                      ; preds = %inst_401486
  %129 = sub i64 %21, 16
  %130 = inttoptr i64 %129 to i32*
  %131 = load i32, i32* %130, align 4
  %132 = sext i32 %131 to i64
  %133 = mul i64 %132, 4
  %134 = add i64 %133, %41
  %135 = inttoptr i64 %134 to i32*
  store i32 0, i32* %135, align 4
  %136 = sub i64 %21, 440
  %137 = inttoptr i64 %136 to i32*
  store i32 0, i32* %137, align 4
  br label %inst_4014d4

inst_401495:                                      ; preds = %inst_401486
  %138 = sext i32 %24 to i64
  %139 = mul i64 %138, 4
  %140 = add i64 %139, %41
  %141 = inttoptr i64 %140 to i32*
  store i32 2147483647, i32* %141, align 4
  %142 = load i32, i32* %23, align 4
  %143 = add i32 1, %142
  store i32 %143, i32* %23, align 4
  br label %inst_401486

inst_4014e8:                                      ; preds = %inst_4014d4
  %144 = zext i32 %97 to i64
  %145 = sub i64 %90, 24
  %146 = inttoptr i64 %145 to i64*
  %147 = load i64, i64* %146, align 8
  store i64 %147, i64* @RDI_2296_4145c678, align 8, !tbaa !8
  %148 = sub i64 %90, 432
  store i64 %148, i64* @RSI_2280_4145c678, align 8, !tbaa !8
  store i64 %144, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  %149 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %150 = add i64 %149, -8
  %151 = inttoptr i64 %150 to i64*
  store i64 add (i64 ptrtoint (i8* @data_401486 to i64), i64 117), i64* %151, align 8
  store i64 %150, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %152 = call %struct.Memory* @sub_4013c0_min_index(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %89)
  %153 = load i64, i64* @RBP_2328_4145c678, align 8
  %154 = sub i64 %153, 444
  %155 = load i32, i32* @RAX_2216_4145c660, align 4
  %156 = inttoptr i64 %154 to i32*
  store i32 %155, i32* %156, align 4
  %157 = sub i32 %155, -1
  %158 = icmp eq i32 %157, 0
  %159 = zext i1 %158 to i8
  %160 = icmp eq i8 %159, 0
  br i1 %160, label %inst_401513, label %inst_401629

inst_401513:                                      ; preds = %inst_4014e8
  %161 = sext i32 %155 to i64
  %162 = mul i64 %161, 4
  %163 = add i64 %153, -432
  %164 = add i64 %163, %162
  %165 = inttoptr i64 %164 to i32*
  store i32 1, i32* %165, align 4
  %166 = sub i64 %153, 448
  %167 = inttoptr i64 %166 to i32*
  store i32 0, i32* %167, align 4
  br label %inst_40152f

inst_401610:                                      ; preds = %inst_40152f
  %168 = sub i64 %153, 440
  %169 = inttoptr i64 %168 to i32*
  %170 = load i32, i32* %169, align 4
  %171 = add i32 1, %170
  store i32 %171, i32* %169, align 4
  br label %inst_4014d4

inst_40153e:                                      ; preds = %inst_40152f
  %172 = sub i64 %153, 8
  %173 = inttoptr i64 %172 to i64*
  %174 = load i64, i64* %173, align 8
  %175 = load i32, i32* %156, align 4
  %176 = sext i32 %175 to i64
  %177 = zext i64 %176 to i128
  %178 = mul i128 400, %177
  %179 = trunc i128 %178 to i64
  %180 = add i64 %179, %174
  %181 = sext i32 %74 to i64
  %182 = mul i64 %181, 4
  %183 = add i64 %182, %180
  %184 = inttoptr i64 %183 to i32*
  %185 = load i32, i32* %184, align 4
  %186 = icmp eq i32 %185, 0
  br i1 %186, label %inst_4015f7, label %inst_401564

inst_401564:                                      ; preds = %inst_40153e
  %187 = add i64 %163, %182
  %188 = inttoptr i64 %187 to i32*
  %189 = load i32, i32* %188, align 4
  %190 = icmp eq i32 %189, 0
  %191 = zext i1 %190 to i8
  %192 = icmp eq i8 %191, 0
  br i1 %192, label %inst_4015f7, label %inst_401579

inst_401579:                                      ; preds = %inst_401564
  %193 = sub i64 %153, 24
  %194 = inttoptr i64 %193 to i64*
  %195 = load i64, i64* %194, align 8
  %196 = mul i64 %176, 4
  %197 = add i64 %196, %195
  %198 = inttoptr i64 %197 to i32*
  %199 = load i32, i32* %198, align 4
  %200 = sub i32 %199, 2147483647
  %201 = icmp eq i32 %200, 0
  br i1 %201, label %inst_4015f7, label %inst_401591

inst_401591:                                      ; preds = %inst_401579
  %202 = add i32 %185, %199
  %203 = sub i64 %153, 452
  %204 = inttoptr i64 %203 to i32*
  store i32 %202, i32* %204, align 4
  %205 = load i64, i64* %194, align 8
  %206 = load i32, i32* %167, align 4
  %207 = sext i32 %206 to i64
  store i64 %207, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  %208 = mul i64 %207, 4
  %209 = add i64 %208, %205
  %210 = inttoptr i64 %209 to i32*
  %211 = load i32, i32* %210, align 4
  %212 = sub i32 %202, %211
  %213 = lshr i32 %212, 31
  %214 = trunc i32 %213 to i8
  %215 = lshr i32 %202, 31
  %216 = lshr i32 %211, 31
  %217 = xor i32 %216, %215
  %218 = xor i32 %213, %215
  %219 = add nuw nsw i32 %218, %217
  %220 = icmp eq i32 %219, 2
  %221 = icmp eq i8 %214, 0
  %222 = xor i1 %221, %220
  br i1 %222, label %inst_4015f7, label %inst_4015de

inst_4015de:                                      ; preds = %inst_401591
  %223 = zext i32 %202 to i64
  store i64 %223, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  store i32 %202, i32* %210, align 4
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
