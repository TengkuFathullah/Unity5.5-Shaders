Shader "TFTM/Unlit/UnlitRimLight"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Rim ("Rim", Range(0, 1)) = 0.1
		_Color ("Color", Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float2 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
                float3 color : COLOR;
				float2 normal : NORMAL;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float _Rim;
			#define RIM (1.0 - _Rim)
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				float diff = 1.0 - dot(v.normal, normalize(WorldSpaceViewDir(v.vertex)));
				diff = step(RIM, diff) * diff;
				float value = step(RIM, diff) * (diff - RIM) / RIM;

				o.color = float3(value, value, value) * _Color;
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : COLOR
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col.rgb += i.color;

				return col;
			}
			ENDCG
		}
	}
}
