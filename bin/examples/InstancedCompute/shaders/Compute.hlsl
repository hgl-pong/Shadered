Texture2D<float> heightMap:register(t0);
RWTexture2D<float> waterMap :register(u0);

cbuffer conParams : register(b0)
{
	uint2 center;
	uint radius;
	float height;
};
bool isInBound(uint2 uv)
{
    if (uv.x < center.x-radius || uv.x > center.x+radius)
        return false;
    if (uv.y < center.y-radius || uv.y > center.y+radius)
        return false;
    int dx=uv.x-center.x;
    int dy=uv.y-center.y;
  	return dx*dx+dy*dy <= radius*radius;
}

[numthreads(32, 32, 1)]
void main(uint3 DTid : SV_DispatchThreadID)
{
    uint2 pixel = DTid.xy;
	if(isInBound(pixel))
        waterMap[pixel] = height;
    else
    	waterMap[pixel] = heightMap[pixel];
}
