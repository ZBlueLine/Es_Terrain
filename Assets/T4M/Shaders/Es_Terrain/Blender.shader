Shader "Es_Terrain/Blender"
{
    Properties{
        _BlockMainTex("Block MainTexture", 2D) = "white" {}
        _NormalTex("Normal Texture", 2D) = "bump" {}
        _WeightTex("Weight Texture", 2D) = "white" {}
        _IDTex("ID Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        _BlockScale("Block Scale", float) = 1.0
    }

    SubShader{
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry"}
        Pass{

            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            #include "m_Mix.cginc"

            sampler2D _BlockMainTex;
            sampler2D _WeightTex;
            sampler2D _IDTex;
            sampler2D _NormalTex;

            float4 _IDTex_ST;
            float4 _WeightTex_ST;
            
            fixed4 _Color;
            float _BlockScale;

            struct a2v{
                float4 texcoord : TEXCOORD0;
                float4 vertex : POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
            };
            struct v2f{
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 worldpos : TEXCOORD1;
                float2 uvw : TEXCOORD2;
                float4 TtoW0 : TEXCOORD3;
                float4 TtoW1 : TEXCOORD4;
                float4 TtoW2 : TEXCOORD5;
                SHADOW_COORDS(6)
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldpos = mul(unity_ObjectToWorld, v.vertex);
                float3 worldPos = o.worldpos.xyz;
                o.uv = v.texcoord.xy * _IDTex_ST.xy + _IDTex_ST.zw;
                o.uvw = v.texcoord.xy * _WeightTex_ST.xy + _WeightTex_ST.zw;

                fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;


                o.TtoW0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
                o.TtoW1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
                o.TtoW2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
                TRANSFER_SHADOW(o);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 worldSpaceLightDir = normalize(UnityWorldSpaceLightDir(i.worldpos));

                fixed4 IdCoord = tex2D(_IDTex, i.uv);
                
                int id0 = round(IdCoord.r * 16);
                int id1 = round(IdCoord.g * 16);
                int id2 = round(IdCoord.b * 16);

                i.uvw *= 0.5f;
                int idx = id1 / 4 % 2;
                int idy = id1 / 4 / 2;

                float4 Weight = tex2D(_WeightTex, i.uvw + float2(idx*0.5, idy*0.5));
                float Weight1 = getChannelValue(Weight, id1 % 4);

                idx = id2 / 4 % 2;
                idy = id2 / 4 / 2;

                Weight = tex2D(_WeightTex, i.uvw + float2(idx*0.5, idy*0.5));
                float Weight2 = getChannelValue(Weight, id2 % 4);

                idx = id0 / 4 % 2;
                idy = id0 / 4 / 2;

                float Weight0 = 1 - Weight1 - Weight2;

                float2 worldScale = i.worldpos.xz * _BlockScale;
                float2 worldUv = 0.248046875 * frac(worldScale) + 0.0009765625;

                float2 dx = clamp(0.248046875 * ddx(worldScale), -0.0009765625, 0.0009765625);
                float2 dy = clamp(0.248046875 * ddy(worldScale), -0.0009765625, 0.0009765625);
                
                float2 uv0 = worldUv + getuv(id0);
                float2 uv1 = worldUv + getuv(id1);
                float2 uv2 = worldUv + getuv(id2);

                float4 col0 = tex2D(_BlockMainTex, uv0, dx, dy);
                float4 col1 = tex2D(_BlockMainTex, uv1, dx, dy);
                float4 col2 = tex2D(_BlockMainTex, uv2, dx, dy);


                float3 normal0 = UnpackNormal(tex2D(_NormalTex, uv0));
                float3 normal1 = UnpackNormal(tex2D(_NormalTex, uv1));

                float3 normal = normal0 * Weight0 + normal1 * Weight1;
                float4 diffuseColor = col0 * Weight0 + col1 * Weight1 + col2 * Weight2;

                //之后修改一下

                //normal = normalize(normal);
                normal = normalize(half3(dot(i.TtoW0.xyz, normal), dot(i.TtoW1.xyz, normal), dot(i.TtoW2.xyz, normal)));
                //return fixed4(normal.x, normal.y, normal.z, 1.0);

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;// *_Color.rgb;
                fixed3 diffuse = _LightColor0.rgb * diffuseColor.rgb * max(0, dot(normal, worldSpaceLightDir));

                UNITY_LIGHT_ATTENUATION(atten, i, i.worldpos.xyz);

                return fixed4(ambient + diffuse , 1.0);
            }
            ENDCG
        }
        Pass{

            Tags { "LightMode" = "ForwardAdd" }
            
            Blend one one

            CGPROGRAM

            #pragma multi_compile_fwdadd

            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            #include "m_Mix.cginc"

            sampler2D _BlockMainTex;
            sampler2D _WeightTex;
            sampler2D _IDTex;
            sampler2D _NormalTex;

            float4 _IDTex_ST;
            float4 _WeightTex_ST;

            fixed4 _Color;
            float _BlockScale;

            struct a2v {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
            };
            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 worldpos : TEXCOORD1;
                float2 uvw : TEXCOORD2;
                float4 TtoW0 : TEXCOORD3;
                float4 TtoW1 : TEXCOORD4;
                float4 TtoW2 : TEXCOORD5;
                SHADOW_COORDS(6)
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldpos = mul(unity_ObjectToWorld, v.vertex);
                float3 worldPos = o.worldpos.xyz;
                o.uv = v.texcoord.xy * _IDTex_ST.xy + _IDTex_ST.zw;
                o.uvw = v.texcoord.xy * _WeightTex_ST.xy + _WeightTex_ST.zw;

                fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;


                o.TtoW0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
                o.TtoW1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
                o.TtoW2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
                TRANSFER_SHADOW(o);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 worldSpaceLightDir = normalize(UnityWorldSpaceLightDir(i.worldpos.xyz));

                fixed4 IdCoord = tex2D(_IDTex, i.uv);

                int id0 = round(IdCoord.r * 16);
                int id1 = round(IdCoord.g * 16);
                int id2 = round(IdCoord.b * 16);

                i.uvw *= 0.5f;
                int idx = id1 / 4 % 2;
                int idy = id1 / 4 / 2;

                float4 Weight = tex2D(_WeightTex, i.uvw + float2(idx * 0.5, idy * 0.5));
                float Weight1 = getChannelValue(Weight, id1 % 4);

                idx = id2 / 4 % 2;
                idy = id2 / 4 / 2;

                Weight = tex2D(_WeightTex, i.uvw + float2(idx * 0.5, idy * 0.5));
                float Weight2 = getChannelValue(Weight, id2 % 4);

                idx = id0 / 4 % 2;
                idy = id0 / 4 / 2;

                float Weight0 = 1 - Weight1 - Weight2;

                float2 worldScale = i.worldpos.xz * _BlockScale;
                float2 worldUv = 0.248046875 * frac(worldScale) + 0.0009765625;

                float2 dx = clamp(0.248046875 * ddx(worldScale), -0.0009765625, 0.0009765625);
                float2 dy = clamp(0.248046875 * ddy(worldScale), -0.0009765625, 0.0009765625);

                float2 uv0 = worldUv + getuv(id0);
                float2 uv1 = worldUv + getuv(id1);
                float2 uv2 = worldUv + getuv(id2);

                float4 col0 = tex2D(_BlockMainTex, uv0, dx, dy);
                float4 col1 = tex2D(_BlockMainTex, uv1, dx, dy);
                float4 col2 = tex2D(_BlockMainTex, uv2, dx, dy);


                float3 normal0 = UnpackNormal(tex2D(_NormalTex, uv0, dx, dy));
                float3 normal1 = UnpackNormal(tex2D(_NormalTex, uv1, dx, dy));

                float3 normal = normal0 * Weight0 + normal1 * Weight1;
                float4 diffuseColor = col0 * Weight0 + col1 * Weight1 + col2 * Weight2;

                normal = normalize(normal);
                //return fixed4(normal.x, normal.y, normal.z, 1.0);

                normal = normalize(half3(dot(i.TtoW0.xyz, normal), dot(i.TtoW1.xyz, normal), dot(i.TtoW2.xyz, normal)));
                UNITY_LIGHT_ATTENUATION(atten, i, i.worldpos.xyz);

                fixed3 diffuse = _LightColor0.rgb * diffuseColor.rgb * max(0, dot(normal, worldSpaceLightDir));

                return fixed4(diffuse * atten, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
