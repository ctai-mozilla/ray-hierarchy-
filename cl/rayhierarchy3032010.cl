#pragma OPENCL EXTENSION cl_khr_byte_addressable_store : enable
#define EPS 0.000001

void intersectPAllLeaves (int j, const __global float* dir, const __global float* o, const __global float* bounds,
__global unsigned char* tHit, float4 v1, float4 v2, float4 v3, float4 e1, float4 e2, int chunk ){
    float4 s1, s2, d, rayd, rayo;
    float divisor, invDivisor, t, b1, b2;
    // process all rays in the cone
    for ( int i = 0; i < chunk; i++){
      rayd = (float4)(dir[3*j*chunk + 3*i], dir[3*j*chunk + 3*i+1], dir[3*j*chunk + 3*i+2], 0);
      rayo = (float4)(o[3*j*chunk + 3*i], o[3*j*chunk +3*i+1], o[3*j*chunk + 3*i+2], 0);
      s1 = cross(rayd, e2);
      divisor = dot(s1, e1);
      if ( divisor == 0.0) continue;
      invDivisor = 1.0f/ divisor;

      // compute first barycentric coordinate
      d = rayo - v1;
      b1 = dot(d, s1) * invDivisor;
      if ( b1 < -1e-3f  || b1 > 1.+1e-3f) continue;

      // compute second barycentric coordinate
      s2 = cross(d, e1);
      b2 = dot(rayd, s2) * invDivisor;
      if ( b2 < -1e-3f || (b1 + b2) > 1.+1e-3f) continue;

      // Compute _t_ to intersection point
      t = dot(e2, s2) * invDivisor;
      if (t < bounds[2*j*chunk + i*2]) continue;
      //mem_fence(CLK_GLOBAL_MEM_FENCE);
      if (tHit[j*chunk+i] != INFINITY && tHit[j*chunk + i] != NAN && t > tHit[j*chunk + i]) continue;
      tHit[j*chunk+i] = '1';
    }
}

