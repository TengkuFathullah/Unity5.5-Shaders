Shader "TFTM/Standard/StandardRimLight" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalMap ("Normal Map", 2D) = "white" {}
		_Detail ("Detail Texture", 2D) = "white" {}
		_Occlusion ("Occlusion", 2D) = "white" {}
		_Rim ("Rim", Range(0, 1)) = 0.1
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf Standard //fullforwardshadows

		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _NormalMap;
		sampler2D _Detail;
		sampler2D _Occlusion;
		float4 _Color;
		float _Rim;
		half _Glossiness;
		half _Metallic;
		#define RIM (1.0 - _Rim)

		struct Input {
			float2 uv_MainTex;
			float3 viewDir;
			INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
		    o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		    o.Albedo *= tex2D (_Detail, IN.uv_MainTex).rgb * 2;
		    o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
		    o.Occlusion = tex2D(_Occlusion, IN.uv_MainTex);
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;

			float diff = 1.0 - dot(o.Normal, IN.viewDir);
			diff = step(RIM, diff) * diff;
			float value = step(RIM, diff) * (diff - RIM) / RIM;

			o.Emission = float3(value, value, value) * _Color;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
