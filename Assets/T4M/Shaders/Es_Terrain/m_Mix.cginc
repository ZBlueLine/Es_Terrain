float getChannelValue(float4 clr,int index )
{
   //return index==0?clr.r:(index==1?clr.g:(index==2?clr.b:clr.a));
   // 应该这样纯数学计算性能更高 （未测试验证）
   const uint  step=256;
   uint v=(uint)(clr.r*step)+(uint)(clr.g*step)*step+(uint)(clr.b*step)*step*step+(uint)(clr.a*step)*step*step*step;
   v/= (uint)(pow(step,(float)index)+0.5);
   return (v%step)/(float)step;
}

float2 getuv(int id)
{
    float2 uv;
    uv.x = (float)(id % 4)/4;
    uv.y = (float)(id / 4)/4;
    return uv;
}