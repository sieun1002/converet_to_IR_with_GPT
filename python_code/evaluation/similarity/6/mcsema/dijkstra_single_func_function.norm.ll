; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/mcsema/ll/O0/dijkstra_single_func_function.ll'
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
@data_40113f = external global i8
@data_402014 = external global i8
@data_402004 = external global i8
@RSP_2312_91fb638 = external global i64
@OF_2077_91fb5f0 = external global i8
@SF_2073_91fb5f0 = external global i8
@ZF_2071_91fb5f0 = external global i8
@AF_2069_91fb5f0 = external global i8
@PF_2067_91fb5f0 = external global i8
@CF_2065_91fb5f0 = external global i8
@RAX_2216_91fb638 = external global i64
@RSP_2312_9202c00 = external global i64*
@RCX_2248_91fb638 = external global i64
@RSI_2280_91fb638 = external global i64
@RDX_2264_91fb638 = external global i64
@RBP_2328_91fb638 = external global i64
@RDI_2296_9202aa0 = external global i8*
@RDI_2296_91fb638 = external global i64
@RAX_2216_91fb5f0 = external global i8
@RSI_2280_91fb620 = external global i32
@RDX_2264_91fb620 = external global i32

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_401120_dijkstra(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_401120:
  %0 = load i64, i64* @RBP_2328_91fb638, align 8
  %1 = load i64, i64* @RSP_2312_91fb638, align 8, !tbaa !5
  %2 = add i64 %1, -8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3, align 8
  store i64 %2, i64* @RBP_2328_91fb638, align 8, !tbaa !8
  %4 = add i64 %1, -856
  store i64 %4, i64* @RSP_2312_91fb638, align 8, !tbaa !8
  %5 = add i64 %1, -16
  %6 = load i64, i64* @RDI_2296_91fb638, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = add i64 %1, -20
  %9 = load i32, i32* @RSI_2280_91fb620, align 4
  %10 = inttoptr i64 %8 to i32*
  store i32 %9, i32* %10, align 4
  %11 = add i64 %1, -24
  %12 = load i32, i32* @RDX_2264_91fb620, align 4
  %13 = inttoptr i64 %11 to i32*
  store i32 %12, i32* %13, align 4
  %14 = add i64 %1, -828
  %15 = inttoptr i64 %14 to i32*
  br label %inst_40113f

inst_401388:                                      ; preds = %inst_401248, %inst_40119f
  %16 = phi i64 [ add (i64 ptrtoint (i8* @data_40113f to i64), i64 116), %inst_401248 ], [ add (i64 ptrtoint (i8* @data_40113f to i64), i64 585), %inst_40119f ]
  %17 = add i64 %1, -852
  %18 = inttoptr i64 %17 to i32*
  store i32 0, i32* %18, align 4
  br label %inst_401392

inst_401392:                                      ; preds = %inst_4013fa, %inst_401388
  %19 = phi %struct.Memory* [ %memory, %inst_401388 ], [ %88, %inst_4013fa ]
  %20 = load i64, i64* @RBP_2328_91fb638, align 8
  %21 = add i64 %20, -844
  %22 = inttoptr i64 %21 to i32*
  %23 = load i32, i32* %22, align 4
  %24 = zext i32 %23 to i64
  store i64 %24, i64* @RAX_2216_91fb638, align 8, !tbaa !8
  %25 = add i64 %20, -12
  %26 = inttoptr i64 %25 to i32*
  %27 = load i32, i32* %26, align 4
  %28 = sub i32 %23, %27
  %29 = lshr i32 %28, 31
  %30 = lshr i32 %23, 31
  %31 = lshr i32 %27, 31
  %32 = xor i32 %31, %30
  %33 = xor i32 %29, %30
  %34 = add nuw nsw i32 %33, %32
  %35 = icmp eq i32 %34, 2
  %36 = icmp sgt i32 %28, -1
  %37 = xor i1 %36, %35
  br i1 %37, label %inst_401413, label %inst_4013a1

inst_40119f:                                      ; preds = %inst_40136f, %inst_401186
  %storemerge1 = phi i32 [ 0, %inst_401186 ], [ %151, %inst_40136f ]
  store i32 %storemerge1, i32* %101, align 4
  %38 = load i32, i32* %10, align 4
  %39 = add i32 %38, -1
  %40 = zext i32 %39 to i64
  store i64 %40, i64* @RCX_2248_91fb638, align 8, !tbaa !8
  %41 = sub i32 %storemerge1, %39
  %42 = lshr i32 %41, 31
  %43 = lshr i32 %storemerge1, 31
  %44 = lshr i32 %39, 31
  %45 = xor i32 %44, %43
  %46 = xor i32 %42, %43
  %47 = add nuw nsw i32 %46, %45
  %48 = icmp eq i32 %47, 2
  %49 = icmp sgt i32 %41, -1
  %50 = xor i1 %49, %48
  br i1 %50, label %inst_401388, label %inst_4011b3

inst_40122f:                                      ; preds = %inst_40120f, %inst_4011f5, %inst_4011e0
  %51 = phi i32 [ %.pre, %inst_40120f ], [ %storemerge2, %inst_4011f5 ], [ %storemerge2, %inst_4011e0 ]
  %52 = add i32 %51, 1
  br label %inst_4011d1

inst_40113f:                                      ; preds = %inst_40114e, %inst_401120
  %storemerge = phi i32 [ 0, %inst_401120 ], [ %114, %inst_40114e ]
  store i32 %storemerge, i32* %15, align 4
  %53 = load i32, i32* %10, align 4
  %54 = sub i32 %storemerge, %53
  %55 = lshr i32 %54, 31
  %56 = lshr i32 %storemerge, 31
  %57 = lshr i32 %53, 31
  %58 = xor i32 %57, %56
  %59 = xor i32 %55, %56
  %60 = add nuw nsw i32 %59, %58
  %61 = icmp eq i32 %60, 2
  %62 = icmp sgt i32 %54, -1
  %63 = xor i1 %62, %61
  br i1 %63, label %inst_401186, label %inst_40114e

inst_4011d1:                                      ; preds = %inst_4011b3, %inst_40122f
  %storemerge2 = phi i32 [ 0, %inst_4011b3 ], [ %52, %inst_40122f ]
  store i32 %storemerge2, i32* %120, align 4
  %64 = load i32, i32* %10, align 4
  %65 = sub i32 %storemerge2, %64
  %66 = lshr i32 %65, 31
  %67 = lshr i32 %storemerge2, 31
  %68 = lshr i32 %64, 31
  %69 = xor i32 %68, %67
  %70 = xor i32 %66, %67
  %71 = add nuw nsw i32 %70, %69
  %72 = icmp eq i32 %71, 2
  %73 = icmp sgt i32 %65, -1
  %74 = xor i1 %73, %72
  br i1 %74, label %inst_401248, label %inst_4011e0

inst_401356:                                      ; preds = %inst_40131b, %inst_4012d8, %inst_4012c0, %inst_4012ab, %inst_401285
  %75 = load i32, i32* %149, align 4
  %76 = add i32 %75, 1
  br label %inst_401276

inst_401276:                                      ; preds = %inst_40125a, %inst_401356
  %storemerge4 = phi i32 [ 0, %inst_40125a ], [ %76, %inst_401356 ]
  store i32 %storemerge4, i32* %149, align 4
  %77 = load i32, i32* %10, align 4
  %78 = sub i32 %storemerge4, %77
  %79 = lshr i32 %78, 31
  %80 = lshr i32 %storemerge4, 31
  %81 = lshr i32 %77, 31
  %82 = xor i32 %81, %80
  %83 = xor i32 %79, %80
  %84 = add nuw nsw i32 %83, %82
  %85 = icmp eq i32 %84, 2
  %86 = icmp sgt i32 %78, -1
  %87 = xor i1 %86, %85
  br i1 %87, label %inst_40136f, label %inst_401285

inst_4013fa:                                      ; preds = %inst_4013b9, %inst_4013d5
  %88 = phi %struct.Memory* [ %249, %inst_4013d5 ], [ %254, %inst_4013b9 ]
  %89 = load i64, i64* @RBP_2328_91fb638, align 8
  %90 = add i64 %89, -844
  %91 = inttoptr i64 %90 to i32*
  %92 = load i32, i32* %91, align 4
  %93 = add i32 %92, 1
  store i32 %93, i32* %91, align 4
  br label %inst_401392

inst_401186:                                      ; preds = %inst_40113f
  %94 = load i32, i32* %13, align 4
  %95 = sext i32 %94 to i64
  %96 = shl nsw i64 %95, 2
  %97 = add i64 %1, -424
  %98 = add i64 %97, %96
  %99 = inttoptr i64 %98 to i32*
  store i32 0, i32* %99, align 4
  %100 = add i64 %1, -832
  %101 = inttoptr i64 %100 to i32*
  br label %inst_40119f

inst_40114e:                                      ; preds = %inst_40113f
  %102 = sext i32 %storemerge to i64
  %103 = shl nsw i64 %102, 2
  %104 = add i64 %1, -424
  %105 = add i64 %104, %103
  %106 = inttoptr i64 %105 to i32*
  store i32 2147483647, i32* %106, align 4
  %107 = load i32, i32* %15, align 4
  %108 = sext i32 %107 to i64
  %109 = shl nsw i64 %108, 2
  %110 = add i64 %1, -824
  %111 = add i64 %110, %109
  %112 = inttoptr i64 %111 to i32*
  store i32 0, i32* %112, align 4
  %113 = load i32, i32* %15, align 4
  %114 = add i32 %113, 1
  br label %inst_40113f

inst_4011b3:                                      ; preds = %inst_40119f
  %115 = add i64 %1, -836
  %116 = inttoptr i64 %115 to i32*
  store i32 -1, i32* %116, align 4
  %117 = add i64 %1, -840
  %118 = inttoptr i64 %117 to i32*
  store i32 2147483647, i32* %118, align 4
  %119 = add i64 %1, -844
  %120 = inttoptr i64 %119 to i32*
  br label %inst_4011d1

inst_401248:                                      ; preds = %inst_4011d1
  %121 = load i32, i32* %116, align 4
  %.not3 = icmp eq i32 %121, -1
  br i1 %.not3, label %inst_401388, label %inst_40125a

inst_4011e0:                                      ; preds = %inst_4011d1
  %122 = sext i32 %storemerge2 to i64
  %123 = shl nsw i64 %122, 2
  %124 = add i64 %1, -824
  %125 = add i64 %124, %123
  %126 = inttoptr i64 %125 to i32*
  %127 = load i32, i32* %126, align 4
  %.not = icmp eq i32 %127, 0
  br i1 %.not, label %inst_4011f5, label %inst_40122f

inst_4011f5:                                      ; preds = %inst_4011e0
  %128 = add i64 %97, %123
  %129 = inttoptr i64 %128 to i32*
  %130 = load i32, i32* %129, align 4
  %131 = load i32, i32* %118, align 4
  %132 = sub i32 %130, %131
  %133 = lshr i32 %132, 31
  %134 = lshr i32 %130, 31
  %135 = lshr i32 %131, 31
  %136 = xor i32 %135, %134
  %137 = xor i32 %133, %134
  %138 = add nuw nsw i32 %137, %136
  %139 = icmp eq i32 %138, 2
  %140 = icmp sgt i32 %132, -1
  %141 = xor i1 %140, %139
  br i1 %141, label %inst_40122f, label %inst_40120f

inst_40120f:                                      ; preds = %inst_4011f5
  store i32 %130, i32* %118, align 4
  %142 = load i32, i32* %120, align 4
  store i32 %142, i32* %116, align 4
  %.pre = load i32, i32* %120, align 4
  br label %inst_40122f

inst_40125a:                                      ; preds = %inst_401248
  %143 = sext i32 %121 to i64
  %144 = shl nsw i64 %143, 2
  %145 = add i64 %1, -824
  %146 = add i64 %145, %144
  %147 = inttoptr i64 %146 to i32*
  store i32 1, i32* %147, align 4
  %148 = add i64 %1, -848
  %149 = inttoptr i64 %148 to i32*
  br label %inst_401276

inst_40136f:                                      ; preds = %inst_401276
  %150 = load i32, i32* %101, align 4
  %151 = add i32 %150, 1
  br label %inst_40119f

inst_401285:                                      ; preds = %inst_401276
  %152 = load i64, i64* %7, align 8
  %153 = load i32, i32* %116, align 4
  %154 = sext i32 %153 to i64
  %155 = mul nsw i64 %154, 400
  %156 = add i64 %155, %152
  %157 = sext i32 %storemerge4 to i64
  %158 = shl nsw i64 %157, 2
  %159 = add i64 %158, %156
  %160 = inttoptr i64 %159 to i32*
  %161 = load i32, i32* %160, align 4
  %162 = icmp eq i32 %161, 0
  br i1 %162, label %inst_401356, label %inst_4012ab

inst_4012ab:                                      ; preds = %inst_401285
  %163 = add i64 %145, %158
  %164 = inttoptr i64 %163 to i32*
  %165 = load i32, i32* %164, align 4
  %.not5 = icmp eq i32 %165, 0
  br i1 %.not5, label %inst_4012c0, label %inst_401356

inst_4012c0:                                      ; preds = %inst_4012ab
  %166 = shl nsw i64 %154, 2
  %167 = add i64 %97, %166
  %168 = inttoptr i64 %167 to i32*
  %169 = load i32, i32* %168, align 4
  %170 = icmp eq i32 %169, 2147483647
  br i1 %170, label %inst_401356, label %inst_4012d8

inst_4012d8:                                      ; preds = %inst_4012c0
  %171 = add i64 %97, %158
  %172 = inttoptr i64 %171 to i32*
  %173 = load i32, i32* %172, align 4
  store i64 %156, i64* @RDX_2264_91fb638, align 8, !tbaa !8
  store i64 %157, i64* @RSI_2280_91fb638, align 8, !tbaa !8
  %174 = add i32 %161, %169
  %175 = sub i32 %173, %174
  %176 = icmp eq i32 %175, 0
  %177 = lshr i32 %175, 31
  %178 = lshr i32 %173, 31
  %179 = lshr i32 %174, 31
  %180 = xor i32 %179, %178
  %181 = xor i32 %177, %178
  %182 = add nuw nsw i32 %181, %180
  %183 = icmp eq i32 %182, 2
  %184 = icmp slt i32 %175, 0
  %185 = xor i1 %184, %183
  %186 = or i1 %176, %185
  br i1 %186, label %inst_401356, label %inst_40131b

inst_40131b:                                      ; preds = %inst_4012d8
  store i64 %157, i64* @RDX_2264_91fb638, align 8, !tbaa !8
  store i32 %174, i32* %172, align 4
  br label %inst_401356

inst_401413:                                      ; preds = %inst_401392
  %187 = load i64*, i64** @RSP_2312_9202c00, align 8
  %188 = load i64, i64* @RSP_2312_91fb638, align 8
  %189 = add i64 %188, 848
  %190 = icmp ugt i64 %188, -849
  %191 = zext i1 %190 to i8
  store i8 %191, i8* @CF_2065_91fb5f0, align 1, !tbaa !10
  %192 = trunc i64 %189 to i32
  %193 = and i32 %192, 255
  %194 = call i32 @llvm.ctpop.i32(i32 %193) #3, !range !24
  %195 = trunc i32 %194 to i8
  %196 = and i8 %195, 1
  %197 = xor i8 %196, 1
  store i8 %197, i8* @PF_2067_91fb5f0, align 1, !tbaa !25
  %198 = xor i64 %188, %189
  %199 = trunc i64 %198 to i8
  %200 = lshr i8 %199, 4
  %201 = and i8 %200, 1
  %202 = xor i8 %201, 1
  store i8 %202, i8* @AF_2069_91fb5f0, align 1, !tbaa !26
  %203 = icmp eq i64 %189, 0
  %204 = zext i1 %203 to i8
  store i8 %204, i8* @ZF_2071_91fb5f0, align 1, !tbaa !27
  %205 = lshr i64 %189, 63
  %206 = trunc i64 %205 to i8
  store i8 %206, i8* @SF_2073_91fb5f0, align 1, !tbaa !28
  %207 = lshr i64 %188, 63
  %208 = xor i64 %205, %207
  %209 = add nuw nsw i64 %208, %205
  %210 = icmp eq i64 %209, 2
  %211 = zext i1 %210 to i8
  store i8 %211, i8* @OF_2077_91fb5f0, align 1, !tbaa !29
  %212 = getelementptr i64, i64* %187, i64 106
  %213 = load i64, i64* %212, align 8
  store i64 %213, i64* @RBP_2328_91fb638, align 8, !tbaa !8
  %214 = add i64 %188, 864
  store i64 %214, i64* @RSP_2312_91fb638, align 8, !tbaa !8
  ret %struct.Memory* %19

inst_4013a1:                                      ; preds = %inst_401392
  %215 = sext i32 %23 to i64
  store i64 %215, i64* @RAX_2216_91fb638, align 8, !tbaa !8
  %216 = shl nsw i64 %215, 2
  %217 = add i64 %20, -416
  %218 = add i64 %217, %216
  %219 = inttoptr i64 %218 to i32*
  %220 = load i32, i32* %219, align 4
  %221 = add i32 %220, -2147483647
  %222 = icmp ult i32 %220, 2147483647
  %223 = zext i1 %222 to i8
  store i8 %223, i8* @CF_2065_91fb5f0, align 1, !tbaa !10
  %224 = and i32 %221, 255
  %225 = call i32 @llvm.ctpop.i32(i32 %224) #3, !range !24
  %226 = trunc i32 %225 to i8
  %227 = and i8 %226, 1
  %228 = xor i8 %227, 1
  store i8 %228, i8* @PF_2067_91fb5f0, align 1, !tbaa !25
  %229 = xor i32 %220, %221
  %230 = trunc i32 %229 to i8
  %231 = lshr i8 %230, 4
  %232 = and i8 %231, 1
  %233 = xor i8 %232, 1
  store i8 %233, i8* @AF_2069_91fb5f0, align 1, !tbaa !26
  %234 = icmp eq i32 %221, 0
  %235 = zext i1 %234 to i8
  store i8 %235, i8* @ZF_2071_91fb5f0, align 1, !tbaa !27
  %236 = lshr i32 %221, 31
  %237 = trunc i32 %236 to i8
  store i8 %237, i8* @SF_2073_91fb5f0, align 1, !tbaa !28
  %238 = lshr i32 %220, 31
  %239 = xor i32 %236, %238
  %240 = add nuw nsw i32 %239, %238
  %241 = icmp eq i32 %240, 2
  %242 = zext i1 %241 to i8
  store i8 %242, i8* @OF_2077_91fb5f0, align 1, !tbaa !29
  %.v = select i1 %234, i64 49, i64 77
  %243 = add i64 %16, %.v
  store i64 %24, i64* @RSI_2280_91fb638, align 8, !tbaa !8
  br i1 %234, label %inst_4013b9, label %inst_4013d5

inst_4013d5:                                      ; preds = %inst_4013a1
  store i64 %215, i64* @RAX_2216_91fb638, align 8, !tbaa !8
  %244 = zext i32 %220 to i64
  store i64 %244, i64* @RDX_2264_91fb638, align 8, !tbaa !8
  store i8* @data_402014, i8** @RDI_2296_9202aa0, align 8
  store i8 0, i8* @RAX_2216_91fb5f0, align 1, !tbaa !5
  %245 = add i64 %243, 37
  %246 = load i64, i64* @RSP_2312_91fb638, align 8, !tbaa !5
  %247 = add i64 %246, -8
  %248 = inttoptr i64 %247 to i64*
  store i64 %245, i64* %248, align 8
  store i64 %247, i64* @RSP_2312_91fb638, align 8, !tbaa !8
  %249 = call %struct.Memory* @ext_404040_printf(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %19)
  br label %inst_4013fa

inst_4013b9:                                      ; preds = %inst_4013a1
  store i8* @data_402004, i8** @RDI_2296_9202aa0, align 8
  store i8 0, i8* @RAX_2216_91fb5f0, align 1, !tbaa !5
  %250 = add i64 %243, 23
  %251 = load i64, i64* @RSP_2312_91fb638, align 8, !tbaa !5
  %252 = add i64 %251, -8
  %253 = inttoptr i64 %252 to i64*
  store i64 %250, i64* %253, align 8
  store i64 %252, i64* @RSP_2312_91fb638, align 8, !tbaa !8
  %254 = call %struct.Memory* @ext_404040_printf(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %19)
  br label %inst_4013fa
}

; Function Attrs: noinline
declare hidden %struct.Memory* @ext_404040_printf(%struct.State*, i64, %struct.Memory*) #2

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
!24 = !{i32 0, i32 9}
!25 = !{!11, !6, i64 2067}
!26 = !{!11, !6, i64 2069}
!27 = !{!11, !6, i64 2071}
!28 = !{!11, !6, i64 2073}
!29 = !{!11, !6, i64 2077}