void intersectAllLeaves (int j, const __global float* dir, const __global float* o,
const __global float* bounds, const __global float* uvs, __global float* tutv,
__global float* dp, global int* index, __global float* tHit, float4 v1, float4 v2, float4 v3,
float4 e1, float4 e2, int chunk ){
    float4 s1, s2, d, rayd, rayo;
    float divisor, invDivisor, t, b1, b2;
    int iGID = get_global_id(0);
  // process all rays in the cone
  for ( int i = 0; i < chunk; i++){
    rayd = (float4)(dir[3*j*chunk + 3*i], dir[3*j*chunk + 3*i+1], dir[3*j*chunk + 3*i+2], 0);
    rayo = (float4)(o[3*j*chunk + 3*i], o[3*j*chunk +3*i+1], o[3*j*chunk + 3*i+2], 0);

    s1 = cross(rayd, e2);
    divisor = dot(s1, e1);
    if ( divisor == 0.0) continue; //potrebuju nejake pole boolu
    invDivisor = 1.0f/ divisor;

   // compute first barycentric coordinate
    d = rayo - v1;
    b1 = dot(d, s1) * invDivisor;
    if ( b1 < -1e-3f  || b1 > 1.+1e-3f) continue;

    // compute second barycentric coordinate
    s2 = cross(d, e1);
    b2 = dot(rayd, s2) * invDivisor;
    if ( b2 < -1e-3f || (b1 + b2) > 1.+1e-3f) continue;

    // Compute _t_ to intersection point
    t = dot(e2, s2) * invDivisor;
    if (t < bounds[2*j*chunk + i*2]) continue;
    //mem_fence(CLK_GLOBAL_MEM_FENCE);
    if (tHit[j*chunk+i] != INFINITY && tHit[j*chunk + i] != NAN && t > tHit[j*chunk + i]) continue;

    tHit[j*chunk + i] = t;
    index[j*chunk + i] = iGID;

    float du1 = uvs[6*iGID]   - uvs[6*iGID+4];
    float du2 = uvs[6*iGID+2] - uvs[6*iGID+4];
    float dv1 = uvs[6*iGID+1] - uvs[6*iGID+5];
    float dv2 = uvs[6*iGID+3] - uvs[6*iGID+5];
    float4 dp1 = v1 - v3;
    float4 dp2 = v2 - v3;
    float determinant = du1 * dv2 - dv1 * du2;
    if ( determinant == 0.f ) {
      float4 temp = normalize(cross(e2, e1));
      if ( fabs(temp.x) > fabs(temp.y)) {
          float invLen = rsqrt(temp.x*temp.x + temp.z*temp.z);
          dp[6*j*chunk + 6*i] = -temp.z*invLen;
          dp[6*j*chunk + 6*i+1] = 0.f;
          dp[6*j*chunk + 6*i+2] = temp.x*invLen;
      } else {
          float invLen = rsqrt(temp.y*temp.y + temp.z*temp.z);
          dp[6*j*chunk + 6*i] = 0.f;
          dp[6*j*chunk + 6*i+1] = temp.z*invLen;
          dp[6*j*chunk + 6*i+2] = -temp.y*invLen;
      }
      float4 help = cross(temp, (float4)(dp[6*j*chunk + 6*i], dp[6*j*chunk + 6*i+1], dp[6*j*chunk + 6*i+2],0));
      dp[6*j*chunk + 6*i+3] = help.x;
      dp[6*j*chunk + 6*i+4] = help.y;
      dp[6*j*chunk + 6*i+5] = help.z;
    } else {
      float invdet = 1.f / determinant;
      float4 help = (dv2 * dp1 - dv1 * dp2) * invdet;
      dp[6*j*chunk + 6*i] = help.x;
      dp[6*j*chunk + 6*i+1] = help.y;
      dp[6*j*chunk + 6*i+2] = help.z;
      help = (-du2 * dp1 + du1 * dp2) * invdet;
      dp[6*j*chunk + 6*i+3] = help.x;
      dp[6*j*chunk + 6*i+4] = help.y;
      dp[6*j*chunk + 6*i+5] = help.z;
  }

  float b0 = 1 - b1 - b2;
  tutv[2*j*chunk + 2*i] = b0*uvs[6*iGID] + b1*uvs[6*iGID+2] + b2*uvs[6*iGID+4];
  tutv[2*j*chunk + 2*i+1] = b0*uvs[6*iGID+1] + b1*uvs[6*iGID+3] + b2*uvs[6*iGID+5];
  }
}


