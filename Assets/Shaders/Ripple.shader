Shader "TFTM/Distortion/Ripple"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Scale ("Scale", Range(0, 3)) = 1
		_Speed ("Speed", Range(0, 3)) = 1
		_Frequency ("Frequency", Range(0, 3)) = 1
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

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float _Scale, _Speed, _Frequency;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				half offsetVert = 1 - ((v.vertex.x * v.vertex.x) + (v.vertex.z * v.vertex.z));
				half value = _Scale * sin(_Time.w * _Speed + offsetVert * _Frequency);

				o.vertex.y += value;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return tex2D(_MainTex, i.uv);
			}
			ENDCG
		}
	}
}
