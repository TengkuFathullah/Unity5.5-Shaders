Shader "TFTM/Unlit/UnlitOutline"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
	    _OutlineColor ("Outline Color", Color) = (1, 1, 1, 1)
        _OutlineSize ("Outline Size", Range(0, 0.2)) = 0.01
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};


			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed4 frag (v2f i) : COLOR
			{
				return tex2D(_MainTex, i.uv);
			}
			ENDCG
		}

		Pass
		{
			Cull Front
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _Color;
			float4 _OutlineColor;
			float _OutlineSize;
			
			v2f vert (appdata_full v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

				// Same outline width on different object scale
				half3 norm = normalize(mul((half3x3)UNITY_MATRIX_IT_MV, v.normal));
				half2 offset = TransformViewToProjection(norm.xy);

				// Same outline width on different object distance
				float dist = length(ObjSpaceViewDir(v.vertex));
				o.pos.xy += offset * o.pos.z * _OutlineSize * dist;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_TARGET
			{
				return _OutlineColor;
			}
			ENDCG
		}
	}
}