__kernel void rayhconstruct(const __global float* dir,const  __global float* o,
 __global float* cones, const int chunk, const int count){

  int iGID = get_global_id(0);
  int total = (count+chunk-1)/chunk;
  if (iGID > total) return;

  float4 x, r, q, xnew, c, p , a, e, n , g, xb, ab, rb, test;
  float cosfi, sinfi, cosfib, sinfib;
  float dotrx, dotcx, t ;

  //start with the zero angle enclosing cone of the first ray
  x = normalize((float4)(dir[3*iGID*chunk],dir[3*iGID*chunk+1],dir[3*iGID*chunk+2],0));
  a = (float4)(o[3*iGID*chunk],o[3*iGID*chunk+1], o[3*iGID*chunk+2],0);
  cosfi = 1;

  for ( int i = 1; i < chunk && iGID*chunk+i < count; i++){
    //check if the direction of the ray lies within the solid angle
    r = normalize((float4)(dir[3*(iGID*chunk+i)], dir[3*(iGID*chunk+i)+1],dir[3*(iGID*chunk+i)+2],0));
    p = (float4)(o[3*(iGID*chunk+i)], o[3*(iGID*chunk+i)+1], o[3*(iGID*chunk+i)+2],0);
    dotrx = dot(r,x);
    if ( dotrx < cosfi ){
      //extend the cone
      q = (dotrx*x - r)*(1/length(dotrx*x-r));
      sinfi = sin(acos(cosfi));
      e = x*cosfi + q*sinfi;
      x = (e+r)*0.5;
      cosfi = dot(r,x);
    }
    //check if the origin of the ray is within the wolume
    if ( length(p-a) > EPS){
      c = normalize(p - a);
      dotcx = dot(c,x);
      if ( dotcx < cosfi){
        q = (dotcx*x - c)/length(dotcx*x-x);
        sinfi = sin(acos(cosfi));
        e = x*cosfi + q*sinfi;
        n = x*cosfi - q*sinfi;
        g = c - dot(n,c)*n;
        t = (length(g)*length(g))/dot(e,g);
        a = a - t*e;
      }
    }
  }

  //store the result
  cones[7*iGID]   = a.x;
  cones[7*iGID+1] = a.y;
  cones[7*iGID+2] = a.z;
  cones[7*iGID+3] = x.x;
  cones[7*iGID+4] = x.y;
  cones[7*iGID+5] = x.z;
  cones[7*iGID+6] = cosfi;

  if ( iGID > (total+1)/2 ) return;
  x = (float4)(cones[14*iGID+3],cones[14*iGID+4],cones[14*iGID+5],0);
  a = (float4)(cones[14*iGID],cones[14*iGID+1],cones[14*iGID+2],0);
  cosfi = cones[2*7*iGID+6];
  if ( iGID != (total+1)/2 ) {
    //posledni vlakno jen prekopiruje
    ab = (float4)(cones[2*7*iGID+7],cones[2*7*iGID+8],cones[2*7*iGID+9],0);
    xb = (float4)(cones[2*7*iGID+10],cones[2*7*iGID+11],cones[2*7*iGID+12],0);
    cosfib = cones[2*7*iGID+13];

   // x = (x+xb)*(1/(length(x+xb)));

    //average direction
    dotrx = dot(x,xb);
    if ( dotrx < cosfib && dotrx < cosfi){
      x = (x+xb)/length(x+xb);
      cosfi = cos(acos(dotrx) + acos(min(cosfib,cosfi)));
    } else {
      if ( cosfi > cosfib){
        x = xb;
        a = ab;
        cosfi = cosfib;
      }
    }


    //compute cones apex
    //move the apex
    c = ab - a;
    if ( length(c) > EPS){
      dotcx = dot(x,c);
      if ( dotcx < cosfi){
        q = (dotcx*x - c)/length(dotcx*x-x);
        sinfi = sin(acos(cosfi));
        e = x*cosfi + q*sinfi;
        n = x*cosfi - q*sinfi;
        g = c - dot(n,c)*n;
        t = (length(g)*length(g))/dot(e,g);
        a = a - t*e;
      }
    }
  }
    total = ((count+chunk-1)/chunk)*7;
    cones[total + 7*iGID]     = a.x;
    cones[total + 7*iGID + 1] = a.y;
    cones[total + 7*iGID + 2] = a.z;
    cones[total + 7*iGID + 3] = x.x;
    cones[total + 7*iGID + 4] = x.y;
    cones[total + 7*iGID + 5] = x.z;
    cones[total + 7*iGID + 6] = cosfi;


}

