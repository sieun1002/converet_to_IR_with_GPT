; ModuleID = 'heapsort.ll'
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

@RSP_2312_2172d5b8 = external global i64
@OF_2077_2172d570 = external global i8
@SF_2073_2172d570 = external global i8
@ZF_2071_2172d570 = external global i8
@AF_2069_2172d570 = external global i8
@PF_2067_2172d570 = external global i8
@CF_2065_2172d570 = external global i8
@RAX_2216_2172d5b8 = external global i64
@RSP_2312_21734bc0 = external global i64*
@RDI_2296_2172d5b8 = external global i64
@RBP_2328_2172d5b8 = external global i64
@RCX_2248_2172d5b8 = external global i64
@RSI_2280_2172d5b8 = external global i64
@RDX_2264_2172d5b8 = external global i64

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_1189_heap_sort(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_1189:
  %0 = load i64, i64* @RBP_2328_2172d5b8, align 8
  %1 = load i64*, i64** @RSP_2312_21734bc0, align 8
  %2 = load i64, i64* @RSP_2312_2172d5b8, align 8, !tbaa !5
  %3 = add i64 %2, -8
  %4 = getelementptr i64, i64* %1, i32 -1
  store i64 %0, i64* %4, align 8
  store i64 %3, i64* @RSP_2312_2172d5b8, align 8, !tbaa !8
  store i64 %3, i64* @RBP_2328_2172d5b8, align 8, !tbaa !8
  %5 = sub i64 %3, 104
  %6 = load i64, i64* @RDI_2296_2172d5b8, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = sub i64 %3, 112
  %9 = load i64, i64* @RSI_2280_2172d5b8, align 8
  %10 = inttoptr i64 %8 to i64*
  store i64 %9, i64* %10, align 8
  %11 = sub i64 %9, 1
  %12 = icmp ult i64 %9, 1
  %13 = zext i1 %12 to i8
  store i8 %13, i8* @CF_2065_2172d570, align 1, !tbaa !10
  %14 = trunc i64 %11 to i32
  %15 = and i32 %14, 255
  %16 = call i32 @llvm.ctpop.i32(i32 %15) #2, !range !24
  %17 = trunc i32 %16 to i8
  %18 = and i8 %17, 1
  %19 = xor i8 %18, 1
  store i8 %19, i8* @PF_2067_2172d570, align 1, !tbaa !25
  %20 = xor i64 %9, 1
  %21 = xor i64 %20, %11
  %22 = lshr i64 %21, 4
  %23 = trunc i64 %22 to i8
  %24 = and i8 %23, 1
  store i8 %24, i8* @AF_2069_2172d570, align 1, !tbaa !26
  %25 = icmp eq i64 %11, 0
  %26 = zext i1 %25 to i8
  store i8 %26, i8* @ZF_2071_2172d570, align 1, !tbaa !27
  %27 = lshr i64 %11, 63
  %28 = trunc i64 %27 to i8
  store i8 %28, i8* @SF_2073_2172d570, align 1, !tbaa !28
  %29 = lshr i64 %9, 63
  %30 = xor i64 %27, %29
  %31 = add nuw nsw i64 %30, %29
  %32 = icmp eq i64 %31, 2
  %33 = zext i1 %32 to i8
  store i8 %33, i8* @OF_2077_2172d570, align 1, !tbaa !29
  %34 = or i8 %26, %13
  %35 = icmp ne i8 %34, 0
  br i1 %35, label %inst_1449, label %inst_11a4

inst_1395:                                        ; preds = %inst_1361, %inst_134b
  %36 = load i64, i64* %93, align 8
  store i64 %36, i64* @RAX_2216_2172d5b8, align 8, !tbaa !8
  br label %inst_1399

inst_1399:                                        ; preds = %inst_138f, %inst_1395
  %37 = sub i64 %3, 32
  %38 = load i64, i64* @RAX_2216_2172d5b8, align 8
  %39 = inttoptr i64 %37 to i64*
  store i64 %38, i64* %39, align 8
  %40 = load i64, i64* %255, align 8
  %41 = mul i64 %40, 4
  %42 = load i64, i64* %7, align 8
  %43 = add i64 %41, %42
  %44 = inttoptr i64 %43 to i32*
  %45 = load i32, i32* %44, align 4
  %46 = zext i32 %45 to i64
  store i64 %46, i64* @RDX_2264_2172d5b8, align 8, !tbaa !8
  %47 = load i64, i64* %39, align 8
  %48 = mul i64 %47, 4
  store i64 %48, i64* @RCX_2248_2172d5b8, align 8, !tbaa !8
  %49 = add i64 %48, %42
  %50 = inttoptr i64 %49 to i32*
  %51 = load i32, i32* %50, align 4
  %52 = zext i32 %51 to i64
  store i64 %52, i64* @RAX_2216_2172d5b8, align 8, !tbaa !8
  %53 = sub i32 %45, %51
  %54 = lshr i32 %53, 31
  %55 = trunc i32 %54 to i8
  %56 = lshr i32 %45, 31
  %57 = lshr i32 %51, 31
  %58 = xor i32 %57, %56
  %59 = xor i32 %54, %56
  %60 = add nuw nsw i32 %59, %58
  %61 = icmp eq i32 %60, 2
  %62 = icmp eq i8 %55, 0
  %63 = xor i1 %62, %61
  br i1 %63, label %inst_1436, label %inst_13cb

inst_1223:                                        ; preds = %inst_11ef, %inst_11d9
  %64 = load i64, i64* %116, align 8
  store i64 %64, i64* @RAX_2216_2172d5b8, align 8, !tbaa !8
  br label %inst_1227

inst_1227:                                        ; preds = %inst_121d, %inst_1223
  %65 = sub i64 %3, 8
  %66 = load i64, i64* @RAX_2216_2172d5b8, align 8
  %67 = inttoptr i64 %65 to i64*
  store i64 %66, i64* %67, align 8
  %68 = load i64, i64* %182, align 8
  %69 = mul i64 %68, 4
  %70 = load i64, i64* %7, align 8
  %71 = add i64 %69, %70
  %72 = inttoptr i64 %71 to i32*
  %73 = load i32, i32* %72, align 4
  %74 = mul i64 %66, 4
  store i64 %74, i64* @RCX_2248_2172d5b8, align 8, !tbaa !8
  %75 = add i64 %74, %70
  %76 = inttoptr i64 %75 to i32*
  %77 = load i32, i32* %76, align 4
  %78 = sub i32 %73, %77
  %79 = lshr i32 %78, 31
  %80 = trunc i32 %79 to i8
  %81 = lshr i32 %73, 31
  %82 = lshr i32 %77, 31
  %83 = xor i32 %82, %81
  %84 = xor i32 %79, %81
  %85 = add nuw nsw i32 %84, %83
  %86 = icmp eq i32 %85, 2
  %87 = icmp eq i8 %80, 0
  %88 = xor i1 %87, %86
  br i1 %88, label %inst_12c4, label %inst_1259

inst_132e:                                        ; preds = %inst_12ea, %inst_13cb
  %89 = load i64, i64* %255, align 8
  %90 = add i64 %89, %89
  %91 = add i64 1, %90
  %92 = sub i64 %3, 48
  %93 = inttoptr i64 %92 to i64*
  store i64 %91, i64* %93, align 8
  store i64 %91, i64* @RAX_2216_2172d5b8, align 8, !tbaa !8
  %94 = load i64, i64* %186, align 8
  %95 = icmp ugt i64 %94, %91
  %96 = zext i1 %95 to i8
  %97 = icmp eq i8 %96, 0
  br i1 %97, label %inst_1436, label %inst_134b

inst_1436:                                        ; preds = %inst_132e, %inst_1399
  %98 = load i64, i64* %186, align 8
  %99 = sub i64 %98, 1
  store i64 %99, i64* %186, align 8
  br label %inst_143b

inst_143b:                                        ; preds = %inst_12d9, %inst_1436
  %100 = load i64, i64* %186, align 8
  store i8 0, i8* @CF_2065_2172d570, align 1, !tbaa !10
  %101 = trunc i64 %100 to i32
  %102 = and i32 %101, 255
  %103 = call i32 @llvm.ctpop.i32(i32 %102) #2, !range !24
  %104 = trunc i32 %103 to i8
  %105 = and i8 %104, 1
  %106 = xor i8 %105, 1
  store i8 %106, i8* @PF_2067_2172d570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_2172d570, align 1, !tbaa !26
  %107 = icmp eq i64 %100, 0
  %108 = zext i1 %107 to i8
  store i8 %108, i8* @ZF_2071_2172d570, align 1, !tbaa !27
  %109 = lshr i64 %100, 63
  %110 = trunc i64 %109 to i8
  store i8 %110, i8* @SF_2073_2172d570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_2172d570, align 1, !tbaa !29
  %111 = icmp eq i8 %108, 0
  br i1 %111, label %inst_12ea, label %inst_1449

inst_11bc:                                        ; preds = %inst_11b4, %inst_1259
  %112 = load i64, i64* %182, align 8
  %113 = add i64 %112, %112
  %114 = add i64 1, %113
  %115 = sub i64 %3, 24
  %116 = inttoptr i64 %115 to i64*
  store i64 %114, i64* %116, align 8
  %117 = load i64, i64* %10, align 8
  %118 = icmp ugt i64 %117, %114
  %119 = zext i1 %118 to i8
  %120 = icmp eq i8 %119, 0
  br i1 %120, label %inst_12c4, label %inst_11d9

inst_12c4:                                        ; preds = %inst_11a4, %inst_11bc, %inst_1227
  %121 = load i64, i64* %131, align 8
  %122 = sub i64 %121, 1
  store i64 %122, i64* @RDX_2264_2172d5b8, align 8, !tbaa !8
  store i64 %122, i64* %131, align 8
  %123 = icmp eq i64 %121, 0
  %124 = zext i1 %123 to i8
  %125 = icmp eq i8 %124, 0
  br i1 %125, label %inst_11b4, label %inst_12d9

inst_1449:                                        ; preds = %inst_143b, %inst_1189
  %126 = phi %struct.Memory* [ %memory, %inst_1189 ], [ %memory, %inst_143b ]
  %127 = load i64, i64* %4, align 8
  store i64 %127, i64* @RBP_2328_2172d5b8, align 8, !tbaa !8
  %128 = add i64 %2, 8
  store i64 %128, i64* @RSP_2312_2172d5b8, align 8, !tbaa !8
  ret %struct.Memory* %126

inst_11a4:                                        ; preds = %inst_1189
  %129 = lshr i64 %9, 1
  %130 = sub i64 %3, 80
  %131 = inttoptr i64 %130 to i64*
  store i64 %129, i64* %131, align 8
  br label %inst_12c4

inst_11d9:                                        ; preds = %inst_11bc
  %132 = add i64 1, %114
  %133 = sub i64 %3, 16
  %134 = inttoptr i64 %133 to i64*
  store i64 %132, i64* %134, align 8
  %135 = load i64, i64* %10, align 8
  %136 = icmp ugt i64 %135, %132
  %137 = zext i1 %136 to i8
  %138 = icmp eq i8 %137, 0
  br i1 %138, label %inst_1223, label %inst_11ef

inst_11ef:                                        ; preds = %inst_11d9
  %139 = mul i64 %132, 4
  %140 = load i64, i64* %7, align 8
  %141 = add i64 %139, %140
  %142 = inttoptr i64 %141 to i32*
  %143 = load i32, i32* %142, align 4
  %144 = load i64, i64* %116, align 8
  %145 = mul i64 %144, 4
  %146 = add i64 %145, %140
  %147 = inttoptr i64 %146 to i32*
  %148 = load i32, i32* %147, align 4
  %149 = sub i32 %143, %148
  %150 = icmp eq i32 %149, 0
  %151 = lshr i32 %149, 31
  %152 = trunc i32 %151 to i8
  %153 = lshr i32 %143, 31
  %154 = lshr i32 %148, 31
  %155 = xor i32 %154, %153
  %156 = xor i32 %151, %153
  %157 = add nuw nsw i32 %156, %155
  %158 = icmp eq i32 %157, 2
  %159 = icmp ne i8 %152, 0
  %160 = xor i1 %159, %158
  %161 = or i1 %150, %160
  br i1 %161, label %inst_1223, label %inst_121d

inst_121d:                                        ; preds = %inst_11ef
  store i64 %132, i64* @RAX_2216_2172d5b8, align 8, !tbaa !8
  br label %inst_1227

inst_1259:                                        ; preds = %inst_1227
  %162 = sub i64 %3, 84
  %163 = inttoptr i64 %162 to i32*
  store i32 %73, i32* %163, align 4
  %164 = load i64, i64* %67, align 8
  %165 = mul i64 %164, 4
  %166 = load i64, i64* %7, align 8
  %167 = add i64 %165, %166
  %168 = load i64, i64* %182, align 8
  %169 = mul i64 %168, 4
  store i64 %169, i64* @RCX_2248_2172d5b8, align 8, !tbaa !8
  %170 = add i64 %169, %166
  %171 = inttoptr i64 %167 to i32*
  %172 = load i32, i32* %171, align 4
  %173 = inttoptr i64 %170 to i32*
  store i32 %172, i32* %173, align 4
  %174 = load i64, i64* %67, align 8
  %175 = mul i64 %174, 4
  %176 = load i64, i64* %7, align 8
  %177 = add i64 %176, %175
  %178 = load i32, i32* %163, align 4
  %179 = inttoptr i64 %177 to i32*
  store i32 %178, i32* %179, align 4
  %180 = load i64, i64* %67, align 8
  store i64 %180, i64* %182, align 8
  br label %inst_11bc

inst_11b4:                                        ; preds = %inst_12c4
  %181 = sub i64 %3, 72
  %182 = inttoptr i64 %181 to i64*
  store i64 %122, i64* %182, align 8
  br label %inst_11bc

inst_12d9:                                        ; preds = %inst_12c4
  %183 = load i64, i64* %10, align 8
  %184 = sub i64 %183, 1
  store i64 %184, i64* @RAX_2216_2172d5b8, align 8, !tbaa !8
  %185 = sub i64 %3, 64
  %186 = inttoptr i64 %185 to i64*
  store i64 %184, i64* %186, align 8
  br label %inst_143b

inst_134b:                                        ; preds = %inst_132e
  %187 = add i64 1, %91
  %188 = sub i64 %3, 40
  %189 = inttoptr i64 %188 to i64*
  store i64 %187, i64* %189, align 8
  %190 = load i64, i64* %186, align 8
  %191 = icmp ugt i64 %190, %187
  %192 = zext i1 %191 to i8
  %193 = icmp eq i8 %192, 0
  br i1 %193, label %inst_1395, label %inst_1361

inst_1361:                                        ; preds = %inst_134b
  %194 = mul i64 %187, 4
  %195 = load i64, i64* %7, align 8
  %196 = add i64 %194, %195
  %197 = inttoptr i64 %196 to i32*
  %198 = load i32, i32* %197, align 4
  %199 = load i64, i64* %93, align 8
  %200 = mul i64 %199, 4
  %201 = add i64 %200, %195
  %202 = inttoptr i64 %201 to i32*
  %203 = load i32, i32* %202, align 4
  %204 = sub i32 %198, %203
  %205 = icmp eq i32 %204, 0
  %206 = lshr i32 %204, 31
  %207 = trunc i32 %206 to i8
  %208 = lshr i32 %198, 31
  %209 = lshr i32 %203, 31
  %210 = xor i32 %209, %208
  %211 = xor i32 %206, %208
  %212 = add nuw nsw i32 %211, %210
  %213 = icmp eq i32 %212, 2
  %214 = icmp ne i8 %207, 0
  %215 = xor i1 %214, %213
  %216 = or i1 %205, %215
  br i1 %216, label %inst_1395, label %inst_138f

inst_138f:                                        ; preds = %inst_1361
  store i64 %187, i64* @RAX_2216_2172d5b8, align 8, !tbaa !8
  br label %inst_1399

inst_13cb:                                        ; preds = %inst_1399
  %217 = sub i64 %3, 88
  %218 = inttoptr i64 %217 to i32*
  store i32 %45, i32* %218, align 4
  %219 = load i64, i64* %39, align 8
  %220 = mul i64 %219, 4
  %221 = load i64, i64* %7, align 8
  %222 = add i64 %220, %221
  %223 = load i64, i64* %255, align 8
  %224 = mul i64 %223, 4
  store i64 %224, i64* @RCX_2248_2172d5b8, align 8, !tbaa !8
  %225 = add i64 %224, %221
  %226 = inttoptr i64 %222 to i32*
  %227 = load i32, i32* %226, align 4
  %228 = inttoptr i64 %225 to i32*
  store i32 %227, i32* %228, align 4
  %229 = load i64, i64* %39, align 8
  %230 = mul i64 %229, 4
  %231 = load i64, i64* %7, align 8
  %232 = add i64 %231, %230
  store i64 %232, i64* @RDX_2264_2172d5b8, align 8, !tbaa !8
  %233 = load i32, i32* %218, align 4
  %234 = inttoptr i64 %232 to i32*
  store i32 %233, i32* %234, align 4
  %235 = load i64, i64* %39, align 8
  store i64 %235, i64* %255, align 8
  br label %inst_132e

inst_12ea:                                        ; preds = %inst_143b
  %236 = load i64, i64* %7, align 8
  %237 = inttoptr i64 %236 to i32*
  %238 = load i32, i32* %237, align 4
  %239 = sub i64 %3, 92
  %240 = inttoptr i64 %239 to i32*
  store i32 %238, i32* %240, align 4
  %241 = load i64, i64* %186, align 8
  %242 = mul i64 %241, 4
  %243 = load i64, i64* %7, align 8
  %244 = add i64 %242, %243
  %245 = inttoptr i64 %244 to i32*
  %246 = load i32, i32* %245, align 4
  %247 = inttoptr i64 %243 to i32*
  store i32 %246, i32* %247, align 4
  %248 = load i64, i64* %186, align 8
  %249 = mul i64 %248, 4
  %250 = load i64, i64* %7, align 8
  %251 = add i64 %250, %249
  store i64 %251, i64* @RDX_2264_2172d5b8, align 8, !tbaa !8
  %252 = load i32, i32* %240, align 4
  %253 = inttoptr i64 %251 to i32*
  store i32 %252, i32* %253, align 4
  %254 = sub i64 %3, 56
  %255 = inttoptr i64 %254 to i64*
  store i64 0, i64* %255, align 8
  br label %inst_132e
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
