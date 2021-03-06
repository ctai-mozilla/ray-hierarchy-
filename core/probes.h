
/*
    pbrt source code Copyright(c) 1998-2009 Matt Pharr and Greg Humphreys.

    This file is part of pbrt.

    pbrt is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.  Note that the text contents of
    the book "Physically Based Rendering" are *not* licensed under the
    GNU GPL.

    pbrt is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

 */

#ifndef PBRT_CORE_PROBES_H
#define PBRT_CORE_PROBES_H

// core/probes.h*
#include "pbrt.h"
#ifdef PBRT_STATS_DTRACE
#include "core/dtrace.h"
inline void ProbesCleanup() { }
inline void ProbesPrint(FILE *) { }
#endif // PBRT_STATS_DTRACE

#ifdef PBRT_STATS_NONE
inline void ProbesCleanup() { }
inline void ProbesPrint(FILE *) { }

// Statistics Disabled Declarations
#define PBRT_STARTED_RAY_INTERSECTION(ray)
#define PBRT_FINISHED_RAY_INTERSECTION(ray, isect, hit)
#define PBRT_STARTED_RAY_INTERSECTIONP(ray)
#define PBRT_FINISHED_RAY_INTERSECTIONP(ray, hit)

// Remainder of statistics disabled declarations
#define PBRT_ACCESSED_TEXEL(arg0, arg1, arg2, arg3)
#define PBRT_ALLOCATED_CACHED_TRANSFORM()
#define PBRT_ATOMIC_MEMORY_OP()
#define PBRT_BVH_STARTED_CONSTRUCTION(arg0, arg1)
#define PBRT_BVH_FINISHED_CONSTRUCTION(arg0)
#define PBRT_BVH_INTERSECTION_STARTED(arg0, arg1)
#define PBRT_BVH_INTERSECTION_TRAVERSED_INTERIOR_NODE(arg0)
#define PBRT_BVH_INTERSECTION_TRAVERSED_LEAF_NODE(arg0)
#define PBRT_BVH_INTERSECTION_PRIMITIVE_TEST(arg0)
#define PBRT_BVH_INTERSECTION_PRIMITIVE_HIT(arg0)
#define PBRT_BVH_INTERSECTION_PRIMITIVE_MISSED(arg0)
#define PBRT_BVH_INTERSECTION_FINISHED()
#define PBRT_BVH_INTERSECTIONP_STARTED(arg0, arg1)
#define PBRT_BVH_INTERSECTIONP_TRAVERSED_INTERIOR_NODE(arg0)
#define PBRT_BVH_INTERSECTIONP_TRAVERSED_LEAF_NODE(arg0)
#define PBRT_BVH_INTERSECTIONP_PRIMITIVE_TEST(arg0)
#define PBRT_BVH_INTERSECTIONP_PRIMITIVE_HIT(arg0)
#define PBRT_BVH_INTERSECTIONP_PRIMITIVE_MISSED(arg0)
#define PBRT_BVH_INTERSECTIONP_FINISHED()
#define PBRT_CREATED_SHAPE(shape)
#define PBRT_CREATED_TRIANGLE(tri)
#define PBRT_FINISHED_GENERATING_CAMERA_RAY(arg0, arg1, arg2)
#define PBRT_FINISHED_PARSING()
#define PBRT_FINISHED_PREPROCESSING()
#define PBRT_FINISHED_RENDERING()
#define PBRT_FINISHED_RENDERTASK(arg0)
#define PBRT_FINISHED_TASK(arg0)
#define PBRT_FINISHED_ADDING_IMAGE_SAMPLE()
#define PBRT_FINISHED_CAMERA_RAY_INTEGRATION(arg0, arg1, arg2)
#define PBRT_FINISHED_EWA_TEXTURE_LOOKUP()
#define PBRT_FINISHED_BSDF_SHADING(arg0, arg1)
#define PBRT_FINISHED_BSSRDF_SHADING(arg0, arg1)
#define PBRT_FINISHED_SPECULAR_REFLECTION_RAY(arg0)
#define PBRT_FINISHED_SPECULAR_REFRACTION_RAY(arg0)
#define PBRT_FINISHED_TRILINEAR_TEXTURE_LOOKUP()
#define PBRT_GRID_BOUNDS_AND_RESOLUTION(arg0, arg1)
#define PBRT_GRID_FINISHED_CONSTRUCTION(arg0)
#define PBRT_GRID_INTERSECTIONP_TEST(arg0, arg1)
#define PBRT_GRID_INTERSECTION_TEST(arg0, arg1)
#define PBRT_GRID_RAY_MISSED_BOUNDS()
#define PBRT_GRID_RAY_PRIMITIVE_HIT(arg0)
#define PBRT_GRID_RAY_PRIMITIVE_INTERSECTIONP_TEST(arg0)
#define PBRT_GRID_RAY_PRIMITIVE_INTERSECTION_TEST(arg0)
#define PBRT_GRID_RAY_TRAVERSED_VOXEL(arg0, arg1)
#define PBRT_GRID_STARTED_CONSTRUCTION(arg0, arg1)
#define PBRT_GRID_VOXELIZED_PRIMITIVE(arg0, arg1)
#define PBRT_IRRADIANCE_CACHE_ADDED_NEW_SAMPLE(arg0, arg1, arg2, arg3, arg4, arg5)
#define PBRT_IRRADIANCE_CACHE_CHECKED_SAMPLE(arg0, arg1, arg2)
#define PBRT_IRRADIANCE_CACHE_FINISHED_COMPUTING_IRRADIANCE(arg0, arg1)
#define PBRT_IRRADIANCE_CACHE_FINISHED_INTERPOLATION(arg0, arg1, arg2, arg3)
#define PBRT_IRRADIANCE_CACHE_FINISHED_RAY(arg0, arg1, arg2)
#define PBRT_IRRADIANCE_CACHE_STARTED_COMPUTING_IRRADIANCE(arg0, arg1)
#define PBRT_IRRADIANCE_CACHE_STARTED_INTERPOLATION(arg0, arg1)
#define PBRT_IRRADIANCE_CACHE_STARTED_RAY(arg0)
#define PBRT_KDTREE_CREATED_INTERIOR_NODE(arg0, arg1)
#define PBRT_KDTREE_CREATED_LEAF(arg0, arg1)
#define PBRT_KDTREE_FINISHED_CONSTRUCTION(arg0)
#define PBRT_KDTREE_INTERSECTIONP_PRIMITIVE_TEST(arg0)
#define PBRT_KDTREE_INTERSECTION_PRIMITIVE_TEST(arg0)
#define PBRT_KDTREE_INTERSECTIONP_HIT(arg0)
#define PBRT_KDTREE_INTERSECTIONP_MISSED()
#define PBRT_KDTREE_INTERSECTIONP_TEST(arg0, arg1)
#define PBRT_KDTREE_INTERSECTION_FINISHED()
#define PBRT_KDTREE_INTERSECTION_HIT(arg0)
#define PBRT_KDTREE_INTERSECTION_TEST(arg0, arg1)
#define PBRT_KDTREE_RAY_MISSED_BOUNDS()
#define PBRT_KDTREE_STARTED_CONSTRUCTION(arg0, arg1)
#define PBRT_KDTREE_INTERSECTION_TRAVERSED_INTERIOR_NODE(arg0)
#define PBRT_KDTREE_INTERSECTION_TRAVERSED_LEAF_NODE(arg0, arg1)
#define PBRT_KDTREE_INTERSECTIONP_TRAVERSED_INTERIOR_NODE(arg0)
#define PBRT_KDTREE_INTERSECTIONP_TRAVERSED_LEAF_NODE(arg0, arg1)
#define PBRT_LOADED_IMAGE_MAP(arg0, arg1, arg2, arg3, arg4)
#define PBRT_MIPMAP_EWA_FILTER(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
#define PBRT_MIPMAP_TRILINEAR_FILTER(arg0, arg1, arg2, arg3, arg4, arg5)
#define PBRT_MLT_ACCEPTED_MUTATION(arg0, arg1, arg2)
#define PBRT_MLT_REJECTED_MUTATION(arg0, arg1, arg2)
#define PBRT_MLT_STARTED_MLT_TASK(arg0)
#define PBRT_MLT_FINISHED_MLT_TASK(arg0)
#define PBRT_PHOTON_MAP_DEPOSITED_CAUSTIC_PHOTON(arg0, arg1, arg2)
#define PBRT_PHOTON_MAP_DEPOSITED_DIRECT_PHOTON(arg0, arg1, arg2)
#define PBRT_PHOTON_MAP_DEPOSITED_INDIRECT_PHOTON(arg0, arg1, arg2)
#define PBRT_PHOTON_MAP_FINISHED_GATHER_RAY(arg0)
#define PBRT_PHOTON_MAP_FINISHED_LOOKUP(arg0, arg1, arg2, arg3)
#define PBRT_PHOTON_MAP_FINISHED_RAY_PATH(arg0, arg1)
#define PBRT_PHOTON_MAP_STARTED_GATHER_RAY(arg0)
#define PBRT_PHOTON_MAP_STARTED_LOOKUP(arg0)
#define PBRT_PHOTON_MAP_STARTED_RAY_PATH(arg0, arg1)
#define PBRT_RAY_TRIANGLE_INTERSECTIONP_HIT(arg0, arg1)
#define PBRT_RAY_TRIANGLE_INTERSECTIONP_TEST(arg0, arg1)
#define PBRT_RAY_TRIANGLE_INTERSECTION_HIT(arg0, arg1)
#define PBRT_RAY_TRIANGLE_INTERSECTION_TEST(arg0, arg1)
#define PBRT_SAMPLE_OUTSIDE_IMAGE_EXTENT(arg0)
#define PBRT_STARTED_ADDING_IMAGE_SAMPLE(arg0, arg1, arg2, arg3)
#define PBRT_STARTED_CAMERA_RAY_INTEGRATION(arg0, arg1)
#define PBRT_STARTED_EWA_TEXTURE_LOOKUP(arg0, arg1)
#define PBRT_STARTED_GENERATING_CAMERA_RAY(arg0)
#define PBRT_STARTED_PARSING()
#define PBRT_STARTED_PREPROCESSING()
#define PBRT_STARTED_RENDERING()
#define PBRT_STARTED_RENDERTASK(arg0)
#define PBRT_STARTED_BSDF_SHADING(arg0)
#define PBRT_STARTED_BSSRDF_SHADING(arg0)
#define PBRT_STARTED_SPECULAR_REFLECTION_RAY(arg0)
#define PBRT_STARTED_SPECULAR_REFRACTION_RAY(arg0)
#define PBRT_STARTED_TASK(arg0)
#define PBRT_STARTED_TRILINEAR_TEXTURE_LOOKUP(arg0, arg1)
#define PBRT_SUBSURFACE_ADDED_INTERIOR_CONTRIBUTION(arg0)
#define PBRT_SUBSURFACE_ADDED_POINT_CONTRIBUTION(arg0)
#define PBRT_SUBSURFACE_ADDED_POINT_TO_OCTREE(arg0, arg1)
#define PBRT_SUBSURFACE_COMPUTED_IRRADIANCE_AT_POINT(arg0, arg1)
#define PBRT_SUBSURFACE_FINISHED_COMPUTING_IRRADIANCE_VALUES()
#define PBRT_SUBSURFACE_FINISHED_OCTREE_LOOKUP()
#define PBRT_SUBSURFACE_FINISHED_RAYS_FOR_POINTS(arg0, arg1)
#define PBRT_SUBSURFACE_STARTED_COMPUTING_IRRADIANCE_VALUES()
#define PBRT_SUBSURFACE_STARTED_OCTREE_LOOKUP(arg0)
#define PBRT_SUBSURFACE_STARTED_RAYS_FOR_POINTS()
#define PBRT_SUPERSAMPLE_PIXEL_NO(arg0, arg1)
#define PBRT_SUPERSAMPLE_PIXEL_YES(arg0, arg1)
#endif // PBRT_STATS_NONE