__kernel void IntersectionR (
    const __global float* vertex, const __global float* dir, const __global float* o,
    const __global float* cones, const __global float* bounds, const __global float* uvs,
    __global float* tHit, __global float* tutv, __global float* dp,
    __global int* index, int count, int size, int chunk   ) {
    // find position in global arrays
    int iGID = get_global_id(0);

    for ( int i = iGID; i < count; i+=size ){
      index[i] = 0; //initialize the array
    }
    // bound check (equivalent to the limit on a 'for' loop for standard/serial C code
    if (iGID >= size) return;

    // find geometry for the work-item
    float4 e1, e2, s1, s2, d,test;
    float divisor, invDivisor, b1, b2, t;

    float4 v1, v2, v3, rayd, rayo;
    v1 = (float4)(vertex[9*iGID], vertex[9*iGID+1], vertex[9*iGID+2], 0);
    v2 = (float4)(vertex[9*iGID + 3], vertex[9*iGID + 4], vertex[9*iGID + 5], 0);
    v3 = (float4)(vertex[9*iGID + 6], vertex[9*iGID + 7], vertex[9*iGID + 8], 0);
    e1 = v2 - v1;
    e2 = v3 - v1;

    float4 a,x;
    float cosfi;
    uint num0 = 7*((count+chunk-1)/(chunk));
    // process throught the cone hieararchy
    for ( int j = 0; j < (count+chunk-1)/(chunk*2); j++){
      // get cone description
      a = (float4)(cones[num0 + 7*j],cones[num0 + 7*j+1],cones[num0 + 7*j+2],0);
      x = (float4)(cones[num0 + 7*j+3],cones[num0 + 7*j+4],cones[num0 + 7*j+5],0);
      cosfi = cones[num0 + 7*j+6];
      // check if triangle intersects cone
      if ( (length(v1-a) > 0.001 && dot(normalize(v1-a),x) < cosfi)
        || (length(v2-a) > 0.001 && dot(normalize(v2-a),x) < cosfi)
        || (length(v3-a) > 0.001 && dot(normalize(v3-a),x))){
        // check 2 cones
        a = (float4)(cones[14*j],cones[14*j+1],cones[14*j+2],0);
        x = (float4)(cones[14*j+3],cones[14*j+4],cones[14*j+5],0);
        cosfi = cones[14*j+6];
        if ( (length(v1-a) > EPS && dot(normalize(v1-a),x) < cosfi)
          || (length(v2-a) > EPS && dot(normalize(v2-a),x) < cosfi)
          || (length(v3-a) > EPS && dot(normalize(v3-a),x))){          //process the rays in that cone
          intersectAllLeaves(2*j, dir, o, bounds, uvs, tutv, dp, index, tHit, v1,v2,v3,e1,e2,chunk);
        }

        a = (float4)(cones[14*j+7],cones[14*j+8],cones[14*j+9],0);
        x = (float4)(cones[14*j+10],cones[14*j+11],cones[14*j+12],0);
        cosfi = cones[14*j+13];
        if ( (length(v1-a) > EPS && dot(normalize(v1-a),x) < cosfi)
          || (length(v2-a) > EPS && dot(normalize(v2-a),x) < cosfi)
          || (length(v3-a) > EPS && dot(normalize(v3-a),x))){          //process the rays in that cone
          intersectAllLeaves(2*j+1, dir, o, bounds, uvs, tutv, dp, index, tHit, v1,v2,v3,e1,e2,chunk);
        }

      }

    }

      // get cone description
      a = (float4)(cones[7*j],cones[7*j+1],cones[7*j+2],0);
      x = (float4)(cones[7*j+3],cones[7*j+4],cones[7*j+5],0);
      cosfi = cones[7*j+6];
      // check if triangle intersects cone
      if ( dot(normalize(v1-a),x) < cosfi || dot(normalize(v2-a),x) < cosfi || dot(normalize(v3-a),x)){
        // process all rays in the cone
        for ( int i = 0; i < chunk; i++){
          rayd = (float4)(dir[3*j*chunk + 3*i], dir[3*j*chunk + 3*i+1], dir[3*j*chunk + 3*i+2], 0);
          rayo = (float4)(o[3*j*chunk + 3*i], o[3*j*chunk +3*i+1], o[3*j*chunk + 3*i+2], 0);

          s1 = cross(rayd, e2);
          divisor = dot(s1, e1);
          if ( divisor == 0.0) continue; //potrebuju nejake pole boolu
          invDivisor = 1.0f/ divisor;

         // compute first barycentric coordinate
          d = rayo - v1;
          b1 = dot(d, s1) * invDivisor;
          if ( b1 < -1e-3f  || b1 > 1.+1e-3f) continue;

          // compute second barycentric coordinate
          s2 = cross(d, e1);
          b2 = dot(rayd, s2) * invDivisor;
          if ( b2 < -1e-3f || (b1 + b2) > 1.+1e-3f) continue;

          // Compute _t_ to intersection point
          t = dot(e2, s2) * invDivisor;
          if (t < bounds[2*j*chunk + i*2]) continue;
	        //mem_fence(CLK_GLOBAL_MEM_FENCE);
          if (tHit[j*chunk+i] != INFINITY && tHit[j*chunk + i] != NAN && t > tHit[j*chunk + i]) continue;

          tHit[j*chunk + i] = t;
          index[j*chunk + i] = iGID;

          float du1 = uvs[6*iGID]   - uvs[6*iGID+4];
          float du2 = uvs[6*iGID+2] - uvs[6*iGID+4];
          float dv1 = uvs[6*iGID+1] - uvs[6*iGID+5];
          float dv2 = uvs[6*iGID+3] - uvs[6*iGID+5];
          float4 dp1 = v1 - v3;
          float4 dp2 = v2 - v3;
          float determinant = du1 * dv2 - dv1 * du2;
          if ( determinant == 0.f ) {
            float4 temp = normalize(cross(e2, e1));
            if ( fabs(temp.x) > fabs(temp.y)) {
                float invLen = rsqrt(temp.x*temp.x + temp.z*temp.z);
                dp[6*j*chunk + 6*i] = -temp.z*invLen;
                dp[6*j*chunk + 6*i+1] = 0.f;
                dp[6*j*chunk + 6*i+2] = temp.x*invLen;
            } else {
                float invLen = rsqrt(temp.y*temp.y + temp.z*temp.z);
                dp[6*j*chunk + 6*i] = 0.f;
                dp[6*j*chunk + 6*i+1] = temp.z*invLen;
                dp[6*j*chunk + 6*i+2] = -temp.y*invLen;
            }
            float4 help = cross(temp, (float4)(dp[6*j*chunk + 6*i], dp[6*j*chunk + 6*i+1], dp[6*j*chunk + 6*i+2],0));
            dp[6*j*chunk + 6*i+3] = help.x;
            dp[6*j*chunk + 6*i+4] = help.y;
            dp[6*j*chunk + 6*i+5] = help.z;
          } else {
            float invdet = 1.f / determinant;
            float4 help = (dv2 * dp1 - dv1 * dp2) * invdet;
            dp[6*j*chunk + 6*i] = help.x;
            dp[6*j*chunk + 6*i+1] = help.y;
            dp[6*j*chunk + 6*i+2] = help.z;
            help = (-du2 * dp1 + du1 * dp2) * invdet;
            dp[6*j*chunk + 6*i+3] = help.x;
            dp[6*j*chunk + 6*i+4] = help.y;
            dp[6*j*chunk + 6*i+5] = help.z;
        }

        float b0 = 1 - b1 - b2;
        tutv[2*j*chunk + 2*i] = b0*uvs[6*iGID] + b1*uvs[6*iGID+2] + b2*uvs[6*iGID+4];
        tutv[2*j*chunk + 2*i+1] = b0*uvs[6*iGID+1] + b1*uvs[6*iGID+3] + b2*uvs[6*iGID+5];
        }
      }

    }
