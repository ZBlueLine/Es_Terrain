Shader "Es_Terrain/Blender"
{
    Properties{
        _BlockMainTex("Block MainTexture", 2D) = "white" {}
<<<<<<< HEAD
        _WeightTex("Weight Texture", 2D) = "white" {}
=======
        _SplatTex("Splat Texture", 2D) = "white" {}
>>>>>>> 6ec3da6507f4ab3ad1dd7ee0ccdd4eed930e5e25
        _IDTex("ID Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        _BlockScale("Block Scale", float) = 1.0
    }

    SubShader{
        Pass{
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
<<<<<<< HEAD
            #include "m_Mix.cginc"

            sampler2D _BlockMainTex;
            sampler2D _WeightTex;
            sampler2D _IDTex;
            float4 _IDTex_ST;
            float4 _WeightTex_ST;
=======

            sampler2D _BlockMainTex;
            sampler2D _SplatTex;
            sampler2D _IDTex;
            float4 _IDTex_ST;
            float4 _SplatTex_ST;
>>>>>>> 6ec3da6507f4ab3ad1dd7ee0ccdd4eed930e5e25
            
            fixed4 _Color;
            float _BlockScale;

            struct a2v{
                float4 texcoord : TEXCOORD0;
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct v2f{
                float4 pos : SV_POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                float4 worldpos : TEXCOORD1;
<<<<<<< HEAD
                float2 uvw : TEXCOORD2;
=======
>>>>>>> 6ec3da6507f4ab3ad1dd7ee0ccdd4eed930e5e25
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldpos = mul(unity_ObjectToWorld, v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
<<<<<<< HEAD
                o.uv = v.texcoord.xy * _IDTex_ST.xy + _IDTex_ST.zw;
                o.uvw = v.texcoord.xy * _WeightTex_ST.xy + _WeightTex_ST.zw;
=======
                o.uv = v.texcoord.xy * _SplatTex_ST.xy + _SplatTex_ST.zw;
>>>>>>> 6ec3da6507f4ab3ad1dd7ee0ccdd4eed930e5e25
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 worldSpaceLightDir = normalize(UnityWorldSpaceLightDir(i.pos));
<<<<<<< HEAD

                fixed4 IdCoord = tex2D(_IDTex, i.uv);
                
                int id0 = IdCoord.r * 16;
                int id1 = IdCoord.g * 16;
                int id2 = IdCoord.b * 16;

                i.uvw *= 0.5f;
                int idx = id1 / 4 % 2;
                int idy = id1 / 4 / 2;

                float4 Weight = tex2D(_WeightTex, i.uvw + float2(idx*0.5, idy*0.5));
                float Weight1 = getChannelValue(Weight, IdCoord.g * 16 % 4);

                idx = id2 / 4 % 2;
                idy = id2 / 4 / 2;

                Weight = tex2D(_WeightTex, i.uvw + float2(idx*0.5, idy*0.5));
                float Weight2 = getChannelValue(Weight, IdCoord.b * 16 % 4);

                float Weight0 = 1 - Weight1 - Weight2;
                
                // return fixed4(Weight1, Weight2, Weight3, 1.0);

=======
                fixed4 SamplerCoord = tex2D(_SplatTex, i.uv);
                //return fixed4(SamplerCoord.xyz, 1.0);
                float blendRatio = tex2D(_SplatTex, i.uv).z;

                float2 twoVerticalIndices;
                float2 twoHorizontalIndices;
                twoVerticalIndices = floor(SamplerCoord.rg * 16.0);
                twoHorizontalIndices = (floor(SamplerCoord.rg * 256.0)) - (twoVerticalIndices.xy * 16);
                //return fixed4(twoVerticalIndices.y, 0, 0, 1.0);
                float4 decodeIndices;
                decodeIndices.x = twoVerticalIndices.x;
                decodeIndices.y = twoHorizontalIndices.x;
                decodeIndices.z = twoVerticalIndices.y;
                decodeIndices.w = twoHorizontalIndices.y;
                decodeIndices = floor(decodeIndices/4)/4;
                
>>>>>>> 6ec3da6507f4ab3ad1dd7ee0ccdd4eed930e5e25
                float2 worldScale = i.worldpos.xz * _BlockScale;
                float2 worldUv = 0.234375 * frac(worldScale) + 0.0078125;

                float2 dx = clamp(0.234375 * ddx(worldScale), -0.0078125, 0.0078125);
                float2 dy = clamp(0.234375 * ddy(worldScale), -0.0078125, 0.0078125);
<<<<<<< HEAD
                
                float2 uv0 = worldUv + getuv(id0);
                float2 uv1 = worldUv + getuv(id1);
                float2 uv2 = worldUv + getuv(id2);

                float4 col0 = tex2D(_BlockMainTex, uv0, dx, dy);
                float4 col1 = tex2D(_BlockMainTex, uv1, dx, dy);
                float4 col2 = tex2D(_BlockMainTex, uv2, dx, dy);

                float4 diffuseColor = col0 * Weight0 + col1 * Weight1 + col2 * Weight2;
                return fixed4(diffuseColor.rgb, 1);
                //return fixed4(SamplerCoord.xyz, 1.0);

                // float2 twoVerticalIndices;
                // float2 twoHorizontalIndices;
                // twoVerticalIndices = floor(SamplerCoord.rg * 16.0);
                // twoHorizontalIndices = (floor(SamplerCoord.rg * 256.0)) - (twoVerticalIndices.xy * 16);
                // //return fixed4(twoVerticalIndices.y, 0, 0, 1.0);
                // float4 decodeIndices;
                // decodeIndices.x = twoVerticalIndices.x;
                // decodeIndices.y = twoHorizontalIndices.x;
                // decodeIndices.z = twoVerticalIndices.y;
                // decodeIndices.w = twoHorizontalIndices.y;
                // decodeIndices = floor(decodeIndices/4)/4;
                


                // float2 uv0 = worldUv + decodeIndices.yx;
                // float2 uv1 = worldUv + decodeIndices.wz;
                

                // float4 diffuseColor = lerp(col0, col1, blendRatio);
=======

                float2 uv0 = worldUv + decodeIndices.yx;
                float2 uv1 = worldUv + decodeIndices.wz;
                
                float4 col0 = tex2D(_BlockMainTex, uv0, dx, dy);
                float4 col1 = tex2D(_BlockMainTex, uv1, dx, dy);

                float4 diffuseColor = lerp(col0, col1, blendRatio);
>>>>>>> 6ec3da6507f4ab3ad1dd7ee0ccdd4eed930e5e25
                

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;
                fixed3 diffuse = _LightColor0.rgb * diffuseColor.rgb * max(0, dot(i.normal, worldSpaceLightDir));
                return fixed4(diffuse, 1.0);
            }
<<<<<<< HEAD
=======

>>>>>>> 6ec3da6507f4ab3ad1dd7ee0ccdd4eed930e5e25
            ENDCG
        }
    }
}
