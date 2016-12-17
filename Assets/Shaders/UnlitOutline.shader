Shader "TFTM/Unlit/UnlitOutline"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
	    _OutlineColor ("Outline Color", Color) = (1, 1, 1, 1)
        _OutlineSize ("Outline Size", Range(0, 0.02)) = 0.01
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
				half3 norm = mul((half3x3)UNITY_MATRIX_IT_MV, v.normal);
				half2 offset = TransformViewToProjection(norm.xy);
				o.pos.xy += offset * o.pos.z * _OutlineSize;
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