*/
}



__kernel void IntersectionP (
const __global float* vertex, const __global float* dir, const __global float* o,
 const __global float* cones, const __global float* bounds,
__global unsigned char* tHit, int count, int size, int chunk)
{
    int iGID = get_global_id(0);
    if (iGID >= size) return;

    // process all geometry
    float4 e1, e2, s1, s2, d, test;
    float divisor, invDivisor, b1, b2, t;

    float4 v1, v2, v3, rayd, rayo;
    v1 = (float4)(vertex[9*iGID], vertex[9*iGID+1], vertex[9*iGID+2], 0);
    v2 = (float4)(vertex[9*iGID + 3], vertex[9*iGID + 4], vertex[9*iGID + 5], 0);
    v3 = (float4)(vertex[9*iGID + 6], vertex[9*iGID + 7], vertex[9*iGID + 8], 0);
    e1 = v2 - v1;
    e2 = v3 - v1;

    float4 a,x;
    float cosfi;
    uint num0 = 7*((count+chunk-1)/(chunk));
    // process throught the cone hieararchy
    for ( int j = 0; j < (count+chunk-1)/(chunk*2); j++){
      // get cone description
      a = (float4)(cones[num0 + 7*j],cones[num0 + 7*j+1],cones[num0 + 7*j+2],0);
      x = (float4)(cones[num0 + 7*j+3],cones[num0 + 7*j+4],cones[num0 + 7*j+5],0);
      cosfi = cones[num0 + 7*j+6];
      // check if triangle intersects cone
      if ( (length(v1-a) > EPS && dot(normalize(v1-a),x) < cosfi)
        || (length(v2-a) > EPS && dot(normalize(v2-a),x) < cosfi)
        || (length(v3-a) > EPS && dot(normalize(v3-a),x))){        // check 2 cones
        a = (float4)(cones[14*j],cones[14*j+1],cones[14*j+2],0);
        x = (float4)(cones[14*j+3],cones[14*j+4],cones[14*j+5],0);
        cosfi = cones[14*j+6];
        if ( (length(v1-a) > EPS && dot(normalize(v1-a),x) < cosfi)
          || (length(v2-a) > EPS && dot(normalize(v2-a),x) < cosfi)
          || (length(v3-a) > EPS && dot(normalize(v3-a),x))){           //process the rays in that cone
          intersectPAllLeaves(2*j, dir, o, bounds, tHit, v1,v2,v3,e1,e2,chunk);
        }
        a = (float4)(cones[14*j+7],cones[14*j+8],cones[14*j+9],0);
        x = (float4)(cones[14*j+10],cones[14*j+11],cones[14*j+12],0);
        cosfi = cones[14*j+13];
        if ( (length(v1-a) > EPS && dot(normalize(v1-a),x) < cosfi)
          || (length(v2-a) > EPS && dot(normalize(v2-a),x) < cosfi)
          || (length(v3-a) > EPS && dot(normalize(v3-a),x))){          //process the rays in that cone
          intersectPAllLeaves(2*j+1, dir, o, bounds, tHit, v1,v2,v3,e1,e2,chunk);
        }

      }
    }

   /* for ( int j = 0; j < count/chunk; j++){
      // get cone description
      a = (float4)(cones[7*j],cones[7*j+1],cones[7*j+2],0);
      x = (float4)(cones[7*j+3],cones[7*j+4],cones[7*j+5],0);
      cosfi = cones[7*j+6];
      // check if triangle intersects cone
      if ( dot(normalize(v1-a),x) < cosfi || dot(normalize(v2-a),x) < cosfi || dot(normalize(v3-a),x)){
        // process all rays in the cone
        for ( int i = 0; i < chunk; i++){
          rayd = (float4)(dir[3*j*chunk + 3*i], dir[3*j*chunk + 3*i+1], dir[3*j*chunk + 3*i+2], 0);
          rayo = (float4)(o[3*j*chunk + 3*i], o[3*j*chunk +3*i+1], o[3*j*chunk + 3*i+2], 0);
          s1 = cross(rayd, e2);
          divisor = dot(s1, e1);
          if ( divisor == 0.0) continue;
          invDivisor = 1.0f/ divisor;

	        // compute first barycentric coordinate
	        d = rayo - v1;
	        b1 = dot(d, s1) * invDivisor;
	        if ( b1 < -1e-3f  || b1 > 1.+1e-3f) continue;

	        // compute second barycentric coordinate
	        s2 = cross(d, e1);
	        b2 = dot(rayd, s2) * invDivisor;
	        if ( b2 < -1e-3f || (b1 + b2) > 1.+1e-3f) continue;

	        // Compute _t_ to intersection point
	        t = dot(e2, s2) * invDivisor;
          if (t < bounds[2*j*chunk + i*2]) continue;
	        //mem_fence(CLK_GLOBAL_MEM_FENCE);
          if (tHit[j*chunk+i] != INFINITY && tHit[j*chunk + i] != NAN && t > tHit[j*chunk + i]) continue;
	        tHit[j*chunk+i] = '1';
        }
      }
    }*/
}