#ifdef PBRT_STATS_COUNTERS

// Statistics Counters Declarations
void ProbesPrint(FILE *dest);
void ProbesCleanup();
class Triangle;
extern void PBRT_CREATED_SHAPE(Shape *);
extern void PBRT_CREATED_TRIANGLE(Triangle *);
extern void PBRT_STARTED_GENERATING_CAMERA_RAY(const struct Sample *);
extern void PBRT_KDTREE_CREATED_INTERIOR_NODE(int axis, float split);
extern void PBRT_KDTREE_CREATED_LEAF(int nprims, int depth);
#if 1
extern void PBRT_RAY_TRIANGLE_INTERSECTION_TEST(const Ray *, const Triangle *);
extern void PBRT_RAY_TRIANGLE_INTERSECTIONP_TEST(const Ray *, const Triangle *);
extern void PBRT_RAY_TRIANGLE_INTERSECTION_HIT(const Ray *, float t);
extern void PBRT_RAY_TRIANGLE_INTERSECTIONP_HIT(const Ray *, float t);
#else
#define PBRT_RAY_TRIANGLE_INTERSECTION_HIT(arg0, arg1)
#define PBRT_RAY_TRIANGLE_INTERSECTION_TEST(arg0, arg1)
#define PBRT_RAY_TRIANGLE_INTERSECTIONP_HIT(arg0, arg1)
#define PBRT_RAY_TRIANGLE_INTERSECTIONP_TEST(arg0, arg1)
#endif
extern void PBRT_FINISHED_RAY_INTERSECTION(const Ray *, const Intersection *, int hit);
extern void PBRT_FINISHED_RAY_INTERSECTIONP(const Ray *, int hit);
extern void PBRT_STARTED_SPECULAR_REFLECTION_RAY(const RayDifferential *);
extern void PBRT_STARTED_SPECULAR_REFRACTION_RAY(const RayDifferential *);
#define PBRT_ACCESSED_TEXEL(arg0, arg1, arg2, arg3)
#define PBRT_ALLOCATED_CACHED_TRANSFORM()
#define PBRT_ATOMIC_MEMORY_OP()
#define PBRT_BVH_STARTED_CONSTRUCTION(arg0, arg1)
#define PBRT_BVH_FINISHED_CONSTRUCTION(arg0)
#define PBRT_BVH_INTERSECTION_STARTED(arg0, arg1)
#define PBRT_BVH_INTERSECTION_TRAVERSED_INTERIOR_NODE(arg0)
#define PBRT_BVH_INTERSECTION_TRAVERSED_LEAF_NODE(arg0)
#define PBRT_BVH_INTERSECTION_PRIMITIVE_TEST(arg0)
#define PBRT_BVH_INTERSECTION_PRIMITIVE_HIT(arg0)
#define PBRT_BVH_INTERSECTION_PRIMITIVE_MISSED(arg0)
#define PBRT_BVH_INTERSECTION_FINISHED()
#define PBRT_BVH_INTERSECTIONP_STARTED(arg0, arg1)
#define PBRT_BVH_INTERSECTIONP_TRAVERSED_INTERIOR_NODE(arg0)
#define PBRT_BVH_INTERSECTIONP_TRAVERSED_LEAF_NODE(arg0)
#define PBRT_BVH_INTERSECTIONP_PRIMITIVE_TEST(arg0)
#define PBRT_BVH_INTERSECTIONP_PRIMITIVE_HIT(arg0)
#define PBRT_BVH_INTERSECTIONP_PRIMITIVE_MISSED(arg0)
#define PBRT_BVH_INTERSECTIONP_FINISHED()
#define PBRT_FINISHED_PARSING()
#define PBRT_FINISHED_PREPROCESSING()
#define PBRT_FINISHED_RENDERING()
#define PBRT_FINISHED_RENDERTASK(arg0)
#define PBRT_FINISHED_TASK(arg0)
#define PBRT_FINISHED_ADDING_IMAGE_SAMPLE()
#define PBRT_FINISHED_CAMERA_RAY_INTEGRATION(arg0, arg1, arg2)
#define PBRT_FINISHED_EWA_TEXTURE_LOOKUP()
#define PBRT_FINISHED_GENERATING_CAMERA_RAY(arg0, arg1, arg2)
#define PBRT_FINISHED_BSDF_SHADING(arg0, arg1)
#define PBRT_FINISHED_BSSRDF_SHADING(arg0, arg1)
#define PBRT_FINISHED_SPECULAR_REFLECTION_RAY(arg0)
#define PBRT_FINISHED_SPECULAR_REFRACTION_RAY(arg0)
#define PBRT_FINISHED_TRILINEAR_TEXTURE_LOOKUP()
#define PBRT_GRID_BOUNDS_AND_RESOLUTION(arg0, arg1)
#define PBRT_GRID_FINISHED_CONSTRUCTION(arg0)
#define PBRT_GRID_INTERSECTIONP_TEST(arg0, arg1)
#define PBRT_GRID_INTERSECTION_TEST(arg0, arg1)
#define PBRT_GRID_RAY_MISSED_BOUNDS()
#define PBRT_GRID_RAY_PRIMITIVE_HIT(arg0)
#define PBRT_GRID_RAY_PRIMITIVE_INTERSECTIONP_TEST(arg0)
#define PBRT_GRID_RAY_PRIMITIVE_INTERSECTION_TEST(arg0)
#define PBRT_GRID_RAY_TRAVERSED_VOXEL(arg0, arg1)
#define PBRT_GRID_STARTED_CONSTRUCTION(arg0, arg1)
#define PBRT_GRID_VOXELIZED_PRIMITIVE(arg0, arg1)
#define PBRT_IRRADIANCE_CACHE_ADDED_NEW_SAMPLE(arg0, arg1, arg2, arg3, arg4, arg5)
#define PBRT_IRRADIANCE_CACHE_CHECKED_SAMPLE(arg0, arg1, arg2)
#define PBRT_IRRADIANCE_CACHE_FINISHED_COMPUTING_IRRADIANCE(arg0, arg1)
#define PBRT_IRRADIANCE_CACHE_FINISHED_INTERPOLATION(arg0, arg1, arg2, arg3)
#define PBRT_IRRADIANCE_CACHE_FINISHED_RAY(arg0, arg1, arg2)
#define PBRT_IRRADIANCE_CACHE_STARTED_COMPUTING_IRRADIANCE(arg0, arg1)
#define PBRT_IRRADIANCE_CACHE_STARTED_INTERPOLATION(arg0, arg1)
#define PBRT_IRRADIANCE_CACHE_STARTED_RAY(arg0)
#define PBRT_KDTREE_FINISHED_CONSTRUCTION(arg0)
#define PBRT_KDTREE_INTERSECTIONP_PRIMITIVE_TEST(arg0)
#define PBRT_KDTREE_INTERSECTION_PRIMITIVE_TEST(arg0)
#define PBRT_KDTREE_INTERSECTIONP_HIT(arg0)
#define PBRT_KDTREE_INTERSECTIONP_MISSED()
#define PBRT_KDTREE_INTERSECTIONP_TEST(arg0, arg1)
#define PBRT_KDTREE_INTERSECTION_FINISHED()
#define PBRT_KDTREE_INTERSECTION_HIT(arg0)
#define PBRT_KDTREE_INTERSECTION_TEST(arg0, arg1)
#define PBRT_KDTREE_RAY_MISSED_BOUNDS()
#define PBRT_KDTREE_STARTED_CONSTRUCTION(arg0, arg1)
#define PBRT_KDTREE_INTERSECTION_TRAVERSED_INTERIOR_NODE(arg0)
#define PBRT_KDTREE_INTERSECTION_TRAVERSED_LEAF_NODE(arg0, arg1)
#define PBRT_KDTREE_INTERSECTIONP_TRAVERSED_INTERIOR_NODE(arg0)
#define PBRT_KDTREE_INTERSECTIONP_TRAVERSED_LEAF_NODE(arg0, arg1)
#define PBRT_LOADED_IMAGE_MAP(arg0, arg1, arg2, arg3, arg4)
#define PBRT_MIPMAP_EWA_FILTER(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
#define PBRT_MIPMAP_TRILINEAR_FILTER(arg0, arg1, arg2, arg3, arg4, arg5)
#define PBRT_MLT_ACCEPTED_MUTATION(arg0, arg1, arg2)
#define PBRT_MLT_REJECTED_MUTATION(arg0, arg1, arg2)
#define PBRT_MLT_STARTED_MLT_TASK(arg0)
#define PBRT_MLT_FINISHED_MLT_TASK(arg0)
#define PBRT_PHOTON_MAP_DEPOSITED_CAUSTIC_PHOTON(arg0, arg1, arg2)
#define PBRT_PHOTON_MAP_DEPOSITED_DIRECT_PHOTON(arg0, arg1, arg2)
#define PBRT_PHOTON_MAP_DEPOSITED_INDIRECT_PHOTON(arg0, arg1, arg2)
#define PBRT_PHOTON_MAP_FINISHED_GATHER_RAY(arg0)
#define PBRT_PHOTON_MAP_FINISHED_LOOKUP(arg0, arg1, arg2, arg3)
#define PBRT_PHOTON_MAP_FINISHED_RAY_PATH(arg0, arg1)
#define PBRT_PHOTON_MAP_STARTED_GATHER_RAY(arg0)
#define PBRT_PHOTON_MAP_STARTED_LOOKUP(arg0)
#define PBRT_PHOTON_MAP_STARTED_RAY_PATH(arg0, arg1)
#define PBRT_SAMPLE_OUTSIDE_IMAGE_EXTENT(arg0)
#define PBRT_STARTED_ADDING_IMAGE_SAMPLE(arg0, arg1, arg2, arg3)
#define PBRT_STARTED_CAMERA_RAY_INTEGRATION(arg0, arg1)
#define PBRT_STARTED_EWA_TEXTURE_LOOKUP(arg0, arg1)
#define PBRT_STARTED_PARSING()
#define PBRT_STARTED_PREPROCESSING()
#define PBRT_STARTED_RAY_INTERSECTION(arg0)
#define PBRT_STARTED_RAY_INTERSECTIONP(arg0)
#define PBRT_STARTED_RENDERING()
#define PBRT_STARTED_RENDERTASK(arg0)
#define PBRT_STARTED_BSDF_SHADING(arg0)
#define PBRT_STARTED_BSSRDF_SHADING(arg0)
#define PBRT_STARTED_TASK(arg0)
#define PBRT_STARTED_TRILINEAR_TEXTURE_LOOKUP(arg0, arg1)
#define PBRT_SUBSURFACE_ADDED_INTERIOR_CONTRIBUTION(arg0)
#define PBRT_SUBSURFACE_ADDED_POINT_CONTRIBUTION(arg0)
#define PBRT_SUBSURFACE_ADDED_POINT_TO_OCTREE(arg0, arg1)
#define PBRT_SUBSURFACE_COMPUTED_IRRADIANCE_AT_POINT(arg0, arg1)
#define PBRT_SUBSURFACE_FINISHED_COMPUTING_IRRADIANCE_VALUES()
#define PBRT_SUBSURFACE_FINISHED_OCTREE_LOOKUP()
#define PBRT_SUBSURFACE_FINISHED_RAYS_FOR_POINTS(arg0, arg1)
#define PBRT_SUBSURFACE_STARTED_COMPUTING_IRRADIANCE_VALUES()
#define PBRT_SUBSURFACE_STARTED_OCTREE_LOOKUP(arg0)
#define PBRT_SUBSURFACE_STARTED_RAYS_FOR_POINTS()
#define PBRT_SUPERSAMPLE_PIXEL_NO(arg0, arg1)
#define PBRT_SUPERSAMPLE_PIXEL_YES(arg0, arg1)
#endif // PBRT_STATS_COUNTERS

#endif // PBRT_CORE_PROBES_H
