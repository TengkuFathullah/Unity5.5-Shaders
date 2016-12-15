Shader "TFTM/Standard/StandardOutline" {
  Properties {
    _MainTex ("Albedo (RGB)", 2D) = "white" {}
	_NormalMap ("Normal Map", 2D) = "white" {}
	_Detail ("Detail Texture", 2D) = "white" {}
	_Occlusion ("Occlusion", 2D) = "white" {}
    _OutlineSize ("Outline Size", float) = 0.05
    _OutlineColor ("Outline Color", Color) = (1, 1, 1, 1)
	_Glossiness ("Smoothness", Range(0,1)) = 0.5
	_Metallic ("Metallic", Range(0,1)) = 0.0
  }
  SubShader {
    Tags { "RenderType" = "Opaque" }

    CGPROGRAM
	#pragma surface surf Standard

	sampler2D _MainTex;
	sampler2D _NormalMap;
	sampler2D _Detail;
	sampler2D _Occlusion;
	half _Glossiness;
	half _Metallic;

	struct Input {
		float2 uv_MainTex;
	};

	void surf (Input IN, inout SurfaceOutputStandard o) {
		o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
		o.Albedo *= tex2D (_Detail, IN.uv_MainTex).rgb * 2;
	    o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
	    o.Occlusion = tex2D(_Occlusion, IN.uv_MainTex);
		o.Metallic = _Metallic;
		o.Smoothness = _Glossiness;
	}
    ENDCG

    Cull Front

    CGPROGRAM
	#pragma surface surf Standard vertex:vert

	float4 _OutlineColor;
	float _OutlineSize;

	void vert (inout appdata_full v) {
		v.vertex.xyz += v.normal * _OutlineSize;
	}

	struct Input {
		float2 uv_MainTex;
	};

	void surf (Input IN, inout SurfaceOutputStandard o) {
		o.Albedo = _OutlineColor.rgb;
	}
    ENDCG
  }
  FallBack "Diffuse"
}