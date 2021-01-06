﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Es_Terrain/16 Bumped Diffuse" {
	Properties {
		_Color ("Color Tint", Color) = (1, 1, 1, 1)
		_Splat0("Layer1 (RGB)", 2D) = "white" {}
		_Splat1("Layer2 (RGB)", 2D) = "white" {}
		_Splat2("Layer3 (RGB)", 2D) = "white" {}
		_Splat3("Layer4 (RGB)", 2D) = "white" {}
		_Splat4("Layer5 (RGB)", 2D) = "white" {}
		_Splat5("Layer6 (RGB)", 2D) = "white" {}
		_Splat6("Layer7 (RGB)", 2D) = "white" {}
		_Splat7("Layer8 (RGB)", 2D) = "white" {}
		_Splat8("Layer9 (RGB)", 2D) = "white" {}
		_Splat9("Layer10 (RGB)", 2D) = "white" {}
		_Splat10("Layer11 (RGB)", 2D) = "white" {}
		_Splat11("Layer12 (RGB)", 2D) = "white" {}
		_Splat12("Layer13 (RGB)", 2D) = "white" {}
		_Splat13("Layer14 (RGB)", 2D) = "white" {}
		_Splat14("Layer15 (RGB)", 2D) = "white" {}
		_Splat15("Layer16 (RGB)", 2D) = "white" {}

		_BumpSplat0("Bump1", 2D) = "bump" {}
		_BumpSplat1("Bump2", 2D) = "bump" {}
		_BumpSplat2("Bump3", 2D) = "bump" {}
		_BumpSplat3("Bump4", 2D) = "bump" {}
		_BumpSplat4("Bump5", 2D) = "bump" {}
		_BumpSplat5("Bump6", 2D) = "bump" {}
		_BumpSplat6("Bump7", 2D) = "bump" {}
		_BumpSplat7("Bump8", 2D) = "bump" {}
		_BumpSplat8("Bump9", 2D) = "bump" {}
		_BumpSplat9("Bump10", 2D) = "bump" {}
		_BumpSplat10("Bump11", 2D) = "bump" {}
		_BumpSplat11("Bump12", 2D) = "bump" {}
		_BumpSplat12("Bump13", 2D) = "bump" {}
		_BumpSplat13("Bump14", 2D) = "bump" {}
		_BumpSplat14("Bump15", 2D) = "bump" {}
		_BumpSplat15("Bump16", 2D) = "bump" {}
				  
		_Control("BumpSplat1 (RGB)", 2D) = "white" {}
		_Control2("Splat2 (RGB)", 2D) = "white" {}
		_Control3("Splat3 (RGB)", 2D) = "white" {}
		_Control4("Splat4 (RGB)", 2D) = "white" {}

		//_BumpMap ("Normal Map", 2D) = "bump" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" "Queue"="Geometry"}

		Pass { 
			Tags { "LightMode"="ForwardBase" }
		
			CGPROGRAM
			
			#pragma multi_compile_fwdbase
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			Texture2D  _Control;
			Texture2D  _Control2;
			Texture2D  _Control3;
			Texture2D  _Control4;

			sampler2D  _BumpMap;
			float4 _BumpMap_ST;

			Texture2D _Splat0;
			Texture2D _Splat1;
			Texture2D _Splat2;
			Texture2D _Splat3;
			Texture2D _Splat4;
			Texture2D _Splat5;
			Texture2D _Splat6;
			Texture2D _Splat7;
			Texture2D _Splat8;
			Texture2D _Splat9;
			Texture2D _Splat10;
			Texture2D _Splat11;
			Texture2D _Splat12;
			Texture2D _Splat13;
			Texture2D _Splat14;
			Texture2D _Splat15;

			Texture2D _BumpSplat0;
			Texture2D _BumpSplat1;
			Texture2D _BumpSplat2;
			Texture2D _BumpSplat3;
			Texture2D _BumpSplat4;
			Texture2D _BumpSplat5;
			Texture2D _BumpSplat6;
			Texture2D _BumpSplat7;
			Texture2D _BumpSplat8;
			Texture2D _BumpSplat9;
			Texture2D _BumpSplat10; 
			Texture2D _BumpSplat11; 
			Texture2D _BumpSplat12; 
			Texture2D _BumpSplat13; 
			Texture2D _BumpSplat14; 
			Texture2D _BumpSplat15; 

			float4 _Splat0_ST;
			float4 _Splat1_ST;
			float4 _Splat2_ST;
			float4 _Splat3_ST;
			float4 _Splat4_ST;
			float4 _Splat5_ST;
			float4 _Splat6_ST;
			float4 _Splat7_ST;
			float4 _Splat8_ST;
			float4 _Splat9_ST;
			float4 _Splat10_ST;
			float4 _Splat11_ST;
			float4 _Splat12_ST;
			float4 _Splat13_ST;
			float4 _Splat14_ST;
			float4 _Splat15_ST;

			SamplerState  sampler_Control;
			fixed4 _Color;


			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float4 TtoW0 : TEXCOORD1;  
				float4 TtoW1 : TEXCOORD2;  
				float4 TtoW2 : TEXCOORD3;
				SHADOW_COORDS(4)
			};
			
			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = v.texcoord.xy;

				o.uv.zw = TRANSFORM_TEX(v.texcoord, _BumpMap);
				
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;  
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);  
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);  
				fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w; 
				
				o.TtoW0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.TtoW1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.TtoW2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
				TRANSFER_SHADOW(o);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				float3 worldPos = float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);
				fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));

				fixed4 Cid1 = _Control.Sample(sampler_Control, i.uv.xy);
				fixed4 Cid2 = _Control2.Sample(sampler_Control, i.uv.xy);
				fixed4 Cid3 = _Control3.Sample(sampler_Control, i.uv.xy);
				fixed4 Cid4 = _Control4.Sample(sampler_Control, i.uv.xy);

				fixed3 Splat_color0 = _Splat0.Sample(sampler_Control, frac(i.uv.xy * _Splat0_ST));
				fixed3 Splat_color1 = _Splat1.Sample(sampler_Control, frac(i.uv.xy * _Splat1_ST));
				fixed3 Splat_color2 = _Splat2.Sample(sampler_Control, frac(i.uv.xy * _Splat2_ST));
				fixed3 Splat_color3 = _Splat3.Sample(sampler_Control, frac(i.uv.xy * _Splat3_ST));
				fixed3 Splat_color4 = _Splat4.Sample(sampler_Control, frac(i.uv.xy * _Splat4_ST));
				fixed3 Splat_color5 = _Splat5.Sample(sampler_Control, frac(i.uv.xy * _Splat5_ST));
				fixed3 Splat_color6 = _Splat6.Sample(sampler_Control, frac(i.uv.xy * _Splat6_ST));
				fixed3 Splat_color7 = _Splat7.Sample(sampler_Control, frac(i.uv.xy * _Splat7_ST));
				fixed3 Splat_color8 = _Splat8.Sample(sampler_Control, frac(i.uv.xy * _Splat8_ST));
				fixed3 Splat_color9 = _Splat9.Sample(sampler_Control, frac(i.uv.xy * _Splat9_ST));
				fixed3 Splat_color10 = _Splat10.Sample(sampler_Control, frac(i.uv.xy * _Splat10_ST));
				fixed3 Splat_color11 = _Splat11.Sample(sampler_Control, frac(i.uv.xy * _Splat11_ST));
				fixed3 Splat_color12 = _Splat12.Sample(sampler_Control, frac(i.uv.xy * _Splat12_ST));
				fixed3 Splat_color13 = _Splat13.Sample(sampler_Control, frac(i.uv.xy * _Splat13_ST));
				fixed3 Splat_color14 = _Splat14.Sample(sampler_Control, frac(i.uv.xy * _Splat14_ST));
				fixed3 Splat_color15 = _Splat15.Sample(sampler_Control, frac(i.uv.xy * _Splat15_ST));


				//采样法贴
				fixed3 normal0 = UnpackNormal(_BumpSplat0.Sample(sampler_Control, frac(i.uv.xy * _Splat0_ST)));
				fixed3 normal1 = UnpackNormal(_BumpSplat1.Sample(sampler_Control, frac(i.uv.xy * _Splat1_ST)));
				fixed3 normal2 = UnpackNormal(_BumpSplat2.Sample(sampler_Control, frac(i.uv.xy * _Splat2_ST)));
				fixed3 normal3 = UnpackNormal(_BumpSplat3.Sample(sampler_Control, frac(i.uv.xy * _Splat3_ST)));
				fixed3 normal4 = UnpackNormal(_BumpSplat4.Sample(sampler_Control, frac(i.uv.xy * _Splat4_ST)));
				fixed3 normal5 = UnpackNormal(_BumpSplat5.Sample(sampler_Control, frac(i.uv.xy * _Splat5_ST)));
				fixed3 normal6 = UnpackNormal(_BumpSplat6.Sample(sampler_Control, frac(i.uv.xy * _Splat6_ST)));
				fixed3 normal7 = UnpackNormal(_BumpSplat7.Sample(sampler_Control, frac(i.uv.xy * _Splat7_ST)));
				fixed3 normal8 = UnpackNormal(_BumpSplat8.Sample(sampler_Control, frac(i.uv.xy * _Splat8_ST)));
				fixed3 normal9 = UnpackNormal(_BumpSplat9.Sample(sampler_Control, frac(i.uv.xy * _Splat9_ST)));
				fixed3 normal10 = UnpackNormal(_BumpSplat10.Sample(sampler_Control, frac(i.uv.xy * _Splat10_ST)));
				fixed3 normal11 = UnpackNormal(_BumpSplat11.Sample(sampler_Control, frac(i.uv.xy * _Splat11_ST)));
				fixed3 normal12 = UnpackNormal(_BumpSplat12.Sample(sampler_Control, frac(i.uv.xy * _Splat12_ST)));
				fixed3 normal13 = UnpackNormal(_BumpSplat13.Sample(sampler_Control, frac(i.uv.xy * _Splat13_ST)));
				fixed3 normal14 = UnpackNormal(_BumpSplat14.Sample(sampler_Control, frac(i.uv.xy * _Splat14_ST)));
				fixed3 normal15 = UnpackNormal(_BumpSplat15.Sample(sampler_Control, frac(i.uv.xy * _Splat15_ST)));


				fixed3 albedo = Cid1.r * Splat_color0.rgb;
				albedo += Cid1.g * Splat_color1.rgb;
				albedo += Cid1.b * Splat_color2.rgb;
				albedo += Cid1.a * Splat_color3.rgb;
				albedo += Cid2.r * Splat_color4.rgb;
				albedo += Cid2.g * Splat_color5.rgb;
				albedo += Cid2.b * Splat_color6.rgb;
				albedo += Cid2.a * Splat_color7.rgb;
				albedo += Cid3.r * Splat_color8.rgb;
				albedo += Cid3.g * Splat_color9.rgb;
				albedo += Cid3.b * Splat_color10.rgb;
				albedo += Cid3.a * Splat_color11.rgb;
				albedo += Cid4.r * Splat_color12.rgb;
				albedo += Cid4.g * Splat_color13.rgb;
				albedo += Cid4.b * Splat_color14.rgb;
				albedo += Cid4.a * Splat_color15.rgb;


				fixed3 normal = Cid1.r * normal0;
				normal += Cid1.g * normal1;
				normal += Cid1.b * normal2;
				normal += Cid1.a * normal3;
				normal += Cid2.r * normal4;
				normal += Cid2.g * normal5;
				normal += Cid2.b * normal6;
				normal += Cid2.a * normal7;
				normal += Cid3.r * normal8;
				normal += Cid3.g * normal9;
				normal += Cid3.b * normal10;
				normal += Cid3.a * normal11;
				normal += Cid4.r * normal12;
				normal += Cid4.g * normal13;
				normal += Cid4.b * normal14;
				normal += Cid4.a * normal15;
				normal = normalize(normal);

				normal = normalize(half3(dot(i.TtoW0.xyz, normal), dot(i.TtoW1.xyz, normal), dot(i.TtoW2.xyz, normal)));
			
				//fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Color.rgb;
				
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
			
			 	fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(normal, lightDir));
				
				UNITY_LIGHT_ATTENUATION(atten, i, worldPos);
				
				return fixed4(ambient + diffuse * atten, 1.0);
			}
			
			ENDCG
		}
		
		Pass { 
			Tags { "LightMode"="ForwardAdd" }
			
			Blend One One

			CGPROGRAM

			#pragma multi_compile_fwdadd

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			Texture2D  _Control;
			Texture2D  _Control2;
			Texture2D  _Control3;
			Texture2D  _Control4;
			SamplerState  sampler_Control;

			sampler2D  _BumpMap;
			float4 _BumpMap_ST;

			Texture2D _Splat0;
			Texture2D _Splat1;
			Texture2D _Splat2;
			Texture2D _Splat3;
			Texture2D _Splat4;
			Texture2D _Splat5;
			Texture2D _Splat6;
			Texture2D _Splat7;
			Texture2D _Splat8;
			Texture2D _Splat9;
			Texture2D _Splat10;
			Texture2D _Splat11;
			Texture2D _Splat12;
			Texture2D _Splat13;
			Texture2D _Splat14;
			Texture2D _Splat15;

			Texture2D _BumpSplat0;
			Texture2D _BumpSplat1;
			Texture2D _BumpSplat2;
			Texture2D _BumpSplat3;
			Texture2D _BumpSplat4;
			Texture2D _BumpSplat5;
			Texture2D _BumpSplat6;
			Texture2D _BumpSplat7;
			Texture2D _BumpSplat8;
			Texture2D _BumpSplat9;
			Texture2D _BumpSplat10;
			Texture2D _BumpSplat11;
			Texture2D _BumpSplat12;
			Texture2D _BumpSplat13;
			Texture2D _BumpSplat14;
			Texture2D _BumpSplat15;

			float _Splat0_ST;
			float _Splat1_ST;
			float _Splat2_ST;
			float _Splat3_ST;
			float _Splat4_ST;
			float _Splat5_ST;
			float _Splat6_ST;
			float _Splat7_ST;
			float _Splat8_ST;
			float _Splat9_ST;
			float _Splat10_ST;
			float _Splat11_ST;
			float _Splat12_ST;
			float _Splat13_ST;
			float _Splat14_ST;
			float _Splat15_ST;

			fixed4 _Color;


			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float4 TtoW0 : TEXCOORD1;
				float4 TtoW1 : TEXCOORD2;
				float4 TtoW2 : TEXCOORD3;
				SHADOW_COORDS(4)
			};

			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = v.texcoord.xy;

				o.uv.zw = TRANSFORM_TEX(v.texcoord, _BumpMap);

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;

				o.TtoW0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.TtoW1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.TtoW2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
				TRANSFER_SHADOW(o);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				float3 worldPos = float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);
				fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));

				fixed4 Cid1 = _Control.Sample(sampler_Control, i.uv.xy);
				fixed4 Cid2 = _Control2.Sample(sampler_Control, i.uv.xy);
				fixed4 Cid3 = _Control3.Sample(sampler_Control, i.uv.xy);
				fixed4 Cid4 = _Control4.Sample(sampler_Control, i.uv.xy);

				//采样图像
				fixed3 Splat_color0 = _Splat0.Sample(sampler_Control, frac(i.uv.xy * _Splat0_ST));
				fixed3 Splat_color1 = _Splat1.Sample(sampler_Control, frac(i.uv.xy * _Splat1_ST));
				fixed3 Splat_color2 = _Splat2.Sample(sampler_Control, frac(i.uv.xy * _Splat2_ST));
				fixed3 Splat_color3 = _Splat3.Sample(sampler_Control, frac(i.uv.xy * _Splat3_ST));
				fixed3 Splat_color4 = _Splat4.Sample(sampler_Control, frac(i.uv.xy * _Splat4_ST));
				fixed3 Splat_color5 = _Splat5.Sample(sampler_Control, frac(i.uv.xy * _Splat5_ST));
				fixed3 Splat_color6 = _Splat6.Sample(sampler_Control, frac(i.uv.xy * _Splat6_ST));
				fixed3 Splat_color7 = _Splat7.Sample(sampler_Control, frac(i.uv.xy * _Splat7_ST));
				fixed3 Splat_color8 = _Splat8.Sample(sampler_Control, frac(i.uv.xy * _Splat8_ST));
				fixed3 Splat_color9 = _Splat9.Sample(sampler_Control, frac(i.uv.xy * _Splat9_ST));
				fixed3 Splat_color10 = _Splat10.Sample(sampler_Control, frac(i.uv.xy * _Splat10_ST));
				fixed3 Splat_color11 = _Splat11.Sample(sampler_Control, frac(i.uv.xy * _Splat11_ST));
				fixed3 Splat_color12 = _Splat12.Sample(sampler_Control, frac(i.uv.xy * _Splat12_ST));
				fixed3 Splat_color13 = _Splat13.Sample(sampler_Control, frac(i.uv.xy * _Splat13_ST));
				fixed3 Splat_color14 = _Splat14.Sample(sampler_Control, frac(i.uv.xy * _Splat14_ST));
				fixed3 Splat_color15 = _Splat15.Sample(sampler_Control, frac(i.uv.xy * _Splat15_ST));

				//采样法贴
				fixed3 normal0 = UnpackNormal(_BumpSplat0.Sample(sampler_Control, frac(i.uv.xy * _Splat0_ST)));
				fixed3 normal1 = UnpackNormal(_BumpSplat1.Sample(sampler_Control, frac(i.uv.xy * _Splat1_ST)));
				fixed3 normal2 = UnpackNormal(_BumpSplat2.Sample(sampler_Control, frac(i.uv.xy * _Splat2_ST)));
				fixed3 normal3 = UnpackNormal(_BumpSplat3.Sample(sampler_Control, frac(i.uv.xy * _Splat3_ST)));
				fixed3 normal4 = UnpackNormal(_BumpSplat4.Sample(sampler_Control, frac(i.uv.xy * _Splat4_ST)));
				fixed3 normal5 = UnpackNormal(_BumpSplat5.Sample(sampler_Control, frac(i.uv.xy * _Splat5_ST)));
				fixed3 normal6 = UnpackNormal(_BumpSplat6.Sample(sampler_Control, frac(i.uv.xy * _Splat6_ST)));
				fixed3 normal7 = UnpackNormal(_BumpSplat7.Sample(sampler_Control, frac(i.uv.xy * _Splat7_ST)));
				fixed3 normal8 = UnpackNormal(_BumpSplat8.Sample(sampler_Control, frac(i.uv.xy * _Splat8_ST)));
				fixed3 normal9 = UnpackNormal(_BumpSplat9.Sample(sampler_Control, frac(i.uv.xy * _Splat9_ST)));
				fixed3 normal10 = UnpackNormal(_BumpSplat10.Sample(sampler_Control, frac(i.uv.xy * _Splat10_ST)));
				fixed3 normal11 = UnpackNormal(_BumpSplat11.Sample(sampler_Control, frac(i.uv.xy * _Splat11_ST)));
				fixed3 normal12 = UnpackNormal(_BumpSplat12.Sample(sampler_Control, frac(i.uv.xy * _Splat12_ST)));
				fixed3 normal13 = UnpackNormal(_BumpSplat13.Sample(sampler_Control, frac(i.uv.xy * _Splat13_ST)));
				fixed3 normal14 = UnpackNormal(_BumpSplat14.Sample(sampler_Control, frac(i.uv.xy * _Splat14_ST)));
				fixed3 normal15 = UnpackNormal(_BumpSplat15.Sample(sampler_Control, frac(i.uv.xy * _Splat15_ST)));


				fixed3 albedo = Cid1.r * Splat_color0.rgb;
				albedo += Cid1.g * Splat_color1.rgb;
				albedo += Cid1.b * Splat_color2.rgb;
				albedo += Cid1.a * Splat_color3.rgb;
				albedo += Cid2.r * Splat_color4.rgb;
				albedo += Cid2.g * Splat_color5.rgb;
				albedo += Cid2.b * Splat_color6.rgb;
				albedo += Cid2.a * Splat_color7.rgb;
				albedo += Cid3.r * Splat_color8.rgb;
				albedo += Cid3.g * Splat_color9.rgb;
				albedo += Cid3.b * Splat_color10.rgb;
				albedo += Cid3.a * Splat_color11.rgb;
				albedo += Cid4.r * Splat_color12.rgb;
				albedo += Cid4.g * Splat_color13.rgb;
				albedo += Cid4.b * Splat_color14.rgb;
				albedo += Cid4.a * Splat_color15.rgb;

				fixed3 normal = Cid1.r * normal0;
				normal += Cid1.g * normal1;
				normal += Cid1.b * normal2;
				normal += Cid1.a * normal3;
				normal += Cid2.r * normal4;
				normal += Cid2.g * normal5;
				normal += Cid2.b * normal6;
				normal += Cid2.a * normal7;
				normal += Cid3.r * normal8;
				normal += Cid3.g * normal9;
				normal += Cid3.b * normal10;
				normal += Cid3.a * normal11;
				normal += Cid4.r * normal12;
				normal += Cid4.g * normal13;
				normal += Cid4.b * normal14;
				normal += Cid4.a * normal15;
				normal = normalize(normal);

				normal = normalize(half3(dot(i.TtoW0.xyz, normal), dot(i.TtoW1.xyz, normal), dot(i.TtoW2.xyz, normal)));

				//fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Color.rgb;

				fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(normal, lightDir));

				UNITY_LIGHT_ATTENUATION(atten, i, worldPos);

				return fixed4(diffuse * atten, 1.0);
			}
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
