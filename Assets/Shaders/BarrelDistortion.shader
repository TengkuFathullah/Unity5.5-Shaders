Shader "TFTM/Distortion/BarrelDistortion" {
	Properties{
		_Color("Main Color", Color) = (1,1,1,0.5)
		_DistortionValue("Distortion Value", Range(0.0,2.0)) = 0.0
		_MainTex("Texture", 2D) = "white" { }
	}

	SubShader{
		Tags{ "Queue" = "Transparent" }
		Pass{
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag	
			#include "UnityCG.cginc"	

			half4 _Color;
			float barrelPower = 1.0;
			float4 _MainTex_ST;
			float _DistortionValue;
			sampler2D _MainTex;


			struct v2f {
				float4  pos : SV_POSITION;
				float2  uv : TEXCOORD0;
			};

			half2 GetBarrelUV(half2 p) {
				float theta = atan2(p.y, p.x);
				float radius = length(p);
				radius = pow(radius, barrelPower);
				p.x = radius * cos(theta);
				p.y = radius * sin(theta);
				return (p + 0.5);
			}

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			half4 frag(v2f i) : COLOR{
				barrelPower = _DistortionValue;		
				half2 barrelUV = GetBarrelUV(i.uv - 0.5);
				half4 texcol = tex2D(_MainTex, barrelUV.xy);
				return texcol*_Color;
			}
			ENDCG
		}
	}
		Fallback "VertexLit"
}
